import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      "About Ziga Infotech",
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Est. 2020",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 11 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9D78F9).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: const Color(0xFF9D78F9),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "4.9",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 11 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF9D78F9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        Text(
                          "Ziga Infotech, a reputable software development company in Chennai, can handle all your software development demands with peace of mind. Give us your whole or partial development projects, and you'll have on-time delivery, faultless product quality, and teams that are flexible.",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 15,
                            color: const Color(0xFF2D3748),
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        // Quick stats row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem("30+", "Projects", isSmallScreen),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _buildStatItem("5+", "Years", isSmallScreen),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _buildStatItem("20+", "Clients", isSmallScreen),
                            ),
                          ],
                        ),
                      ],
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
                  
                  // Features Container
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
                        _buildFeatureItem(
                          icon: Icons.analytics_outlined,
                          title: "Object Counting",
                          description: "Advanced AI models for accurate detection",
                          isSmallScreen: isSmallScreen,
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        _buildFeatureItem(
                          icon: Icons.insert_chart_outlined,
                          title: "Usage Tracking",
                          description: "Daily statistics to monitor your activity",
                          isSmallScreen: isSmallScreen,
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        _buildFeatureItem(
                          icon: Icons.history_outlined,
                          title: "History Logging",
                          description: "Detailed history of all sessions",
                          isSmallScreen: isSmallScreen,
                        ),
                        
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        
                        _buildFeatureItem(
                          icon: Icons.dashboard_outlined,
                          title: "Personalized Dashboard",
                          description: "Display the metrics that matter to you",
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Company Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ziga Infotech",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  
                  // Company Details Card
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: isSmallScreen ? 16 : 18,
                              color: const Color(0xFF9D78F9),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Address:",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.only(left: isSmallScreen ? 24 : 26),
                          child: Text(
                            "2nd Floor, Sai RK Complex, Plot No: 9, 1st Main Rd, Raghava Nagar, Madipakkam, Chennai, St.Thomas Mount-cum-Pallavaram, Tamil Nadu 600091",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: const Color(0xFF2D3748),
                              height: 1.4,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: isSmallScreen ? 16 : 18,
                              color: const Color(0xFF9D78F9),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Phone: 098409 22623",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 15,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.language_outlined,
                              size: isSmallScreen ? 16 : 18,
                              color: const Color(0xFF9D78F9),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _launchURL("https://zigainfotech.com"),
                              child: Text(
                                "Website : zigainfotech.com",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 15,
                                  color: const Color(0xFF9D78F9),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: isSmallScreen ? 16 : 18,
                              color: const Color(0xFF9D78F9),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _launchURL("https://www.linkedin.com/company/ziga-infotech-pvt-ltd/"),
                              child: Text(
                                "LinkedIn : Ziga Infotech",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 15,
                                  color: const Color(0xFF9D78F9),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
  

  Widget _buildStatItem(String number, String label, bool isSmallScreen) {
  return Column(
    children: [
      Text(
        number,
        style: TextStyle(
          fontSize: isSmallScreen ? 18 : 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF9D78F9),
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(
          fontSize: isSmallScreen ? 11 : 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

  // Feature item widget (for use inside container)
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isSmallScreen,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 20 : 22,
          color: const Color(0xFF9D78F9),
        ),
        SizedBox(width: isSmallScreen ? 12 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 15 : 16,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // URL launcher helper method
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Handle case where URL can't be launched
        print('Could not launch $url');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error launching URL: $e');
    }
  }
}