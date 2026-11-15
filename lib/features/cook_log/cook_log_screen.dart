import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../domain/models/cook_log.dart';
import '../../domain/models/recipe.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../recipe/ingredient_lines.dart';
import '../recipe/recipe_providers.dart';

/// Outline width of the comment field (mockup 08-fertig-gekocht).
const _fieldBorderWidth = 2.0;

/// "Fertig gekocht": rate the recipe and leave a comment, saved as a cook log
/// entry (mockup `08-fertig-gekocht`, without the photo: Tandoor's cook log
/// has no image).
///
/// Reached from the last step of cooking mode and from the recipe screen.
/// Saving and skipping both return to the recipe.
class CookLogScreen extends ConsumerWidget {
  const CookLogScreen({super.key, required this.recipeId, this.servings});

  final int recipeId;

  /// The servings that were cooked; `null` means the recipe's own.
  final int? servings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final recipe = ref.watch(recipeProvider(recipeId));
    final closeButton = _CloseButton(recipeId: recipeId);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, t.space6),
          child: switch (recipe) {
            AsyncData(:final value) => _CookLogView(
              recipe: value,
              servings: servings ?? math.max(value.servings, 1),
            ),
            AsyncError(:final error) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                closeButton,
                Expanded(
                  child: FailureView(
                    error: error,
                    notFoundMessage: context.l10n.recipeNotFound,
                    onRetry: () => ref.invalidate(recipeProvider(recipeId)),
                  ),
                ),
              ],
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

/// Where [CookLogScreen] is for [recipeId], cooked for [servings].
String cookLogLocation(int recipeId, int servings) => Uri(
  path: '/recipe/$recipeId/cooked',
  queryParameters: {'servings': '$servings'},
).toString();

/// Back to the recipe below, or to it if this screen was opened directly.
void _leave(BuildContext context, int recipeId) =>
    context.canPop() ? context.pop() : context.go('/recipe/$recipeId');

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.recipeId, this.enabled = true});

  final int recipeId;
  final bool enabled;

  @override
  Widget build(BuildContext context) => RoundIconButton(
    icon: Icons.close_rounded,
    label: context.l10n.cookLogClose,
    onPressed: enabled ? () => _leave(context, recipeId) : null,
  );
}

class _CookLogView extends ConsumerStatefulWidget {
  const _CookLogView({required this.recipe, required this.servings});

  final Recipe recipe;
  final int servings;

  @override
  ConsumerState<_CookLogView> createState() => _CookLogViewState();
}

class _CookLogViewState extends ConsumerState<_CookLogView> {
  final _comment = TextEditingController();
  int? _rating;
  var _saving = false;
  Failure? _failure;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  /// Tapping the selected star again takes the rating back.
  void _rate(int stars) =>
      setState(() => _rating = _rating == stars ? null : stars);

  Future<void> _save() async {
    final recipeId = widget.recipe.id;
    final messenger = ScaffoldMessenger.of(context);
    final saved = context.l10n.cookLogSaved;
    setState(() {
      _saving = true;
      _failure = null;
    });
    try {
      await ref
          .read(cookLogRepositoryProvider)
          .create(
            NewCookLog(
              recipeId: recipeId,
              servings: widget.servings,
              rating: _rating,
              comment: _comment.text,
            ),
          );
    } on Failure catch (failure) {
      if (mounted) {
        setState(() {
          _saving = false;
          _failure = failure;
        });
      }
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text(saved)));
    // Leaving is blocked while saving, but logging out isn't.
    if (!mounted) return;
    // The recipe screen below shows the new rating and last cooked date.
    ref.invalidate(recipeProvider(recipeId));
    _leave(context, recipeId);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final recipe = widget.recipe;
    final offline = ref.watch(isOfflineProvider);
    final failure = _failure;

