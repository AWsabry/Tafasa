import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/core/managers/snack_bar_manager.dart';
import 'package:food_gpt/core/services/locator/service_locator.dart';
import 'package:food_gpt/features/home/presentation/view/home_screen.dart';
import 'package:food_gpt/features/login/data/model/login_model.dart';
import 'package:food_gpt/features/login/presentation/controller/login_state.dart';
import 'package:food_gpt/features/register/presentation/view/register_screen.dart';

import '../controller/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          state.mapOrNull(
            success: (message) {
              if (!context.mounted) return;

              SnackbarManager.show(
                context,
                message: message.message,
                backgroundColor: const Color(0xFF3B8A00),
              );
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, __, ___) => const HomeScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },

            failure: (value) {
              SnackbarManager.show(
                context,
                message: value.failure.message,
                backgroundColor: const Color.fromARGB(255, 243, 7, 7),
              );
            },
          );
        },
        child: const _LoginScreenView(),
      ),
    );
  }
}

class _LoginScreenView extends StatefulWidget {
  const _LoginScreenView();

  @override
  State<_LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<_LoginScreenView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _formController;
  late AnimationController _particlesController;
  late AnimationController _glowController;

  late Animation<double> _headerScale;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _formOpacity;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _headerScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.elasticOut),
    );
    _headerOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeIn));

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
        );
    _formOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeIn));

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      _headerController.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _formController.dispose();
    _particlesController.dispose();
    _glowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildFloatingParticle(
    double left,
    double top,
    double delay,
    Color color,
  ) {
    return AnimatedBuilder(
      animation: _particlesController,
      builder: (context, child) {
        final offset = sin((_particlesController.value + delay) * 2 * pi) * 20;
        final opacity =
            (sin((_particlesController.value + delay) * 2 * pi) + 1) / 2;
        return Positioned(
          left: left,
          top: top + offset,
          child: Opacity(
            opacity: opacity * 0.25,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await context.read<LoginCubit>().login(
        LoginModel(
          password: _passwordController.text,
          email: _emailController.text.toLowerCase(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1a1a2e),
                const Color(0xFF16213e),
                const Color(0xFF0f3460),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles
              _buildFloatingParticle(40, 80, 0, Colors.pink.shade300),
              _buildFloatingParticle(
                screenWidth - 60,
                120,
                0.2,
                const Color(0xFF3B8A00),
              ),
              _buildFloatingParticle(50, 250, 0.4, Colors.purple.shade300),
              _buildFloatingParticle(
                screenWidth - 70,
                350,
                0.6,
                Colors.orange.shade300,
              ),
              _buildFloatingParticle(
                80,
                screenHeight - 200,
                0.8,
                Colors.blue.shade300,
              ),

              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Back button
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 800,
                                  ),
                                  pageBuilder: (_, __, ___) =>
                                      const RegisterScreen(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale:
                                                Tween<double>(
                                                  begin: 0.9,
                                                  end: 1.0,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeOutBack,
                                                  ),
                                                ),
                                            child: child,
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white.withOpacity(0.8),
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Header with animation
                        AnimatedBuilder(
                          animation: _headerController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _headerOpacity.value,
                              child: Transform.scale(
                                scale: _headerScale.value,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _glowController,
                                builder: (context, child) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF3B8A00),
                                          const Color(0xFF4CA500),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF3B8A00)
                                              .withOpacity(
                                                0.3 +
                                                    _glowController.value * 0.2,
                                              ),
                                          blurRadius:
                                              30 + _glowController.value * 15,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.lock_outline,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    const Color(0xFF3B8A00),
                                    const Color(0xFF4CA500),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'مرحباً بعودتك!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Form with slide animation
                        SlideTransition(
                          position: _formSlide,
                          child: FadeTransition(
                            opacity: _formOpacity,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Email field
                                  _buildTextField(
                                    controller: _emailController,
                                    hint: 'البريد الإلكتروني',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'من فضلك أدخل البريد الإلكتروني';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // Password field
                                  BlocBuilder<LoginCubit, LoginState>(
                                    builder: (context, state) {
                                      return _buildTextField(
                                        controller: _passwordController,
                                        hint: 'كلمة المرور',
                                        icon: Icons.lock_outline,
                                        obscureText: _obscure,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscure = !_obscure;
                                            });
                                          },
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.white.withOpacity(
                                              0.6,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'من فضلك أدخل كلمة المرور';
                                          }
                                          return null;
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Forgot password
                                  // Align(
                                  //   alignment: Alignment.centerLeft,
                                  //   child: TextButton(
                                  //     onPressed: () {},
                                  //     child: Text(
                                  //       'نسيت كلمة المرور؟',
                                  //       style: TextStyle(
                                  //         color: const Color(0xFF3B8A00),
                                  //         fontWeight: FontWeight.w600,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  // const SizedBox(height: 30),

                                  // Login button
                                  BlocBuilder<LoginCubit, LoginState>(
                                    builder: (context, state) {
                                      return _buildGradientButton(
                                        onPressed: () => _handleLogin(context),
                                        text: 'تسجيل الدخول',
                                        isLoading: state.isLoading,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: const Color(0xFF3B8A00)),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [const Color(0xFF3B8A00), const Color(0xFF4CA500)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B8A00).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Widget _buildSocialButton({required IconData icon, required Color color}) {
  //   return TweenAnimationBuilder<double>(
  //     tween: Tween(begin: 0.0, end: 1.0),
  //     duration: const Duration(milliseconds: 800),
  //     builder: (context, value, child) {
  //       return Transform.scale(scale: value, child: child);
  //     },
  //     child: Container(
  //       width: 60,
  //       height: 60,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.white.withOpacity(0.05),
  //         border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
  //       ),
  //       child: Material(
  //         color: Colors.transparent,
  //         child: InkWell(
  //           onTap: () {},
  //           customBorder: CircleBorder(),
  //           child: Icon(icon, color: color, size: 28),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
