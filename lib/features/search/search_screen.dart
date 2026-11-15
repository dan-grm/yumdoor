import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/session.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/components/recipe_card.dart';
import '../../design/components/search_field.dart';
import '../../design/design.dart';
import '../../domain/models/food.dart';
import '../../domain/models/recipe_match.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_sort.dart';
import '../../domain/services/scaling_service.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../recipe/recipe_meta.dart';
import 'filter_picker_sheet.dart';
import 'history_filters.dart';
import 'option_sheet.dart';
import 'saved_filters.dart';
import 'search_location.dart';
import 'search_providers.dart';
import 'space_filters.dart';

/// Recipe search with food and keyword filter chips (mockup `03-suche`).
///
/// The location is the source of truth: [query] comes from the URL, and every
/// change goes back into it, so a search survives reload and can be shared.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.query});

  final RecipeQuery query;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final _text = TextEditingController(text: widget.query.text);
  Timer? _debounce;

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Back navigation or a link changed the text; typing that is still
    // ahead of the URL is kept.
    final text = widget.query.text;
    if (text != oldWidget.query.text && text != _text.text.trim()) {
      _debounce?.cancel();
      _text.text = text;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _text.dispose();
    super.dispose();
  }

  /// Shows [query] with the text as typed, replacing the current history
  /// entry so typing doesn't fill the browser history.
  void _show(RecipeQuery query) {
    // A filter sheet may answer after the screen has gone.
    if (!mounted) return;
    _debounce?.cancel();
    final location = searchLocation(query.copyWith(text: _text.text.trim()));
    Router.neglect(context, () => context.go(location));
  }

  /// Shows [query] with its own text, e.g. a saved search.
  void _replace(RecipeQuery query) {
    _text.text = query.text;
    _show(query);
  }

  void _onTextChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, () => _show(widget.query));
  }

  Future<void> _addFilter(FilterKind kind) async {
    final query = widget.query;
    final id = await showFilterPicker(
      context,
      kind: kind,
      exclude: kind == FilterKind.food ? query.foodIds : query.keywordIds,
    );
    if (id == null || !mounted) return;
    _show(
      kind == FilterKind.food
          ? widget.query.copyWith(foodIds: {...widget.query.foodIds, id})
          : widget.query.copyWith(keywordIds: {...widget.query.keywordIds, id}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final query = widget.query;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.searchTitle,
                            style: t.titleL.copyWith(color: t.ink),
                          ),
                        ),
                      ),
                      // Moves to the settings screen once it exists.
                      RoundIconButton(
                        icon: Icons.logout_rounded,
                        label: l10n.logout,
                        onPressed: () => ref
                            .read(sessionControllerProvider.notifier)
                            .logout(),
                      ),
                    ],
                  ),
                  SizedBox(height: t.space3),
                  SearchField(
                    controller: _text,
                    label: l10n.searchFieldLabel,
                    hint: l10n.searchFieldHint,
                    clearLabel: l10n.searchClear,
                    onChanged: _onTextChanged,
                    onSubmitted: (_) => _show(query),
                  ),
                ],
              ),
            ),
            SizedBox(height: t.space1),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: t.space5),
              child: Row(
                spacing: t.space2,
                children: _selectedFirst([
                  for (final id in query.foodIds)
                    _FoodChip(
                      id: id,
                      onRemove: () => _show(
                        query.copyWith(foodIds: {...query.foodIds}..remove(id)),
                      ),
                    ),
                  for (final id in query.keywordIds)
                    _KeywordChip(
                      id: id,
                      onRemove: () => _show(
                        query.copyWith(
                          keywordIds: {...query.keywordIds}..remove(id),
                        ),
                      ),
                    ),
                  AddFilterChip(
                    label: l10n.searchAddFood,
                    tooltip: l10n.pickerFoodTitle,
                    onPressed: () => _addFilter(FilterKind.food),
                  ),
                  AddFilterChip(
                    label: l10n.searchAddKeyword,
                    tooltip: l10n.pickerKeywordTitle,
                    onPressed: () => _addFilter(FilterKind.keyword),
                  ),
                  ...historyFilterChips(context, query: query, onChange: _show),
                  ...spaceFilterChips(context, query: query, onChange: _show),
                  ...savedFilterChips(context, query: query, onChange: _show),
                ]),
              ),
            ),
            SavedFilterRow(query: query, onChange: _replace),
            Expanded(
              child: _Results(query: query, onChange: _show),
            ),
          ],
        ),
      ),
    );
  }
}

/// The filters that are set before the "+" chips, so they show without
/// scrolling the row.
List<Widget> _selectedFirst(List<Widget> chips) => [
  ...chips.where((chip) => chip is! AddFilterChip),
  ...chips.whereType<AddFilterChip>(),
];

