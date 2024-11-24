import 'package:app_core/app_core.dart';

/// Manages the state and logic for the current shuffle index.
class ShuffleIndexCubit extends Cubit<int> {
  /// Creates a new instance of [ShuffleIndexCubit].
  ShuffleIndexCubit() : super(0);

  /// Increments or decrements index
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
