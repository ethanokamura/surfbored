import 'package:app_core/app_core.dart';

class FriendFailure extends Failure {
  const FriendFailure._();

  // friend data retrieval
  factory FriendFailure.fromGetFriend() => const GetFriendFailure();
  factory FriendFailure.fromCreateFriend() => const CreateFriendFailure();
  factory FriendFailure.fromUpdateFriend() => const UpdateFriendFailure();
  factory FriendFailure.fromDeleteFriend() => const DeleteFriendFailure();

  static const empty = EmptyFriendFailure();
}

class EmptyFriendFailure extends FriendFailure {
  const EmptyFriendFailure() : super._();
}

class GetFriendFailure extends FriendFailure {
  const GetFriendFailure() : super._();
}

class CreateFriendFailure extends FriendFailure {
  const CreateFriendFailure() : super._();
}

class UpdateFriendFailure extends FriendFailure {
  const UpdateFriendFailure() : super._();
}

class DeleteFriendFailure extends FriendFailure {
  const DeleteFriendFailure() : super._();
}
