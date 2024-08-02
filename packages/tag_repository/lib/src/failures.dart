import 'package:app_core/app_core.dart';

class TagFailure extends Failure {
  const TagFailure._();

  factory TagFailure.fromCreateTag() => const CreateTagFailure();
  factory TagFailure.fromGetTag() => const GetTagFailure();
  factory TagFailure.fromUpdateTag() => const UpdateTagFailure();
  factory TagFailure.fromDeleteTag() => const DeleteTagFailure();

  static const empty = EmptyTagFailure();
}

class CreateTagFailure extends TagFailure {
  const CreateTagFailure() : super._();
}

class GetTagFailure extends TagFailure {
  const GetTagFailure() : super._();
}

class UpdateTagFailure extends TagFailure {
  const UpdateTagFailure() : super._();
}

class DeleteTagFailure extends TagFailure {
  const DeleteTagFailure() : super._();
}

class EmptyTagFailure extends TagFailure {
  const EmptyTagFailure() : super._();
}
