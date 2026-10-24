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
import '../../domain/models/recipe_query.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../recipe/recipe_meta.dart';
import 'filter_picker_sheet.dart';
import 'search_location.dart';
import 'search_providers.dart';

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
    _debounce?.cancel();
    final location = searchLocation(query.copyWith(text: _text.text.trim()));
    Router.neglect(context, () => context.go(location));
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
                children: [
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
                ],
              ),
            ),
            Expanded(child: _Results(query: query)),
          ],
        ),
      ),
    );
  }
}

/// "enthält Karotten": the plural if the food has one.
String _foodLabel(BuildContext context, Food food) =>
    context.l10n.searchFoodFilter(food.pluralName ?? food.name);

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
  const _Results({required this.query});

  final RecipeQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = searchResultsProvider(query);
    return switch (ref.watch(provider)) {
      AsyncData(:final value) when value.items.isEmpty => _Empty(
        filtered: !query.isEmpty,
        fromCache: value.fromCache,
      ),
      AsyncData(:final value) => _ResultList(
        query: query,
        results: value,
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
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
  });

  final RecipeQuery query;
  final RecipeResults results;
  final VoidCallback onLoadMore;

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
    final match = foods.isEmpty
        ? null
        : l10n.searchFoodFilter(
            foods.map((food) => food.pluralName ?? food.name).join(', '),
          );
    final footer = results.hasMore ? 1 : 0;

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(t.space5, t.space2, t.space5, t.space6),
      itemCount: 1 + items.length + footer,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: t.space2),
            child: Semantics(
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
                  ],
                  Text(
                    l10n.searchResultCount(results.totalCount),
                    style: t.label.copyWith(color: t.ink),
                  ),
                ],
              ),
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
        final recipe = items[index - 1];
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
            match: match,
            onTap: () => context.push('/recipe/${recipe.id}'),
          ),
        );
      },
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
  const _Empty({required this.filtered, required this.fromCache});

  /// Whether text or filters narrowed the search.
  final bool filtered;

  /// Whether only the offline cache was searched.
  final bool fromCache;

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
              Text(
                l10n.searchOfflineResults,
                textAlign: TextAlign.center,
                style: t.body.copyWith(color: t.inkMuted),
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
