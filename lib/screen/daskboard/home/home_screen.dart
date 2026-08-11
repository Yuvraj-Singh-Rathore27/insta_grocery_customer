import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/vechile_profile/VehicleMapScreenn.dart';
import '../../../controller/address_controller.dart';
import '../../../controller/homepage_controller.dart';
import '../../../controller/vender_controller.dart';
import '../../../controller/user_profile_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/app_bottom_bar.dart';
import '../../side_menu/supports/my_support_page.dart';
import '../../../webservices/WebServicesHelper.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  HomePageController homePageController = Get.put(HomePageController());
  AddressController addressController = Get.put(AddressController());
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  PharmacyController controller = Get.put(PharmacyController());
  late double width;

  int _currentIndex = 0;

  // Quick Actions grid (Book Cab / Book Ambulance / ...), built from
  // GET /admin/vehicle-type/ instead of being hardcoded, so any vehicle
  // type added on the backend shows up here automatically.
  List<Map<String, dynamic>> _vehicleTypes = [];
  bool _isLoadingVehicleTypes = true;

  // Quick Actions shows one row of three until "View all" is tapped.
  bool _showAllVehicleTypes = false;

  /// Page gutter — tighter on small phones so cards keep their breathing room.
  double get _hPad => width < 360 ? 12 : 16;

  /// True on compact phones, where four columns of labelled icons stop
  /// fitting side by side.
  bool get _isCompact => width < 360;

  /// Three service tiles per row like the design, dropping to two on very
  /// narrow phones and widening to four on tablets.
  int get _serviceColumns {
    if (width < 340) return 2;
    if (width >= 600) return 4;
    return 3;
  }

  /// How much the user's font-size setting inflates text, capped so a huge
  /// accessibility scale doesn't stretch tiles past the screen.
  double get _textScale =>
      MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.4);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userProfileController.getUserDetails();

      // Location first — the top bar's city label depends on it.
      await _determinePosition();

      homePageController.getBannerList();
      addressController.getAddreessListing();
      _loadVehicleTypes();
    });
  }

  Future<void> _loadVehicleTypes() async {
    try {
      final response = await WebServicesHelper().getVechileTypes();

      List<dynamic> rawList = [];
      if (response != null) {
        if (response['data'] is List) {
          rawList = response['data'];
        } else if (response['items'] is List) {
          rawList = response['items'];
        }
      }

      final types = rawList.whereType<Map<String, dynamic>>().toList();
      if (mounted) {
        setState(() {
          _vehicleTypes = types;
          _isLoadingVehicleTypes = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingVehicleTypes = false);
    }
  }

  // Same fallback used on the map screen's category chips: pick an icon from
  // the type name when the API doesn't send an image for it.
  IconData _iconForVehicleType(String name) {
    final n = name.toLowerCase();
    if (n.contains('ambulance') || n.contains('icu')) {
      return Icons.local_hospital;
    }
    if (n.contains('van')) return Icons.local_shipping;
    if (n.contains('auto')) return Icons.electric_rickshaw;
    return Icons.local_taxi;
  }

  // First usable image URL sent by the vehicle-type API for [type], mirroring
  // how category images are read on the map screen.
  String? _imageUrlOfVehicleType(Map<String, dynamic> type) {
    final dynamic image = type['image'];
    if (image is List) {
      for (final img in image) {
        if (img is Map && img['path'] != null && img['path'].toString().isNotEmpty) {
          return img['path'].toString();
        }
      }
    } else if (image is Map && image['path'] != null) {
      return image['path'].toString();
    } else if (image is String && image.isNotEmpty) {
      return image;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshHomeScreen();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(),
                const SizedBox(height: 16),
                _quickActionWidget(),
                const SizedBox(height: 14),
                _featureStrip(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      // 🦶 Bottom Navigation Bar — the bar routes to each tab's screen itself.
      bottomNavigationBar: const AppBottomBar(currentIndex: AppTab.home),
    );
  }

  // 🖼 Banner Carousel
  Widget _buildBanner() {
    return Obx(
      () => Column(
        children: [
          _buildCarousel(homePageController),
          if (homePageController.bannerList.length > 1) ...[
            const SizedBox(height: 10),
            _bannerDots(homePageController.bannerList.length),
          ],
        ],
      ),
    );
  }

  /// Page indicator under the banner — active dot stretches into a pill.
  Widget _bannerDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final bool isActive = i == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 7,
          width: isActive ? 20 : 7,
          decoration: BoxDecoration(
            color: isActive
                ? AppColor().colorPrimary
                : AppColor().colorGray.withOpacity(0.55),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _quickActionWidget() {
    // Collapsed the grid shows one row of three, like the design; "View all"
    // reveals the rest of whatever the vehicle-type API returns.
    final int visibleCount = _showAllVehicleTypes
        ? _vehicleTypes.length
        : (_vehicleTypes.length > 3 ? 3 : _vehicleTypes.length);

    return _card(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor,
                ),
              ),
              if (_vehicleTypes.length > 3)
                GestureDetector(
                  onTap: () => setState(
                    () => _showAllVehicleTypes = !_showAllVehicleTypes,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        _showAllVehicleTypes ? "Show less" : "View all",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor().colorPrimary,
                        ),
                      ),
                      Icon(
                        _showAllVehicleTypes
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.chevron_right_rounded,
                        size: 20,
                        color: AppColor().colorPrimary,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          /// SERVICE TILES — built from GET /admin/vehicle-type/, 3 per row.
          if (_isLoadingVehicleTypes)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_vehicleTypes.isEmpty)
            const SizedBox.shrink()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleCount,
              // A fixed tile height (rather than an aspect ratio) keeps the
              // icon + two text lines from overflowing on narrow screens or
              // when the system font scale is turned up.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _serviceColumns,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 132 * _textScale,
              ),
              itemBuilder: (context, index) =>
                  _serviceTile(_vehicleTypes[index], index),
            ),

          const SizedBox(height: 14),
          _trustBanner(),
        ],
      ),
    );
  }

  /// One tinted service tile (Passenger / Ambulance / Local Goods / …).
  Widget _serviceTile(Map<String, dynamic> type, int index) {
    final int typeId = type['id'] is int
        ? type['id']
        : int.tryParse(type['id']?.toString() ?? '') ?? 0;
    final String name = (type['name'] ?? 'Vehicle').toString();
    final String? imageUrl = _imageUrlOfVehicleType(type);
    final Color tint = _tintForVehicleType(name, index);

    return GestureDetector(
      onTap: () => Get.to(() => VehicleMapScreen(vehicleTypeId: typeId)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          color: tint.withOpacity(0.09),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: AppColor().whiteColor,
                shape: BoxShape.circle,
              ),
              child: imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(11),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => Icon(
                          _iconForVehicleType(name),
                          color: tint,
                          size: 26,
                        ),
                        errorWidget: (_, __, ___) => Icon(
                          _iconForVehicleType(name),
                          color: tint,
                          size: 26,
                        ),
                      ),
                    )
                  : Icon(_iconForVehicleType(name), color: tint, size: 26),
            ),
            const SizedBox(height: 9),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColor().blackColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _subtitleForVehicleType(name),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                color: AppColor().grey_Li.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Emergency services stay on the app's red; everything else cycles through
  /// the accent palette so a row of tiles reads as distinct services.
  Color _tintForVehicleType(String name, int index) {
    final n = name.toLowerCase();
    if (n.contains('ambulance') || n.contains('icu')) {
      return AppColor().colorPrimary;
    }
    const List<Color> palette = [
      Color(0xFF2F6BFF),
      Color(0xFF1E9E5A),
      Color(0xFF7C4DFF),
      Color(0xFFE58A00),
    ];
    return palette[index % palette.length];
  }

  /// Short caption under each service name — the API sends no description.
  String _subtitleForVehicleType(String name) {
    final n = name.toLowerCase();
    if (n.contains('ambulance') || n.contains('icu')) return "Emergency service";
    if (n.contains('goods') || n.contains('van') || n.contains('truck')) {
      return "Delivery service";
    }
    if (n.contains('passenger') ||
        n.contains('cab') ||
        n.contains('taxi') ||
        n.contains('auto')) {
      return "Book a ride";
    }
    return "Book now";
  }

  /// "Safe. Trusted. Always." strip at the bottom of the Quick Actions card.
  Widget _trustBanner() {
    const Color trustGreen = Color(0xFF1B6B4A);

    return GestureDetector(
      onTap: () => Get.to(() => const MySupportsPage()),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: trustGreen.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: trustGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: trustGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Safe. Trusted. Always.",
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Verified drivers and 24/7 support for a worry-free experience.",
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: AppColor().grey_Li.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 34,
              width: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: trustGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColor().whiteColor,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Four selling points split by hairline dividers — one row normally, two
  /// rows of two once the screen is too narrow for four labelled columns.
  Widget _featureStrip() {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.verified_user_rounded,
        'tint': const Color(0xFF1B6B4A),
        'title': "Safe & Secure",
        'subtitle': "Verified drivers",
      },
      {
        'icon': Icons.local_offer_rounded,
        'tint': const Color(0xFFE58A00),
        'title': "Best Prices",
        'subtitle': "Affordable fares",
      },
      {
        'icon': Icons.headset_mic_rounded,
        'tint': const Color(0xFF7C4DFF),
        'title': "24/7 Support",
        'subtitle': "Always here to help",
      },
      {
        'icon': Icons.star_rounded,
        'tint': const Color(0xFFE58A00),
        'title': "Premium Service",
        'subtitle': "Comfort & reliability",
      },
    ];

    return _card(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: _isCompact
          ? Column(
              children: [
                _featureRow(features.sublist(0, 2)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1, color: AppColor().colorGrayLess),
                ),
                _featureRow(features.sublist(2)),
              ],
            )
          : _featureRow(features),
    );
  }

  Widget _featureRow(List<Map<String, dynamic>> features) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(features.length * 2 - 1, (i) {
          if (i.isOdd) {
            return VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 4,
              endIndent: 4,
              color: AppColor().colorGrayLess,
            );
          }
          return Expanded(child: _featureItem(features[i ~/ 2]));
        }),
      ),
    );
  }

  Widget _featureItem(Map<String, dynamic> feature) {
    final Color tint = feature['tint'] as Color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(feature['icon'] as IconData, color: tint, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            feature['title'] as String,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            feature['subtitle'] as String,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 9.5,
              height: 1.3,
              color: AppColor().grey_Li.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }

  /// Shared white surface for the home sections.
  Widget _card({required Widget child, required EdgeInsets padding}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor().colorGrayLess),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // 📍 Location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error('Location permissions are permanently denied.');
    }

    controller.getBusinessTypecategory();
    controller.getCityList();

    Position position = await Geolocator.getCurrentPosition();
    controller.lat.value = position.latitude;
    controller.lng.value = position.longitude;
    controller.getAddressFromLatLng(position.latitude, position.longitude);
    return position;
  }

  // 🎞 Carousel Widget
  Widget _buildCarousel(HomePageController controller) {
    // Edge-to-edge hero card: the banner spans the full content width and its
    // height follows the width so the artwork keeps its proportions.
    final double bannerHeight = ((width - 28) * 0.66).clamp(180.0, 260.0);

    return CarouselSlider(
      items: controller.bannerList.map((item) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: bannerHeight,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: item.path ?? '',
              errorWidget: (context, url, error) => Image.asset(
                ImageRes().bannerImage2,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: bannerHeight,
        autoPlay: true,
        viewportFraction: 1.0,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        onPageChanged: (index, reason) {
          if (mounted) setState(() => _currentIndex = index);
        },
      ),
    );
  }

  /// Pull-to-refresh: re-runs exactly what the screen renders.
  Future<void> _refreshHomeScreen() async {
    await userProfileController.getUserDetails();
    await _determinePosition();
    await homePageController.getBannerList();
    await addressController.getAddreessListing();
    await _loadVehicleTypes();
  }
}
