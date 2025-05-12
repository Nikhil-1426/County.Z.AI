import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:pipe_counting_app/home_page.dart';
import 'package:pipe_counting_app/auth.dart'; // or correct file name if different


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 239, 221, 247),],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Animated Logo
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 2 * math.pi,
                    child: SizedBox(
                      height: screenWidth * 0.3,
                      width: screenWidth * 0.3,
                      child: CustomPaint(
                        painter: LogoPainter(
                          pulseValue: math.sin(_animationController.value * math.pi),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Gradient Title Text
              const GradientText(
                text: 'Welcome to County.Z.AI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                ),
              ),
              const SizedBox(height: 16),
              // Tagline
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Easily count objects in your images with advanced AI technology. No manual counting needed - just capture and get results instantly!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              // Button
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 36),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9D78F9).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D78F9), Color(0xFF7985FA)],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
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
}

// Logo painter with stronger pulse
class LogoPainter extends CustomPainter {
  final double pulseValue;

  LogoPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    final pulseFactor = 1.0 + (pulseValue * 0.1); // Increased from 0.05 to 0.1

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

    // Top arrow
    var paint = createGradientPaint(
      colors: const [Color(0xFF9D78F9), Color(0xFFB295FA)],
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

    // Right arrow
    paint = createGradientPaint(
      colors: const [Color(0xFF7985FA), Color(0xFF94A8FB)],
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

    // Bottom arrow
    paint = createGradientPaint(
      colors: const [Color(0xFF78BDF9), Color(0xFF95D2FA)],
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

    // Left arrow
    paint = createGradientPaint(
      colors: const [Color(0xFFAC78F9), Color(0xFFC29DFA)],
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
  }

  @override
  bool shouldRepaint(covariant LogoPainter oldDelegate) =>
      oldDelegate.pulseValue != pulseValue;
}

// Gradient text widget
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({
    required this.text,
    required this.style,
    required this.gradient,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        foreground: Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, text.length * style.fontSize!, style.fontSize!),
          ),
      ),
    );
  }
}