    // Leaving while saving would race with the return after it.
    return PopScope(
      canPop: !_saving,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: t.sizeButton,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _CloseButton(recipeId: recipe.id, enabled: !_saving),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: t.space2),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: t.sizeWide),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Heading(
                        recipe: recipe.name,
                        servings: servingsLabel(
                          context,
                          widget.servings,
                          recipe.servingsText,
                        ),
                      ),
                      SizedBox(height: t.space6),
                      _RatingCard(
                        rating: _rating,
                        onRate: _saving ? null : _rate,
                        comment: _comment,
                        enabled: !_saving,
                      ),
                      SizedBox(height: t.space3),
                      _Note(
                        icon: Icons.group_outlined,
                        text: l10n.cookLogVisibility,
                      ),
                      if (offline) ...[
                        SizedBox(height: t.space2),
                        _Note(
                          icon: Icons.cloud_off_outlined,
                          text: l10n.offlineWriteDisabled,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (failure != null) ...[
            SizedBox(height: t.space3),
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.cookLogFailed(failureMessage(context, failure)),
                style: t.body.copyWith(color: t.danger),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          SizedBox(height: t.space3),
          OfflineDisabled(
            builder: (context, enabled) => PillButton(
              label: l10n.cookLogSave,
              onPressed: enabled && !_saving ? _save : null,
            ),
          ),
          SizedBox(height: t.space1),
          SizedBox(
            height: t.sizeTouch,
            child: TextButton(
              onPressed: _saving ? null : () => _leave(context, recipe.id),
              style: TextButton.styleFrom(
                foregroundColor: t.inkMuted,
                textStyle: t.label,
              ),
              child: Text(l10n.cookLogSkip),
            ),
          ),
        ],
      ),
    );
  }
}

/// The check mark, "Guten Appetit!" and what was cooked.
class _Heading extends StatelessWidget {
  const _Heading({required this.recipe, required this.servings});

  final String recipe;
  final String servings;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final circle = t.sizeButton + t.space8;
    return Column(
      children: [
        ExcludeSemantics(
          child: Container(
            width: circle,
            height: circle,
            decoration: BoxDecoration(
              color: t.sageSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, size: t.sizeTouch, color: t.sage),
          ),
        ),
        SizedBox(height: t.space4),
        Semantics(
          header: true,
          child: Text(
            context.l10n.cookLogTitle,
            style: t.titleL.copyWith(color: t.ink),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: t.space1),
        Text(
          context.l10n.cookLogSubtitle(recipe, servings),
          style: t.label.copyWith(color: t.inkMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// "Wie war's?" with the stars, and the comment field.
class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.rating,
    required this.onRate,
    required this.comment,
    required this.enabled,
  });

  final int? rating;

  /// `null` while saving.
  final ValueChanged<int>? onRate;
  final TextEditingController comment;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(t.radiusM),
      borderSide: BorderSide(color: color, width: _fieldBorderWidth),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(t.radiusL),
      ),
      child: Padding(
        padding: EdgeInsets.all(t.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.cookLogRatingQuestion,
                style: t.titleS.copyWith(color: t.ink),
              ),
            ),
            SizedBox(height: t.space2),
            Wrap(
              spacing: t.space1,
              children: [
                for (
                  var stars = minCookLogRating;
                  stars <= maxCookLogRating;
                  stars++
                )
                  _Star(
                    filled: stars <= (rating ?? 0),
                    selected: stars == rating,
                    label: l10n.cookLogRatingStar(stars),
                    onPressed: switch (onRate) {
                      final onRate? => () => onRate(stars),
                      null => null,
                    },
                  ),
              ],
            ),
            SizedBox(height: t.space4),
            // Screen readers get the label as the field's name instead.
            ExcludeSemantics(
              child: Text(
                l10n.cookLogComment,
                style: t.caption.copyWith(
                  color: t.inkMuted,
                  fontWeight: t.label.fontWeight,
                ),
              ),
            ),
            SizedBox(height: t.space2),
            Semantics(
              label: l10n.cookLogComment,
              textField: true,
              child: TextField(
                controller: comment,
                enabled: enabled,
                minLines: 3,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: t.bodyL.copyWith(color: t.ink),
                cursorColor: t.sage,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: t.bg,
                  contentPadding: EdgeInsets.all(t.space3),
                  border: border(t.controlBorder),
                  enabledBorder: border(t.controlBorder),
                  disabledBorder: border(t.line),
                  focusedBorder: border(t.sage),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({
    required this.filled,
    required this.selected,
    required this.label,
    required this.onPressed,
  });

  final bool filled;
  final bool selected;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final extent = t.sizeTouch + t.space1;
    return Semantics(
      selected: selected,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        constraints: BoxConstraints.tightFor(width: extent, height: extent),
        padding: EdgeInsets.zero,
        iconSize: t.space8,
        color: filled ? t.sage : t.controlBorder,
        disabledColor: filled ? t.sage : t.controlBorder,
        icon: Icon(filled ? Icons.star_rounded : Icons.star_outline_rounded),
      ),
    );
  }
}

/// A line of helper text with an icon, below the card.
class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final style = t.caption.copyWith(
      color: t.inkMuted,
      fontWeight: t.label.fontWeight,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: style.fontSize! + t.space1, color: t.inkMuted),
        SizedBox(width: t.space2),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}
