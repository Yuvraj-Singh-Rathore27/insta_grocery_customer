import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/AppColor.dart';
import '../../res/AppDimens.dart';
import '../../res/ImageRes.dart';
import 'location_permission.dart';

/// One onboarding slide. Images come from [ImageRes] so the paths stay in the
/// one global file.
class OnboardingPage {
  const OnboardingPage({
    required this.image,
    required this.titleTop,
    required this.titleBottom,
    required this.description,
  });

  final String image;

  /// Split across two lines so the emphasis lands the same way on every slide.
  final String titleTop;
  final String titleBottom;
  final String description;
}

/// Sizing derived from the real constraints, clamped at both ends: a plain
/// percentage would give a 40pt title on a tablet and an unreadable one on a
/// small phone.
class _Metrics {
  _Metrics(Size size)
      : width = size.width,
        height = size.height,
        // Landscape / split screen: the artwork has to give up its share.
        tiny = size.height < 560,
        compact = size.height < 700;

  final double width;
  final double height;
  final bool tiny;
  final bool compact;

  double get _shrink => compact ? 0.9 : 1.0;

  double get gutter => (width * 0.06).clamp(16.0, 32.0);

  double get titleFont => (width * 0.062).clamp(18.0, 28.0) * _shrink;

  double get bodyFont =>
      (width * 0.037).clamp(12.0, AppDimens().front_regularX);

  double get ctaHeight => (height * 0.075).clamp(46.0, 60.0);

  double get cardRadius => (width * 0.065).clamp(18.0, 28.0);

  double get gap => (height * 0.018).clamp(8.0, 16.0);

  /// Artwork gives up room first when the screen is short.
  int get imageFlex => tiny ? 4 : 6;

  int get textFlex => tiny ? 4 : 3;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Color get _primary => AppColor().colorPrimary;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: ImageRes().onboarding1,
      titleTop: "Book Your Ride",
      titleBottom: "In Seconds",
      description:
          "Cabs and autos around you, booked from your phone. Live tracking from pickup to drop, every trip.",
    ),
    OnboardingPage(
      image: ImageRes().onboarding2,
      titleTop: "Emergency Help",
      titleBottom: "Anytime You Need",
      description:
          "Call an ambulance and reach the nearest hospital fast. Help is one tap away, day or night.",
    ),
    OnboardingPage(
      image: ImageRes().onboarding3,
      titleTop: "Delivery At Your",
      titleBottom: "Doorstep",
      description:
          "Send parcels or get your orders delivered on time by trusted partners across your city.",
    ),
  ];

  bool get _isLast => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _finish() => Get.offAll(() => LocationPerMissionScreeen());

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);

    // Cap the system font scale; past this the two title lines and the
    // description stop fitting the slide on small phones.
    final double textScale = media.textScaler.scale(1).clamp(1.0, 1.15);

    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        backgroundColor: AppColor().whiteColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final _Metrics m = _Metrics(constraints.biggest);

              return Center(
                child: ConstrainedBox(
                  // Keeps the slide readable instead of stretched on tablets.
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: [
                      _buildSkip(m),

                      // ---------------- SLIDES ----------------
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          itemBuilder: (context, index) =>
                              _buildPage(_pages[index], m),
                        ),
                      ),

                      // ---------------- INDICATOR + CTA ----------------
                      _buildBottomBar(m),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                           SKIP
  // -----------------------------------------------------------
  Widget _buildSkip(_Metrics m) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: m.gutter - 8, vertical: 2),
        child: GestureDetector(
          onTap: _finish,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Skip",
              style: TextStyle(
                color: _primary,
                fontSize: m.bodyFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                          SLIDE
  // -----------------------------------------------------------
  Widget _buildPage(OnboardingPage page, _Metrics m) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: m.gutter),
      child: Column(
        children: [
          // ---------------- IMAGE CARD ----------------
          Expanded(
            flex: m.imageFlex,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: m.gap * 0.5, bottom: m.gap * 1.6),
              decoration: BoxDecoration(
                color: AppColor().whiteColor,
                borderRadius: BorderRadius.circular(m.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.10),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(m.cardRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Diagonal brand block behind the artwork.
                    ClipPath(
                      clipper: const _DiagonalClipper(),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_primary, _primary.withOpacity(0.72)],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(m.gap),
                      child: Image.asset(
                        page.image,
                        fit: BoxFit.contain,
                        // Missing/!renamed asset must not blank the slide.
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: _primary.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------------- TEXT ----------------
          Expanded(
            flex: m.textFlex,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // FittedBox is the backstop on the narrowest phones: the line
                // scales down rather than ellipsising the headline.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    page.titleTop,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: m.titleFont,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      color: AppColor().blackColor,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    page.titleBottom,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: m.titleFont,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      color: _primary,
                    ),
                  ),
                ),
                SizedBox(height: m.gap * 0.75),
                // Flexible + ellipsis: a long description can never overflow
                // the slide, it just truncates.
                Flexible(
                  child: Text(
                    page.description,
                    textAlign: TextAlign.center,
                    maxLines: m.tiny ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: m.bodyFont,
                      height: 1.55,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  //                    INDICATOR + NEXT BUTTON
  // -----------------------------------------------------------
  Widget _buildBottomBar(_Metrics m) {
    return Padding(
      padding: EdgeInsets.fromLTRB(m.gutter, 4, m.gutter, m.gap * 1.6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ---------------- DOTS ----------------
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_pages.length, (index) {
              final bool active = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 8,
                width: active ? 24 : 8,
                decoration: BoxDecoration(
                  color: active ? _primary : _primary.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          // ---------------- CTA ----------------
          // Circle on the first slides, widening into a labelled pill on the
          // last one so the final step reads as the commitment.
          //
          // Two constraints on how this is built:
          //  * AnimatedSize, not AnimatedContainer. Animating width from a
          //    number to null asks BoxConstraints.lerp to interpolate between
          //    finite and unbounded, which throws — and mid-tween the label
          //    gets squeezed into the 60px circle and overflows the Row.
          //    AnimatedSize animates the measured size instead, so the child
          //    is always laid out at its real width.
          //  * Shape stays rectangle with a full radius. Tweening between
          //    BoxShape.circle and rectangle trips the "borderRadius can only
          //    be given for a rectangular box" assert.
          GestureDetector(
            onTap: _next,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: Alignment.centerRight,
              child: Container(
                height: m.ctaHeight,
                width: _isLast ? null : m.ctaHeight,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: _isLast ? m.gutter * 0.85 : 0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(m.ctaHeight / 2),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [_primary, _primary.withOpacity(0.80)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLast) ...[
                      Flexible(
                        child: Text(
                          "Get Started",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColor().whiteColor,
                            fontSize: AppDimens().front_medium,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColor().whiteColor,
                      size: m.ctaHeight * 0.38,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Angled brand block behind the artwork — the diagonal from the reference UI.
class _DiagonalClipper extends CustomClipper<Path> {
  const _DiagonalClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.72, 0)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
