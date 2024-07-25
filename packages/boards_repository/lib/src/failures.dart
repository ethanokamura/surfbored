import 'package:app_core/app_core.dart';

class BoardFailure extends Failure {
  const BoardFailure._();

  factory BoardFailure.fromCreateBoard() => const CreateBoardFailure();
  factory BoardFailure.fromGetBoard() => const GetBoardFailure();
  factory BoardFailure.fromUpdateBoard() => const UpdateBoardFailure();
  factory BoardFailure.fromDeleteBoard() => const DeleteBoardFailure();

  static const empty = EmptyBoardFailure();
}

class CreateBoardFailure extends BoardFailure {
  const CreateBoardFailure() : super._();
}

class GetBoardFailure extends BoardFailure {
  const GetBoardFailure() : super._();
}

class UpdateBoardFailure extends BoardFailure {
  const UpdateBoardFailure() : super._();
}

class DeleteBoardFailure extends BoardFailure {
  const DeleteBoardFailure() : super._();
}

class EmptyBoardFailure extends BoardFailure {
  const EmptyBoardFailure() : super._();
}
