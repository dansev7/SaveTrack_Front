// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AsyncValue<AuthResponse?>> {
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AuthResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AuthResponse?>>(value),
    );
  }
}

String _$authControllerHash() => r'9042a096419cc5a39930c3386fcd50bcfbddcd78';

abstract class _$AuthController extends $Notifier<AsyncValue<AuthResponse?>> {
  AsyncValue<AuthResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AuthResponse?>, AsyncValue<AuthResponse?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthResponse?>, AsyncValue<AuthResponse?>>,
              AsyncValue<AuthResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
