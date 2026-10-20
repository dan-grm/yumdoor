// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_information.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NutritionInformation extends NutritionInformation {
  @override
  final double calories;
  @override
  final double carbohydrates;
  @override
  final double fats;
  @override
  final int? id;
  @override
  final double proteins;
  @override
  final String? source_;

  factory _$NutritionInformation([
    void Function(NutritionInformationBuilder)? updates,
  ]) => (NutritionInformationBuilder()..update(updates))._build();

  _$NutritionInformation._({
    required this.calories,
    required this.carbohydrates,
    required this.fats,
    this.id,
    required this.proteins,
    this.source_,
  }) : super._();
  @override
  NutritionInformation rebuild(
    void Function(NutritionInformationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  NutritionInformationBuilder toBuilder() =>
      NutritionInformationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NutritionInformation &&
        calories == other.calories &&
        carbohydrates == other.carbohydrates &&
        fats == other.fats &&
        id == other.id &&
        proteins == other.proteins &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, calories.hashCode);
    _$hash = $jc(_$hash, carbohydrates.hashCode);
    _$hash = $jc(_$hash, fats.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, proteins.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NutritionInformation')
          ..add('calories', calories)
          ..add('carbohydrates', carbohydrates)
          ..add('fats', fats)
          ..add('id', id)
          ..add('proteins', proteins)
          ..add('source_', source_))
        .toString();
  }
}

class NutritionInformationBuilder
    implements Builder<NutritionInformation, NutritionInformationBuilder> {
  _$NutritionInformation? _$v;

  double? _calories;
  double? get calories => _$this._calories;
  set calories(double? calories) => _$this._calories = calories;

  double? _carbohydrates;
  double? get carbohydrates => _$this._carbohydrates;
  set carbohydrates(double? carbohydrates) =>
      _$this._carbohydrates = carbohydrates;

  double? _fats;
  double? get fats => _$this._fats;
  set fats(double? fats) => _$this._fats = fats;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  double? _proteins;
  double? get proteins => _$this._proteins;
  set proteins(double? proteins) => _$this._proteins = proteins;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  NutritionInformationBuilder() {
    NutritionInformation._defaults(this);
  }

  NutritionInformationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _calories = $v.calories;
      _carbohydrates = $v.carbohydrates;
      _fats = $v.fats;
      _id = $v.id;
      _proteins = $v.proteins;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NutritionInformation other) {
    _$v = other as _$NutritionInformation;
  }

  @override
  void update(void Function(NutritionInformationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NutritionInformation build() => _build();

  _$NutritionInformation _build() {
    final _$result =
        _$v ??
        _$NutritionInformation._(
          calories: BuiltValueNullFieldError.checkNotNull(
            calories,
            r'NutritionInformation',
            'calories',
          ),
          carbohydrates: BuiltValueNullFieldError.checkNotNull(
            carbohydrates,
            r'NutritionInformation',
            'carbohydrates',
          ),
          fats: BuiltValueNullFieldError.checkNotNull(
            fats,
            r'NutritionInformation',
            'fats',
          ),
          id: id,
          proteins: BuiltValueNullFieldError.checkNotNull(
            proteins,
            r'NutritionInformation',
            'proteins',
          ),
          source_: source_,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
