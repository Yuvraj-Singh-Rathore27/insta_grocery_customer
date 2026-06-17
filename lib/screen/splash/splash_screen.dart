import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'OnboardingScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>
    with TickerProviderStateMixin {

  late AnimationController _animationController;
  late AnimationController _carAnimationController;
  late AnimationController _loaderController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textAnimation;
  late Animation<double> _cardOpacity;

  @override
  void initState() {
    super.initState();

    // MAIN CONTROLLER
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // CAR FLOATING CONTROLLER
    _carAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // LOADER CONTROLLER
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // LOGO SCALE
    _logoScale = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // LOGO OPACITY
    _logoOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // TEXT SLIDE
    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // CARD FADE
    _cardOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1),
      ),
    );

    _animationController.forward();

    Timer(
      const Duration(seconds: 4),
      () {
        Get.offAll(() => OnboardingScreen());
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _carAnimationController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB31217),
              Color(0xFFE52D27),
            ],
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [

              // BACKGROUND CIRCLES
              Positioned(
                top: -120,
                right: -100,
                child: Container(
                  height: 260,
                  width: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),

              Positioned(
                bottom: -140,
                left: -120,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              // MAIN CONTENT
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // LOGO
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Container(
                            height: size.width * 0.24,
                            width: size.width * 0.24,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),

                            child: const Center(
                              child: Text(
                                "F",
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFE52D27),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // TEXT
                      SlideTransition(
                        position: _textAnimation,
                        child: FadeTransition(
                          opacity: _logoOpacity,
                          child: Column(
                            children: [

                              const Text(
                                "Frebbo Connect",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.4,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Book Cabs • Autos • Nearby Rides",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 55),

                      // GLASS CARD
                      FadeTransition(
                        opacity: _cardOpacity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 14,
                              sigmaY: 14,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34),
                                color: Colors.white.withOpacity(0.12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),

                              child: Column(
                                children: [

                                  // ANIMATED CAR
                                  AnimatedBuilder(
                                    animation: _carAnimationController,
                                    builder: (context, child) {

                                      double move = sin(
                                        _carAnimationController.value * pi,
                                      ) * 12;

                                      return Transform.translate(
                                        offset: Offset(move, 0),
                                        child: child,
                                      );
                                    },
                                    child: Container(
                                      height: 115,
                                      width: 115,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.18),
                                            Colors.white.withOpacity(0.08),
                                          ],
                                        ),
                                      ),

                                      child: const Icon(
                                        Icons.local_taxi_rounded,
                                        size: 56,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  const Text(
                                    "Book Cabs &\nAuto Near You",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 31,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    "Fast, reliable and affordable rides whenever you need them.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // RIDE CARD
                                  Container(
                                    padding: const EdgeInsets.all(18),

                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),

                                    child: Row(
                                      children: [

                                        Container(
                                          height: 56,
                                          width: 56,

                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: const Color(0xFFFFEBEE),
                                          ),

                                          child: const Icon(
                                            Icons.directions_car_filled_rounded,
                                            color: Color(0xFFE52D27),
                                          ),
                                        ),

                                        const SizedBox(width: 16),

                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                "Book Rides",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black87,
                                                ),
                                              ),

                                              SizedBox(height: 5),

                                              Text(
                                                "Mini • Sedan • SUV",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          padding: const EdgeInsets.all(10),

                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFEBEE),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),

                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                            color: Color(0xFFE52D27),
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
                    ],
                  ),
                ),
              ),

              // PROFESSIONAL LOADER
              Positioned(
                bottom: 45,
                left: 0,
                right: 0,
                child: Column(
                  children: [

                    AnimatedBuilder(
                      animation: _loaderController,
                      builder: (context, child) {

                        return SizedBox(
                          width: 65,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: List.generate(3, (index) {

                              double delay = index * 0.2;

                              double value = sin(
                                (_loaderController.value - delay) * 2 * pi,
                              );

                              return Transform.translate(
                                offset: Offset(0, -value * 8),
                                child: Container(
                                  height: 10,
                                  width: 10,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(
                                      0.5 + (value.abs() * 0.5),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "Finding nearby rides...",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}