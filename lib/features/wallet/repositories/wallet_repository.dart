import '../../../core/models/wallet_model.dart';
import '../../../core/services/supabase_service.dart';

class WalletRepository {
  final _supabase = SupabaseService.client;

  Future<List<WalletModel>> getWallets(String userId) async {
    try {
      final response = await _supabase
          .from('wallets')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((wallet) => WalletModel.fromJson(wallet))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch wallets: $e');
    }
  }

  Future<WalletModel> createWallet({
    required String userId,
    required String name,
    required String type,
    String? network,
    String? address,
    required String currency,
    String? symbol,
  }) async {
    try {
      final walletData = {
        'user_id': userId,
        'name': name,
        'type': type,
        'network': network,
        'address': address,
        'balance': 0.0,
        'currency': currency,
        'symbol': symbol,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('wallets')
          .insert(walletData)
          .select()
          .single();

      return WalletModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create wallet: $e');
    }
  }

  Future<void> updateWalletBalance({
    required String walletId,
    required double balance,
  }) async {
    try {
      await _supabase
          .from('wallets')
          .update({
            'balance': balance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', walletId);
    } catch (e) {
      throw Exception('Failed to update wallet balance: $e');
    }
  }

  Future<void> deleteWallet(String walletId) async {
    try {
      await _supabase.from('wallets').delete().eq('id', walletId);
    } catch (e) {
      throw Exception('Failed to delete wallet: $e');
    }
  }

  Stream<List<WalletModel>> walletsStream(String userId) {
    return _supabase
        .from('wallets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (data) => data.map((wallet) => WalletModel.fromJson(wallet)).toList(),
        );
  }
}
