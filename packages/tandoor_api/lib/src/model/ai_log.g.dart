// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AiLog extends AiLog {
  @override
  final AiProvider? aiProvider;
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final double creditCost;
  @override
  final bool? creditsFromBalance;
  @override
  final DateTime? endTime;
  @override
  final String function_;
  @override
  final int? id;
  @override
  final int? inputTokens;
  @override
  final int? outputTokens;
  @override
  final DateTime? startTime;
  @override
  final DateTime? updatedAt;

  factory _$AiLog([void Function(AiLogBuilder)? updates]) =>
      (AiLogBuilder()..update(updates))._build();

  _$AiLog._({
    this.aiProvider,
    this.createdAt,
    this.createdBy,
    required this.creditCost,
    this.creditsFromBalance,
    this.endTime,
    required this.function_,
    this.id,
    this.inputTokens,
    this.outputTokens,
    this.startTime,
    this.updatedAt,
  }) : super._();
  @override
  AiLog rebuild(void Function(AiLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiLogBuilder toBuilder() => AiLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiLog &&
        aiProvider == other.aiProvider &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        creditCost == other.creditCost &&
        creditsFromBalance == other.creditsFromBalance &&
        endTime == other.endTime &&
        function_ == other.function_ &&
        id == other.id &&
        inputTokens == other.inputTokens &&
        outputTokens == other.outputTokens &&
        startTime == other.startTime &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, aiProvider.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, creditCost.hashCode);
    _$hash = $jc(_$hash, creditsFromBalance.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, function_.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inputTokens.hashCode);
    _$hash = $jc(_$hash, outputTokens.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiLog')
          ..add('aiProvider', aiProvider)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('creditCost', creditCost)
          ..add('creditsFromBalance', creditsFromBalance)
          ..add('endTime', endTime)
          ..add('function_', function_)
          ..add('id', id)
          ..add('inputTokens', inputTokens)
          ..add('outputTokens', outputTokens)
          ..add('startTime', startTime)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AiLogBuilder implements Builder<AiLog, AiLogBuilder> {
  _$AiLog? _$v;

  AiProviderBuilder? _aiProvider;
  AiProviderBuilder get aiProvider =>
      _$this._aiProvider ??= AiProviderBuilder();
  set aiProvider(AiProviderBuilder? aiProvider) =>
      _$this._aiProvider = aiProvider;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  double? _creditCost;
  double? get creditCost => _$this._creditCost;
  set creditCost(double? creditCost) => _$this._creditCost = creditCost;

  bool? _creditsFromBalance;
  bool? get creditsFromBalance => _$this._creditsFromBalance;
  set creditsFromBalance(bool? creditsFromBalance) =>
      _$this._creditsFromBalance = creditsFromBalance;

  DateTime? _endTime;
  DateTime? get endTime => _$this._endTime;
  set endTime(DateTime? endTime) => _$this._endTime = endTime;

  String? _function_;
  String? get function_ => _$this._function_;
  set function_(String? function_) => _$this._function_ = function_;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _inputTokens;
  int? get inputTokens => _$this._inputTokens;
  set inputTokens(int? inputTokens) => _$this._inputTokens = inputTokens;

  int? _outputTokens;
  int? get outputTokens => _$this._outputTokens;
  set outputTokens(int? outputTokens) => _$this._outputTokens = outputTokens;

  DateTime? _startTime;
  DateTime? get startTime => _$this._startTime;
  set startTime(DateTime? startTime) => _$this._startTime = startTime;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AiLogBuilder() {
    AiLog._defaults(this);
  }

  AiLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _aiProvider = $v.aiProvider?.toBuilder();
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _creditCost = $v.creditCost;
      _creditsFromBalance = $v.creditsFromBalance;
      _endTime = $v.endTime;
      _function_ = $v.function_;
      _id = $v.id;
      _inputTokens = $v.inputTokens;
      _outputTokens = $v.outputTokens;
      _startTime = $v.startTime;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiLog other) {
    _$v = other as _$AiLog;
  }

  @override
  void update(void Function(AiLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiLog build() => _build();

  _$AiLog _build() {
    _$AiLog _$result;
    try {
      _$result =
          _$v ??
          _$AiLog._(
            aiProvider: _aiProvider?.build(),
            createdAt: createdAt,
            createdBy: createdBy,
            creditCost: BuiltValueNullFieldError.checkNotNull(
              creditCost,
              r'AiLog',
              'creditCost',
            ),
            creditsFromBalance: creditsFromBalance,
            endTime: endTime,
            function_: BuiltValueNullFieldError.checkNotNull(
              function_,
              r'AiLog',
              'function_',
            ),
            id: id,
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            startTime: startTime,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'aiProvider';
        _aiProvider?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AiLog', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
