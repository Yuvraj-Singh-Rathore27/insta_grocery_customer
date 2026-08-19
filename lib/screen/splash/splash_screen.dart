import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/AppColor.dart';
import 'OnboardingScreen.dart';

/// Drop the artwork from the design sheet at these paths and the splash picks
/// it up on the next build — `assets/images/` is already declared in
/// pubspec.yaml, so no pubspec change is needed. Until a file exists the
/// screen paints the same scene instead (see [_CityScenePainter] /
/// [_CarPainter]), so the splash never ships broken.
const String kSplashCityAsset = "assets/images/splash_city.png";
const String kSplashCarAsset = "assets/images/splash_car.png";

/// Every size on the splash derives from the real layout constraints, so the
/// screen holds up from a small phone through a tablet, and in landscape.
/// Values are clamped at both ends: proportional sizing alone would leave a
/// 200px logo on a tablet and an unreadable one on a compact phone.
class _Metrics {
  _Metrics(Size size)
      : width = size.width,
        height = size.height,
        // Landscape phones and split screen: not enough height for the tiles.
        tiny = size.height < 560,
        compact = size.height < 700;

  final double width;
  final double height;
  final bool tiny;
  final bool compact;

  double get _shrink => compact ? 0.85 : 1.0;

  double get logo => (width * 0.26).clamp(58.0, 112.0) * _shrink;

  double get brandFont => (width * 0.085).clamp(21.0, 34.0) * _shrink;

  double get bodyFont => (width * 0.037).clamp(11.5, 14.5);

  double get tile => (width * 0.145).clamp(42.0, 62.0) * _shrink;

  double get tileIcon => tile * 0.48;

  /// Base vertical rhythm; every gap on the screen is a multiple of it.
  double get gap => (height * 0.02).clamp(8.0, 18.0);

  double get topSpace => (height * 0.05).clamp(10.0, 44.0);

  double get bottomSpace => (height * 0.05).clamp(12.0, 48.0);

  /// Car never gets wider than a comfortable reading width on tablets.
  double carWidth(double heroWidth) => (heroWidth * 0.52).clamp(120.0, 380.0);
}

