import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:insta_grocery_customer/res/AppDimens.dart';
import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/VenderListingGoogleMap.dart';

import '../../../controller/vender_controller.dart';
import '../../../model/state_model.dart';
import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBarCity.dart';

import '../../../utills/constant.dart';
import '../../address_managment/clientSetLocation.dart';
import 'items/vender_item.dart';

class VenderListing extends StatefulWidget {
  VenderListing({Key? key}) : super(key: key);

  @override
  State<VenderListing> createState() => _PharmaryListingState();
}

class _PharmaryListingState extends State<VenderListing> {
  PharmacyController controller = Get.put(PharmacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor().colorGrayLess2,
        appBar: TopBarCity(
            title: '',
            menuicon: false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            is_mapshow: true,
            onPressed: () => {
                  Get.to(() => ClientLocationSetOnMap(type: "pickup")),
                  // showcityList(controller)
                },
            onTitleTapped: () => {
                  Get.to(() => VenderListingGoogleMap()),
                }),
        body: Obx(() => controller.isLoading.value == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: AppColor().blackColor,
                        ),
                        obscureText: false,
                        controller: controller.searchController,
                        onChanged: (value) => {
                          controller.searchKeyword.value = value,
                          if (controller.searchKeyword.value.length > 3)
                            {
                              // controller.getDoctorList()
                            }
                          else if (controller.searchKeyword.value.length == 0)
                            {
                              // contorller.getDoctorList()
                            }
                        },
                        decoration: InputDecoration(
                          hintText: "Search for hospitals, labs, clinics...",
                          hintStyle: TextStyle(
                            color: AppColor().blackColor.withOpacity(0.4),
                            fontSize: AppDimens().front_regular,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColor().colorPrimary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: AppColor().colorPrimary, width: 2),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons
                                  .search, // Built-in Flutter QR code scanner icon
                              size: 20,
                              color: AppColor().colorPrimary,
                            ),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons
                                      .mic, // Built-in Flutter QR code scanner icon
                                  size: 20,
                                  color: AppColor().colorPrimary,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons
                                      .qr_code_scanner, // Built-in Flutter QR code scanner icon
                                  size: 20,
                                  color: AppColor().colorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Exclusive Offers Section

                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.venderTagsList.length,
                        itemBuilder: (context, index) {
                          final tag = controller.venderTagsList[index];
                          return GestureDetector(
                            onTap: () => controller.onTagSelect(tag),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: tag.isSelected
                                    ? AppColor().colorPrimary.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: tag.isSelected
                                      ? AppColor().colorPrimary
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .local_hospital, // You can customize per tag
                                    size: 18,
                                    color: AppColor().colorPrimary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    tag.name ?? '',
                                    style: TextStyle(
                                      color: AppColor().blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Obx(
                      () => controller.venderList.isEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Text("No Data found."),
                              ))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent scrolling inside SingleChildScrollView
                              itemCount: controller.venderList.length,
                              // itemCount: 10,
                              itemBuilder: (context, index) {
                                return VenderItem(
                                    data: controller.venderList[index]);
                              },
                            ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildExclusiveOffersSection(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildServicesByBusinessesSection(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildHealthTipsNewsSection(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildQuickActionsSection(),
                  ],
                ),
              )));
  }

