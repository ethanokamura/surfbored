part of 'like_cubit.dart';

/// Represents the different states a post like can be in.
enum LikeStatus {
  initial,
  loading,
  loaded,
  liked,
  success,
  failure,
}

/// Represents the state of post like-related operations.
final class LikeState extends Equatable {
  /// Private constructor for creating [LikeState] instances.
  const LikeState._({
    this.status = LikeStatus.initial,
    this.liked = false,
    this.likes = 0,
  });

  /// Creates an initial [LikeState].
  const LikeState.initial() : this._();

  final LikeStatus status;
  final bool liked;
  final int likes;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        liked,
        likes,
      ];

  /// Creates a new [LikeState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
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

/// Extension methods for convenient state checks.
extension LikeStateExtensions on LikeState {
  bool get isLoaded => status == LikeStatus.loaded;
  bool get isLoading => status == LikeStatus.loading;
  bool get isFailure => status == LikeStatus.failure;
  bool get isLiked => status == LikeStatus.liked;
  bool get isSuccess => status == LikeStatus.success;
}

/// Extension methods for creating new [LikeState] instances.
extension _LikeStateExtensions on LikeState {
  LikeState fromLoading() => copyWith(status: LikeStatus.loading);

  LikeState fromLikeSuccess({required bool isLiked, required int likes}) =>
      copyWith(status: LikeStatus.success, liked: isLiked, likes: likes);
}
