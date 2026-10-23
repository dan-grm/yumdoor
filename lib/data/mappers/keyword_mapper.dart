import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/keyword.dart';
import 'mapping.dart';

extension KeywordMapper on api.Keyword {
  Keyword toDomain() =>
      Keyword(id: requireId(id, 'Keyword'), name: name, parentId: parent);
}

/// The short form in recipe lists (`RecipeOverview.keywords`).
extension KeywordLabelMapper on api.KeywordLabel {
  Keyword toDomain() =>
      Keyword(id: requireId(id, 'KeywordLabel'), name: label ?? '');
}
