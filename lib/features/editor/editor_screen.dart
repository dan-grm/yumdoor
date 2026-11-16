import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import 'editor_controller.dart';
import 'general_tab.dart';

/// The tabs of the editor (mockup 09-rezept-bearbeiten).
enum EditorTab { general, ingredients, steps }

/// Where the editor for the recipe [recipeId] is.
String editLocation(int recipeId) => '/recipe/$recipeId/edit';

/// Where the editor for a new recipe is.
const newRecipeLocation = '/recipe/new';

/// The recipe editor (mockup `09-rezept-bearbeiten`): "Abbrechen", the
/// title and "Speichern" on top, then the tabs Allgemein, Zutaten and
/// Schritte. [recipeId] is the recipe to edit, `null` for a new one.
///
/// Saving returns to the recipe, which then shows the saved version; for a
/// new recipe it replaces the editor. Offline, "Speichern" is disabled and
/// nothing is queued.
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key, this.recipeId});

  final int? recipeId;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  var _tab = EditorTab.general;

  /// Back to where the editor was opened from: the recipe, or search for a
  /// new recipe if the editor was opened directly.
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(switch (widget.recipeId) {
        final id? => '/recipe/$id',
        null => '/',
      });
    }
  }

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final savedMessage = context.l10n.editorSaved;
    final saved = await ref
        .read(recipeEditorProvider(widget.recipeId).notifier)
        .save();
    if (saved == null || !mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(savedMessage)));
    if (widget.recipeId == null) {
      // The new recipe takes the editor's place, so back leads to search.
      if (context.canPop()) {
        context.pushReplacement('/recipe/${saved.id}');
      } else {
        context.go('/recipe/${saved.id}');
      }
    } else {
      _leave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = recipeEditorProvider(widget.recipeId);
    final editor = ref.watch(provider);
    final state = editor.value;
    final saving = state?.saving ?? false;

    return PopScope(
      // Leaving while saving would race with the return after it.
      canPop: !saving,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                recipeName: state?.recipeName,
                isNew: widget.recipeId == null,
                saving: saving,
                canSave: state != null,
                onCancel: saving ? null : _leave,
                onSave: _save,
              ),
              Expanded(
                child: switch (editor) {
                  AsyncData(:final value) => _Body(
                    recipeId: widget.recipeId,
                    state: value,
                    tab: _tab,
                    onTab: (tab) => setState(() => _tab = tab),
                    onRetry: _save,
                  ),
                  AsyncError(:final error) => FailureView(
                    error: error,
                    notFoundMessage: l10n.editorRecipeGone,
                    onRetry: () => ref.invalidate(provider),
                  ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Abbrechen", the recipe name over "Bearbeiten" (or "Neues Rezept"), and
/// "Speichern".
class _Header extends StatelessWidget {
  const _Header({
    required this.recipeName,
    required this.isNew,
    required this.saving,
    required this.canSave,
    required this.onCancel,
    required this.onSave,
  });

  final String? recipeName;
  final bool isNew;
  final bool saving;

  /// Whether there is a draft to save: not while loading.
  final bool canSave;
  final VoidCallback? onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final recipeName = this.recipeName;
    return Padding(
      padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, 0),
      child: Row(
        spacing: t.space2,
        children: [
          SizedBox(
            height: t.sizeTouch,
            child: TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: t.ink,
                textStyle: t.label,
                padding: EdgeInsets.symmetric(horizontal: t.space1),
              ),
              child: Text(l10n.editorCancel),
            ),
          ),
          Expanded(
            child: Semantics(
              header: true,
              child: Column(
                children: [
                  if (recipeName != null)
                    Text(
                      recipeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(
                        color: t.inkMuted,
                        fontWeight: t.label.fontWeight,
                      ),
                    ),
                  Text(
                    isNew ? l10n.editorTitleNew : l10n.editorTitleEdit,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleS.copyWith(color: t.ink),
                  ),
                ],
              ),
            ),
          ),
          if (saving)
            _SavingButton(label: l10n.editorSaving)
          else
            OfflineDisabled(
              builder: (context, enabled) => PillButton(
                label: l10n.editorSave,
                compact: true,
                onPressed: enabled && canSave ? onSave : null,
              ),
            ),
        ],
      ),
    );
  }
}

