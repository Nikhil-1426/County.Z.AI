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

  Future<Map<String, dynamic>> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid == null) return {};

    // Update last login timestamp
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'last_login': Timestamp.now(),
    }, SetOptions(merge: true));

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "User";

    final List<Map<String, dynamic>> allFeatures = [
      {
        'title': 'Start Counting',
        'subtitle': 'Ready to begin tracking?',
        'imageUrl': 'https://cdn4.iconfinder.com/data/icons/object-detection-technology/24/material_scan_reader_recognition_3D_object_detection-512.png',
        'route': '/count',
        'hideButton': false,
      },
      {
        'title': 'Recent Activity',
        'subtitle': 'Last login info below',
        'imageUrl': 'https://cdn2.iconfinder.com/data/icons/thin-outline-essential-ui/25/39-512.png',
        'route': '/history',
        'hideButton': false,
        'buttonText': 'View History',
      },
    ];

    return Scaffold(
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
          child: FutureBuilder<Map<String, dynamic>>(
            future: getUserData(),
            builder: (context, snapshot) {
              final userData = snapshot.data ?? {};
              final countUsed = userData['counts_used'] ?? 0;
              final hoursLogged = userData['hours_logged']?.toString() ?? "0";
              final lastLoginTimestamp = userData['last_login'];
              final lastLogin = lastLoginTimestamp != null
                  ? (lastLoginTimestamp as Timestamp).toDate().toString()
                  : "N/A";

              final filteredFeatures = allFeatures.where((feature) {
                return feature['title'].toLowerCase().contains(searchText.toLowerCase());
              }).toList();

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Home",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  style: const TextStyle(fontSize: 16, color: Color(0xFF888888)),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.grey),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                                );
                              },
                            )
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Search features",
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Feature Cards (filtered)
                        for (var feature in filteredFeatures)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFeatureCard(
                              title: feature['title'],
                              subtitle: feature['title'] == 'Recent Activity'
                                  ? "Last login: $lastLogin"
                                  : feature['subtitle'],
                              imageUrl: feature['imageUrl'],
                              onTap: () {
                                if (feature['route'] != null) {
                                  Navigator.pushNamed(context, feature['route']);
                                }
                              },
                              hideButton: feature['hideButton'] ?? false,
                              buttonText: feature['buttonText'] ?? "Explore",
                            ),
                          ),

                        // User Stats Card
                        _buildFeatureCard(
                          title: "User Stats",
                          subtitle: "Hours logged: $hoursLogged\nCounts used: $countUsed",
                          imageUrl: 'https://static.thenounproject.com/png/4963515-200.png',
                          onTap: () {},
                          hideButton: true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF444444))),
                  const SizedBox(height: 8),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF888888))),
                  if (!hideButton) ...[
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9D78F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(buttonText),
                    ),
                  ]
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
