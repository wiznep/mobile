import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static SupabaseClient? _instance;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    _instance = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_instance == null) {
      throw Exception(
        'SupabaseService not initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  static RealtimeClient get realtime => client.realtime;

  // Helper method to check if user is authenticated
  static bool get isAuthenticated => auth.currentUser != null;

  // Helper method to get current user
  static User? get currentUser => auth.currentUser;

  // Helper method to get current user ID
  static String? get currentUserId => currentUser?.id;
}
