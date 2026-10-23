import 'package:freezed_annotation/freezed_annotation.dart';

part 'food.freezed.dart';

/// A food such as "Karotte". Foods form a tree ("Gemüse > Wurzelgemüse >
/// Karotte"); filtering by a food includes its children.
@freezed
abstract class Food with _$Food {
  const factory Food({
    required int id,
    required String name,
    String? pluralName,

    /// The parent in the food tree, `null` for a root.
    int? parentId,

    /// Someone in the household has it at home.
    @Default(false) bool onHand,

    /// Never goes on the shopping list (salt, water).
    @Default(false) bool ignoreShopping,
  }) = _Food;
}
