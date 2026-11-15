import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/saved_filter.dart';
import 'package:yumdoor/domain/repositories/saved_filter_repository.dart';

/// [SavedFilterRepository] for tests, keeping its [list] in memory. Set
/// [failure] to make every call throw.
class FakeSavedFilterRepository implements SavedFilterRepository {
  FakeSavedFilterRepository([List<SavedFilter> list = const []])
    : list = [...list];

  final List<SavedFilter> list;
  Failure? failure;

  /// The searches passed to [create], in order.
  final created = <RecipeQuery>[];

  @override
  Future<List<SavedFilter>> savedFilters() async {
    if (failure case final failure?) throw failure;
    return [...list]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Future<SavedFilter> create(String name, RecipeQuery query) async {
    if (failure case final failure?) throw failure;
    created.add(query);
    final id = list.fold(0, (max, f) => f.id > max ? f.id : max) + 1;
    final filter = SavedFilter(id: id, name: name, query: query);
    list.add(filter);
    return filter;
  }

  @override
  Future<SavedFilter> rename(int id, String name) async {
    if (failure case final failure?) throw failure;
    final index = list.indexWhere((f) => f.id == id);
    if (index < 0) throw const NotFoundFailure();
    return list[index] = list[index].copyWith(name: name);
  }

  @override
  Future<void> delete(int id) async {
    if (failure case final failure?) throw failure;
    if (list.indexWhere((f) => f.id == id) < 0) throw const NotFoundFailure();
    list.removeWhere((f) => f.id == id);
  }
}
