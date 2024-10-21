part of 'save_cubit.dart';

/// Represents the different states a save operation can be in.
enum SaveStatus {
  initial,
  loading,
  loaded,
  saved,
  success,
  failure,
}

/// Represents the state of save-related operations.
final class SaveState extends Equatable {
  /// Private constructor for creating [SaveState] instances.
  const SaveState._({
    this.status = SaveStatus.initial,
    this.saved = false,
    this.saves = 0,
  });

  /// Creates an initial [SaveState].
  const SaveState.initial() : this._();

  final SaveStatus status;
  final bool saved;
  final int saves;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        saved,
        saves,
      ];

  /// Creates a new [SaveState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  SaveState copyWith({
    SaveStatus? status,
    bool? saved,
    int? saves,
  }) {
    return SaveState._(
      status: status ?? this.status,
      saved: saved ?? this.saved,
      saves: saves ?? this.saves,
    );
  }
}

/// Extension methods for convenient state checks.
extension SaveStateExtensions on SaveState {
  bool get isLoaded => status == SaveStatus.loaded;
  bool get isLoading => status == SaveStatus.loading;
  bool get isFailure => status == SaveStatus.failure;
  bool get isSaved => status == SaveStatus.saved;
  bool get isSuccess => status == SaveStatus.success;
}

/// Extension methods for creating new [SaveState] instances.
extension _SaveStateExtensions on SaveState {
  SaveState fromLoading() => copyWith(status: SaveStatus.loading);

  SaveState fromSaveSuccess({required bool isSaved, required int saves}) =>
      copyWith(status: SaveStatus.success, saved: isSaved, saves: saves);
}
