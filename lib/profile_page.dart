import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};
  final TextEditingController _usernameController = TextEditingController();
  bool _isEditingUsername = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final uid = user?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (mounted) {
      setState(() {
        userData = doc.data() ?? {};
        _usernameController.text = userData['username'] ?? '';
      });
    }
  }

  Future<void> _updateUsername() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uid = user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'username': _usernameController.text.trim(),
        });
        
        setState(() {
          userData['username'] = _usernameController.text.trim();
          _isEditingUsername = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Username updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating username: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _usernameController.text = userData['username'] ?? '';
      _isEditingUsername = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;
    
    final String email = user?.email ?? "Not available";
    final String username = userData['username'] ?? "User";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9D78F9),
              Color(0xFF78BDF9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 24.0,
                vertical: 12.0,
              ),
              child: Column(
              children: [
                // Header Section
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: isSmallScreen ? 36 : 40,
                        height: isSmallScreen ? 36 : 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "User Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 22 : isMediumScreen ? 24 : 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 36 : 40),
                  ],
                ),
                
                SizedBox(height: isSmallScreen ? 20 : 24),
                
                // Profile Avatar Section (Smaller)
                Container(
                  width: isSmallScreen ? 60 : isMediumScreen ? 70 : 80,
                  height: isSmallScreen ? 60 : isMediumScreen ? 70 : 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: isSmallScreen ? 24 : isMediumScreen ? 28 : 32,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 20 : 24),
                
                // Profile Information Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Profile Information",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 12),
                
                // Username Info Card with Edit Functionality
                _buildEditableUsernameCard(
                  icon: Icons.person_outline,
                  title: "Username",
                  value: username,
                  isSmallScreen: isSmallScreen,
                  isMediumScreen: isMediumScreen,
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 12),
                
                // Email Info Card
                _buildInfoCard(
                  icon: Icons.email_outlined,
                  title: "Email Address",
                  value: email,
                  isSmallScreen: isSmallScreen,
                  isMediumScreen: isMediumScreen,
                ),
                
                SizedBox(height: isSmallScreen ? 20 : 24),
                
                // Settings Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 12),
                
                // About Company Option
                _buildSettingsCard(
                  icon: Icons.info_outline,
                  title: "About the Company",
                  subtitle: "Learn about our mission",
                  onTap: () {
                    Navigator.pushNamed(context, '/info');
                  },
                  isSmallScreen: isSmallScreen,
                  isMediumScreen: isMediumScreen,
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 12),
                
                // Additional Settings Options
                _buildSettingsCard(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  subtitle: "Get help with your account",
                  onTap: () {
                    Navigator.pushNamed(context, '/support');
                    // You can add navigation to help page here
                  },
                  isSmallScreen: isSmallScreen,
                  isMediumScreen: isMediumScreen,
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 12),
                
                _buildSettingsCard(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  subtitle: "Review our privacy terms",
                  onTap: () {
                    // You can add navigation to privacy policy here
                  },
                  isSmallScreen: isSmallScreen,
                  isMediumScreen: isMediumScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildEditableUsernameCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isSmallScreen,
    required bool isMediumScreen,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isSmallScreen ? 8 : 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 36 : isMediumScreen ? 40 : 44,
            height: isSmallScreen ? 36 : isMediumScreen ? 40 : 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9D78F9).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 18 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 3 : 4),
                _isEditingUsername
                    ? TextField(
                        controller: _usernameController,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Color(0xFF9D78F9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Color(0xFF9D78F9), width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 6 : 8,
                            vertical: isSmallScreen ? 4 : 6,
                          ),
                          isDense: true,
                        ),
                        autofocus: true,
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          _isEditingUsername
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading)
                      SizedBox(
                        width: isSmallScreen ? 14 : 16,
                        height: isSmallScreen ? 14 : 16,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9D78F9)),
                        ),
                      )
                    else ...[
                      GestureDetector(
                        onTap: _cancelEdit,
                        child: Container(
                          width: isSmallScreen ? 24 : 28,
                          height: isSmallScreen ? 24 : 28,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade600,
                            size: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      GestureDetector(
                        onTap: _updateUsername,
                        child: Container(
                          width: isSmallScreen ? 24 : 28,
                          height: isSmallScreen ? 24 : 28,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditingUsername = true;
                    });
                  },
                  child: Container(
                    width: isSmallScreen ? 24 : 28,
                    height: isSmallScreen ? 24 : 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9D78F9).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: const Color(0xFF9D78F9),
                      size: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isSmallScreen,
    required bool isMediumScreen,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isSmallScreen ? 8 : 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 36 : isMediumScreen ? 40 : 44,
            height: isSmallScreen ? 36 : isMediumScreen ? 40 : 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9D78F9).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 18 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 3 : 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallScreen,
    required bool isMediumScreen,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isSmallScreen ? 8 : 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 36 : isMediumScreen ? 40 : 44,
                  height: isSmallScreen ? 36 : isMediumScreen ? 40 : 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9D78F9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF9D78F9),
                    size: isSmallScreen ? 18 : 20,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 1 : 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: isSmallScreen ? 24 : 28,
                  height: isSmallScreen ? 24 : 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade600,
                    size: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}