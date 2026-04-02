// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoalsController)
final goalsControllerProvider = GoalsControllerProvider._();

final class GoalsControllerProvider
    extends $AsyncNotifierProvider<GoalsController, List<Goal>> {
  GoalsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsControllerHash();

  @$internal
  @override
  GoalsController create() => GoalsController();
}

String _$goalsControllerHash() => r'75d77ee07d737b9e4213af288138bc292907bb46';

abstract class _$GoalsController extends $AsyncNotifier<List<Goal>> {
  FutureOr<List<Goal>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Goal>>, List<Goal>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Goal>>, List<Goal>>,
              AsyncValue<List<Goal>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
