part of 'like_cubit.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object?> get props => [];
}

class LikeInitial extends LikeState {}

class LikeLoading extends LikeState {}

class LikeSuccess extends LikeState {
  const LikeSuccess({required this.isLiked, required this.likes});
  final bool isLiked;
  final int likes;
  @override
  List<Object?> get props => [isLiked, likes];
}

class LikeFailure extends LikeState {
  const LikeFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
