import 'dart:io';
import 'package:app_core/app_core.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:items_repository/items_repository.dart';

class CreateState {
  CreateState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  CreateState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return CreateState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class CreateCubit extends Cubit<CreateState> {
  CreateCubit({
    required BoardsRepository boardsRepository,
    required ItemsRepository itemsRepository,
  })  : _boardsRepository = boardsRepository,
        _itemsRepository = itemsRepository,
        super(CreateState());

  final BoardsRepository _boardsRepository;
  final ItemsRepository _itemsRepository;

  Future<void> createItem({
    required String userID,
    required String type,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
    required String? filename,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (type == 'items') {
        final docID = await _itemsRepository.createItem(
          Item(
            title: title,
            description: description,
            uid: 'userId', // Replace with actual user ID
            tags: tags,
          ),
          userID,
        );
        if (imageFile != null && filename != null) {
          await _itemsRepository.uploadImage(imageFile, docID);
        }
      } else if (type == 'boards') {
        final docID = await _boardsRepository.createBoard(
          Board(
            title: title,
            description: description,
            uid: 'userId', // Replace with actual user ID
          ),
          userID,
        );
        if (imageFile != null && filename != null) {
          await _boardsRepository.uploadImage(imageFile, docID);
        }
      } else {
        throw Exception('Unknown type');
      }

      emit(state.copyWith(
        isLoading: false,
        successMessage: '$title Created!',
      ));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to create item. Please try again.',
        ),
      );
    }
  }
}
