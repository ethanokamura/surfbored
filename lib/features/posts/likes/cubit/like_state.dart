part of 'like_cubit.dart';

enum LikeStatus {
  initial,
  loading,
  loaded,
  liked,
  success,
  failure,
}

final class LikeState extends Equatable {
  const LikeState._({
    this.status = LikeStatus.initial,
    this.liked = false,
    this.likes = 0,
  });

  // initial state
  const LikeState.initial() : this._();

  final LikeStatus status;
  final bool liked;
  final int likes;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        liked,
        likes,
      ];

  LikeState copyWith({
    LikeStatus? status,
    bool? liked,
    int? likes,
  }) {
    return LikeState._(
      status: status ?? this.status,
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
    );
  }
}

extension LikeStateExtensions on LikeState {
  bool get isLoaded => status == LikeStatus.loaded;
  bool get isLoading => status == LikeStatus.loading;
  bool get isFailure => status == LikeStatus.failure;
  bool get isLiked => status == LikeStatus.liked;
  bool get isSuccess => status == LikeStatus.success;
}

extension _LikeStateExtensions on LikeState {
  LikeState fromLoading() => copyWith(status: LikeStatus.loading);

  LikeState fromLikeSuccess({required bool isLiked, required int likes}) =>
      copyWith(status: LikeStatus.success, liked: isLiked, likes: likes);
}
