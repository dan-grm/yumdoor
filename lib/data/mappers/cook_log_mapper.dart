import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/cook_log.dart';
import 'mapping.dart';
import 'user_mapper.dart';

extension CookLogMapper on api.CookLog {
  CookLog toDomain() => CookLog(
    id: requireId(id, 'CookLog'),
    recipeId: recipe,
    servings: servings,
    rating: rating,
    comment: switch (comment?.trim()) {
      final text? when text.isNotEmpty => text,
      _ => null,
    },
    createdBy: createdBy?.toDomain(),
    createdAt:
        createdAt ?? (throw const FormatException('CookLog without a date')),
  );
}

extension NewCookLogMapper on NewCookLog {
  /// The request body. `created_at` is left out, so the server uses now.
  api.CookLog toApi() => api.CookLog(
    (b) => b
      ..recipe = recipeId
      ..servings = servings
      ..rating = rating
      ..comment = comment,
  );
}
