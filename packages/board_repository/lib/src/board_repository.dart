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
  Future<void> createBoard({
    required Board board,
  }) async {
    try {
      await _supabase.fromBoardsTable().insert(board.toJson());
    } catch (e) {
      throw BoardFailure.fromCreateBoard();
    }
  }

  Future<void> likeBoard({
    required BoardSave like,
  }) async {
    try {
      await _supabase.fromBoardSavesTable().insert(like.toJson());
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
    required String boardId,
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

  Future<List<Board>> fetchUserBoards({
    required String userId,
  }) async {
    try {
      final res = await _supabase
          .fromBoardsTable()
          .select()
          .eq(Board.creatorIdConverter, userId)
          .withConverter(Board.converter);
      return res;
    } catch (e) {
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<int> fetchBoardSaves({
    required String boardId,
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

extension Update on BoardRepository {
  // update specific user profile field
  Future<void> updateBoard({
    required String field,
    required String boardId,
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
    required String boardId,
  }) async {
    try {
      await _supabase.fromBoardsTable().delete().eq(Board.idConverter, boardId);
    } catch (e) {
      throw BoardFailure.fromDeleteBoard();
    }
  }

  Future<void> removePost({
    required String postId,
    required String boardId,
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
    required String boardId,
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
