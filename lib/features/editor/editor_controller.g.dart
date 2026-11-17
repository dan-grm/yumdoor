// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recipe editor's state: the single source for all its tabs.
///
/// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
/// the recipe fresh from the server and fails with [OfflineFailure] rather
/// than edit a cached copy; failures are shown with a retry button instead
/// of retrying on their own.
///
/// Saving overwrites the recipe as it is on the server: the last save wins,
/// without checking for changes made elsewhere meanwhile, like Tandoor's own
/// editor (decided in M3, docs/ROADMAP.md).
///
/// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
/// change, and when the editor closes), one draft per recipe and one for a
/// new recipe. Loading offers a stored draft that differs from the recipe
/// ([EditorState.offeredDraft]); saving deletes it, and so does
/// [discardChanges].

@ProviderFor(RecipeEditor)
final recipeEditorProvider = RecipeEditorFamily._();

/// The recipe editor's state: the single source for all its tabs.
///
/// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
/// the recipe fresh from the server and fails with [OfflineFailure] rather
/// than edit a cached copy; failures are shown with a retry button instead
/// of retrying on their own.
///
/// Saving overwrites the recipe as it is on the server: the last save wins,
/// without checking for changes made elsewhere meanwhile, like Tandoor's own
/// editor (decided in M3, docs/ROADMAP.md).
///
/// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
/// change, and when the editor closes), one draft per recipe and one for a
/// new recipe. Loading offers a stored draft that differs from the recipe
/// ([EditorState.offeredDraft]); saving deletes it, and so does
/// [discardChanges].
final class RecipeEditorProvider
    extends $AsyncNotifierProvider<RecipeEditor, EditorState> {
  /// The recipe editor's state: the single source for all its tabs.
  ///
  /// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
  /// the recipe fresh from the server and fails with [OfflineFailure] rather
  /// than edit a cached copy; failures are shown with a retry button instead
  /// of retrying on their own.
  ///
  /// Saving overwrites the recipe as it is on the server: the last save wins,
  /// without checking for changes made elsewhere meanwhile, like Tandoor's own
  /// editor (decided in M3, docs/ROADMAP.md).
  ///
  /// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
  /// change, and when the editor closes), one draft per recipe and one for a
  /// new recipe. Loading offers a stored draft that differs from the recipe
  /// ([EditorState.offeredDraft]); saving deletes it, and so does
  /// [discardChanges].
  RecipeEditorProvider._({
    required RecipeEditorFamily super.from,
    required int? super.argument,
  }) : super(
         retry: _noRetry,
         name: r'recipeEditorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeEditorHash();

  @override
  String toString() {
    return r'recipeEditorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RecipeEditor create() => RecipeEditor();

  @override
  bool operator ==(Object other) {
    return other is RecipeEditorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeEditorHash() => r'b1a2335f9d89a2746cae9394bbb2477f221c61ca';

/// The recipe editor's state: the single source for all its tabs.
///
/// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
/// the recipe fresh from the server and fails with [OfflineFailure] rather
/// than edit a cached copy; failures are shown with a retry button instead
/// of retrying on their own.
///
/// Saving overwrites the recipe as it is on the server: the last save wins,
/// without checking for changes made elsewhere meanwhile, like Tandoor's own
/// editor (decided in M3, docs/ROADMAP.md).
///
/// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
/// change, and when the editor closes), one draft per recipe and one for a
/// new recipe. Loading offers a stored draft that differs from the recipe
/// ([EditorState.offeredDraft]); saving deletes it, and so does
/// [discardChanges].

final class RecipeEditorFamily extends $Family
    with
        $ClassFamilyOverride<
          RecipeEditor,
          AsyncValue<EditorState>,
          EditorState,
          FutureOr<EditorState>,
          int?
        > {
  RecipeEditorFamily._()
    : super(
        retry: _noRetry,
        name: r'recipeEditorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe editor's state: the single source for all its tabs.
  ///
  /// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
  /// the recipe fresh from the server and fails with [OfflineFailure] rather
  /// than edit a cached copy; failures are shown with a retry button instead
  /// of retrying on their own.
  ///
  /// Saving overwrites the recipe as it is on the server: the last save wins,
  /// without checking for changes made elsewhere meanwhile, like Tandoor's own
  /// editor (decided in M3, docs/ROADMAP.md).
  ///
  /// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
  /// change, and when the editor closes), one draft per recipe and one for a
  /// new recipe. Loading offers a stored draft that differs from the recipe
  /// ([EditorState.offeredDraft]); saving deletes it, and so does
  /// [discardChanges].

  RecipeEditorProvider call(int? recipeId) =>
      RecipeEditorProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeEditorProvider';
}

/// The recipe editor's state: the single source for all its tabs.
///
/// [recipeId] is the recipe to edit, `null` for a new one. Loading fetches
/// the recipe fresh from the server and fails with [OfflineFailure] rather
/// than edit a cached copy; failures are shown with a retry button instead
/// of retrying on their own.
///
/// Saving overwrites the recipe as it is on the server: the last save wins,
/// without checking for changes made elsewhere meanwhile, like Tandoor's own
/// editor (decided in M3, docs/ROADMAP.md).
///
/// Unsaved changes are kept in the [DraftStore] ([draftDelay] after the last
/// change, and when the editor closes), one draft per recipe and one for a
/// new recipe. Loading offers a stored draft that differs from the recipe
/// ([EditorState.offeredDraft]); saving deletes it, and so does
/// [discardChanges].

abstract class _$RecipeEditor extends $AsyncNotifier<EditorState> {
  late final _$args = ref.$arg as int?;
  int? get recipeId => _$args;

  FutureOr<EditorState> build(int? recipeId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EditorState>, EditorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditorState>, EditorState>,
              AsyncValue<EditorState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
