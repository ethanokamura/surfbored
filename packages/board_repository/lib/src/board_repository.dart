import 'package:api_client/api_client.dart';
import 'package:board_repository/src/failures.dart';
import 'package:board_repository/src/models/board.dart';
import 'package:board_repository/src/models/board_post.dart';
import 'package:board_repository/src/models/board_save.dart';

/// Repository for managing board-related operations.
class BoardRepository {
  /// Constructor for BoardRepository.
  /// If [supabase] is not provided, it uses the default Supabase instance.
  BoardRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on BoardRepository {
  /// Creates a new board and returns its ID.
  Future<int> createBoard({required Board board}) async {
    try {
      final res = await _supabase
          .fromBoardsTable()
          .insert(board.toJson())
          .select('id')
          .single();
      return res['id'] as int;
    } catch (e) {
      throw BoardFailure.fromCreate();
    }
  }

  /// Saves a board for a user.
  Future<void> saveBoard({required BoardSave save}) async {
    try {
      await _supabase.fromBoardSavesTable().insert(save.toJson());
    } catch (e) {
      throw BoardFailure.fromCreate();
    }
  }

  /// Adds a post to a board.
  Future<void> addPost({required BoardPost boardPost}) async {
    try {
      await _supabase.fromBoardPostsTable().insert(boardPost.toJson());
    } catch (e) {
      throw BoardFailure.fromCreate();
    }
  }
}

extension Read on BoardRepository {
  /// Fetches a board by its ID.
  /// Returns [Board.empty] if not found.
  Future<Board> fetchBoard({required int boardId}) async {
    try {
      return await _supabase
          .fromBoardsTable()
          .select()
          .eq(Board.idConverter, boardId)
          .maybeSingle()
          .withConverter(
            (data) => data == null ? Board.empty : Board.converterSingle(data),
          );
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }

  /// Searches boards based on a query with pagination.
  Future<List<Board>> searchBoards({
    required String query,
    required int offset,
    required int limit,
  }) async {
    try {
      return await _supabase
          .fromBoardsTable()
          .select()
          .textSearch(Board.boardSearchQuery, query)
          .range(offset, offset + limit - 1)
          .withConverter(Board.converter);
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }

  /// Checks if a post exists in a board.
  Future<bool> hasPost({
    required int boardId,
    required int postId,
  }) async {
    try {
      final res = await _supabase.fromBoardPostsTable().select().match({
        BoardPost.boardIdConverter: boardId,
        BoardPost.postIdConverter: postId,
      }).maybeSingle();
      return res != null;
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }

  /// Checks if a user has saved a board.
  Future<bool> hasUserSavedBoard({
    required int boardId,
    required String userId,
  }) async {
    try {
      final res = await _supabase.fromBoardSavesTable().select().match({
        BoardSave.boardIdConverter: boardId,
        BoardSave.userIdConverter: userId,
      }).maybeSingle();
      return res != null;
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }

  /// Fetches boards created by a user with pagination.
  Future<List<Board>> fetchUserBoards({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      return await _supabase
          .fromBoardsTable()
          .select()
          .eq(Board.creatorIdConverter, userId)
          .range(offset, offset + limit - 1)
          .order('created_at')
          .withConverter(Board.converter);
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }

  /// Fetches boards saved by a user with pagination.
  Future<List<Board>> fetchUserSavedBoards({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      return await _supabase
          .fromBoardsTable()
          .select()
          .eq(BoardSave.userIdConverter, userId)
          .range(offset, offset + limit - 1)
          .order('created_at')
          .withConverter(Board.converter);
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }

  /// Fetches the number of saves for a board.
  Future<int> fetchBoardSaves({required int boardId}) async {
    try {
      final likes = await _supabase
          .fromBoardSavesTable()
          .select()
          .eq(Board.idConverter, boardId)
          .order('created_at')
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw BoardFailure.fromGet();
    }
  }
}

extension StreamData on BoardRepository {
  /// Streams boards created by a user.
  Stream<List<Board>> streamUserBoards({required String userId}) {
    try {
      return _supabase
          .fromBoardsTable()
          .stream(primaryKey: [Board.idConverter])
          .eq('creator_id', userId)
          .order('created_at')
          .map(Board.converter);
    } catch (e) {
      throw BoardFailure.fromStream();
    }
  }
}

extension Update on BoardRepository {
  /// Updates a specific field of a board.
  Future<void> updateBoard({
    required String field,
    required int boardId,
    required dynamic data,
  }) async {
    try {
      await _supabase
          .fromBoardsTable()
          .update({field: data}).eq(Board.idConverter, boardId);
    } catch (e) {
      throw BoardFailure.fromUpdate();
    }
  }
}

extension Delete on BoardRepository {
  /// Deletes a board by its ID.
  Future<void> deleteBoard({required int boardId}) async {
    try {
      await _supabase.fromBoardsTable().delete().eq(Board.idConverter, boardId);
    } catch (e) {
      throw BoardFailure.fromDelete();
    }
  }

  /// Removes a post from a board.
  Future<void> removePost({required int postId, required int boardId}) async {
    try {
      await _supabase.fromBoardPostsTable().delete().match({
        BoardPost.postIdConverter: postId,
        BoardPost.boardIdConverter: boardId,
      });
    } catch (e) {
      throw BoardFailure.fromDelete();
    }
  }

  /// Removes a user's save of a board.
  Future<void> removeSave({
    required int boardId,
    required String userId,
  }) async {
    try {
      await _supabase.fromBoardSavesTable().delete().match({
        BoardSave.userIdConverter: userId,
        BoardSave.boardIdConverter: boardId,
      });
    } catch (e) {
      throw BoardFailure.fromDelete();
    }
  }
}
