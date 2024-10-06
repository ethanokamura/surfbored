import 'package:app_core/app_core.dart';

class FriendFailure extends Failure {
  const FriendFailure._();

  factory FriendFailure.fromCreate() => const CreateFailure();
  factory FriendFailure.fromGet() => const ReadFailure();
  factory FriendFailure.fromUpdate() => const UpdateFailure();
  factory FriendFailure.fromDelete() => const DeleteFailure();
  factory FriendFailure.fromStream() => const StreamFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends FriendFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends FriendFailure {
  const ReadFailure() : super._();
}

class StreamFailure extends FriendFailure {
  const StreamFailure() : super._();
}

class UpdateFailure extends FriendFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends FriendFailure {
  const DeleteFailure() : super._();
}

class EmptyFailure extends FriendFailure {
  const EmptyFailure() : super._();
}
