import '../../core/failures.dart';
import '../models/shopping.dart';

/// The shopping list of the current user's household. Methods throw a
/// [Failure].
abstract interface class ShoppingRepository {
  /// Reads the shopping list: entries of the current user and everyone in
  /// their household.
  ///
  /// With [updatedAfter] (a previous [ShoppingListSnapshot.syncedAt]), only
  /// the entries created, changed, checked or unchecked since then, by
  /// anyone in the household. Deleted entries are not reported, so read the
  /// whole list now and then.
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter});

  /// Checks off ([checked] `true`) or unchecks the entries with [ids].
  /// Ids the household doesn't have are ignored.
  Future<void> setChecked(Set<int> ids, {required bool checked});

  /// The supermarkets of the space with their category order.
  Future<List<Supermarket>> supermarkets();
}
