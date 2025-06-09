import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;

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
                          "Privacy Policy",
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
                  
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: isSmallScreen ? 12 : 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.privacy_tip_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9D78F9).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Last Updated: Jan 2025",
                                style: TextStyle(
                                  color: const Color(0xFF9D78F9),
                                  fontSize: isSmallScreen ? 11 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        Text(
                          "Your Privacy Matters",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        
                        SizedBox(height: isSmallScreen ? 8 : 12),
                        
                        Text(
                          "At Ziga Infotech, we are committed to protecting your privacy and ensuring the security of your personal information. This privacy policy explains how we collect, use, and safeguard your data.",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 15,
                            color: const Color(0xFF2D3748),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Privacy Sections
                  ..._buildPrivacySections(isSmallScreen),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Contact Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: isSmallScreen ? 12 : 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.contact_support_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 12 : 16),
                            Text(
                              "Contact Us",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        Text(
                          "If you have any questions about this Privacy Policy or our data practices, please contact us:",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 15,
                            color: const Color(0xFF2D3748),
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        
                        _buildContactItem(
                          icon: Icons.email_outlined,
                          text: "Email: info@zigainfotech.com",
                          isSmallScreen: isSmallScreen,
                        ),
                        
                        SizedBox(height: isSmallScreen ? 8 : 12),
                        
                        _buildContactItem(
                          icon: Icons.phone_outlined,
                          text: "Phone: 098409 22623",
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 16 : 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPrivacySections(bool isSmallScreen) {
    final sections = [
      {
        'icon': Icons.info_outline_rounded,
        'title': 'Information We Collect',
        'content': 'We collect information you provide directly to us, such as when you create an account, use our services, or contact us. This may include your name, email address, phone number, and usage data to improve our services.',
      },
      {
        'icon': Icons.how_to_reg_outlined,
        'title': 'Information Usage',
        'content': 'We use your information to provide and improve our services, communicate with you, ensure security, comply with legal obligations, and deliver personalized experiences tailored to your needs.',
      },
      {
        'icon': Icons.share_outlined,
        'title': 'Information Sharing',
        'content': 'We do not sell, trade, or rent your personal information to third parties. We may share information only with your consent, for legal compliance, or with trusted service providers who assist us in operating our services.',
      },
      {
        'icon': Icons.security_outlined,
        'title': 'Data Security',
        'content': 'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. Your data is encrypted and stored securely.',
      },
      {
        'icon': Icons.cookie_outlined,
        'title': 'Cookies & Tracking',
        'content': 'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and remember your preferences. You can control cookie settings through your browser preferences.',
      },
      {
        'icon': Icons.verified_user_outlined,
        'title': 'Your Rights',
        'content': 'You have the right to access, update, or delete your personal information. You can also opt-out of certain communications and request data portability. Contact us to exercise these rights.',
      },
      {
        'icon': Icons.child_care_outlined,
        'title': 'Children\'s Privacy',
        'content': 'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13. If we become aware of such data, we will take steps to delete it.',
      },
      {
        'icon': Icons.update_outlined,
        'title': 'Policy Updates',
        'content': 'We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the new policy on our app and updating the "Last Updated" date.',
      },
    ];

    return sections.map((section) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: isSmallScreen ? 12 : 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9D78F9).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        section['icon'] as IconData,
                        size: isSmallScreen ? 20 : 22,
                        color: const Color(0xFF9D78F9),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Text(
                      section['title'] as String,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  section['content'] as String,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    color: const Color(0xFF2D3748),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
        ],
      );
    }).toList();
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required bool isSmallScreen,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 16 : 18,
          color: const Color(0xFF9D78F9),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 15,
            color: const Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}