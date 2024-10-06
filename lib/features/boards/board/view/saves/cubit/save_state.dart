part of 'save_cubit.dart';

enum SaveStatus {
  initial,
  loading,
  loaded,
  saved,
  success,
  failure,
}

final class SaveState extends Equatable {
  const SaveState._({
    this.status = SaveStatus.initial,
    this.saved = false,
    this.saves = 0,
  });

  // initial state
  const SaveState.initial() : this._();

  final SaveStatus status;
  final bool saved;
  final int saves;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        saved,
        saves,
      ];

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

extension SaveStateExtensions on SaveState {
  bool get isLoaded => status == SaveStatus.loaded;
  bool get isLoading => status == SaveStatus.loading;
  bool get isFailure => status == SaveStatus.failure;
  bool get isSaved => status == SaveStatus.saved;
  bool get isSuccess => status == SaveStatus.success;
}

extension _SaveStateExtensions on SaveState {
  SaveState fromLoading() => copyWith(status: SaveStatus.loading);

  SaveState fromSaveSuccess({required bool isSaved, required int saves}) =>
      copyWith(status: SaveStatus.success, saved: isSaved, saves: saves);
}
