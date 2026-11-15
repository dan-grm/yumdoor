import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/components/filter_chips.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/user_ref.dart';
import '../../l10n/l10n.dart';
import 'option_sheet.dart';
import 'search_providers.dart';

/// The chips for the filters on the household and the space: what can be
/// cooked from what is on hand, the cookbooks a recipe is in and who created
/// it. A filter that is set shows as a removable chip, an unset one as a "+"
/// chip that opens a sheet of choices. Several books match recipes in any of
/// them.
List<Widget> spaceFilterChips(
  BuildContext context, {
  required RecipeQuery query,
  required void Function(RecipeQuery query) onChange,
}) {
  final l10n = context.l10n;
  return [
    if (query.maxMissingFoods case final missing?)
      _Chip(
        label: missing == 0
            ? l10n.searchCookableNow
            : l10n.searchCookableOneMissing,
        onRemove: () => onChange(query.copyWith(maxMissingFoods: null)),
      )
    else
      AddFilterChip(
        label: l10n.searchAddCookable,
        tooltip: l10n.searchCookableTitle,
        onPressed: () async {
          final missing = await showOptionSheet<int>(
            context,
            title: l10n.searchCookableTitle,
            hint: l10n.searchCookableHint,
            options: [
              (l10n.searchCookableNow, 0),
              (l10n.searchCookableOneMissing, 1),
            ],
          );
          if (missing != null) {
            onChange(query.copyWith(maxMissingFoods: missing));
          }
        },
      ),
    for (final id in query.bookIds)
      _BookChip(
        id: id,
        onRemove: () =>
            onChange(query.copyWith(bookIds: {...query.bookIds}..remove(id))),
      ),
    AddFilterChip(
      label: l10n.searchAddBook,
      tooltip: l10n.searchBookTitle,
      onPressed: () async {
        final id = await showLoadingOptionSheet<int>(
          context,
          title: l10n.searchBookTitle,
          hint: l10n.searchBookHint,
          empty: l10n.searchBookEmpty,
          options: (ref) => ref
              .watch(recipeBooksProvider)
              .whenData(
                (books) => [
                  for (final book in books)
                    if (!query.bookIds.contains(book.id)) (book.name, book.id),
                ],
              ),
          retry: (ref) => ref.invalidate(recipeBooksProvider),
        );
        if (id != null) {
          onChange(query.copyWith(bookIds: {...query.bookIds, id}));
        }
      },
    ),
    if (query.createdBy case final id?)
      _CreatorChip(
        id: id,
        onRemove: () => onChange(query.copyWith(createdBy: null)),
      )
    else
      AddFilterChip(
        label: l10n.searchAddCreator,
        tooltip: l10n.searchCreatorTitle,
        onPressed: () async {
          final id = await showLoadingOptionSheet<int>(
            context,
            title: l10n.searchCreatorTitle,
            options: (ref) => ref
                .watch(spaceUsersProvider)
                .whenData(
                  (users) => [
                    for (final user in users) (_name(l10n, user), user.id),
                  ],
                ),
            retry: (ref) => ref.invalidate(spaceUsersProvider),
          );
          if (id != null) onChange(query.copyWith(createdBy: id));
        },
      ),
  ];
}

String _name(AppLocalizations l10n, UserRef user) =>
    user.name.isEmpty ? l10n.searchFilterUnknown : user.name;

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => SelectedFilterChip(
    label: label,
    removeLabel: context.l10n.searchRemoveFilter(label),
    onRemove: onRemove,
  );
}

class _BookChip extends ConsumerWidget {
  const _BookChip({required this.id, required this.onRemove});

  final int id;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final label = switch (ref.watch(recipeBooksProvider)) {
      AsyncData(:final value) => switch ([
        for (final book in value)
          if (book.id == id) book,
      ]) {
        [final book] => l10n.searchBookFilter(book.name),
        _ => l10n.searchFilterUnknown,
      },
      AsyncError() => l10n.searchFilterUnknown,
      _ => l10n.searchFilterLoading,
    };
    return _Chip(label: label, onRemove: onRemove);
  }
}

class _CreatorChip extends ConsumerWidget {
  const _CreatorChip({required this.id, required this.onRemove});

  final int id;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final label = switch (ref.watch(spaceUsersProvider)) {
      AsyncData(:final value) => switch ([
        for (final user in value)
          if (user.id == id) user,
      ]) {
        [final user] => l10n.searchCreatorFilter(_name(l10n, user)),
        _ => l10n.searchFilterUnknown,
      },
      AsyncError() => l10n.searchFilterUnknown,
      _ => l10n.searchFilterLoading,
    };
    return _Chip(label: label, onRemove: onRemove);
  }
}
