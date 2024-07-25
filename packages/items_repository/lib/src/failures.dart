import 'package:app_core/app_core.dart';

class ItemFailure extends Failure {
  const ItemFailure._();

  factory ItemFailure.fromCreateItem() => const CreateItemFailure();
  factory ItemFailure.fromGetItem() => const GetItemFailure();
  factory ItemFailure.fromUpdateItem() => const UpdateItemFailure();
  factory ItemFailure.fromDeleteItem() => const DeleteItemFailure();

  static const empty = EmptyItemFailure();
}

class CreateItemFailure extends ItemFailure {
  const CreateItemFailure() : super._();
}

class GetItemFailure extends ItemFailure {
  const GetItemFailure() : super._();
}

class UpdateItemFailure extends ItemFailure {
  const UpdateItemFailure() : super._();
}

class DeleteItemFailure extends ItemFailure {
  const DeleteItemFailure() : super._();
}

class EmptyItemFailure extends ItemFailure {
  const EmptyItemFailure() : super._();
}
