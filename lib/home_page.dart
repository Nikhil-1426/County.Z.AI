import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  Map<String, dynamic> userData = {};
  Timer? _timer;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initializeUserDataAndStartTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeUserDataAndStartTimer() async {
    await _incrementSession();
    await _fetchUserData();

    _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _incrementMinutesLogged();
      await _fetchUserData(); // Update UI
    });
  }

  Future<void> _incrementSession() async {
    final uid = user?.uid;
    if (uid == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      final currentSessions = (snapshot.data()?['total_sessions'] ?? 0) as int;
      transaction.set(
          userDoc,
          {
            'total_sessions': currentSessions + 1,
          },
          SetOptions(merge: true));
    });
  }

  Future<void> _incrementMinutesLogged() async {
    final uid = user?.uid;
    if (uid == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      final currentMinutes = (snapshot.data()?['minutes_logged'] ?? 0) as int;
      transaction.set(
          userDoc,
          {
            'minutes_logged': currentMinutes + 1,
          },
          SetOptions(merge: true));
    });
  }

  Future<void> _fetchUserData() async {
    final uid = user?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (mounted) {
      setState(() {
        userData = doc.data() ?? {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safePadding = MediaQuery.of(context).padding;
    
    // Responsive values based on screen size
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final headerSpacing = screenHeight * 0.035; // 2% of screen height
    final cardSpacing = screenHeight * 0.030; // 2.5% of screen height
    final iconSize = screenWidth * 0.055; // 5.5% of screen width
    final buttonHeight = screenHeight * 0.065; // 5.5% of screen height
    
    final String email = user?.email ?? "User";

    final List<Map<String, dynamic>> allFeatures = [
      {
        'title': 'Start Counting',
        'subtitle': 'Ready to begin tracking?',
        'imageUrl':
            'https://cdn4.iconfinder.com/data/icons/object-detection-technology/24/material_scan_reader_recognition_3D_object_detection-512.png',
        'route': '/count',
        'hideButton': false,
        'imageHeight': screenWidth * 0.15,
        'imageWidth': screenWidth * 0.15,
      },
      {
        'title': 'Recent Activity',
        'subtitle': 'Track your Journey', // Set later
        'imageUrl':
            'https://cdn2.iconfinder.com/data/icons/thin-outline-essential-ui/25/39-512.png',
        'route': '/history',
        'hideButton': false,
        'buttonText': 'View History',
        'imageHeight': screenWidth * 0.15,
        'imageWidth': screenWidth * 0.15,
      },
    ];

    final countUsed = userData['counts_used'] ?? 0;
    final minutesLogged = userData['minutes_logged'] ?? 0;
    final totalSessions = userData['total_sessions'] ?? 0;

    final filteredFeatures = allFeatures.where((feature) {
      return feature['title'].toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
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
          child: Column(
            children: [
              SizedBox(height: headerSpacing),
              // Header with user info and actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: headerSpacing * 0.38),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Action buttons - positioned higher and smaller
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: screenWidth * 0.11,
                              height: screenWidth * 0.11,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: iconSize,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.settings, color: Color.fromARGB(255, 247, 243, 243)),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile');
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Container(
                              width: screenWidth * 0.11,
                              height: screenWidth * 0.11,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: iconSize,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.logout, color: Color.fromARGB(255, 247, 243, 243)),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const AuthScreen()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48),
              // Main content area - Now takes remaining space with better distribution
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Feature Cards with responsive spacing
                              for (int i = 0; i < filteredFeatures.length; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: i == filteredFeatures.length - 1 
                                        ? cardSpacing * 0.93
                                        : cardSpacing,
                                  ),
                                  child: _buildFeatureCard(
                                    title: filteredFeatures[i]['title'],
                                    subtitle: filteredFeatures[i]['subtitle'],
                                    imageUrl: filteredFeatures[i]['imageUrl'],
                                    onTap: () {
                                      if (filteredFeatures[i]['route'] != null) {
                                        Navigator.pushNamed(context, filteredFeatures[i]['route']);
                                      }
                                    },
                                    hideButton: filteredFeatures[i]['hideButton'] ?? false,
                                    buttonText: filteredFeatures[i]['buttonText'] ?? "Explore",
                                    imageHeight: filteredFeatures[i]['imageHeight'],
                                    imageWidth: filteredFeatures[i]['imageWidth'],
                                    buttonHeight: buttonHeight,
                                    screenWidth: screenWidth,
                                  ),
                                ),
                              // User Stats Card with responsive spacing
                              _buildStatsCard(
                                minutesLogged: minutesLogged,
                                countUsed: countUsed,
                                totalSessions: totalSessions,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                              // Flexible spacer to push content up while maintaining spacing
                              SizedBox(height: cardSpacing),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required VoidCallback onTap,
    bool hideButton = false,
    String buttonText = "Explore",
    required double imageHeight,
    required double imageWidth,
    required double buttonHeight,
    required double screenWidth,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.052,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF444444),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.041,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!hideButton) ...[
                    SizedBox(height: screenWidth * 0.03),
                    Container(
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9D78F9).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onTap,
                          child: Center(
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey.shade400,
                      size: imageWidth * 0.4,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required int minutesLogged,
    required int countUsed,
    required int totalSessions,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF9D78F9).withOpacity(0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  "User Stats",
                  style: TextStyle(
                    fontSize: screenWidth * 0.052,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF444444),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.025),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    "Minutes",
                    minutesLogged.toString(),
                    Icons.timer_outlined,
                    screenWidth,
                  ),
                ),
                Container(
                  width: 1,
                  height: screenHeight * 0.095,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: _buildStatItem(
                    "Counts",
                    countUsed.toString(),
                    Icons.confirmation_number_outlined,
                    screenWidth,
                  ),
                ),
                Container(
                  width: 1,
                  height: screenHeight * 0.095,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: _buildStatItem(
                    "Sessions",
                    totalSessions.toString(),
                    Icons.insights_outlined,
                    screenWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, double screenWidth) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF9D78F9),
          size: screenWidth * 0.075,
        ),
        SizedBox(height: screenWidth * 0.025),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF444444),
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.034,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}