/// "enthält Karotten": the plural if the food has one.
String _foodLabel(BuildContext context, Food food) =>
    context.l10n.searchFoodFilter(_plural(food));

String _plural(Food food) =>
    ScalingService.pickName(food.name, food.pluralName, plural: true);

/// Why a result matched, for its pill: "enthält Karotten oder Möhren ·
/// Stichwort: Vegetarisch". Also echoes the [filterFoods], which every
/// result contains, as server results don't say which ingredient matched.
String? _matchLabel(
  AppLocalizations l10n,
  RecipeMatch match,
  List<Food> filterFoods,
) {
  final matchedIds = {for (final food in match.foods) food.id};
  final echoed = [
    for (final food in filterFoods)
      if (!matchedIds.contains(food.id)) _plural(food),
  ];
  final parts = [
    // The recipe contains at least one of these; server results don't say
    // which.
    if (match.foods.isNotEmpty)
      l10n.searchFoodFilter(
        _list(l10n, [for (final f in match.foods) _plural(f)], or: true),
      ),
    // Like foods: a child keyword may be what matched.
    if (match.keywords.isNotEmpty)
      l10n.searchMatchKeyword(
        _list(l10n, [for (final k in match.keywords) k.name], or: true),
      ),
    if (echoed.isNotEmpty) l10n.searchFoodFilter(_list(l10n, echoed)),
  ];
  return parts.isEmpty ? null : parts.reduce(l10n.searchMatchJoin);
}

/// "Karotten, Kartoffeln", or with [or] "Karotten oder Kartoffeln"; at most
/// three names, so a pill stays short.
String _list(AppLocalizations l10n, List<String> names, {bool or = false}) {
  final shown = [...names.take(3), if (names.length > 3) l10n.searchMatchMore];
  if (shown.length == 1) return shown.single;
  final head = shown.sublist(0, shown.length - 1).reduce(l10n.searchMatchList);
  return or
      ? l10n.searchMatchOr(head, shown.last)
      : l10n.searchMatchList(head, shown.last);
}

class _FoodChip extends ConsumerWidget {
  const _FoodChip({required this.id, required this.onRemove});

  final int id;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final label = switch (ref.watch(foodProvider(id))) {
      AsyncData(:final value) => _foodLabel(context, value),
      AsyncError() => l10n.searchFilterUnknown,
      _ => l10n.searchFilterLoading,
    };
    return SelectedFilterChip(
      label: label,
      removeLabel: l10n.searchRemoveFilter(label),
      onRemove: onRemove,
    );
  }
}

class _KeywordChip extends ConsumerWidget {
  const _KeywordChip({required this.id, required this.onRemove});

  final int id;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final label = switch (ref.watch(keywordProvider(id))) {
      AsyncData(:final value) => value.name,
      AsyncError() => l10n.searchFilterUnknown,
      _ => l10n.searchFilterLoading,
    };
    return SelectedFilterChip(
      label: label,
      removeLabel: l10n.searchRemoveFilter(label),
      onRemove: onRemove,
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.onChange});

  final RecipeQuery query;
  final void Function(RecipeQuery query) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = searchResultsProvider(query);
    return switch (ref.watch(provider)) {
      AsyncData(:final value) when value.items.isEmpty => _Empty(
        filtered: !query.isEmpty,
        fromCache: value.fromCache,
        query: query,
      ),
      AsyncData(:final value) => _ResultList(
        query: query,
        results: value,
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        onChange: onChange,
      ),
      AsyncError(:final error) => FailureView(
        error: error,
        onRetry: () => ref.invalidate(provider),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _ResultList extends ConsumerWidget {
  const _ResultList({
    required this.query,
    required this.results,
    required this.onLoadMore,
    required this.onChange,
  });

  final RecipeQuery query;
  final RecipeResults results;
  final VoidCallback onLoadMore;
  final void Function(RecipeQuery query) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final items = results.items;
    // Overviews carry no ingredients, so the pill echoes the food filters
    // rather than the matching ingredient and its amount.
    final foods = [
      for (final id in query.foodIds) ?ref.watch(foodProvider(id)).value,
    ];
    final footer = results.hasMore ? 1 : 0;

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(t.space5, t.space2, t.space5, t.space6),
      itemCount: 1 + items.length + footer,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: t.space1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (results.fromCache) ...[
                        Text(
                          l10n.searchOfflineResults,
                          style: t.caption.copyWith(color: t.inkMuted),
                        ),
                        SizedBox(height: t.space1),
                        if ((query.minTimesCooked ?? 0) > 1) ...[
                          Text(
                            l10n.searchOfflineTimesNote,
                            style: t.caption.copyWith(color: t.inkMuted),
                          ),
                          SizedBox(height: t.space1),
                        ],
                        if (query.maxMissingFoods != null) ...[
                          Text(
                            l10n.searchOfflineCookableNote,
                            style: t.caption.copyWith(color: t.inkMuted),
                          ),
                          SizedBox(height: t.space1),
                        ],
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          l10n.searchResultCount(results.totalCount),
                          style: t.label.copyWith(color: t.ink),
                        ),
                      ),
                    ),
                    _SortButton(query: query, onChange: onChange),
                  ],
                ),
              ],
            ),
          );
        }
        if (index > items.length) {
          return _LoadMore(
            // A new trigger for every page, so each loads the next one once.
            key: ValueKey(items.length),
            results: results,
            onLoadMore: onLoadMore,
          );
        }
        final match = items[index - 1];
        final recipe = match.recipe;
        return Padding(
          padding: EdgeInsets.only(bottom: t.space2),
          child: RecipeCard(
            title: recipe.name,
            image: recipe.image,
            meta: RecipeMetaLine(
              time: recipe.workingTime + recipe.waitingTime,
              rating: recipe.rating,
              lastCooked: recipe.lastCooked,
            ),
            match: _matchLabel(l10n, match, foods),
            onTap: () => context.push('/recipe/${recipe.id}'),
          ),
        );
      },
    );
  }
}

