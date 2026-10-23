// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current login, kept across app starts in the [TokenStore]; `null`
/// while nobody is logged in.
///
/// Only the token is stored, never the password. Starting the app reads the
/// stored session without asking the server, so it also starts offline.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// The current login, kept across app starts in the [TokenStore]; `null`
/// while nobody is logged in.
///
/// Only the token is stored, never the password. Starting the app reads the
/// stored session without asking the server, so it also starts offline.
final class SessionControllerProvider
    extends $AsyncNotifierProvider<SessionController, Session?> {
  /// The current login, kept across app starts in the [TokenStore]; `null`
  /// while nobody is logged in.
  ///
  /// Only the token is stored, never the password. Starting the app reads the
  /// stored session without asking the server, so it also starts offline.
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();
}

String _$sessionControllerHash() => r'51bdf2eb8a4a8f7090b57da8ede5ff7a0403187f';

/// The current login, kept across app starts in the [TokenStore]; `null`
/// while nobody is logged in.
///
/// Only the token is stored, never the password. Starting the app reads the
/// stored session without asking the server, so it also starts offline.

abstract class _$SessionController extends $AsyncNotifier<Session?> {
  FutureOr<Session?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Session?>, Session?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Session?>, Session?>,
              AsyncValue<Session?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The server of the last session, to prefill login.

@ProviderFor(savedServerUrl)
final savedServerUrlProvider = SavedServerUrlProvider._();

/// The server of the last session, to prefill login.

final class SavedServerUrlProvider
    extends $FunctionalProvider<AsyncValue<Uri?>, Uri?, FutureOr<Uri?>>
    with $FutureModifier<Uri?>, $FutureProvider<Uri?> {
  /// The server of the last session, to prefill login.
  SavedServerUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedServerUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedServerUrlHash();

  @$internal
  @override
  $FutureProviderElement<Uri?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uri?> create(Ref ref) {
    return savedServerUrl(ref);
  }
}

String _$savedServerUrlHash() => r'aa00433275673cd1ba205765d49f2c807f4abf18';
