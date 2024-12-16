import 'package:app_core/app_core.dart';

class PostFailure extends Failure {
  const PostFailure._();

  factory PostFailure.fromCreate() => const CreateFailure();
  factory PostFailure.fromGet() => const ReadFailure();
  factory PostFailure.fromUpdate() => const UpdateFailure();
  factory PostFailure.fromDelete() => const DeleteFailure();
  factory PostFailure.fromAdd() => const AddLikeFailure();
  factory PostFailure.fromRemove() => const RemoveLikeFailure();
  factory PostFailure.fromStream() => const StreamFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends PostFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends PostFailure {
  const ReadFailure() : super._();
}

class StreamFailure extends PostFailure {
  const StreamFailure() : super._();
}

class UpdateFailure extends PostFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends PostFailure {
  const DeleteFailure() : super._();
}

class AddLikeFailure extends PostFailure {
  const AddLikeFailure() : super._();
}

class RemoveLikeFailure extends PostFailure {
  const RemoveLikeFailure() : super._();
}

class EmptyFailure extends PostFailure {
  const EmptyFailure() : super._();
}
