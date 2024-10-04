import 'package:api_client/api_client.dart';
import 'package:board_repository/src/failures.dart';
import 'package:board_repository/src/models/board.dart';
import 'package:board_repository/src/models/board_post.dart';
import 'package:board_repository/src/models/board_save.dart';

class BoardRepository {
  BoardRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on BoardRepository {
  Future<int> createBoard({
    required Board board,
  }) async {
    final res = await _supabase
        .fromBoardsTable()
        .insert(board.toJson())
        .select('id')
        .single();
    return res['id'] as int;
  }

  Future<void> saveBoard({
    required BoardSave save,
  }) async {
    try {
      await _supabase.fromBoardSavesTable().insert(save.toJson());
    } catch (e) {
      throw BoardFailure.fromCreateBoard();
    }
  }

  Future<void> addPost({
    required BoardPost post,
  }) async {
    try {
      await _supabase.fromBoardPostsTable().insert(post.toJson());
    } catch (e) {
      throw BoardFailure.fromCreateBoard();
    }
  }
}

extension Read on BoardRepository {
  Future<Board> fetchBoard({
    required int boardId,
  }) async {
    try {
      final res = await _supabase
          .fromBoardsTable()
          .select()
          .eq(Board.idConverter, boardId)
          .maybeSingle()
          .withConverter(
            (data) => data == null ? Board.empty : Board.converterSingle(data),
          );
      return res;
    } catch (e) {
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<List<Board>> searchBoards({
    required String query,
    required int offset,
    required int limit,
  }) async =>
      _supabase
          .fromBoardsTable()
          .select()
          .textSearch(Board.boardSearchQuery, query)
          .range(offset, offset + limit - 1)
          .withConverter(Board.converter);

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
      throw BoardFailure.fromGetBoard();
    }
  }

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
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<List<Board>> fetchUserBoards({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      final res = await _supabase
          .fromBoardsTable()
          .select()
          .eq(Board.creatorIdConverter, userId)
          .range(offset, offset + limit - 1)
          .withConverter(Board.converter);
      return res;
    } catch (e) {
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<List<Board>> fetchUserSavedBoards({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      final res = await _supabase
          .fromBoardsTable()
          .select()
          .eq(BoardSave.userIdConverter, userId)
          .range(offset, offset + limit - 1)
          .withConverter(Board.converter);
      return res;
    } catch (e) {
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<int> fetchBoardSaves({
    required int boardId,
  }) async {
    try {
      final likes = await _supabase
          .fromBoardSavesTable()
          .select()
          .eq(Board.idConverter, boardId)
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw BoardFailure.fromGetBoard();
    }
  }
}

extension StreamData on BoardRepository {
  Stream<List<Board>> streamUserBoards({
    required String userId,
  }) {
    return _supabase
        .fromBoardsTable()
        .stream(primaryKey: [Board.idConverter])
        .eq('creator_id', userId)
        .order('created_at')
        .map(Board.converter);
  }
}

extension Update on BoardRepository {
  // update specific user profile field
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
      throw BoardFailure.fromUpdateBoard();
    }
  }
}

extension Delete on BoardRepository {
  Future<void> deleteBoard({
    required int boardId,
  }) async {
    try {
      await _supabase.fromBoardsTable().delete().eq(Board.idConverter, boardId);
    } catch (e) {
      throw BoardFailure.fromDeleteBoard();
    }
  }

  Future<void> removePost({
    required int postId,
    required int boardId,
  }) async {
    try {
      await _supabase.fromBoardPostsTable().delete().match({
        BoardPost.postIdConverter: postId,
        BoardPost.boardIdConverter: boardId,
      });
    } catch (e) {
      throw BoardFailure.fromDeleteBoard();
    }
  }

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
      throw BoardFailure.fromDeleteBoard();
    }
  }
}
