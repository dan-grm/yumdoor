// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExportRequest extends ExportRequest {
  @override
  final bool? all;
  @override
  final CustomFilter? customFilter;
  @override
  final BuiltList<RecipeSimple>? recipes;
  @override
  final String type;

  factory _$ExportRequest([void Function(ExportRequestBuilder)? updates]) =>
      (ExportRequestBuilder()..update(updates))._build();

  _$ExportRequest._({
    this.all,
    this.customFilter,
    this.recipes,
    required this.type,
  }) : super._();
  @override
  ExportRequest rebuild(void Function(ExportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExportRequestBuilder toBuilder() => ExportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExportRequest &&
        all == other.all &&
        customFilter == other.customFilter &&
        recipes == other.recipes &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, all.hashCode);
    _$hash = $jc(_$hash, customFilter.hashCode);
    _$hash = $jc(_$hash, recipes.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExportRequest')
          ..add('all', all)
          ..add('customFilter', customFilter)
          ..add('recipes', recipes)
          ..add('type', type))
        .toString();
  }
}

class ExportRequestBuilder
    implements Builder<ExportRequest, ExportRequestBuilder> {
  _$ExportRequest? _$v;

  bool? _all;
  bool? get all => _$this._all;
  set all(bool? all) => _$this._all = all;

  CustomFilterBuilder? _customFilter;
  CustomFilterBuilder get customFilter =>
      _$this._customFilter ??= CustomFilterBuilder();
  set customFilter(CustomFilterBuilder? customFilter) =>
      _$this._customFilter = customFilter;

  ListBuilder<RecipeSimple>? _recipes;
  ListBuilder<RecipeSimple> get recipes =>
      _$this._recipes ??= ListBuilder<RecipeSimple>();
  set recipes(ListBuilder<RecipeSimple>? recipes) => _$this._recipes = recipes;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ExportRequestBuilder() {
    ExportRequest._defaults(this);
  }

  ExportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _all = $v.all;
      _customFilter = $v.customFilter?.toBuilder();
      _recipes = $v.recipes?.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExportRequest other) {
    _$v = other as _$ExportRequest;
  }

  @override
  void update(void Function(ExportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExportRequest build() => _build();

  _$ExportRequest _build() {
    _$ExportRequest _$result;
    try {
      _$result =
          _$v ??
          _$ExportRequest._(
            all: all,
            customFilter: _customFilter?.build(),
            recipes: _recipes?.build(),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'ExportRequest',
              'type',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customFilter';
        _customFilter?.build();
        _$failedField = 'recipes';
        _recipes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ExportRequest',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
