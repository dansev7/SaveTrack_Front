// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateTransactionController)
final createTransactionControllerProvider =
    CreateTransactionControllerProvider._();

final class CreateTransactionControllerProvider
    extends $NotifierProvider<CreateTransactionController, AsyncValue<void>> {
  CreateTransactionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTransactionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTransactionControllerHash();

  @$internal
  @override
  CreateTransactionController create() => CreateTransactionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$createTransactionControllerHash() =>
    r'2984dd99f4db994f6246a17be9db42387689bf83';

abstract class _$CreateTransactionController
    extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
