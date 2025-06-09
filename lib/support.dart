import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Match InfoPage responsive breakpoints
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;
    
    // More comprehensive responsive breakpoints for other elements
    final isVerySmall = screenWidth < 320; // Very old/small phones
    final isSmall = screenWidth >= 320 && screenWidth < 375; // iPhone SE, etc.
    final isMedium = screenWidth >= 375 && screenWidth < 414; // iPhone 8, etc.
    final isLarge = screenWidth >= 414; // iPhone Plus, Android large
    
    // Dynamic sizing based on screen
    final horizontalPadding = isVerySmall ? 12.0 : isSmall ? 16.0 : 20.0;
    final cardPadding = isVerySmall ? 12.0 : isSmall ? 14.0 : 16.0;
    final iconSize = isVerySmall ? 16.0 : isSmall ? 18.0 : 20.0;
    final buttonHeight = isVerySmall ? 40.0 : isSmall ? 44.0 : 48.0;

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
                  // Header Section - Match InfoPage exactly
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
                          "Support",
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
                  
                  // FAQ Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Frequently Asked Questions",
                      style: TextStyle(
                        fontSize: isVerySmall ? 16 : isSmall ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isVerySmall ? 8 : isSmall ? 10 : 12),
                  
                  // FAQ Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isVerySmall ? 12 : isSmall ? 14 : 16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: isVerySmall ? 6 : isSmall ? 8 : 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: isVerySmall ? 24 : isSmall ? 26 : 28,
                              height: isVerySmall ? 24 : isSmall ? 26 : 28,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: isVerySmall ? 14 : isSmall ? 16 : 18,
                              ),
                            ),
                            SizedBox(width: isVerySmall ? 8 : isSmall ? 10 : 12),
                            Text(
                              "Common Questions",
                              style: TextStyle(
                                fontSize: isVerySmall ? 14 : isSmall ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isVerySmall ? 12 : isSmall ? 14 : 16),
                        
                        // FAQ Items
                        _buildFAQItem(
                          question: "How accurate is the object detection?",
                          answer: "Our AI models provide 95%+ accuracy for most common objects.",
                          isVerySmall: isVerySmall,
                          isSmall: isSmall,
                        ),
                        
                        SizedBox(height: isVerySmall ? 12 : isSmall ? 14 : 16),
                        
                        _buildFAQItem(
                          question: "Can I export my usage data?",
                          answer: "Yes, you can export your data from the dashboard section.",
                          isVerySmall: isVerySmall,
                          isSmall: isSmall,
                        ),
                        
                        SizedBox(height: isVerySmall ? 12 : isSmall ? 14 : 16),
                        
                        _buildFAQItem(
                          question: "Is my data secure?",
                          answer: "All data is processed locally on your device for privacy.",
                          isVerySmall: isVerySmall,
                          isSmall: isSmall,
                        ),
                        
                        SizedBox(height: isVerySmall ? 12 : isSmall ? 14 : 16),
                        
                        _buildFAQItem(
                          question: "How do I report a bug?",
                          answer: "Email us at info@zigainfotech.com with device details and steps to reproduce.",
                          isVerySmall: isVerySmall,
                          isSmall: isSmall,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isVerySmall ? 16 : isSmall ? 20 : 24),
                  
                  // Quick Support Options
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Quick Support",
                      style: TextStyle(
                        fontSize: isVerySmall ? 16 : isSmall ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isVerySmall ? 8 : isSmall ? 10 : 12),
                  
                  // Support Options
                  _buildSupportOption(
                    icon: Icons.email_outlined,
                    title: "Support",
                    description: "info@zigainfotech.com",
                    onTap: () => _showSupportDialog(context),
                    isVerySmall: isVerySmall,
                    isSmall: isSmall,
                    isMedium: isMedium,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                  ),
                  
                  SizedBox(height: isVerySmall ? 8 : isSmall ? 10 : 12),
                  
                  _buildSupportOption(
                    icon: Icons.bug_report_outlined,
                    title: "Report a Bug",
                    description: "Help us improve the app",
                    onTap: () => _showBugReportDialog(context),
                    isVerySmall: isVerySmall,
                    isSmall: isSmall,
                    isMedium: isMedium,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                  ),
                  
                  SizedBox(height: isVerySmall ? 8 : isSmall ? 10 : 12),
                  
                  _buildSupportOption(
                    icon: Icons.star_outline,
                    title: "Feature Request",
                    description: "Suggest new features",
                    onTap: () => _showFeatureRequestDialog(context),
                    isVerySmall: isVerySmall,
                    isSmall: isSmall,
                    isMedium: isMedium,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                  ),
                  
                  SizedBox(height: isVerySmall ? 16 : isSmall ? 20 : 24),
                  
                  // Response Time Info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isVerySmall ? 12 : isSmall ? 14 : 16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: isVerySmall ? 6 : isSmall ? 8 : 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: isVerySmall ? 32 : isSmall ? 36 : 40,
                          height: isVerySmall ? 32 : isSmall ? 36 : 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF78BDF9).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(isVerySmall ? 8 : isSmall ? 10 : 12),
                          ),
                          child: Icon(
                            Icons.schedule_outlined,
                            color: const Color(0xFF78BDF9),
                            size: iconSize,
                          ),
                        ),
                        SizedBox(width: isVerySmall ? 8 : isSmall ? 10 : 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Response Time",
                                style: TextStyle(
                                  fontSize: isVerySmall ? 14 : isSmall ? 16 : 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                              SizedBox(height: isVerySmall ? 1 : isSmall ? 2 : 4),
                              Text(
                                "We typically respond within 24 hours",
                                style: TextStyle(
                                  fontSize: isVerySmall ? 11 : isSmall ? 13 : 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isVerySmall ? 12 : isSmall ? 16 : 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isVerySmall,
    required bool isSmall,
  }) {
    return Container(
      padding: EdgeInsets.all(isVerySmall ? 10 : isSmall ? 12 : 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(isVerySmall ? 8 : isSmall ? 10 : 12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: isVerySmall ? 13 : isSmall ? 14 : 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isVerySmall ? 4 : isSmall ? 6 : 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: isVerySmall ? 12 : isSmall ? 13 : 14,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isVerySmall,
    required bool isSmall,
    required bool isMedium,
    required double cardPadding,
    required double iconSize,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isSmall ? 8 : 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(isSmall ? 14 : 16),
            child: Row(
              children: [
                Container(
                  width: isSmall ? 36 : isMedium ? 40 : 44,
                  height: isSmall ? 36 : isMedium ? 40 : 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                    ),
                    borderRadius: BorderRadius.circular(isSmall ? 10 : 12),
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
                    size: isSmall ? 18 : 20,
                  ),
                ),
                SizedBox(width: isSmall ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isSmall ? 16 : 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: isSmall ? 1 : 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isSmall ? 13 : 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: isSmall ? 24 : 28,
                  height: isSmall ? 24 : 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade600,
                    size: isSmall ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text("Support"),
          ],
        ),
        content: const Text("You can reach us directly at:\n\ninfo@zigainfotech.com\n\nWe typically respond within 24 hours."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Color(0xFF9D78F9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.bug_report_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text("Report a Bug"),
          ],
        ),
        content: const Text("Found a bug? Please email us at info@zigainfotech.com with:\n\n• Device model and OS version\n• Steps to reproduce the issue\n• Screenshots if possible\n\nThis helps us fix issues faster!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Color(0xFF9D78F9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                ),
                borderRadius: BorderRadius.circular(6),
                ),
              child: const Icon(
                Icons.star_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text("Feature Request"),
          ],
        ),
        content: const Text("Have an idea for a new feature? We'd love to hear it!\n\nPlease email us at info@zigainfotech.com with:\n\n• Detailed description of the feature\n• How it would benefit users\n• Any mockups or examples\n\nYour feedback helps shape our app!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Color(0xFF9D78F9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}