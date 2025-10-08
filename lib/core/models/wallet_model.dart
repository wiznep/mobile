import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String type; // web3, fiat, payment
  final String? network; // ethereum, bsc, polygon
  final String? address;
  final double balance;
  final String currency;
  final String? symbol;
  final String? iconUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WalletModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.network,
    this.address,
    required this.balance,
    required this.currency,
    this.symbol,
    this.iconUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      network: json['network'] as String?,
      address: json['address'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String,
      symbol: json['symbol'] as String?,
      iconUrl: json['icon_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'network': network,
      'address': address,
      'balance': balance,
      'currency': currency,
      'symbol': symbol,
      'icon_url': iconUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  WalletModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    String? network,
    String? address,
    double? balance,
    String? currency,
    String? symbol,
    String? iconUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      network: network ?? this.network,
      address: address ?? this.address,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      symbol: symbol ?? this.symbol,
      iconUrl: iconUrl ?? this.iconUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    type,
    network,
    address,
    balance,
    currency,
    symbol,
    iconUrl,
    isActive,
    createdAt,
    updatedAt,
  ];
}