  // Exclusive Offers Widget
  Widget _buildExclusiveOffersSection() {
    final PageController _pageController = PageController();
    final RxInt _currentPage = 0.obs;

    final List<Map<String, dynamic>> offers = [
      {
        'title': '15% Off Blood Tests',
        'subtitle': 'at Medico Labs',
        'description':
            'Get comprehensive blood testing at discounted rates. Valid till month end.',
        'icon': Icons.local_hospital,
        'color1': AppColor().colorPrimary.withOpacity(0.4),
        'color2': AppColor().colorPrimary,
      },
      {
        'title': '20% Off Health Checkup',
        'subtitle': 'at City Hospital',
        'description':
            'Complete body checkup with premium services. Limited time offer.',
        'icon': Icons.medical_services,
        'color1': Colors.green.withOpacity(0.4),
        'color2': Colors.green,
      },
      {
        'title': 'Free Consultation',
        'subtitle': 'with Senior Doctors',
        'description':
            'First consultation free for new patients. Book your appointment now.',
        'icon': Icons.people,
        'color1': Colors.orange.withOpacity(0.4),
        'color2': Colors.orange,
      },
    ];

    return Column(
      children: [
        Container(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            onPageChanged: (int page) {
              _currentPage.value = page;
            },
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      offer['color1'] as Color,
                      offer['color2'] as Color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Exclusive Offers",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${offer['title']}\n${offer['subtitle']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            offer['description'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              print("Explore Now tapped for ${offer['title']}");
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Explore Now",
                                style: TextStyle(
                                  color: offer['color2'] as Color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        offer['icon'] as IconData,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        // Page Indicators
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(offers.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage.value == index
                        ? offers[index]['color2'] as Color
                        : Colors.grey.withOpacity(0.5),
                  ),
                );
              }),
            )),
      ],
    );
  }

  //  business categoury visits

  Widget _buildServicesByBusinessesSection() {
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Labs',
        'subtitle': 'Accurate Diagnostics',
        'icon': Icons.science,
        'color1': Color(0xFF667eea).withOpacity(0.8),
        'color2': Color(0xFF764ba2),
      },
      {
        'title': 'Pharmacy',
        'subtitle': 'Order from Ne',
        'icon': Icons.local_pharmacy,
        'color1': Color(0xFFf093fb).withOpacity(0.8),
        'color2': Color(0xFFf5576c),
      },
      {
        'title': 'Clinics',
        'subtitle': 'Expert Consultations',
        'icon': Icons.medical_services,
        'color1': Color(0xFF4facfe).withOpacity(0.8),
        'color2': Color(0xFF00f2fe),
      },
      {
        'title': 'Hospitals',
        'subtitle': 'Emergency Care',
        'icon': Icons.local_hospital,
        'color1': Color(0xFF43e97b).withOpacity(0.8),
        'color2': Color(0xFF38f9d7),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Services by Businesses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
        ),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  print("${service['title']} tapped");
                  // Add your navigation logic here
                },
                child: Container(
                  width: 140,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        service['color1'] as Color,
                        service['color2'] as Color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            service['subtitle'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Healtcare detail Widget
  Widget _buildHealthTipsNewsSection() {
    final List<Map<String, dynamic>> healthTips = [
      {
        'title': '5 Foods to Boost Immunity',
        'description':
            'Discover natural ways to strengthen your immune system with these superfoods.',
        'time': '2 hours ago',
        'icon': Icons.eco,
        'color': Color(0xFF4CAF50),
      },
      {
        'title': 'Heart Health Check-up',
        'description':
            'Regular screening can prevent cardiovascular diseases. Book your check-up today.',
        'time': '5 hours ago',
        'icon': Icons.favorite,
        'color': Color(0xFFF44336),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Health Tips & News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(healthTips.length, (index) {
              final tip = healthTips[index];
              return Column(
                children: [
                  if (index > 0)
                    Divider(height: 1, color: Colors.grey.shade300),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: (tip['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                tip['icon'] as IconData,
                                color: tip['color'] as Color,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tip['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor().blackColor,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    tip['time'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(left: 52),
                          child: Text(
                            tip['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

// Quick Actions - Updated to match your image exactly
  Widget _buildQuickActionsSection() {
    final List<Map<String, dynamic>> quickActions = [
      {
        'title': 'Book Appointment',
        'subtitle': 'Schedule with doctors',
        'icon': Icons.calendar_today,
        'color': Color(0xFFFFCDD2),
        'iconColor': Color(0xFFF44336),
      },
      {
        'title': 'Order Medicine',
        'subtitle': 'Home delivery available',
        'icon': Icons.medical_services,
        'color': Color(0xFFBBDEFB),
        'iconColor': Color(0xFF2196F3),
      },
      {
        'title': 'Lab Tests',
        'subtitle': 'Book test online',
        'icon': Icons.science,
        'color': Color(0xFFC8E6C9),
        'iconColor': Color(0xFF4CAF50),
      },
      {
        'title': 'Emergency',
        'subtitle': '24×7 helpline',
        'icon': Icons.call,
        'color': Color(0xFFE1BEE7),
        'iconColor': Color(0xFF9C27B0),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.amber, size: 20),
              SizedBox(width: 6),
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return GestureDetector(
                onTap: () {
                  print("${action['title']} tapped");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: action['color'],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          action['icon'],
                          color: action['iconColor'],
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        action['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action['subtitle'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedTag.value = StateModel();
      controller.getPharmacyList();
      controller.getTagServicesList();
    });
  }

  void showcityList(PharmacyController registerController) {
    BuildContext context = Get.context as BuildContext;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0),
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              builder: (_, controller) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.remove,
                        color: Colors.grey[600],
                      ),
                      Container(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            onChanged: (value) {
                              registerController.filterCityList(value);
                            },
                            decoration: InputDecoration(
                                labelText: "Enter City Name",
                                labelStyle:
                                    TextStyle(color: AppColor().colorPrimary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor().colorPrimary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor().colorPrimary),
                                ),
                                suffixIcon: Image(
                                    width: 20,
                                    height: 20,
                                    image: AssetImage(
                                        ImageRes().img_icon_mobile))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Obx(() => ListView.builder(
                              controller: controller,
                              itemCount:
                                  registerController.filteredCityList.length,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () => {
                                    registerController.onCitySelect(
                                        registerController
                                            .filteredCityList[index]),
                                    Navigator.pop(context),
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(registerController
                                              .filteredCityList[index].name ??
                                          ''),
                                    ),
                                  ),
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
