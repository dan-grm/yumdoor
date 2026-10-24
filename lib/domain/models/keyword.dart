import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyword.freezed.dart';
part 'keyword.g.dart';

/// A recipe keyword such as "Suppe". Keywords form a tree like foods.
@freezed
abstract class Keyword with _$Keyword {
  const factory Keyword({
    required int id,
    required String name,

    /// The parent in the keyword tree, `null` for a root or when unknown
    /// (recipe summaries only carry id and name).
    int? parentId,
  }) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) =>
      _$KeywordFromJson(json);
}
