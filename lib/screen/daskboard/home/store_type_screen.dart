import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:insta_grocery_customer/toolbar/TopBarCity.dart';

import '../../../controller/address_controller.dart';
import '../../../controller/homepage_controller.dart';
import '../../../controller/vender_controller.dart';
import '../../../controller/user_profile_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';
import '../../../utills/constant.dart';
import '../../address_managment/clientSetLocation.dart';
import '../nearme_vender/VenderList.dart';
import '../nearme_vender/product_listing/product_listing_sub_category.dart';

class StoreTypeScreen extends StatefulWidget {
  StoreTypeScreen({Key? key}) : super(key: key);

  @override
  State<StoreTypeScreen> createState() => _HomeState();
}

class _HomeState extends State<StoreTypeScreen> {
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  PharmacyController controller = Get.put(PharmacyController());
  HomePageController homePageController = Get.put(HomePageController());
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: TopBarCity(
        title: '',
        menuicon: false,
        menuback: true,
        is_mapshow: false,
        iconnotifiction: true,
        is_wallaticon: true,
        is_supporticon: false,
        is_whatsappicon: false,
        onPressed: () => Get.to(() => ClientLocationSetOnMap(type: "pickup")),
        onTitleTapped: () {},
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Obx(() => controller.storeCode.isNotEmpty
                  ? _buildStoreCategoryGrid()
                  : _buildGeneralCategoryGrid()),
            ],
          ),
        ),
      ),
    );
  }

  /// 🟢 When a store is selected
  Widget _buildStoreCategoryGrid() {
    return Obx(() {
      if (controller.categoryList.isEmpty) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: const Center(child: Text("No Data found.")),
        );
      }

      return Column(
        children: [
          _sectionHeader("Welcome ! ${controller.selectedPharmacy.value.name}"),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.85,
            children: controller.categoryList.map((item) {
              return GestureDetector(
                onTap: () {
                  controller.selectedCategory.value = item;
                  Get.to(() => ProductListingSubCategory());
                },
                child: _gridItem(
                  imageUrl: item.logo.toString(),
                  label: item.name ?? '',
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  /// 🟢 When no store selected (main screen)
  Widget _buildGeneralCategoryGrid() {
    return Column(
      children: [
        _sectionHeader("Categories"),
        const SizedBox(height: 10),
        Obx(() => homePageController.storeGroupbannerList.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor().homeBannerBg,
                ),
                child: _banner(homePageController),
              )
            : const SizedBox()),
        const SizedBox(height: 10),
        Obx(() => GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.9,
              children: controller.venderCategory.map((item) {
                return GestureDetector(
                  onTap: () {
                    controller.selectedVenderCategory.value = item;
                    Get.to(() => VenderListing());
                  },
                  child: _gridItem(
                    imageUrl: (item.photos != null && item.photos!.isNotEmpty)
                        ? item.photos![0].path.toString()
                        : "https://via.placeholder.com/80",
                    label: item.name ?? '',
                  ),
                );
              }).toList(),
            )),
        const SizedBox(height: 20),
      ],
    );
  }

  /// 🟢 Grid item reusable widget
  Widget _gridItem({required String imageUrl, required String label}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                flex: 4,
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🟢 Header section widget
  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor().grey_li,
        border: Border.all(width: 1, color: AppColor().grey_li),
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppDimens().front_larger,
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            color: AppColor().blackColor,
          ),
        ),
      ),
    );
  }

  /// 🟢 Banner widget
  Widget _banner(HomePageController controller) {
    return CarouselSlider(
      items: controller.storeGroupbannerList.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: item.path ?? '',
              errorWidget: (context, url, error) => Image.asset(
                ImageRes().bannerImage2,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 120.0,
        autoPlay: true,
        viewportFraction: .9,
        aspectRatio: 3,
        enlargeCenterPage: false,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  /// 🟢 Location handling
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProfileController.getUserDetails();
      homePageController
          .getBannerStoreList(controller.selectedBusinessCategory.value.id);
      _determinePosition();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied. Please enable them in settings.');
    }

    controller.getStoreTypeCategory();

    Position position = await Geolocator.getCurrentPosition();
    controller.lat.value = position.latitude;
    controller.lng.value = position.longitude;
    controller.getAddressFromLatLng(position.latitude, position.longitude);

    return position;
  }
}
