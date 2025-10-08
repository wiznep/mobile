import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final String userId;
  final String walletId;
  final String type; // send, receive, payment, reward, staking
  final String? hash;
  final double amount;
  final String currency;
  final String? fromAddress;
  final String? toAddress;
  final String? recipientName;
  final String? description;
  final String status; // pending, completed, failed
  final String? paymentMethod;
  final double? feeAmount;
  final String? feeCurrency;
  final DateTime? createdAt;
  final DateTime? completedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.walletId,
    required this.type,
    this.hash,
    required this.amount,
    required this.currency,
    this.fromAddress,
    this.toAddress,
    this.recipientName,
    this.description,
    required this.status,
    this.paymentMethod,
    this.feeAmount,
    this.feeCurrency,
    this.createdAt,
    this.completedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      type: json['type'] as String,
      hash: json['hash'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      fromAddress: json['from_address'] as String?,
      toAddress: json['to_address'] as String?,
      recipientName: json['recipient_name'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['payment_method'] as String?,
      feeAmount: (json['fee_amount'] as num?)?.toDouble(),
      feeCurrency: json['fee_currency'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'type': type,
      'hash': hash,
      'amount': amount,
      'currency': currency,
      'from_address': fromAddress,
      'to_address': toAddress,
      'recipient_name': recipientName,
      'description': description,
      'status': status,
      'payment_method': paymentMethod,
      'fee_amount': feeAmount,
      'fee_currency': feeCurrency,
      'created_at': createdAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? walletId,
    String? type,
    String? hash,
    double? amount,
    String? currency,
    String? fromAddress,
    String? toAddress,
    String? recipientName,
    String? description,
    String? status,
    String? paymentMethod,
    double? feeAmount,
    String? feeCurrency,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      hash: hash ?? this.hash,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      recipientName: recipientName ?? this.recipientName,
      description: description ?? this.description,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      feeAmount: feeAmount ?? this.feeAmount,
      feeCurrency: feeCurrency ?? this.feeCurrency,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    walletId,
    type,
    hash,
    amount,
    currency,
    fromAddress,
    toAddress,
    recipientName,
    description,
    status,
    paymentMethod,
    feeAmount,
    feeCurrency,
    createdAt,
    completedAt,
  ];
}
