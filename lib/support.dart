import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // More comprehensive responsive breakpoints
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
                horizontal: horizontalPadding,
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
                          width: isVerySmall ? 32 : isSmall ? 36 : 40,
                          height: isVerySmall ? 32 : isSmall ? 36 : 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Support",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isVerySmall ? 20 : isSmall ? 22 : isMedium ? 24 : 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: isVerySmall ? 32 : isSmall ? 36 : 40),
                    ],
                  ),
                  
                  SizedBox(height: isVerySmall ? 16 : isSmall ? 20 : 24),
                  
                  // Contact Form Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: isVerySmall ? 16 : isSmall ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isVerySmall ? 8 : isSmall ? 10 : 12),
                  
                  // Contact Form Card
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Send us a message",
                            style: TextStyle(
                              fontSize: isVerySmall ? 14 : isSmall ? 16 : 17,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: isVerySmall ? 10 : isSmall ? 12 : 16),
                          
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Your Name",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: isVerySmall ? 12 : isSmall ? 14 : 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF9D78F9)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isVerySmall ? 10 : isSmall ? 12 : 14,
                                vertical: isVerySmall ? 10 : isSmall ? 12 : 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: isVerySmall ? 10 : isSmall ? 12 : 16),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: isVerySmall ? 12 : isSmall ? 14 : 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF9D78F9)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isVerySmall ? 10 : isSmall ? 12 : 14,
                                vertical: isVerySmall ? 10 : isSmall ? 12 : 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: isVerySmall ? 10 : isSmall ? 12 : 16),
                          
                          // Message Field
                          TextFormField(
                            controller: _messageController,
                            maxLines: isVerySmall ? 3 : 4,
                            decoration: InputDecoration(
                              labelText: "Your Message",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: isVerySmall ? 12 : isSmall ? 14 : 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF9D78F9)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isVerySmall ? 10 : isSmall ? 12 : 14,
                                vertical: isVerySmall ? 10 : isSmall ? 12 : 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your message';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: isVerySmall ? 14 : isSmall ? 16 : 20),
                          
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9D78F9),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: _isSubmitting
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      "Send Message",
                                      style: TextStyle(
                                        fontSize: isVerySmall ? 14 : isSmall ? 15 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
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
                    title: "Email Support",
                    description: "zigainfotech@gmail.com",
                    onTap: () => _showEmailDialog(context),
                    isVerySmall: isVerySmall,
                    isSmall: isSmall,
                    isMedium: isMedium,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                  ),
                  
                  SizedBox(height: isVerySmall ? 8 : isSmall ? 10 : 12),
                  
                  _buildSupportOption(
                    icon: Icons.help_outline,
                    title: "FAQ",
                    description: "Find answers to common questions",
                    onTap: () => _showFAQDialog(context),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
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
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text("Message Sent"),
            ],
          ),
          content: const Text("Thank you for your message! We'll get back to you within 24 hours."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text(
                "OK",
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

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  void _showEmailDialog(BuildContext context) {
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
            const Text("Email Support"),
          ],
        ),
        content: const Text("You can reach us directly at:\n\nzigainfotech@gmail.com\n\nWe typically respond within 24 hours."),
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

  void _showFAQDialog(BuildContext context) {
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
                Icons.help_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text("Frequently Asked Questions"),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Q: How accurate is the object detection?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text("A: Our AI models provide 95%+ accuracy for most common objects.\n"),
              Text(
                "Q: Can I export my usage data?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text("A: Yes, you can export your data from the dashboard.\n"),
              Text(
                "Q: Is my data secure?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text("A: All data is processed locally on your device for privacy."),
            ],
          ),
        ),
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
        content: const Text("Found a bug? Please email us at zigainfotech@gmail.com with:\n\n• Device model and OS version\n• Steps to reproduce the issue\n• Screenshots if possible\n\nThis helps us fix issues faster!"),
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
        content: const Text("Have an idea for a new feature?\n\nWe'd love to hear from you! Send your suggestions to zigainfotech@gmail.com and help us make the app even better.\n\nDescribe your idea and how it would help you use the app more effectively."),
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