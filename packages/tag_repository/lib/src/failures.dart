import 'package:app_core/app_core.dart';

class TagFailure extends Failure {
  const TagFailure._();

  factory TagFailure.fromCreate() => const CreateFailure();
  factory TagFailure.fromGet() => const ReadFailure();
  factory TagFailure.fromUpdate() => const UpdateFailure();
  factory TagFailure.fromDelete() => const DeleteFailure();
  factory TagFailure.fromStream() => const StreamFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends TagFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends TagFailure {
  const ReadFailure() : super._();
}

class StreamFailure extends TagFailure {
  const StreamFailure() : super._();
}

class UpdateFailure extends TagFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends TagFailure {
  const DeleteFailure() : super._();
}

class EmptyFailure extends TagFailure {
  const EmptyFailure() : super._();
}