/// "Speichern" while saving: the button with a spinner in place of the
/// label, disabled.
class _SavingButton extends StatelessWidget {
  const _SavingButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final spinner = t.label.fontSize! + t.space1;
    return Semantics(
      label: label,
      button: true,
      enabled: false,
      child: Container(
        height: t.sizeTouch,
        padding: EdgeInsets.symmetric(horizontal: t.space5),
        decoration: ShapeDecoration(
          color: t.sage,
          shape: const StadiumBorder(),
        ),
        alignment: Alignment.center,
        child: SizedBox.square(
          dimension: spinner,
          child: CircularProgressIndicator(
            color: t.onSage,
            strokeWidth: t.space1 / 2,
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.recipeId,
    required this.state,
    required this.tab,
    required this.onTab,
    required this.onRetry,
  });

  final int? recipeId;
  final EditorState state;
  final EditorTab tab;
  final ValueChanged<EditorTab> onTab;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final offline = ref.watch(isOfflineProvider);
    final failure = state.failure;
    final hasProblems = state.showProblems && state.problems.isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, t.space6),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.sizeWide),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Tabs(selected: tab, onSelect: onTab),
              if (offline)
                _Notice(
                  icon: Icons.cloud_off_outlined,
                  text: l10n.offlineWriteDisabled,
                ),
              if (failure != null)
                _Notice(
                  icon: Icons.error_outline_rounded,
                  danger: true,
                  text: switch (failure) {
                    // Tandoor answers 403 for an invalid token too, but then
                    // the session ends and login takes over this screen.
                    UnauthorizedFailure() => l10n.editorForbidden,
                    _ => l10n.editorSaveFailed(
                      failureMessage(
                        context,
                        failure,
                        notFoundMessage: l10n.editorRecipeGone,
                      ),
                    ),
                  },
                  // Asking again won't change a refusal or a deleted recipe.
                  onRetry:
                      failure is UnauthorizedFailure ||
                          failure is NotFoundFailure ||
                          offline
                      ? null
                      : onRetry,
                )
              else if (hasProblems)
                _Notice(
                  icon: Icons.error_outline_rounded,
                  danger: true,
                  text: l10n.editorProblems,
                ),
              SizedBox(height: t.space4),
              switch (tab) {
                EditorTab.general => GeneralTab(recipeId: recipeId),
                EditorTab.ingredients || EditorTab.steps => Padding(
                  padding: EdgeInsets.symmetric(vertical: t.space6),
                  child: Text(
                    l10n.editorTabComingSoon,
                    textAlign: TextAlign.center,
                    style: t.body.copyWith(color: t.inkMuted),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

/// The segmented tab bar: a `surface-sunken` pill with the selected tab
/// raised on `surface`.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onSelect});

  final EditorTab selected;
  final ValueChanged<EditorTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final labels = {
      EditorTab.general: l10n.editorTabGeneral,
      EditorTab.ingredients: l10n.editorTabIngredients,
      EditorTab.steps: l10n.editorTabSteps,
    };
    return Container(
      padding: EdgeInsets.all(t.space1),
      decoration: ShapeDecoration(
        color: t.surfaceSunken,
        shape: const StadiumBorder(),
      ),
      child: Row(
        spacing: t.space1,
        children: [
          for (final MapEntry(key: tab, value: label) in labels.entries)
            Expanded(
              child: Semantics(
                selected: tab == selected,
                inMutuallyExclusiveGroup: true,
                button: true,
                child: _TabButton(
                  label: label,
                  selected: tab == selected,
                  onTap: () => onSelect(tab),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final shape = StadiumBorder(
      side: selected ? BorderSide(color: t.line) : BorderSide.none,
    );
    return Material(
      color: selected ? t.surface : Colors.transparent,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: SizedBox(
          height: t.sizeTouch,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: t.space2),
                child: Text(
                  label,
                  style: t.label.copyWith(color: selected ? t.ink : t.inkMuted),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A line under the tabs: offline, or why saving failed, with a retry
/// button where trying again can help.
class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.text,
    this.danger = false,
    this.onRetry,
  });

  final IconData icon;
  final String text;
  final bool danger;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = danger ? t.danger : t.inkMuted;
    final style = t.body.copyWith(color: color);
    return Padding(
      padding: EdgeInsets.only(top: t.space3),
      child: Semantics(
        liveRegion: danger,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: t.space2,
          children: [
            Icon(icon, size: style.fontSize! + t.space1, color: color),
            Expanded(child: Text(text, style: style)),
            if (onRetry case final onRetry?)
              PillButton(
                label: context.l10n.retry,
                onPressed: onRetry,
                kind: PillButtonKind.secondary,
                compact: true,
              ),
          ],
        ),
      ),
    );
  }
}
