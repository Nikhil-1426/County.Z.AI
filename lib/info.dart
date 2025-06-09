import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

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
                          "Information",
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
                  
                  // About Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About the App",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  // About Description Card
                  Container(
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
                    child: Text(
                      "This app helps users perform object detection and track activity statistics like sessions, usage time, and more. Powered by advanced AI technology to provide accurate real-time detection.",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 15,
                        color: const Color(0xFF2D3748),
                        height: 1.4,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Features Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Features",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  // Feature Cards
                  _buildFeatureItem(
                    icon: Icons.analytics_outlined,
                    title: "Object Counting",
                    description: "Advanced AI models for accurate detection",
                    isSmallScreen: isSmallScreen,
                    isMediumScreen: isMediumScreen,
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  _buildFeatureItem(
                    icon: Icons.insert_chart_outlined,
                    title: "Usage Tracking",
                    description: "Daily statistics to monitor your activity",
                    isSmallScreen: isSmallScreen,
                    isMediumScreen: isMediumScreen,
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  _buildFeatureItem(
                    icon: Icons.history_outlined,
                    title: "History Logging",
                    description: "Detailed history of all sessions",
                    isSmallScreen: isSmallScreen,
                    isMediumScreen: isMediumScreen,
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  _buildFeatureItem(
                    icon: Icons.dashboard_outlined,
                    title: "Personalized Dashboard",
                    description: "Display the metrics that matter to you",
                    isSmallScreen: isSmallScreen,
                    isMediumScreen: isMediumScreen,
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Contact Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Support",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  // Contact Support Card
                  Container(
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                              contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                      Icons.support_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Contact Support",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                "For any queries, please email:\n\nzigainfotech@gmail.com",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF2D3748),
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
                        },
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
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
                                  Icons.support_outlined,
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
                                      "Contact Support",
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 16 : 17,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3748),
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 1 : 2),
                                    Text(
                                      "Get help with any questions",
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
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Footer Section
                  Container(
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
                    child: Column(
                      children: [
                        Text(
                          "Developed by Ziga Infotech",
                          style: TextStyle(
                            color: const Color(0xFF2D3748),
                            fontSize: isSmallScreen ? 14 : 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 4 : 6),
                        Text(
                          "Version 1.0.0",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isSmallScreen ? 12 : 13,
                          ),
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
  
  // Feature item widget
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(height: isSmallScreen ? 3 : 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}