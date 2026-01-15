import 'package:flutter/material.dart';
import 'package:pebblex_app/views/setting/widgets/profile_widget.dart';
import 'package:provider/provider.dart';
import 'package:pebblex_app/core/services/secure_storage.dart';
import 'package:pebblex_app/providers/auth_provider.dart';
import 'package:pebblex_app/views/auth/login_page.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final SecureStorageService _storageService = SecureStorageService();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.me();

      final name = await _storageService.readValue('name');
      final email = await _storageService.readValue('email');
      final phone = await _storageService.readValue('phone');
      final address = await _storageService.readValue('address');

      if (mounted) {
        setState(() {
          _name = name ?? 'Unknown';
          _email = email ?? 'No email';
          _phone = phone ?? 'No phone';
          _address = address ?? 'No address';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToChangePassword() {
    // TODO: Implement change password navigation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Change Password - Coming Soon')));
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _storageService.clearAll();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 16.0 : size.width * 0.04;
    final spacing = isSmallScreen ? 12.0 : 16.0;
    final sectionSpacing = isSmallScreen ? 20.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.blue.shade700,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading profile...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Profile Header
                      ProfileHeader(name: _name),

                      // Content
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            children: [
                              SizedBox(height: sectionSpacing),

                              // Personal Information Section
                              ProfileSectionTitle(
                                title: 'Personal Information',
                              ),
                              SizedBox(height: spacing),

                              // Name Card
                              ProfileInfoCard(
                                icon: Icons.person_rounded,
                                iconColor: Colors.blue.shade700,
                                label: 'Full Name',
                                value: _name,
                              ),
                              SizedBox(height: spacing),

                              // Email Card
                              ProfileInfoCard(
                                icon: Icons.email_rounded,
                                iconColor: Colors.orange.shade600,
                                label: 'Email Address',
                                value: _email,
                              ),
                              SizedBox(height: spacing),

                              // Phone Card
                              ProfileInfoCard(
                                icon: Icons.phone_rounded,
                                iconColor: Colors.green.shade600,
                                label: 'Phone Number',
                                value: _phone,
                              ),
                              SizedBox(height: spacing),

                              // Address Card
                              ProfileInfoCard(
                                icon: Icons.location_on_rounded,
                                iconColor: Colors.red.shade600,
                                label: 'Address',
                                value: _address,
                              ),
                              SizedBox(height: sectionSpacing),

                              // Security Section
                              ProfileSectionTitle(title: 'Security'),
                              SizedBox(height: spacing),

                              // Change Password Card
                              ProfileActionCard(
                                icon: Icons.lock_rounded,
                                iconColor: Colors.purple.shade600,
                                title: 'Change Password',
                                subtitle: 'Update your password',
                                onTap: _navigateToChangePassword,
                              ),
                              SizedBox(height: sectionSpacing),

                              // Account Section
                              ProfileSectionTitle(title: 'Account'),
                              SizedBox(height: spacing),

                              // Logout Card
                              ProfileActionCard(
                                icon: Icons.logout_rounded,
                                iconColor: Colors.red,
                                title: 'Logout',
                                subtitle: 'Sign out from your account',
                                isDestructive: true,
                                onTap: _handleLogout,
                              ),
                              SizedBox(height: sectionSpacing),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
