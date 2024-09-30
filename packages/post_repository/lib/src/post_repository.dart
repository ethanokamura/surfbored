import 'package:api_client/api_client.dart';

class PostRepository {
  PostRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on PostRepository {}

extension Read on PostRepository {}

extension Update on PostRepository {}

extension Delete on PostRepository {}
