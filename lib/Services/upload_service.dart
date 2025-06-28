// lib/Services/upload_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:technical_test/domain/entities/bundle_entity.dart';

class UploadService {
  SupabaseClient get supabase => Supabase.instance.client;

  Future<void> uploadData(String media, String price) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await supabase.from('bundle').insert({
        'media': media,
        'price': price,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      throw Exception('Failed to upload data: $error');
    }
  }

  Future<List<BundleEntity>> fetchUploads() async {
    try {
      final response = await supabase.from('bundle').select();
      return (response as List<dynamic>).map((e) => BundleEntity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      throw Exception('Failed to fetch uploads: $error');
    }
  }

  Future<List<BundleEntity>> fetchMyUploads() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await supabase.from('bundle').select().eq('user_id', userId);
      return (response as List<dynamic>).map((e) => BundleEntity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      throw Exception('Failed to fetch my uploads: $error');
    }
  }
}