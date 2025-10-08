import '../../../core/models/user_model.dart';
import '../../../core/services/supabase_service.dart';

class AuthRepository {
  final _supabase = SupabaseService.client;

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        // Create user profile if it doesn't exist
        final newUser = {
          'id': user.id,
          'email': user.email,
          'role': 'user',
          'kyc_status': 'not_submitted',
          'created_at': DateTime.now().toIso8601String(),
        };

        await _supabase.from('users').insert(newUser);
        return UserModel.fromJson(newUser);
      }

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      // Get user profile or create if doesn't exist
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (userData == null) {
        // Create user profile if it doesn't exist
        final newUser = {
          'id': response.user!.id,
          'email': response.user!.email,
          'role': 'user',
          'kyc_status': 'not_submitted',
          'created_at': DateTime.now().toIso8601String(),
        };

        await _supabase.from('users').insert(newUser);
        return UserModel.fromJson(newUser);
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null, // Disable email confirmation redirect
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      // Create user profile
      final newUser = {
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'role': 'user',
        'kyc_status': 'not_submitted',
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('users').insert(newUser);

      return UserModel.fromJson(newUser);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) return null;

      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return userData != null ? UserModel.fromJson(userData) : null;
    });
  }
}
