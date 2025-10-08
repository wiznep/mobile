import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit profile
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          user?.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.fullName ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      _buildKYCStatus(user?.kycStatus ?? 'not_submitted'),
                    ],
                  ),
                ),

                const Divider(),

                // Profile Info
                _buildSection(
                  context,
                  title: 'Account Information',
                  children: [
                    _buildListTile(
                      icon: Icons.person_outline,
                      title: 'Full Name',
                      subtitle: user?.fullName ?? 'Not set',
                      onTap: () {},
                    ),
                    _buildListTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: user?.email ?? '',
                      onTap: () {},
                    ),
                    _buildListTile(
                      icon: Icons.phone_outlined,
                      title: 'Phone Number',
                      subtitle: user?.phoneNumber ?? 'Not set',
                      onTap: () {},
                    ),
                    _buildListTile(
                      icon: Icons.badge_outlined,
                      title: 'Role',
                      subtitle: user?.role ?? 'user',
                      onTap: () {},
                    ),
                  ],
                ),

                const Divider(),

                // Security
                _buildSection(
                  context,
                  title: 'Security',
                  children: [
                    _buildListTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        // TODO: Change password
                      },
                    ),
                    _buildListTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Authentication',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Toggle biometric
                        },
                      ),
                      onTap: null,
                    ),
                    _buildListTile(
                      icon: Icons.verified_user_outlined,
                      title: 'Two-Factor Authentication',
                      onTap: () {
                        // TODO: 2FA settings
                      },
                    ),
                  ],
                ),

                const Divider(),

                // Settings
                _buildSection(
                  context,
                  title: 'Preferences',
                  children: [
                    _buildListTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {
                        context.push('/settings');
                      },
                    ),
                    _buildListTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {
                        // TODO: Help & support
                      },
                    ),
                    _buildListTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // TODO: About
                      },
                    ),
                  ],
                ),

                const Divider(),

                // Logout
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKYCStatus(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'approved':
        color = AppColors.success;
        label = 'KYC Verified';
        icon = Icons.verified;
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'KYC Pending';
        icon = Icons.pending;
        break;
      case 'rejected':
        color = AppColors.error;
        label = 'KYC Rejected';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        label = 'Complete KYC';
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios, size: 16)
              : null),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(const AuthSignOutRequested());
              context.go('/auth');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
