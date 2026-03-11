import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'OnboardingScreen.dart';
import '../../res/AppColor.dart';

class Splash extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> with SingleTickerProviderStateMixin {
  final splashDelay = 6;
  late AnimationController _controller;
  final Random _random = Random();
  List<_IconParticle> _particles = [];
  late Timer _particleTimer;

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    Get.offAll(() => OnboardingScreen());
  }

  @override
  void initState() {
    super.initState();

    // main animation controller (for looping background icons)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // create initial icons
    _generateParticles();

    // continuously add icons if fewer than 60
    _particleTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && _particles.length < 60) {
        setState(() {
          _particles.add(_createRandomParticle());
        });
      }
    });

    _loadWidget();
  }

  void _generateParticles() {
    _particles = List.generate(40, (_) => _createRandomParticle());
  }

  _IconParticle _createRandomParticle() {
    return _IconParticle(
      icon: _getRandomIcon(),
      size: _random.nextDouble() * 28 + 20, // 20–48 px
      left: _random.nextDouble() * Get.width,
      top: _random.nextDouble() * Get.height,
      fadeSpeed: _random.nextDouble() * 0.5 + 0.5,
    );
  }

  IconData _getRandomIcon() {
    List<IconData> icons = [
      Icons.people,
      Icons.business_center,
      Icons.handshake,
      Icons.network_check,
      Icons.connect_without_contact,
      Icons.language,
      Icons.group,
      Icons.public,
      Icons.share,
      Icons.workspaces,
      Icons.link,
      Icons.restaurant,
      Icons.shopping_bag,
      Icons.car_rental,
      Icons.map_outlined,
      Icons.location_on_outlined,
    ];
    return icons[_random.nextInt(icons.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorPrimary,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // 🌀 Animated background icons (fade in/out)
              ..._particles.map((particle) {
                final double fade =
                    (sin((_controller.value * 2 * pi * particle.fadeSpeed)) +
                            1) /
                        2; // 0–1 smooth oscillation
                return Positioned(
                  left: particle.left,
                  top: particle.top,
                  child: Opacity(
                    opacity: fade * 0.25, // subtle transparency
                    child: Icon(
                      particle.icon,
                      size: particle.size,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                );
              }),

              // 🌟 Static main splash content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // "F" logo
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "F",
                          style: TextStyle(
                            fontSize: 64,
                            color: AppColor().colorPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // App name + subtitles
                    Column(
                      children: [
                        Text(
                          "Frebbo",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Find & Connect",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Find & Connect faster",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // progress bar
                    Container(
                      height: 6,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: _controller.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.white, Color(0xFFFFCCBC)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // loading text
                    _LoadingText(controller: _controller),

                    const SizedBox(height: 30),

                    // footer
                    Text(
                      "Powered by Frebbo Connect © 2025",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoadingText extends StatefulWidget {
  final AnimationController controller;
  const _LoadingText({required this.controller});

  @override
  __LoadingTextState createState() => __LoadingTextState();
}

class __LoadingTextState extends State<_LoadingText> {
  final List<String> _loadingMessages = [
    "Loading your connections...",
    "Connecting to businesses",
    "Building your network",
    "Almost ready...",
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateText);
  }

  void _updateText() {
    final progress = widget.controller.value;
    final newIndex = (progress * _loadingMessages.length).floor();
    if (newIndex != _currentIndex && newIndex < _loadingMessages.length) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _loadingMessages[_currentIndex],
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// 🎨 Helper class for particles
class _IconParticle {
  final IconData icon;
  final double size;
  final double left;
  final double top;
  final double fadeSpeed;

  _IconParticle({
    required this.icon,
    required this.size,
    required this.left,
    required this.top,
    required this.fadeSpeed,
  });
}
