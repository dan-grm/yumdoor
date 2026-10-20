// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Automation extends Automation {
  @override
  final int? createdBy;
  @override
  final String? description;
  @override
  final bool? disabled;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final int? order;
  @override
  final String? param1;
  @override
  final String? param2;
  @override
  final String? param3;
  @override
  final AutomationTypeEnum type;

  factory _$Automation([void Function(AutomationBuilder)? updates]) =>
      (AutomationBuilder()..update(updates))._build();

  _$Automation._({
    this.createdBy,
    this.description,
    this.disabled,
    this.id,
    this.name,
    this.order,
    this.param1,
    this.param2,
    this.param3,
    required this.type,
  }) : super._();
  @override
  Automation rebuild(void Function(AutomationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutomationBuilder toBuilder() => AutomationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Automation &&
        createdBy == other.createdBy &&
        description == other.description &&
        disabled == other.disabled &&
        id == other.id &&
        name == other.name &&
        order == other.order &&
        param1 == other.param1 &&
        param2 == other.param2 &&
        param3 == other.param3 &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, disabled.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, param1.hashCode);
    _$hash = $jc(_$hash, param2.hashCode);
    _$hash = $jc(_$hash, param3.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Automation')
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('disabled', disabled)
          ..add('id', id)
          ..add('name', name)
          ..add('order', order)
          ..add('param1', param1)
          ..add('param2', param2)
          ..add('param3', param3)
          ..add('type', type))
        .toString();
  }
}

class AutomationBuilder implements Builder<Automation, AutomationBuilder> {
  _$Automation? _$v;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _disabled;
  bool? get disabled => _$this._disabled;
  set disabled(bool? disabled) => _$this._disabled = disabled;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  String? _param1;
  String? get param1 => _$this._param1;
  set param1(String? param1) => _$this._param1 = param1;

  String? _param2;
  String? get param2 => _$this._param2;
  set param2(String? param2) => _$this._param2 = param2;

  String? _param3;
  String? get param3 => _$this._param3;
  set param3(String? param3) => _$this._param3 = param3;

  AutomationTypeEnum? _type;
  AutomationTypeEnum? get type => _$this._type;
  set type(AutomationTypeEnum? type) => _$this._type = type;

  AutomationBuilder() {
    Automation._defaults(this);
  }

  AutomationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdBy = $v.createdBy;
      _description = $v.description;
      _disabled = $v.disabled;
      _id = $v.id;
      _name = $v.name;
      _order = $v.order;
      _param1 = $v.param1;
      _param2 = $v.param2;
      _param3 = $v.param3;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Automation other) {
    _$v = other as _$Automation;
  }

  @override
  void update(void Function(AutomationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Automation build() => _build();

  _$Automation _build() {
    final _$result =
        _$v ??
        _$Automation._(
          createdBy: createdBy,
          description: description,
          disabled: disabled,
          id: id,
          name: name,
          order: order,
          param1: param1,
          param2: param2,
          param3: param3,
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'Automation',
            'type',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
