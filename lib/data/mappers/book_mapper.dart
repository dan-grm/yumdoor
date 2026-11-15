import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/recipe_book.dart';
import 'mapping.dart';

extension BookMapper on api.RecipeBook {
  RecipeBook toDomain() => RecipeBook(
    id: requireId(id, 'RecipeBook'),
    name: name,
    isDynamic: filter != null,
  );
}
