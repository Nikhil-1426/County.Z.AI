import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:pipe_counting_app/auth.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // App name
                const Text(
                  'County.Z.AI',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Spacer(),
                // Animated Logo
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animationController.value * 2 * math.pi,
                      child: Container(
                        height: screenWidth * 0.385,
                        width: screenWidth * 0.385,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 25,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: LogoPainter(
                            pulseValue:
                                math.sin(_animationController.value * math.pi),
                            shimmerValue: _animationController.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                // Info card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'AI-Powered Object Counting',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Instantly count objects in your images with advanced AI technology. Just capture and get accurate results in seconds!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Get Started button
                Container(
                  width: double.infinity,
                  height: 58,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF9D78F9),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
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

// Enhanced logo painter with pulsing effect, glossy appearance, and shimmer
class LogoPainter extends CustomPainter {
  final double pulseValue;
  final double shimmerValue;

  LogoPainter({required this.pulseValue, required this.shimmerValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Pulse factor makes arrows grow and shrink
    final pulseFactor = 1.0 + (pulseValue * 0.1);

    // Functions to create gradient paints with highlight
    Paint createGradientPaint({
      required List<Color> colors,
      required Offset start,
      required Offset end,
    }) {
      return Paint()
        ..shader = LinearGradient(
          colors: colors,
          begin: Alignment(start.dx, start.dy),
          end: Alignment(end.dx, end.dy),
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.fill;
    }

    // Enhanced background circle with gradient and shine effect
    final bgRadius = radius * 0.9;

    // Main background gradient (slightly toned down)
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.3, -0.3), // Offset for lighting effect
        radius: 1.2,
        colors: [
          Colors.white.withOpacity(0.25), // Reduced from 0.4
          Colors.white.withOpacity(0.15), // Reduced from 0.2
          Colors.white.withOpacity(0.08), // Reduced from 0.1
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: bgRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, bgRadius, bgPaint);

    // Shimmer/shine overlay that moves around
    final shimmerAngle = shimmerValue * 2 * math.pi;
    final shimmerOffset = Offset(
      math.cos(shimmerAngle) * radius * 0.3,
      math.sin(shimmerAngle) * radius * 0.3,
    );

    final shimmerPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [
          Colors.white.withOpacity(0.4), // Reduced from 0.3
          Colors.white.withOpacity(0.08), // Reduced from 0.1
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: center + shimmerOffset,
        radius: bgRadius * 0.6,
      ))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center + shimmerOffset, bgRadius * 0.6, shimmerPaint);

    // Top arrow with enhanced gradient
    var paint = createGradientPaint(
      colors: const [Color(0xFFB295FA), Color(0xFF9D78F9)],
      start: const Offset(0, -1),
      end: const Offset(0, 0),
    );

    var path = Path()
      ..moveTo(center.dx, center.dy - radius * pulseFactor)
      ..lineTo(center.dx - radius / 2, center.dy - radius / 2)
      ..lineTo(center.dx, center.dy - radius / 4)
      ..lineTo(center.dx + radius / 2, center.dy - radius / 2)
      ..close();
    canvas.drawPath(path, paint);

    // Right arrow with enhanced gradient
    paint = createGradientPaint(
      colors: const [Color(0xFF94A8FB), Color(0xFF7985FA)],
      start: const Offset(1, 0),
      end: const Offset(0, 0),
    );

    path = Path()
      ..moveTo(center.dx + radius * pulseFactor, center.dy)
      ..lineTo(center.dx + radius / 2, center.dy - radius / 2)
      ..lineTo(center.dx + radius / 4, center.dy)
      ..lineTo(center.dx + radius / 2, center.dy + radius / 2)
      ..close();
    canvas.drawPath(path, paint);

    // Bottom arrow with enhanced gradient
    paint = createGradientPaint(
      colors: const [Color(0xFF95D2FA), Color(0xFF78BDF9)],
      start: const Offset(0, 1),
      end: const Offset(0, 0),
    );

    path = Path()
      ..moveTo(center.dx, center.dy + radius * pulseFactor)
      ..lineTo(center.dx - radius / 2, center.dy + radius / 2)
      ..lineTo(center.dx, center.dy + radius / 4)
      ..lineTo(center.dx + radius / 2, center.dy + radius / 2)
      ..close();
    canvas.drawPath(path, paint);

    // Left arrow with enhanced gradient
    paint = createGradientPaint(
      colors: const [Color(0xFFC29DFA), Color(0xFFAC78F9)],
      start: const Offset(-1, 0),
      end: const Offset(0, 0),
    );

    path = Path()
      ..moveTo(center.dx - radius * pulseFactor, center.dy)
      ..lineTo(center.dx - radius / 2, center.dy - radius / 2)
      ..lineTo(center.dx - radius / 4, center.dy)
      ..lineTo(center.dx - radius / 2, center.dy + radius / 2)
      ..close();
    canvas.drawPath(path, paint);

    // Draw center highlight with shimmer effect
    final centerPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.4, -0.4),
        radius: 1.0,
        colors: [
          Colors.white.withOpacity(0.15), // Reduced from 0.8
          Colors.white.withOpacity(0.45), // Reduced from 0.6
          Colors.white.withOpacity(0.3), // Reduced from 0.4
        ],
        stops: [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius * 0.15,
      ))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.15, centerPaint);
  }

  @override
  bool shouldRepaint(covariant LogoPainter oldDelegate) =>
      oldDelegate.pulseValue != pulseValue ||
      oldDelegate.shimmerValue != shimmerValue;
}
