import 'package:app_core/app_core.dart';

class PostFailure extends Failure {
  const PostFailure._();

  factory PostFailure.fromCreatePost() => const CreatePostFailure();
  factory PostFailure.fromGetPost() => const GetPostFailure();
  factory PostFailure.fromUpdatePost() => const UpdatePostFailure();
  factory PostFailure.fromDeletePost() => const DeletePostFailure();

  static const empty = EmptyPostFailure();
}

class CreatePostFailure extends PostFailure {
  const CreatePostFailure() : super._();
}

class GetPostFailure extends PostFailure {
  const GetPostFailure() : super._();
}

class UpdatePostFailure extends PostFailure {
  const UpdatePostFailure() : super._();
}

class DeletePostFailure extends PostFailure {
  const DeletePostFailure() : super._();
}

class EmptyPostFailure extends PostFailure {
  const EmptyPostFailure() : super._();
}
