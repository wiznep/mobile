import 'package:flutter/material.dart';

class WalletDetailScreen extends StatelessWidget {
  final String walletId;

  const WalletDetailScreen({super.key, required this.walletId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show wallet options
            },
          ),
        ],
      ),
      body: const Center(child: Text('Wallet Detail Screen - Coming Soon')),
    );
  }
}
