import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/food.dart';
import '../../domain/models/unit.dart';
import 'mapping.dart';

extension FoodMapper on api.Food {
  Food toDomain() => Food(
    id: requireId(id, 'Food'),
    name: name,
    pluralName: _nonEmpty(pluralName),
    parentId: parent,
    onHand: foodOnhand ?? false,
    ignoreShopping: ignoreShopping ?? false,
  );
}

extension UnitMapper on api.Unit {
  Unit toDomain() => Unit(
    id: requireId(id, 'Unit'),
    name: name,
    pluralName: _nonEmpty(pluralName),
  );
}

String? _nonEmpty(String? value) =>
    value == null || value.isEmpty ? null : value;
