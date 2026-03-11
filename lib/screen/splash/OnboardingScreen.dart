import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/AppColor.dart';
import 'location_permission.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Welcome to Frebbo",
      subtitle: "Your gateway to seamless business connections",
      description:
          "Discover a world of business opportunities and build meaningful connections that drive growth and success.",
      icon: Icons.business_center_rounded,
    ),
    OnboardingPage(
      title: "Find Businesses",
      subtitle: "Discover local services and partners",
      description:
          "Easily search and discover businesses in your area. Find the perfect partners and services to help your business thrive.",
      icon: Icons.search_rounded,
    ),
    OnboardingPage(
      title: "Connect Instantly",
      subtitle: "Build meaningful business relationships",
      description:
          "Connect with business owners and professionals instantly. Build lasting relationships that benefit your business growth.",
      icon: Icons.connect_without_contact_rounded,
    ),
    OnboardingPage(
      title: "Grow Together",
      subtitle: "Scale your business network effortlessly",
      description:
          "Expand your network and watch your business grow. Collaborate, partner, and succeed together with Frebbo.",
      icon: Icons.trending_up_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    _startAutoAdvance();
  }

  void _pageListener() {
    if (_pageController.hasClients && _pageController.page != null) {
      setState(() {
        _currentPage =
            _pageController.page!.round().clamp(0, _pages.length - 1);
      });
    }
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();

    _autoAdvanceTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentPage < _pages.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  void _resetAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _handleButtonPress() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
      _resetAutoAdvance();
    } else {
      _getStarted();
    }
  }

  void _getStarted() {
    _autoAdvanceTimer?.cancel();
    Get.offAll(() => LocationPerMissionScreeen());
  }

  void _skipOnboarding() {
    _autoAdvanceTimer?.cancel();
    Get.offAll(() => LocationPerMissionScreeen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: AppColor().whiteColor.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: _pages[index]);
                },
              ),
            ),

            // Bottom Section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return AnimatedContainer(
                duration: Duration(seconds: 2),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColor().whiteColor
                      : AppColor().whiteColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          SizedBox(height: 40),

          // Get Started/Next Button
          if (_currentPage == _pages.length - 1)
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleButtonPress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().whiteColor,
                  foregroundColor: AppColor().colorPrimary,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: AppColor().blackColor.withOpacity(0.3),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 56), // Placeholder for consistent spacing

          SizedBox(height: 20),

          // Powered by Footer
          Text(
            "Powered by Frebbo Connect © 2025",
            style: TextStyle(
              color: AppColor().whiteColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColor().whiteColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor().whiteColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              page.icon,
              size: 50,
              color: AppColor().whiteColor,
            ),
          ),

          SizedBox(height: 40),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColor().whiteColor,
              letterSpacing: 0.5,
              height: 1.2,
            ),
          ),

          SizedBox(height: 16),

          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor().whiteColor.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
          ),

          SizedBox(height: 24),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor().whiteColor.withOpacity(0.8),
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),

          SizedBox(height: 40),

          // Feature List (for specific pages)
          if (page.title == "Find Businesses")
            _buildFeatureList([
              "Local business discovery",
              "Service categorization",
              "Ratings and reviews",
              "Easy search filters",
            ]),

          if (page.title == "Connect Instantly")
            _buildFeatureList([
              "Direct messaging",
              "Business profiles",
              "Contact sharing",
              "Meeting scheduling",
            ]),

          if (page.title == "Grow Together")
            _buildFeatureList([
              "Network expansion",
              "Collaboration tools",
              "Growth analytics",
              "Partnership opportunities",
            ]),
        ],
      ),
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      children: features
          .map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColor().whiteColor.withOpacity(0.8),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      feature,
                      style: TextStyle(
                        color: AppColor().whiteColor.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
