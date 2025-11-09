import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/core/managers/snack_bar_manager.dart';
import 'package:food_gpt/core/services/locator/service_locator.dart';
import 'package:food_gpt/features/login/presentation/view/login_screen.dart';
import 'package:food_gpt/features/register/data/model/register_model.dart';
import 'package:food_gpt/features/register/presentation/controller/register_state.dart';

import '../controller/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (message, _, __, ___, ____) {
              SnackbarManager.show(
                context,
                message: message,
                backgroundColor: const Color(0xFF3B8A00),
              );

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, __, ___) => const LoginScreen(),
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
            failure: (failure, _, __, ___, ____) {
              SnackbarManager.show(
                context,
                message: failure.message,
                backgroundColor: const Color.fromARGB(255, 243, 7, 7),
              );
            },
            orElse: () {},
          );
        },
        child: const _RegisterScreenView(),
      ),
    );
  }
}

class _RegisterScreenView extends StatefulWidget {
  const _RegisterScreenView();

  @override
  State<_RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<_RegisterScreenView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _formController;
  late AnimationController _particlesController;
  late AnimationController _glowController;
  late AnimationController _progressController;

  late Animation<double> _headerScale;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _formOpacity;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();

  final _pageController = PageController();

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

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

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
    _progressController.dispose();
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
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

  void _nextStep() {
    final state = context.read<RegisterCubit>().state;

    // ✅ استخدم الـ getter أو when للوصول للـ currentStep
    final currentStep = state.currentStep;

    if (currentStep < 2) {
      if (_formKey.currentState!.validate()) {
        context.read<RegisterCubit>().nextStep();
        _pageController.animateToPage(
          currentStep + 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _progressController.forward(from: 0);
      }
    }
  }

  void _previousStep() {
    final state = context.read<RegisterCubit>().state;
    final currentStep = state.currentStep;

    if (currentStep > 0) {
      context.read<RegisterCubit>().previousStep();
      _pageController.animateToPage(
        currentStep - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _progressController.forward(from: 0);
    }
  }

  void _handleRegister(BuildContext context) async {
    final cubit = context.read<RegisterCubit>();
    final state = cubit.state;

    if (_formKey.currentState!.validate() && state.acceptTerms) {
      await cubit.register(
        RegisterModel(
          username: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phoneNumber: _phoneController.text,
          age: int.parse(_ageController.text),
        ),
      );
    } else if (!state.acceptTerms) {
      SnackbarManager.show(
        context,
        message: "يجب الموافقة على الشروط والأحكام",
        backgroundColor: Colors.red.shade400,
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
        backgroundColor: Color(0xFF0f3460),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles
              _buildFloatingParticle(40, 80, 0, Colors.orange.shade300),
              _buildFloatingParticle(
                screenWidth - 60,
                120,
                0.2,
                const Color(0xFF3B8A00),
              ),
              _buildFloatingParticle(50, 250, 0.4, Colors.pink.shade300),
              _buildFloatingParticle(
                screenWidth - 70,
                350,
                0.6,
                Colors.purple.shade300,
              ),
              _buildFloatingParticle(
                80,
                screenHeight - 200,
                0.8,
                Colors.amber.shade300,
              ),

              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) =>
                                  _buildProgressIndicator(state.currentStep),
                            ),
                          ],
                        ),
                      ),

                      // Animated header
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _glowController,
                                builder: (context, child) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange.shade400,
                                          Colors.pink.shade400,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(
                                            0.3 + _glowController.value * 0.2,
                                          ),
                                          blurRadius:
                                              30 + _glowController.value * 15,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_add_outlined,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.pink.shade400,
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'إنشاء حساب جديد',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'انضم إلينا الآن!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Form pages
                      SizedBox(
                        height: 350,
                        child: SlideTransition(
                          position: _formSlide,
                          child: FadeTransition(
                            opacity: _formOpacity,
                            child: Form(
                              key: _formKey,
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildStep1(),
                                  _buildStep2(),
                                  _buildStep3(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Navigation buttons
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          final currentStep = state.currentStep;

                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 30,
                              left: 30,
                              bottom: 30,
                              top: 10,
                            ),
                            child: Row(
                              children: [
                                if (currentStep > 0)
                                  Expanded(
                                    child: _buildOutlineButton(
                                      onPressed: _previousStep,
                                      text: 'السابق',
                                    ),
                                  ),
                                if (currentStep > 0) const SizedBox(width: 16),
                                Expanded(
                                  child: _buildGradientButton(
                                    onPressed: currentStep == 2
                                        ? () => _handleRegister(context)
                                        : _nextStep,
                                    text: currentStep == 2
                                        ? 'إنشاء الحساب'
                                        : 'التالي',
                                    isLoading:
                                        state.isLoading && currentStep == 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 800,
                                  ),
                                  pageBuilder: (_, __, ___) =>
                                      const LoginScreen(),
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
                            child: RichText(
                              text: TextSpan(
                                text: 'لديك حساب بالفعل؟ ',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'تسجيل دخول',
                                    style: TextStyle(
                                      color: Colors.orange.shade400,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: index == currentStep ? 30 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index <= currentStep
                ? const Color(0xFF3B8A00)
                : Colors.white.withOpacity(0.2),
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المعلومات الشخصية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nameController,
            hint: 'الاسم الكامل',
            icon: Icons.person_outline,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'من فضلك أدخل الاسم';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _phoneController,
            hint: 'رقم الهاتف',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'من فضلك أدخل رقم الهاتف';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _ageController,
            hint: 'العمر',
            icon: Icons.hourglass_bottom,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'من فضلك أدخل العمر';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'البريد الإلكتروني',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _emailController,
            hint: 'البريد الإلكتروني',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'من فضلك أدخل البريد الإلكتروني';
              }
              if (!value!.contains('@')) {
                return 'البريد الإلكتروني غير صحيح';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'كلمة المرور',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _passwordController,
                hint: 'كلمة المرور',
                icon: Icons.lock_outline,
                obscureText: state.obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<RegisterCubit>().togglePasswordVisibility();
                  },
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'من فضلك أدخل كلمة المرور';
                  }
                  if (value!.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _confirmPasswordController,
                hint: 'تأكيد كلمة المرور',
                icon: Icons.lock_outline,
                obscureText: state.obscureConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    context
                        .read<RegisterCubit>()
                        .toggleConfirmPasswordVisibility();
                  },
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'من فضلك أكد كلمة المرور';
                  }
                  if (value != _passwordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: state.acceptTerms
                      ? const Color(0xFF3B8A00).withOpacity(0.1)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: state.acceptTerms
                        ? const Color(0xFF3B8A00)
                        : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: state.acceptTerms,
                        onChanged: (value) {
                          context.read<RegisterCubit>().updateTermsAcceptance(
                            value ?? false,
                          );
                        },
                        activeColor: const Color(0xFF3B8A00),
                        side: BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(text: 'أوافق على '),
                            TextSpan(
                              text: 'الشروط والأحكام',
                              style: TextStyle(
                                color: const Color(0xFF3B8A00),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' و '),
                            TextSpan(
                              text: 'سياسة الخصوصية',
                              style: TextStyle(
                                color: const Color(0xFF3B8A00),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
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
            prefixIcon: Icon(icon, color: Colors.orange.shade400),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(15),
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
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.pink.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
