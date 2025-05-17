import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Information",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 239, 221, 247),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // About section
              const SizedBox(height: 8),
              const Text(
                "About the App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "This app helps users perform object detection and track activity statistics like sessions, usage time, and more. Powered by advanced AI technology to provide accurate real-time detection.",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Features section
              const Text(
                "Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 16),
              
              // Feature list items
              _buildFeatureItem(
                icon: Icons.analytics_outlined,
                title: "Object Counting",
                description: "Advanced AI models for accurate detection",
              ),
              
              _buildFeatureItem(
                icon: Icons.insert_chart_outlined,
                title: "Usage Tracking",
                description: "Daily statistics to monitor your activity",
              ),
              
              _buildFeatureItem(
                icon: Icons.history_outlined,
                title: "History Logging",
                description: "Detailed history of all sessions",
              ),
              
              _buildFeatureItem(
                icon: Icons.dashboard_outlined,
                title: "Personalized Dashboard",
                description: "Display the metrics that matter to you",
              ),
              
              const SizedBox(height: 28),
              
              // Contact section (simplified)
                            ElevatedButton(
                onPressed: () {
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
                          const Icon(
                            Icons.support_outlined,
                            color: Color(0xFF9C27B0),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Contact Support",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF444444),
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        "For any queries, please email:\n\nzigainfotech@gmail.com",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF666666),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Close",
                            style: TextStyle(
                              color: Color(0xFF9C27B0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 205, 143, 233),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Contact Support",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Footer (simplified)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Developed by Ziga Infotech",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const Center(
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Simplified feature item
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: const Color.fromARGB(255, 156, 39, 176),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF444444),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
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
