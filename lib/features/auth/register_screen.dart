import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // ref.listen(authControllerProvider, (previous, next) {
    //   if (next.hasValue && next.value != null) {
    //     context.go('/dashboard');
    //   }
    //   if (next.hasError) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.redAccent),
    //     );
    //   }
    // });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF004D40), Color(0xFF121212)],
              ),
            ),
          ),
          
          // Decorative Orbs
          Positioned(top: -50, right: -50, child: _buildOrb(200, Colors.tealAccent.withOpacity(0.1))),
          Positioned(bottom: -100, left: -50, child: _buildOrb(300, Colors.teal.withOpacity(0.2))),

          // Glassmorphic Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text("Join SaveTrack today", style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 32),

                        _buildTextField(controller: _nameController, label: "Full Name", icon: Icons.person_outline, isObscure: false),
                        const SizedBox(height: 16),
                        _buildTextField(controller: _emailController, label: "Email", icon: Icons.email_outlined, isObscure: false),
                        const SizedBox(height: 16),
                        _buildTextField(controller: _passwordController, label: "Password", icon: Icons.lock_outline, isObscure: true),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () => ref.read(authControllerProvider.notifier).register(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: authState.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("SIGN UP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Switch to Login Button
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text("Already have an account? Log in", style: TextStyle(color: Colors.tealAccent)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, required bool isObscure}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.tealAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.tealAccent)),
      ),
    );
  }
}