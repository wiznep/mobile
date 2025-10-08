import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddWalletDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh wallets
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance
              _buildTotalBalanceCard(),
              const SizedBox(height: 24),

              // Web3 Wallets
              const Text(
                'Web3 Wallets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildWalletCard(
                context,
                name: 'Ethereum Wallet',
                balance: '0.045 ETH',
                fiatBalance: 'NPR 5,250.00',
                icon: Icons.currency_bitcoin,
                color: AppColors.primary,
              ),
              _buildWalletCard(
                context,
                name: 'BSC Wallet',
                balance: '1.25 BNB',
                fiatBalance: 'NPR 3,200.00',
                icon: Icons.account_balance_wallet,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),

              // Fiat Wallets
              const Text(
                'Fiat Wallets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildWalletCard(
                context,
                name: 'NPR Wallet',
                balance: 'NPR 12,450.50',
                fiatBalance: '',
                icon: Icons.monetization_on,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),

              // Payment Wallets
              const Text(
                'Payment Wallets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildWalletCard(
                context,
                name: 'eSewa',
                balance: 'NPR 5,600.00',
                fiatBalance: '',
                icon: Icons.payment,
                color: Colors.green,
              ),
              _buildWalletCard(
                context,
                name: 'Khalti',
                balance: 'NPR 2,800.00',
                fiatBalance: '',
                icon: Icons.payment,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Portfolio Value',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'NPR 29,300.50',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                const Text(
                  '+8.2% this month',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(
    BuildContext context, {
    required String name,
    required String balance,
    required String fiatBalance,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // context.push('/wallet/wallet-id');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      balance,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (fiatBalance.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        fiatBalance,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.currency_bitcoin),
              title: const Text('Web3 Wallet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add Web3 wallet
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Fiat Wallet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add fiat wallet
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment Wallet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add payment wallet
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
