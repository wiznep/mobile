import '../../../core/models/transaction_model.dart';
import '../../../core/services/supabase_service.dart';

class TransactionRepository {
  final _supabase = SupabaseService.client;

  Future<List<TransactionModel>> getTransactions({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((tx) => TransactionModel.fromJson(tx))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionModel> createTransaction({
    required String userId,
    required String walletId,
    required String type,
    required double amount,
    required String currency,
    String? toAddress,
    String? recipientName,
    String? description,
    String? paymentMethod,
  }) async {
    try {
      final txData = {
        'user_id': userId,
        'wallet_id': walletId,
        'type': type,
        'amount': amount,
        'currency': currency,
        'to_address': toAddress,
        'recipient_name': recipientName,
        'description': description,
        'status': 'pending',
        'payment_method': paymentMethod,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('transactions')
          .insert(txData)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
    String? hash,
  }) async {
    try {
      final updateData = {
        'status': status,
        if (hash != null) 'hash': hash,
        if (status == 'completed')
          'completed_at': DateTime.now().toIso8601String(),
      };

      await _supabase
          .from('transactions')
          .update(updateData)
          .eq('id', transactionId);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Stream<List<TransactionModel>> transactionsStream(String userId) {
    return _supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map(
          (data) => data.map((tx) => TransactionModel.fromJson(tx)).toList(),
        );
  }
}
