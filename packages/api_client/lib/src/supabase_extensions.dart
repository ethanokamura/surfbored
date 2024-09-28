import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

extension SupabaseExtensions on Supabase {
  static final ref = Supabase.instance.client.storage;

  /// Upload A File
  /// [collection] the collection the file is stored in
  /// [id] the document id
  /// [file] the file that needs to be uploaded
  Future<String> uploadFile(
    String collection,
    String id,
    Uint8List file,
  ) async {
    // get path
    final path = '/$id/image';
    try {
      await Supabase.instance.client.storage.from(collection).uploadBinary(
            path,
            file,
          );
      return Supabase.instance.client.storage
          .from(collection)
          .getPublicUrl(path);
    } catch (e) {
      throw Exception('Error uploading file');
    }
  }
}
