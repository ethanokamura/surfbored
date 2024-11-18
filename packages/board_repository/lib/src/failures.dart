import 'package:app_core/app_core.dart';

class BoardFailure extends Failure {
  const BoardFailure._();

  factory BoardFailure.fromCreate() => const CreateFailure();
  factory BoardFailure.fromGet() => const ReadFailure();
  factory BoardFailure.fromUpdate() => const UpdateFailure();
  factory BoardFailure.fromDelete() => const DeleteFailure();
  factory BoardFailure.fromAdd() => const AddSaveFailure();
  factory BoardFailure.fromRemove() => const RemoveSaveFailure();
  factory BoardFailure.fromStream() => const StreamFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends BoardFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends BoardFailure {
  const ReadFailure() : super._();
}

class StreamFailure extends BoardFailure {
  const StreamFailure() : super._();
}

class UpdateFailure extends BoardFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends BoardFailure {
  const DeleteFailure() : super._();
}

class AddSaveFailure extends BoardFailure {
  const AddSaveFailure() : super._();
}

class RemoveSaveFailure extends BoardFailure {
  const RemoveSaveFailure() : super._();
}

class EmptyFailure extends BoardFailure {
  const EmptyFailure() : super._();
}
