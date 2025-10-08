import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Send', 'Receive', 'Payment', 'Reward'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
          ),

          // Transactions List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: Refresh transactions
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildDateSection('Today'),
                  _buildTransactionItem(
                    icon: Icons.arrow_upward,
                    iconColor: AppColors.error,
                    title: 'Sent to John',
                    subtitle: 'Wallet Transfer',
                    time: '3:45 PM',
                    amount: '-NPR 250.00',
                    isNegative: true,
                  ),
                  _buildTransactionItem(
                    icon: Icons.shopping_bag,
                    iconColor: AppColors.info,
                    title: 'Coffee Shop',
                    subtitle: 'Card Payment',
                    time: '9:15 AM',
                    amount: '-NPR 120.00',
                    isNegative: true,
                  ),

                  const SizedBox(height: 16),
                  _buildDateSection('Yesterday'),
                  _buildTransactionItem(
                    icon: Icons.arrow_downward,
                    iconColor: AppColors.success,
                    title: 'Received from Sarah',
                    subtitle: 'Bank Transfer',
                    time: '10:30 AM',
                    amount: '+NPR 1,500.00',
                    isNegative: false,
                  ),
                  _buildTransactionItem(
                    icon: Icons.star,
                    iconColor: AppColors.secondary,
                    title: 'Staking Reward',
                    subtitle: 'Automatic',
                    time: '12:00 AM',
                    amount: '+NPR 25.00',
                    isNegative: false,
                  ),

                  const SizedBox(height: 16),
                  _buildDateSection('October 4, 2025'),
                  _buildTransactionItem(
                    icon: Icons.restaurant,
                    iconColor: AppColors.warning,
                    title: 'Restaurant',
                    subtitle: 'eSewa Payment',
                    time: '7:30 PM',
                    amount: '-NPR 850.00',
                    isNegative: true,
                  ),
                  _buildTransactionItem(
                    icon: Icons.local_gas_station,
                    iconColor: AppColors.info,
                    title: 'Fuel Station',
                    subtitle: 'Card Payment',
                    time: '2:15 PM',
                    amount: '-NPR 2,500.00',
                    isNegative: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required String amount,
    required bool isNegative,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          _showTransactionDetails();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isNegative ? AppColors.error : AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filters.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildDetailRow('Amount', '-NPR 250.00'),
                  _buildDetailRow('Fee', 'NPR 2.50'),
                  _buildDetailRow('Total', '-NPR 252.50'),
                  const Divider(height: 32),
                  _buildDetailRow('To', 'John Doe'),
                  _buildDetailRow('Date', 'October 6, 2025'),
                  _buildDetailRow('Time', '3:45 PM'),
                  _buildDetailRow('Payment Method', 'Wallet Transfer'),
                  _buildDetailRow('Status', 'Completed'),
                  _buildDetailRow('Transaction ID', '0x1a2b...3c4d'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Share receipt
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share Receipt'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
