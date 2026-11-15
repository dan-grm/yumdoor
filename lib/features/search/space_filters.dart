import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

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
      _LookupChip(
        items: recipeBooksProvider,
        matches: (book) => book.id == id,
        label: (book) => l10n.searchBookFilter(book.name),
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
          // Chosen books aren't offered again.
          empty: (ref) => (ref.read(recipeBooksProvider).value ?? []).isEmpty
              ? l10n.searchBookEmpty
              : l10n.searchBookAllChosen,
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
      _LookupChip(
        items: spaceUsersProvider,
        matches: (user) => user.id == id,
        label: (user) => l10n.searchCreatorFilter(_name(l10n, user)),
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
            empty: (_) => l10n.pickerEmpty,
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

/// A selected filter on an item of a loaded list, labelled once the list
/// has loaded; "Unbekannter Filter" if the item isn't in it (any more).
class _LookupChip<T> extends ConsumerWidget {
  const _LookupChip({
    required this.items,
    required this.matches,
    required this.label,
    required this.onRemove,
  });

  final ProviderListenable<AsyncValue<List<T>>> items;
  final bool Function(T item) matches;
  final String Function(T item) label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = switch (ref.watch(items)) {
      AsyncData(:final value) => switch (value.where(matches).firstOrNull) {
        final item? => label(item),
        null => l10n.searchFilterUnknown,
      },
      AsyncError() => l10n.searchFilterUnknown,
      _ => l10n.searchFilterLoading,
    };
    return _Chip(label: text, onRemove: onRemove);
  }
}
