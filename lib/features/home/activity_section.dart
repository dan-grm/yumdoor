import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/offline.dart';
import '../../design/design.dart';
import '../../domain/models/cook_log.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../recipe/recipe_screen.dart';
import 'home_providers.dart';

/// "Was andere kochen" on the start screen: the last cook log entries of
/// other users, each with who cooked what, the rating, how long ago and the
/// comment. A row opens the recipe.
///
/// It loads on its own, so a failure shows here and leaves the rest of the
/// start screen alone. It needs the server, so offline it is one line saying
/// so. Comments are untrusted: they are shown as plain text, at most two
/// lines.
class ActivitySection extends ConsumerWidget {
  const ActivitySection({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    if (ref.watch(isOfflineProvider)) {
      return Text(
        l10n.homeActivityOffline,
        style: t.caption.copyWith(color: t.inkMuted),
      );
    }

    final activity = ref.watch(othersActivityProvider);
    // While it reloads, the entries stay until the new ones are there.
    final Widget body = switch (activity) {
      AsyncValue(value: final value?) when value.isEmpty => Text(
        l10n.homeActivityEmpty,
        style: t.body.copyWith(color: t.inkMuted),
      ),
      AsyncValue(value: final value?) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, log) in value.indexed) ...[
            if (i > 0) SizedBox(height: t.space2),
            _Entry(log: log, now: now),
          ],
        ],
      ),
      AsyncError(:final error) => Row(
        children: [
          Expanded(
            child: Text(
              '${l10n.homeActivityFailed} ${failureMessage(context, error)}',
              style: t.caption.copyWith(color: t.inkMuted),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(othersActivityProvider),
            child: Text(l10n.retry, style: t.label.copyWith(color: t.sage)),
          ),
        ],
      ),
      _ => const _Placeholders(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.homeActivity,
            style: t.titleS.copyWith(color: t.ink),
          ),
        ),
        Text(
          l10n.homeActivitySubtitle,
          style: t.caption.copyWith(color: t.inkMuted),
        ),
        SizedBox(height: t.space3),
        body,
      ],
    );
  }
}

/// One entry: the initial of who cooked, "Name hat Rezept gekocht",
/// stars and relative time, and the comment.
class _Entry extends StatelessWidget {
  const _Entry({required this.log, required this.now});

  final RecentCookLog log;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final entry = log.entry;
    final user = entry.createdBy;
    final shownName = switch ((user?.name.trim(), user?.username.trim())) {
      (final name?, _) when name.isNotEmpty => name,
      (_, final username?) when username.isNotEmpty => username,
      _ => l10n.homeActivityUnknownUser,
    };
    final rating = entry.rating;
    final comment = entry.comment?.trim();
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.radiusM),
      side: BorderSide(color: t.line),
    );
    return Material(
      color: t.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => unawaited(context.push(recipeLocation(log.recipe.id))),
        customBorder: shape,
        child: Padding(
          padding: EdgeInsets.all(t.space3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: t.sageSoft,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: t.sizeTouch - t.space2,
                    child: Center(
                      child: Text(
                        String.fromCharCode(shownName.runes.first)
                            .toUpperCase(),
                        style: t.titleS.copyWith(color: t.sage),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: t.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeActivityCooked(shownName, log.recipe.name),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.label.copyWith(color: t.ink),
                    ),
                    SizedBox(height: t.space1),
                    Row(
                      children: [
                        if (rating != null) ...[
                          Semantics(
                            label: l10n.cookLogRatingStar(rating),
                            excludeSemantics: true,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (
                                  var star = minCookLogRating;
                                  star <= maxCookLogRating;
                                  star++
                                )
                                  Icon(
                                    star <= rating
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    size: t.caption.fontSize! + t.space1,
                                    color: star <= rating
                                        ? t.sage
                                        : t.controlBorder,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: t.space2),
                        ],
                        Flexible(
                          child: Text(
                            _ago(context, entry.createdAt, now),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.caption.copyWith(color: t.inkMuted),
                          ),
                        ),
                      ],
                    ),
                    if (comment != null && comment.isNotEmpty) ...[
                      SizedBox(height: t.space1),
                      Text(
                        comment,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.body.copyWith(color: t.ink),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// How long before [now] [date] was, in the largest fitting unit.
String _ago(BuildContext context, DateTime date, DateTime now) {
  final l10n = context.l10n;
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return l10n.homeActivityJustNow;
  if (diff.inHours < 1) return l10n.homeActivityMinutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return l10n.homeActivityHoursAgo(diff.inHours);
  if (diff.inDays < 7) return l10n.homeActivityDaysAgo(diff.inDays);
  if (diff.inDays < 60) return l10n.homeActivityWeeksAgo(diff.inDays ~/ 7);
  return l10n.homeActivityMonthsAgo(diff.inDays ~/ 30);
}

/// Boxes where the entries will be, while they load.
class _Placeholders extends StatelessWidget {
  const _Placeholders();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ExcludeSemantics(
      child: Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) SizedBox(height: t.space2),
            DecoratedBox(
              decoration: BoxDecoration(
                color: t.sageSoft,
                borderRadius: BorderRadius.circular(t.radiusM),
              ),
              child: SizedBox(width: double.infinity, height: t.sizeTouch),
            ),
          ],
        ],
      ),
    );
  }
}
