import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/failures.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../search/search_location.dart';
import 'editor_controller.dart';

/// The end of the editor's Allgemein tab: "Rezept löschen" in the danger
/// style, for a recipe that exists. Offline it is disabled, with the reason.
class DeleteRecipeButton extends ConsumerWidget {
  const DeleteRecipeButton({super.key, required this.recipeId});

  final int recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final state = ref.watch(recipeEditorProvider(recipeId)).value;
    final canDelete = state != null && !state.saving;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: OfflineDisabled(
        builder: (context, enabled) => TextButton.icon(
          onPressed: enabled && canDelete
              ? () => confirmAndDeleteRecipe(context, ref, recipeId)
              : null,
          style: TextButton.styleFrom(
            foregroundColor: t.danger,
            minimumSize: Size(0, t.sizeTouch),
            textStyle: t.label,
          ),
          icon: const Icon(Icons.delete_outline_rounded),
          label: Text(l10n.editorDelete),
        ),
      ),
    );
  }
}

/// Asks "Rezept löschen?", naming the recipe and what goes with it, and
/// deletes it if the user agrees. Then the app goes back to search and a
/// snackbar says so; if the server refuses, the snackbar says why and the
/// editor stays as it is.
Future<void> confirmAndDeleteRecipe(
  BuildContext context,
  WidgetRef ref,
  int recipeId,
) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  final provider = recipeEditorProvider(recipeId);
  // The name as saved; the field may hold something else by now.
  final name = ref.read(provider).value?.recipeName ?? '';
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final t = context.tokens;
      return AlertDialog(
        title: Text(l10n.editorDeleteTitle),
        content: Text(l10n.editorDeleteBody(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.editorDeleteKeep),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: t.danger),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.editorDeleteConfirm),
          ),
        ],
      );
    },
  );
  if (confirmed != true || !context.mounted) return;
  final failure = await ref.read(provider.notifier).deleteRecipe();
  if (failure != null) {
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (failure) {
          // Tandoor answers 403 for an invalid token too, but then the
          // session ends and login takes over.
          UnauthorizedFailure() => l10n.editorDeleteForbidden,
          // Tandoor fails with a 500 for a recipe used as a step.
          ServerFailure(statusCode: 500) => l10n.editorDeleteInUse,
          _ => l10n.editorDeleteFailed(failureMessage(context, failure)),
        }),
      ),
    );
    return;
  }
  messenger.showSnackBar(SnackBar(content: Text(l10n.editorDeleted)));
  // The user left already (the editor is gone, with its locked state).
  if (!context.mounted) return;
  // Not back: the recipe screen below the editor is gone too. To search,
  // where the recipe was likely found.
  router.go(searchPath);
}
