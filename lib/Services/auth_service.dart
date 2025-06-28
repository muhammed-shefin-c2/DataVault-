import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/entities/user_entity.dart';


/// `AuthService` handles authentication operations using Supabase.
class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  /// Signs in a user and returns a `UserEntity`.
  Future<UserEntity> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Sign-in failed: User not found.");
      }

      return UserEntity(
        userId: response.user!.id,
        email: response.user!.email ?? "",

      );
    } catch (e) {
      throw Exception("Sign-in failed: $e");
    }
  }

  /// Signs up a user and returns a `UserEntity`.
  Future<UserEntity> signUpWithEmailPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Sign-up failed: User not created.");
      }

      return UserEntity(
        userId: response.user!.id,
        email: response.user!.email ?? "",
      );
    } catch (e) {
      throw Exception("Sign-up failed: $e");
    }
  }

  /// Logs out the current user.
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception("Sign-out failed: $e");
    }
  }

  /// Retrieves the currently logged-in user as a `UserEntity`.
  UserEntity? getCurrentUser() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;

    if (user != null) {
      return UserEntity(
        userId: user.id,
        email: user.email ?? "",
      );
    }
    return null;
  }

  Stream<UserEntity?> get userChanges {
  return _supabaseClient.auth.onAuthStateChange.map((event) {
    final user = event.session?.user;
    if (user == null) return null;  // Fixed equality check
    return UserEntity(
      userId: user.id,
      email: user.email!,
    );
  });
}
}
