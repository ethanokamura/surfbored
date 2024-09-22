import 'package:app_core/app_core.dart';

class CommentFailure extends Failure {
  const CommentFailure._();

  factory CommentFailure.fromCreateComment() => const CreateCommentFailure();
  factory CommentFailure.fromGetComment() => const GetCommentFailure();
  factory CommentFailure.fromUpdateComment() => const UpdateCommentFailure();
  factory CommentFailure.fromDeleteComment() => const DeleteCommentFailure();

  static const empty = EmptyCommentFailure();
}

class CreateCommentFailure extends CommentFailure {
  const CreateCommentFailure() : super._();
}

class GetCommentFailure extends CommentFailure {
  const GetCommentFailure() : super._();
}

class UpdateCommentFailure extends CommentFailure {
  const UpdateCommentFailure() : super._();
}

class DeleteCommentFailure extends CommentFailure {
  const DeleteCommentFailure() : super._();
}

class EmptyCommentFailure extends CommentFailure {
  const EmptyCommentFailure() : super._();
}
