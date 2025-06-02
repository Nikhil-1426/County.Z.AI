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
    final String email = user?.email ?? "User";

    final List<Map<String, dynamic>> allFeatures = [
      {
        'title': 'Start Counting',
        'subtitle': 'Ready to begin tracking?',
        'imageUrl':
            'https://cdn4.iconfinder.com/data/icons/object-detection-technology/24/material_scan_reader_recognition_3D_object_detection-512.png',
        'route': '/count',
        'hideButton': false,
        'imageHeight': 60.0,
        'imageWidth': 60.0,
      },
      {
        'title': 'Recent Activity',
        'subtitle': '', // Set later
        'imageUrl':
            'https://cdn2.iconfinder.com/data/icons/thin-outline-essential-ui/25/39-512.png',
        'route': '/history',
        'hideButton': false,
        'buttonText': 'View History',
        'imageHeight': 60.0,
        'imageWidth': 60.0,
      },
    ];

    final countUsed = userData['counts_used'] ?? 0;
    final minutesLogged = userData['minutes_logged'] ?? 0;
    final totalSessions = userData['total_sessions'] ?? 0;

    final lastCountTimestamp = userData['last_count_time'];
    final lastCount = lastCountTimestamp != null
        ? (lastCountTimestamp as Timestamp).toDate().toString()
        : "N/A";

    allFeatures[1]['subtitle'] = "Last count: $lastCount";

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
              const SizedBox(height: 20),
              // Header with user info and actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Row(
                    children: [
                      Container(
                        width: 40, // smaller container size
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 21, // smaller icon
                          padding: EdgeInsets.zero, // remove default padding
                          icon: const Icon(Icons.info_outline, color: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(context, '/info');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 21,
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Main content area
              Flexible(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feature Cards
                        for (var feature in filteredFeatures)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFeatureCard(
                              title: feature['title'],
                              subtitle: feature['subtitle'],
                              imageUrl: feature['imageUrl'],
                              onTap: () {
                                if (feature['route'] != null) {
                                  Navigator.pushNamed(
                                      context, feature['route']);
                                }
                              },
                              hideButton: feature['hideButton'] ?? false,
                              buttonText: feature['buttonText'] ?? "Explore",
                              imageHeight: feature['imageHeight'],
                              imageWidth: feature['imageWidth'],
                            ),
                          ),
                        // User Stats Card
                        _buildStatsCard(
                          minutesLogged: minutesLogged,
                          countUsed: countUsed,
                          totalSessions: totalSessions,
                        ),
                      ],
                    ),
                  ),
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
    double? imageHeight,
    double? imageWidth,
  }) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!hideButton) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 36,
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
                              style: const TextStyle(
                                fontSize: 14,
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
            const SizedBox(width: 12),
            Container(
              width: imageWidth ?? 60,
              height: imageHeight ?? 60,
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
                      size: 30,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9D78F9).withOpacity(0.1),
            const Color(0xFF78BDF9).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF9D78F9).withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "User Stats",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF444444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    "Minutes",
                    minutesLogged.toString(),
                    Icons.timer_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: _buildStatItem(
                    "Counts",
                    countUsed.toString(),
                    Icons.confirmation_number_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: _buildStatItem(
                    "Sessions",
                    totalSessions.toString(),
                    Icons.insights_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF9D78F9),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF444444),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