/// Launch screen (route `/`). Red wave top-left and bottom-right, logo card,
/// brand lock-up, the three ride tiles, the city/road hero, and the loader.
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _loader;
  Timer? _timer;

  Color get _primary => AppColor().colorPrimary;

  @override
  void initState() {
    super.initState();

    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _loader = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _timer = Timer(const Duration(milliseconds: 3800), () {
      if (mounted) Get.offAll(() => OnboardingScreen());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _entry.dispose();
    _loader.dispose();
    super.dispose();
  }

  /// Side gutter for the text sections, capped so the lock-up doesn't stretch
  /// across a tablet. The hero skips it and spans the full screen width.
  Widget _gutter(Widget child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ),
      );

  /// Fade + rise, staggered so the screen assembles top-down.
  Widget _entrance({
    required double start,
    required double end,
    required Widget child,
  }) {
    final CurvedAnimation curved = CurvedAnimation(
      parent: _entry,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);

    // A very large system font would push the fixed rows past the screen, so
    // the splash caps it. Everything else scales off the real constraints.
    final double textScale = media.textScaler.scale(1).clamp(1.0, 1.15);

    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        backgroundColor: AppColor().whiteColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final _Metrics m = _Metrics(constraints.biggest);

            return Stack(
              children: [
                // ---------------- CORNER WAVES ----------------
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.30,
                  child: CustomPaint(
                    painter: _TopWavePainter(primary: _primary),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.22,
                    child: CustomPaint(
                      painter: _BottomWavePainter(primary: _primary),
                    ),
                  ),
                ),

                // The gutter is applied per section, not to the whole column,
                // so the hero can run edge to edge while the text stays inset.
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: m.topSpace),

                      // ---------------- LOGO ----------------
                      _gutter(
                        _entrance(start: 0, end: 0.5, child: _buildLogo(m)),
                      ),

                      SizedBox(height: m.gap),

                      // ---------------- BRAND ----------------
                      _gutter(
                        _entrance(
                          start: 0.12,
                          end: 0.6,
                          child: Column(
                            children: [
                              _buildBrandName(m),
                              SizedBox(height: m.gap * 0.5),
                              _buildTagline(m),
                            ],
                          ),
                        ),
                      ),

                      // Ride tiles are the first thing to go when the screen
                      // is too short to hold everything (landscape phones).
                      if (!m.tiny) ...[
                        SizedBox(height: m.gap * 1.4),
                        _gutter(
                          _entrance(
                            start: 0.2,
                            end: 0.7,
                            child: _buildRideTiles(m),
                          ),
                        ),
                      ],

                      // ---------------- HERO SCENE (full bleed) ----------
                      Expanded(
                        child: _entrance(
                          start: 0.28,
                          end: 0.85,
                          child: _buildHero(),
                        ),
                      ),

                      SizedBox(height: m.gap),

                      // ---------------- LOADER ----------------
                      _gutter(
                        _entrance(
                          start: 0.45,
                          end: 1,
                          child: Column(
                            children: [
                              _buildDots(m),
                              SizedBox(height: m.gap),
                              Text(
                                "Finding nearby rides...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: m.bodyFont,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor().blackColorMore,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: m.bottomSpace),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                         LOGO CARD
  // -----------------------------------------------------------
  Widget _buildLogo(_Metrics m) {
    final double box = m.logo;

    return Container(
      height: box,
      width: box,
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(box * 0.28),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.18),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "F",
          style: TextStyle(
            fontSize: box * 0.54,
            fontWeight: FontWeight.w900,
            color: _primary,
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                        BRAND NAME
  // -----------------------------------------------------------
  Widget _buildBrandName(_Metrics m) {
    // FittedBox is the backstop for the narrowest phones: the name shrinks to
    // one line instead of wrapping or overflowing.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Frebbo ",
              style: TextStyle(
                fontSize: m.brandFont,
                fontWeight: FontWeight.w900,
                fontFamily: "Inter",
                color: _primary,
              ),
            ),
            TextSpan(
              text: "Connect",
              style: TextStyle(
                fontSize: m.brandFont,
                fontWeight: FontWeight.w800,
                fontFamily: "Inter",
                color: AppColor().blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                    TAGLINE (dot separated)
  // -----------------------------------------------------------
  Widget _buildTagline(_Metrics m) {
    const List<String> items = ["Book Cabs", "Autos", "Nearby Rides"];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i != 0) ...[
              const SizedBox(width: 10),
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              items[i],
              style: TextStyle(
                fontSize: m.bodyFont,
                fontWeight: FontWeight.w500,
                color: AppColor().blackColorMore,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  //                        RIDE TILES
  // -----------------------------------------------------------
  Widget _buildRideTiles(_Metrics m) {
    final List<(IconData, String)> tiles = [
      (Icons.directions_car_filled_rounded, "Cabs"),
      (Icons.electric_rickshaw_rounded, "Autos"),
      (Icons.location_on_rounded, "Nearby Rides"),
    ];

    return Row(
      children: [
        for (final (IconData icon, String label) in tiles)
          // Equal shares, so "Nearby Rides" can't shove the other two around
          // on a narrow screen.
          Expanded(
            child: Column(
              children: [
                Container(
                  height: m.tile,
                  width: m.tile,
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(m.tile * 0.29),
                  ),
                  child: Icon(icon, color: _primary, size: m.tileIcon),
                ),
                SizedBox(height: m.gap * 0.45),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: m.bodyFont * 0.92,
                    fontWeight: FontWeight.w500,
                    color: AppColor().blackColorMore,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // -----------------------------------------------------------
  //          HERO: CITY BACKDROP + CAR (asset or painted)
  // -----------------------------------------------------------
  Widget _buildHero() {
    // SizedBox.expand is load bearing: without it the Stack shrink-wraps to
    // the car (its only non-positioned child) and the whole scene renders at
    // roughly half the screen width.
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final _Metrics m = _Metrics(constraints.biggest);

          // On a short hero the car would be taller than the box it sits in,
          // so cap it against the available height too.
          final double carWidth = [
            m.carWidth(constraints.maxWidth),
            constraints.maxHeight * 0.9 * 1.55,
          ].reduce((a, b) => a < b ? a : b);

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: Image.asset(
                  kSplashCityAsset,
                  fit: BoxFit.cover,
                  // Missing asset -> painted scene, so the screen still
                  // renders.
                  errorBuilder: (_, __, ___) => CustomPaint(
                    painter: _CityScenePainter(primary: _primary),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.04),
                child: SizedBox(
                  width: carWidth,
                  child: AspectRatio(
                    aspectRatio: 1.55,
                    child: Image.asset(
                      kSplashCarAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => CustomPaint(
                        painter: _CarPainter(primary: _primary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // -----------------------------------------------------------
  //                        DOT LOADER
  // -----------------------------------------------------------
  Widget _buildDots(_Metrics m) {
    final double dot = (m.width * 0.022).clamp(7.0, 10.0);

    return AnimatedBuilder(
      animation: _loader,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Each dot peaks a third of a cycle after the one before it.
            final double phase = (_loader.value - index * 0.22) % 1.0;
            final double pulse =
                (phase < 0.5 ? phase : 1 - phase) * 2; // 0 -> 1 -> 0

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: dot * 0.55),
              child: Container(
                height: dot + pulse * dot * 0.38,
                width: dot + pulse * dot * 0.38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(
                    _primary.withOpacity(0.25),
                    _primary,
                    pulse,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// -----------------------------------------------------------
//                    TOP-LEFT WAVE PAINTER
// -----------------------------------------------------------
class _TopWavePainter extends CustomPainter {
  const _TopWavePainter({required this.primary});

  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path blob = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h * 0.72)
      ..cubicTo(w * 0.26, h * 0.66, w * 0.40, h * 0.32, w * 0.42, 0)
      ..close();

    canvas.drawPath(
      blob,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.75), primary.withOpacity(0.35)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Hairline echo of the same curve, sweeping further right.
    canvas.drawPath(
      Path()
        ..moveTo(0, h)
        ..cubicTo(w * 0.38, h * 0.92, w * 0.58, h * 0.44, w * 0.66, 0),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = primary.withOpacity(0.28),
    );
  }

  @override
  bool shouldRepaint(covariant _TopWavePainter oldDelegate) =>
      oldDelegate.primary != primary;
}

// -----------------------------------------------------------
//                  BOTTOM-RIGHT WAVE PAINTER
// -----------------------------------------------------------
class _BottomWavePainter extends CustomPainter {
  const _BottomWavePainter({required this.primary});

  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Solid sweep hugging the bottom edge.
    final Path wave = Path()
      ..moveTo(w, h)
      ..lineTo(0, h)
      ..lineTo(0, h * 0.62)
      ..cubicTo(w * 0.34, h * 0.30, w * 0.62, h * 0.86, w, h * 0.20)
      ..close();

    canvas.drawPath(
      wave,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [primary.withOpacity(0.85), primary.withOpacity(0.45)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Lighter wave riding just above it.
    canvas.drawPath(
      Path()
        ..moveTo(w, h)
        ..lineTo(0, h)
        ..lineTo(0, h * 0.80)
        ..cubicTo(w * 0.40, h * 0.52, w * 0.60, h * 0.98, w, h * 0.46)
        ..close(),
      Paint()..color = primary.withOpacity(0.18),
    );
  }

  @override
  bool shouldRepaint(covariant _BottomWavePainter oldDelegate) =>
      oldDelegate.primary != primary;
}

// -----------------------------------------------------------
//     CITY SCENE FALLBACK: SKY + SUN + SKYLINE + TREES + ROAD
// -----------------------------------------------------------
class _CityScenePainter extends CustomPainter {
  const _CityScenePainter({required this.primary});

  final Color primary;

  /// Fixed silhouette (height factor, red-tinted?) so the skyline is stable
  /// across launches instead of shuffling on every rebuild.
  static const List<(double, bool)> _buildings = [
    (0.34, false),
    (0.52, true),
    (0.26, false),
    (0.62, true),
    (0.38, false),
    (0.70, false),
    (0.30, true),
    (0.56, false),
    (0.28, true),
    (0.46, false),
    (0.36, true),
    (0.58, false),
  ];

  static const Color _blueBuilding = Color(0xFFC3D4E8);
  static const Color _blueBuildingDark = Color(0xFFA9BFDA);
  static const Color _road = Color(0xFFD8DEE6);
  static const Color _tree = Color(0xFF6FB268);
  static const Color _treeDark = Color(0xFF4F9350);
  static const Color _pole = Color(0xFF97A3B4);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double horizon = h * 0.66;

    _paintSky(canvas, w, horizon);
    _paintSkyline(canvas, w, horizon);
    _paintRoad(canvas, w, h, horizon);
    _paintRoadside(canvas, w, horizon);
  }

  void _paintSky(Canvas canvas, double w, double horizon) {
    final Rect sky = Rect.fromLTWH(0, 0, w, horizon);

    canvas.drawRect(
      sky,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF6FAFF), Colors.white],
        ).createShader(sky),
    );

    // Sun.
    final Offset sunAt = Offset(w * 0.62, horizon * 0.30);
    canvas.drawCircle(
      sunAt,
      w * 0.085,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFB48F), Color(0xFFFF8A6B)],
        ).createShader(Rect.fromCircle(center: sunAt, radius: w * 0.085)),
    );

    // Clouds.
    for (final (double cx, double cy, double r) in [
      (0.16, 0.16, 0.055),
      (0.84, 0.24, 0.045),
    ]) {
      final Paint cloud = Paint()..color = const Color(0xFFDCEAF8);
      canvas.drawCircle(Offset(w * cx, horizon * cy), w * r, cloud);
      canvas.drawCircle(
        Offset(w * (cx + r * 0.9), horizon * cy + w * r * 0.15),
        w * r * 0.75,
        cloud,
      );
    }

    // Birds.
    final Paint bird = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = const Color(0xFF9AA6B4);

    for (final (double bx, double by, double s) in [
      (0.40, 0.38, 1.0),
      (0.46, 0.32, 0.8),
      (0.44, 0.45, 0.7),
    ]) {
      final double span = w * 0.022 * s;
      final Offset at = Offset(w * bx, horizon * by);
      canvas.drawPath(
        Path()
          ..moveTo(at.dx - span, at.dy)
          ..quadraticBezierTo(at.dx - span * 0.5, at.dy - span * 0.6, at.dx,
              at.dy)
          ..quadraticBezierTo(
              at.dx + span * 0.5, at.dy - span * 0.6, at.dx + span, at.dy),
        bird,
      );
    }
  }

  void _paintSkyline(Canvas canvas, double w, double horizon) {
    final double slot = w / _buildings.length;
    final Paint paint = Paint();

    for (int i = 0; i < _buildings.length; i++) {
      final (double factor, bool tinted) = _buildings[i];
      final double height = horizon * factor;
      final Rect rect = Rect.fromLTWH(
        i * slot + slot * 0.08,
        horizon - height,
        slot * 0.84,
        height,
      );

      paint.color = tinted
          ? primary.withOpacity(0.22)
          : (i.isEven ? _blueBuilding : _blueBuildingDark);

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        ),
        paint,
      );

      // Antenna on the tallest blocks.
      if (factor > 0.55) {
        canvas.drawLine(
          Offset(rect.center.dx, rect.top),
          Offset(rect.center.dx, rect.top - horizon * 0.08),
          Paint()
            ..strokeWidth = 1.4
            ..color = paint.color,
        );
      }
    }
  }

  void _paintRoad(Canvas canvas, double w, double h, double horizon) {
    // Ground.
    canvas.drawRect(
      Rect.fromLTWH(0, horizon, w, h - horizon),
      Paint()..color = const Color(0xFFF2F5F8),
    );

    // Road widens toward the viewer.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.40, horizon)
        ..lineTo(w * 0.60, horizon)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = _road,
    );

    // Lane dashes: squaring `t` fakes the perspective foreshortening.
    final Paint dash = Paint()..color = Colors.white;

    for (final double lane in [0.5]) {
      for (int i = 0; i < 6; i++) {
        final double t = i / 6;
        final double next = (i + 0.45) / 6;

        final double y1 = horizon + (h - horizon) * t * t;
        final double y2 = horizon + (h - horizon) * next * next;
        final double halfWidth = 1 + 3.5 * t * t;
        final double x = w * lane;

        canvas.drawPath(
          Path()
            ..moveTo(x - halfWidth, y1)
            ..lineTo(x + halfWidth, y1)
            ..lineTo(x + halfWidth * 1.3, y2)
            ..lineTo(x - halfWidth * 1.3, y2)
            ..close(),
          dash,
        );
      }
    }

    // Solid edge lines.
    final Paint edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white;

    canvas.drawLine(Offset(w * 0.40, horizon), Offset(0, h), edge);
    canvas.drawLine(Offset(w * 0.60, horizon), Offset(w, h), edge);
  }

  /// Street lamps and trees framing the road.
  void _paintRoadside(Canvas canvas, double w, double horizon) {
    final Paint polePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = _pole;

    // (x, height factor, arm points right?)
    for (final (double x, double factor, bool right) in [
      (0.10, 0.30, true),
      (0.24, 0.20, true),
      (0.90, 0.30, false),
      (0.77, 0.20, false),
    ]) {
      final double baseY = horizon;
      final double topY = horizon - horizon * factor;
      final double px = w * x;
      final double arm = w * 0.045 * (right ? 1 : -1);

      canvas.drawLine(Offset(px, baseY), Offset(px, topY), polePaint);
      canvas.drawPath(
        Path()
          ..moveTo(px, topY)
          ..quadraticBezierTo(px + arm * 0.6, topY - horizon * 0.04,
              px + arm, topY - horizon * 0.02),
        polePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(px + arm, topY - horizon * 0.01),
            width: w * 0.022,
            height: w * 0.010,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = _pole,
      );
    }

    // Trees: trunk plus two leaf blobs.
    for (final (double x, double scale) in [
      (0.05, 1.0),
      (0.17, 0.75),
      (0.95, 1.0),
      (0.84, 0.78),
    ]) {
      final double r = w * 0.05 * scale;
      final double cx = w * x;
      final double baseY = horizon + r * 0.15;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, baseY - r * 0.4),
          width: r * 0.24,
          height: r * 1.2,
        ),
        Paint()..color = const Color(0xFF8D6E58),
      );
      canvas.drawCircle(
        Offset(cx, baseY - r * 1.25),
        r * 0.85,
        Paint()..color = _tree,
      );
      canvas.drawCircle(
        Offset(cx - r * 0.42, baseY - r * 0.85),
        r * 0.6,
        Paint()..color = _treeDark,
      );
      canvas.drawCircle(
        Offset(cx + r * 0.45, baseY - r * 0.9),
        r * 0.55,
        Paint()..color = _treeDark,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CityScenePainter oldDelegate) =>
      oldDelegate.primary != primary;
}

// -----------------------------------------------------------
//        CAR FALLBACK: RED SEDAN, REAR VIEW (fills its box)
// -----------------------------------------------------------
class _CarPainter extends CustomPainter {
  const _CarPainter({required this.primary});

  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint body = Paint()..color = primary;
    final Paint bodyDark = Paint()..color = _shade(primary, 0.82);
    final Paint glass = Paint()..color = const Color(0xFF3A4048);

    // Contact shadow.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.97),
        width: w * 0.94,
        height: h * 0.10,
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Wheels (drawn first, body overlaps them).
    for (final double dx in [0.06, 0.72]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * dx, h * 0.70, w * 0.22, h * 0.26),
          Radius.circular(w * 0.04),
        ),
        Paint()..color = const Color(0xFF2E3238),
      );
    }

    // Cabin + rear windscreen.
    final RRect cabin = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.14, h * 0.06, w * 0.72, h * 0.46),
      topLeft: Radius.circular(w * 0.14),
      topRight: Radius.circular(w * 0.14),
    );
    canvas.drawRRect(cabin, body);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(w * 0.20, h * 0.13, w * 0.60, h * 0.30),
        topLeft: Radius.circular(w * 0.10),
        topRight: Radius.circular(w * 0.10),
        bottomLeft: Radius.circular(w * 0.03),
        bottomRight: Radius.circular(w * 0.03),
      ),
      glass,
    );

    // Head rests, just visible through the glass.
    for (final double dx in [0.31, 0.57]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * dx, h * 0.22, w * 0.12, h * 0.13),
          Radius.circular(w * 0.03),
        ),
        Paint()..color = const Color(0xFF23272C),
      );
    }

    // Main body.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.02, h * 0.44, w * 0.96, h * 0.42),
        Radius.circular(w * 0.10),
      ),
      body,
    );

    // Tail lights.
    for (final double dx in [0.05, 0.68]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * dx, h * 0.52, w * 0.27, h * 0.09),
          Radius.circular(h * 0.045),
        ),
        Paint()..color = const Color(0xFFFFE3E0),
      );
    }

    // Number plate.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.36, h * 0.64, w * 0.28, h * 0.11),
        Radius.circular(w * 0.02),
      ),
      Paint()..color = Colors.white,
    );

    // Bumper + exhausts.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.06, h * 0.79, w * 0.88, h * 0.11),
        Radius.circular(w * 0.05),
      ),
      bodyDark,
    );

    for (final double dx in [0.16, 0.72]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * dx, h * 0.83, w * 0.12, h * 0.05),
          Radius.circular(h * 0.025),
        ),
        Paint()..color = const Color(0xFF2E3238),
      );
    }
  }

  /// Darker variant of [color] for the bumper shading.
  Color _shade(Color color, double factor) => Color.fromARGB(
        color.alpha,
        (color.red * factor).round(),
        (color.green * factor).round(),
        (color.blue * factor).round(),
      );

  @override
  bool shouldRepaint(covariant _CarPainter oldDelegate) =>
      oldDelegate.primary != primary;
}
