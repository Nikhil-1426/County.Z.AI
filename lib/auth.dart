import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSignUp = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndCheckLogin();
  }

  Future<void> _initializeFirebaseAndCheckLogin() async {
    await Firebase.initializeApp();
    if (_auth.currentUser != null) {
      _navigateToHomePage();
    }
  }

  void _toggleFormType() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("OK"))
        ],
      ),
    );
  }

  Future<void> _authenticateWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential;
      if (_isSignUp) {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      await _createUserDocument(userCredential.user);
      _navigateToHomePage();
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Authentication error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _createUserDocument(userCredential.user);
      _navigateToHomePage();
    } catch (e) {
      _showErrorDialog("Google Sign-In failed: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createUserDocument(User? user) async {
    if (user == null) return;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'email': user.email,
        'uid': user.uid,
        'createdAt': Timestamp.now(),
        'counts_used': 0,
        'minutes_logged': 0,
        'last_login': Timestamp.now(),
      });
    } else {
      await userRef.update({
        'last_login': Timestamp.now(),
      });
    }
  }

  void _navigateToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFEFDDF7)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    GradientText(
                      text: _isSignUp ? "Create Account" : "Welcome Back",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      gradient: const LinearGradient(colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isSignUp ? "Sign up to continue" : "Sign in to continue",
                      style: const TextStyle(fontSize: 18, color: Color(0xFF555555)),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration("Email", Icons.email_outlined),
                            validator: (value) => value == null || !value.contains('@')
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF9D78F9),
                                ),
                                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                              ),
                            ),
                            validator: (value) => value == null || value.length < 6
                                ? 'Minimum 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9D78F9)),
                                )
                              : _submitButton(),
                          const SizedBox(height: 24),
                          _dividerWithOr(),
                          const SizedBox(height: 24),
                          _googleSignInButton(),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _toggleFormType,
                            child: Text(
                              _isSignUp
                                  ? 'Already registered? Sign In'
                                  : 'New user? Create Account',
                              style: const TextStyle(
                                color: Color(0xFF9D78F9),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF9D78F9)),
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9D78F9)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF9D78F9), width: 2),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFF9D78F9), Color(0xFF7985FA)]),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D78F9).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _authenticateWithEmailPassword,
          child: Center(
            child: Text(
              _isSignUp ? 'Sign Up' : 'Sign In',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dividerWithOr() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
      ],
    );
  }

  Widget _googleSignInButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: _signInWithGoogle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(
            'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Sign in with Google',
            style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
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
