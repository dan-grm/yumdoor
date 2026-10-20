// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_open_data_response_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportOpenDataResponseDetail extends ImportOpenDataResponseDetail {
  @override
  final int? totalCreated;
  @override
  final int? totalErrored;
  @override
  final int? totalUntouched;
  @override
  final int? totalUpdated;

  factory _$ImportOpenDataResponseDetail([
    void Function(ImportOpenDataResponseDetailBuilder)? updates,
  ]) => (ImportOpenDataResponseDetailBuilder()..update(updates))._build();

  _$ImportOpenDataResponseDetail._({
    this.totalCreated,
    this.totalErrored,
    this.totalUntouched,
    this.totalUpdated,
  }) : super._();
  @override
  ImportOpenDataResponseDetail rebuild(
    void Function(ImportOpenDataResponseDetailBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ImportOpenDataResponseDetailBuilder toBuilder() =>
      ImportOpenDataResponseDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportOpenDataResponseDetail &&
        totalCreated == other.totalCreated &&
        totalErrored == other.totalErrored &&
        totalUntouched == other.totalUntouched &&
        totalUpdated == other.totalUpdated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalCreated.hashCode);
    _$hash = $jc(_$hash, totalErrored.hashCode);
    _$hash = $jc(_$hash, totalUntouched.hashCode);
    _$hash = $jc(_$hash, totalUpdated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportOpenDataResponseDetail')
          ..add('totalCreated', totalCreated)
          ..add('totalErrored', totalErrored)
          ..add('totalUntouched', totalUntouched)
          ..add('totalUpdated', totalUpdated))
        .toString();
  }
}

class ImportOpenDataResponseDetailBuilder
    implements
        Builder<
          ImportOpenDataResponseDetail,
          ImportOpenDataResponseDetailBuilder
        > {
  _$ImportOpenDataResponseDetail? _$v;

  int? _totalCreated;
  int? get totalCreated => _$this._totalCreated;
  set totalCreated(int? totalCreated) => _$this._totalCreated = totalCreated;

  int? _totalErrored;
  int? get totalErrored => _$this._totalErrored;
  set totalErrored(int? totalErrored) => _$this._totalErrored = totalErrored;

  int? _totalUntouched;
  int? get totalUntouched => _$this._totalUntouched;
  set totalUntouched(int? totalUntouched) =>
      _$this._totalUntouched = totalUntouched;

  int? _totalUpdated;
  int? get totalUpdated => _$this._totalUpdated;
  set totalUpdated(int? totalUpdated) => _$this._totalUpdated = totalUpdated;

  ImportOpenDataResponseDetailBuilder() {
    ImportOpenDataResponseDetail._defaults(this);
  }

  ImportOpenDataResponseDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalCreated = $v.totalCreated;
      _totalErrored = $v.totalErrored;
      _totalUntouched = $v.totalUntouched;
      _totalUpdated = $v.totalUpdated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportOpenDataResponseDetail other) {
    _$v = other as _$ImportOpenDataResponseDetail;
  }

  @override
  void update(void Function(ImportOpenDataResponseDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportOpenDataResponseDetail build() => _build();

  _$ImportOpenDataResponseDetail _build() {
    final _$result =
        _$v ??
        _$ImportOpenDataResponseDetail._(
          totalCreated: totalCreated,
          totalErrored: totalErrored,
          totalUntouched: totalUntouched,
          totalUpdated: totalUpdated,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