/// "Sortiert: passend": opens a sheet of the orders (mockup `03-suche`).
/// Relevance is only offered with search text; without, it is by name.
class _SortButton extends StatelessWidget {
  const _SortButton({required this.query, required this.onChange});

  final RecipeQuery query;
  final void Function(RecipeQuery query) onChange;

  Future<void> _pick(BuildContext context) async {
    final l10n = context.l10n;
    final current = query.effectiveSort;
    final sort = await showOptionSheet<RecipeSort>(
      context,
      title: l10n.searchSortTitle,
      hint: l10n.searchSortHint,
      selected: current,
      options: [
        for (final sort in RecipeSort.values)
          if (sort != RecipeSort.relevance || query.text.trim().isNotEmpty)
            (l10n.searchSortOption(sort.name), sort),
      ],
    );
    // Kept even when it is the default now, so it stays when the text changes.
    if (sort != null && sort != query.sort) {
      onChange(query.copyWith(sort: sort));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(t.radiusM),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.sizeTouch),
        child: Padding(
          padding: EdgeInsets.only(left: t.space3, right: t.space1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.searchSortButton(query.effectiveSort.name),
                style: t.caption.copyWith(color: t.inkMuted),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: t.label.fontSize! + t.space1,
                color: t.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The end of the loaded results: loads the next page as soon as it is
/// built, or offers to retry when that failed.
class _LoadMore extends StatefulWidget {
  const _LoadMore({super.key, required this.results, required this.onLoadMore});

  final RecipeResults results;
  final VoidCallback onLoadMore;

  @override
  State<_LoadMore> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<_LoadMore> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLoadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.space4),
      child: widget.results.loadMoreError == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  l10n.searchLoadMoreFailed,
                  textAlign: TextAlign.center,
                  style: t.body.copyWith(color: t.ink),
                ),
                SizedBox(height: t.space2),
                PillButton(
                  label: l10n.retry,
                  onPressed: widget.onLoadMore,
                  kind: PillButtonKind.secondary,
                  compact: true,
                ),
              ],
            ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    required this.filtered,
    required this.fromCache,
    required this.query,
  });

  /// Whether text or filters narrowed the search.
  final bool filtered;

  /// Whether only the offline cache was searched.
  final bool fromCache;

  /// For the notes on filters the offline cache can't apply like the
  /// server.
  final RecipeQuery query;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.space5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: t.sizeButton,
              color: t.inkMuted,
            ),
            SizedBox(height: t.space3),
            Text(
              fromCache
                  ? l10n.searchOfflineEmpty
                  : filtered
                  ? l10n.searchEmpty
                  : l10n.searchEmptyServer,
              textAlign: TextAlign.center,
              style: t.titleS.copyWith(color: t.ink),
            ),
            if (fromCache) ...[
              SizedBox(height: t.space2),
              for (final note in [
                if (query.savedFilter != null)
                  l10n.searchOfflineSavedNote
                else if (query.bookIds.isNotEmpty)
                  l10n.searchOfflineBookNote
                else
                  l10n.searchOfflineResults,
                if (query.maxMissingFoods != null)
                  l10n.searchOfflineCookableNote,
              ])
                Padding(
                  padding: EdgeInsets.only(bottom: t.space1),
                  child: Text(
                    note,
                    textAlign: TextAlign.center,
                    style: t.body.copyWith(color: t.inkMuted),
                  ),
                ),
            ] else if (filtered) ...[
              SizedBox(height: t.space2),
              Text(
                l10n.searchEmptyHint,
                textAlign: TextAlign.center,
                style: t.body.copyWith(color: t.inkMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
