import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_ref.dart';

part 'cook_log.freezed.dart';

/// The lowest and highest rating of a cook log entry, in whole stars.
const minCookLogRating = 1;
const maxCookLogRating = 5;

/// An entry in Tandoor's cook log: someone cooked a recipe, optionally with a
/// rating and a comment. Every member of the space can read it.
@freezed
abstract class CookLog with _$CookLog {
  const factory CookLog({
    required int id,
    required int recipeId,

    /// The servings that were cooked, `null` if not recorded.
    int? servings,

    /// 1 to 5 stars, `null` if not rated.
    int? rating,

    /// `null` if there is none.
    String? comment,
    UserRef? createdBy,
    required DateTime createdAt,
  }) = _CookLog;
}

/// A cook log entry to create, for the current user and the current time.
class NewCookLog {
  /// Throws an [ArgumentError] for [servings] below 1 or a [rating] outside
  /// [minCookLogRating]..[maxCookLogRating]. A blank [comment] counts as none.
  factory NewCookLog({
    required int recipeId,
    required int servings,
    int? rating,
    String? comment,
  }) {
    if (servings < 1) {
      throw ArgumentError.value(servings, 'servings', 'must be at least 1');
    }
    if (rating != null &&
        (rating < minCookLogRating || rating > maxCookLogRating)) {
      throw ArgumentError.value(
        rating,
        'rating',
        'must be $minCookLogRating to $maxCookLogRating',
      );
    }
    final text = comment?.trim() ?? '';
    return NewCookLog._(recipeId, servings, rating, text.isEmpty ? null : text);
  }

  const NewCookLog._(this.recipeId, this.servings, this.rating, this.comment);

  final int recipeId;
  final int servings;
  final int? rating;
  final String? comment;

  @override
  bool operator ==(Object other) =>
      other is NewCookLog &&
      other.recipeId == recipeId &&
      other.servings == servings &&
      other.rating == rating &&
      other.comment == comment;

  @override
  int get hashCode => Object.hash(recipeId, servings, rating, comment);

  @override
  String toString() =>
      'NewCookLog(recipeId: $recipeId, servings: $servings, rating: $rating, '
      'comment: $comment)';
}
