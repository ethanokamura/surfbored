import 'package:app_core/app_core.dart';

class CommentFailure extends Failure {
  const CommentFailure._();

  factory CommentFailure.fromCreate() => const CreateFailure();
  factory CommentFailure.fromGet() => const ReadFailure();
  factory CommentFailure.fromUpdate() => const UpdateFailure();
  factory CommentFailure.fromDelete() => const DeleteFailure();
  factory CommentFailure.fromAdd() => const AddLikeFailure();
  factory CommentFailure.fromRemove() => const RemoveLikeFailure();
  factory CommentFailure.fromStream() => const StreamFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends CommentFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends CommentFailure {
  const ReadFailure() : super._();
}

class StreamFailure extends CommentFailure {
  const StreamFailure() : super._();
}

class UpdateFailure extends CommentFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends CommentFailure {
  const DeleteFailure() : super._();
}

class AddLikeFailure extends CommentFailure {
  const AddLikeFailure() : super._();
}

class RemoveLikeFailure extends CommentFailure {
  const RemoveLikeFailure() : super._();
}

class EmptyFailure extends CommentFailure {
  const EmptyFailure() : super._();
}
