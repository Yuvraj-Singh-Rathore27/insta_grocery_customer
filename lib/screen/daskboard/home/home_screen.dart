import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/daskboard/home/store_type_screen.dart';
import 'package:insta_grocery_customer/screen/side_menu/event_managment/event_detail_screen_all.dart';
import '../../../controller/address_controller.dart';
import '../../../controller/homepage_controller.dart';
import '../../../controller/vender_controller.dart';
import '../../../controller/user_profile_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';
import '../nearme_vender/store_type/store_type_search.dart';
import '../../../controller/customer_event_controller.dart';
import '../home/store_offer_screen.dart';
import '../../../toolbar/app_bottom_bar.dart';
import '../../common/video_player_screen.dart';
import '../nearme_vender/store_offer.dart';

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
  CustomerEventController eventController=Get.put(CustomerEventController());
  late double height, width;

  int _currentIndex = 0; 
  int selectedIndex = 0;// Track current tab index
  

  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) async {
  await userProfileController.getUserDetails();

// STEP 1: Get location first
await _determinePosition();

// STEP 2: Load APIs that depend on location
await controller.getStoreOfferApi();
await controller.getStoreVideoApi();
await controller.getHomePharmacyList();

// STEP 3: Other APIs
homePageController.getBannerList();
addressController.getAddreessListing();

});

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      
      backgroundColor: AppColor().whiteColor,
      body: SafeArea(
  child: RefreshIndicator(
    onRefresh: () async {
      await _refreshHomeScreen();


    },
    child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 15),
          _buildBanner(),
          const SizedBox(height: 20),
          _buildBusinessCategory(),
          const SizedBox(height: 15),
          _nearbyHealthcareSection(),
          const SizedBox(height: 15),
        
homeOfferWidget(),
          const SizedBox(height: 15),

          homeVideoWidget(),
          const SizedBox(height: 15,),
          homeEventWidget(),
                    const SizedBox(height: 15,),


          _recentActivitySectionWithBottomActions(),
          const SizedBox(height: 15),
          _recentEnquiriesSection(),
          const SizedBox(height: 20),
          _sectionBanner(),
          const SizedBox(height: 20),
          _membershipCardsSection(),
          const SizedBox(height: 20),
          _customerReviewsSection(),
        ],
      ),
    ),
  ),
),
bottomNavigationBar: AppBottomBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
  

      // 🦶 Bottom Navigation Bar
      
    );
  }

  Widget _recentActivitySectionWithBottomActions() {
    final List<Map<String, dynamic>> activities = [
      {
        'type': 'Appointment Booked',
        'title': 'Dr. Sarah Wilson - Cardiology',
        'time': '2 hours ago',
        'icon': Icons.calendar_today,
        'color': Colors.green,
      },
      {
        'type': 'Viewed Clinic',
        'title': 'HealthFirst Medical Center',
        'time': 'Yesterday',
        'icon': Icons.medical_services,
        'color': Colors.blue,
      },
      {
        'type': 'Search Query',
        'title': '"Pediatric doctors near me"',
        'time': '2 days ago',
        'icon': Icons.search,
        'color': Colors.orange,
      },
    ];

    final List<String> actions = ['View', 'Visit', 'Search'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: AppDimens().front_larger,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica",
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Clear all functionality
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: AppDimens().front_small,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Activity List
          Column(
            children: activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;

              return Column(
                children: [
                  // Activity Item
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: activity['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            activity['icon'],
                            color: activity['color'],
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['type'],
                                style: TextStyle(
                                  fontSize: AppDimens().front_small,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activity['title'],
                                style: TextStyle(
                                  fontSize: AppDimens().front_medium,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activity['time'],
                                style: TextStyle(
                                  fontSize: AppDimens().front_small - 2,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider (except for last item)
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey[300],
                        height: 1,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),

          // Bottom Action Buttons
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions.map((action) {
                return GestureDetector(
                  onTap: () {
                    // Handle action tap
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      action,
                      style: TextStyle(
                        fontSize: AppDimens().front_small,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nearbyHealthcareSection() {
    final controller = Get.find<PharmacyController>();

    // Auto-load when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getHomePharmacyList();
    });

    print("HomeVendorList length: ${controller.HomeVendorList.length}");
    print("HomeVendorList: ${controller.HomeVendorList}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Healthcare',
                style: TextStyle(
                  fontSize: AppDimens().front_larger,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Helvetica",
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: Obx(() {
            final isLoading = controller.isLoading.value;
            final hasData = controller.HomeVendorList.isNotEmpty;

            // CASE 1: Small loader while fetching data
            if (isLoading && !hasData) {
              return Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              );
            }

            // CASE 2: No data after loading completed
            if (!isLoading && controller.HomeVendorList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_hospital, color: Colors.grey, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      'No healthcare facilities found',
                      style: TextStyle(
                        fontSize: AppDimens().front_medium,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pull down to refresh or check your connection',
                      style: TextStyle(
                        fontSize: AppDimens().front_small,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // CASE 3: Data available → show the list
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.HomeVendorList.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final facility = controller.HomeVendorList[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top banner (status)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Open Now',
                              style: TextStyle(
                                fontSize: AppDimens().front_small,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[800],
                              ),
                            ),
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.green[800],
                            ),
                          ],
                        ),
                      ),

                      // Facility details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                facility.name ?? 'Unknown Facility',
                                style: TextStyle(
                                  fontSize: AppDimens().front_medium,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber[600], size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      fontSize: AppDimens().front_small,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(' ● ',
                                      style:
                                          TextStyle(color: Colors.grey[500])),
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.grey[600], size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Nearby',
                                    style: TextStyle(
                                      fontSize: AppDimens().front_small,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.blue[100]!),
                                ),
                                child: Text(
                                  'Healthcare Service',
                                  style: TextStyle(
                                    fontSize: AppDimens().front_small - 2,
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.blue[200]!),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'View Details',
                                          style: TextStyle(
                                            fontSize: AppDimens().front_small,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColor().colorPrimary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Book Now',
                                          style: TextStyle(
                                            fontSize: AppDimens().front_small,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }


Widget homeOfferWidget() {
  final PharmacyController controller = Get.find<PharmacyController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
          'Latest Offers',
          style: TextStyle(
            fontSize: AppDimens().front_larger,
            fontWeight: FontWeight.bold,
            fontFamily: "Helvetica",
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=>const StoreOfferTypeScreen());

          },
          child: Text("View More",style: TextStyle(color: AppColor().colorPrimary,fontWeight: FontWeight.bold),),
        )
          ],
        )
      ),

      SizedBox(
        height: 150,
        child: Obx(() {
          if (controller.isLoadingOffer.value) {
            return const Center(child: CircularProgressIndicator());
          }

       if (controller.nearbyOfferList.isEmpty) {
  return const Center(child: Text("No nearby offers"));
}


          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.nearbyOfferList.length > 5
                ? 5
                : controller.nearbyOfferList.length,
            itemBuilder: (context, index) {
              final offer = controller.nearbyOfferList[index];

              final imageUrl =
                  (offer.image != null &&
                          offer.image!.isNotEmpty &&
                          offer.image!.first.path != null)
                      ? offer.image!.first.path
                      : null;

              return GestureDetector(
                onTap: () {
                  // 🔥 OPEN OFFER DETAIL SCREEN WITH INDEX
                  Get.to(
                    () => StoreOfferTypeScreen(
                      initialIndex: index,
                    ),
                  );
                },
                child: Container(
                  width: 340,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 🖼 LEFT IMAGE
                      ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(16),
    bottomLeft: Radius.circular(16),
  ),
  child: SizedBox(
    width: 150,
    height: double.infinity,
    child: imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,

            // 🔄 Loading state
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                ),
              );
            },

            // ❌ Error state (image too large / 404 / timeout)
            errorBuilder: (context, error, stackTrace) {
              return _offerImagePlaceholder();
            },
          )
        : _offerImagePlaceholder(),
  ),
),


                      // 📝 RIGHT CONTENT
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.name ?? "Special Offer",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Icon(Icons.store,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      offer.store?.name ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 14, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      offer.timeLeft != null
                                          ? "Valid till ${offer.timeLeft}"
                                          : "Limited period",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    ],
  );
}


Widget _offerImagePlaceholder() {
  return Container(
    color: Colors.grey.shade200,
    child: const Center(
      child: Icon(Icons.local_offer, size: 40, color: Colors.grey),
    ),
  );
}


// home screeb event managment 
Widget homeEventWidget() {
  final CustomerEventController controller =
      Get.find<CustomerEventController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
           
            Text(
                "Latest Events",
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontWeight: FontWeight.bold,
                ),
             
            ),
            Text(
                "View more",
                style: TextStyle(
                  color: AppColor().colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
             
            )
          ],
        ),
      ),

      SizedBox(
        height: 150,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.allEvents.isEmpty) {
            return const Center(child: Text("No events found"));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.allEvents.length > 5
                ? 5
                : controller.allEvents.length,
            itemBuilder: (context, index) {
              final event = controller.allEvents[index];

              final imageUrl =
                  event.image != null && event.image!.isNotEmpty
                      ? event.image!.first.path
                      : null;

              return GestureDetector(
                onTap: () {
                  Get.to(() => EventDetailScreenAll(event:event));
                },
                child: Container(
                  width: 340,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: SizedBox(
                          width: 150,
                          height: double.infinity,
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return _eventPlaceholder();
                                  },
                                )
                              : _eventPlaceholder(),
                        ),
                      ),

                      // DETAILS
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title ?? "Event",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.organizerName ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 14, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.eventDate ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    ],
  );
}


Widget _eventPlaceholder() {
  return Container(
    color: Colors.grey.shade200,
    child: const Center(
      child: Icon(Icons.event, size: 40, color: Colors.grey),
    ),
  );
}





Widget homeVideoWidget() {
  final PharmacyController controller = Get.find<PharmacyController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          'Trending Videos',
          style: TextStyle(
            fontSize: AppDimens().front_larger,
            fontWeight: FontWeight.bold,
            fontFamily: "Helvetica",
            color: Colors.black87,
          ),
        ),
      ),

      SizedBox(
        height: 220,
        child: Obx(() {
          if (controller.isLoadingVideos.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myVideos.isEmpty) {
            return const Center(child: Text("No videos available"));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount:
                controller.myVideos.length > 5 ? 5 : controller.myVideos.length,
            itemBuilder: (context, index) {
              final video = controller.myVideos[index];
              final videoData =
                  video.video.isNotEmpty ? video.video.first : null;

              final String? thumbnail = videoData?['thumbnail'];
final int duration =
    (videoData?['duration'] as num?)?.toInt() ?? 0;

              return GestureDetector(
                onTap: () {
                  final String? videoUrl = videoData?['path'];
                  if (videoUrl == null || videoUrl.isEmpty) return;

                  Get.to(
                    () => Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(backgroundColor: Colors.black),
                      body: VideoPlayerScreen(
                        videoUrl: videoUrl,
                        autoPlay: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 170,
                  margin: const EdgeInsets.only(right: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // 🎥 THUMBNAIL
                        Positioned.fill(
                          child: thumbnail != null
                              ? Image.network(
                                  thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _videoPlaceholder(),
                                )
                              : _videoPlaceholder(),
                        ),

                        // 🌑 GRADIENT OVERLAY
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ▶ PLAY ICON
                        const Positioned.fill(
                          child: Center(
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                          ),
                        ),

                        // ⏱ DURATION
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // 📝 TITLE + STORE
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.name.isNotEmpty
                                    ? video.name
                                    : "Store Video",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                video.storeName ?? "Store",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
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
            },
          );
        }),
      ),
    ],
  );
}
String _formatDuration(int seconds) {
  final mins = seconds ~/ 60;
  final secs = seconds % 60;
  return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
}


Widget _videoPlaceholder() {
  return Container(
    color: Colors.grey.shade300,
    child: const Center(
      child: Icon(
        Icons.videocam,
        size: 40,
        color: Colors.white,
      ),
    ),
  );
}





  Widget _recentEnquiriesSection() {
    final List<Map<String, String>> enquiries = [
      {
        'name': 'Priya Mehta',
        'topic': 'Request for bulk order pricing',
        'time': 'Today, 10:45 AM',
      },
      {
        'name': 'Kunal Joshi',
        'topic': 'Product availability in Jaipur',
        'time': 'Yesterday, 3:20 PM',
      },
      {
        'name': 'Sneha Kapoor',
        'topic': 'Return policy clarification',
        'time': '2 days ago, 6:15 PM',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.purple[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Recent Enquiries 📩',
              style: TextStyle(
                fontSize: AppDimens().front_medium,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 160, // Increased height for better spacing
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: enquiries.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final enquiry = enquiries[index];
                return Container(
                  width: 260,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey[50]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enquiry['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimens().front_small,
                          color: AppColor().colorPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        enquiry['topic'] ?? '',
                        style: TextStyle(
                          fontSize: AppDimens().front_small,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        enquiry['time'] ?? '',
                        style: TextStyle(
                          fontSize: AppDimens().front_small - 2,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // custom review

  Widget _customerReviewsSection() {
    final List<Map<String, String>> reviews = [
      {
        'name': 'Aarav Sharma',
        'review':
            'Great service! Delivery was quick and packaging was neat. 😍',
        'ratings': '⭐⭐⭐⭐⭐'
      },
      {
        'name': 'Meera Patel',
        'review': 'Loved the product quality. Will definitely order again! 🥰',
        'ratings': '⭐⭐⭐⭐⭐'
      },
      {
        'name': 'Rohan Verma',
        'review': 'Customer support was responsive and helpful. ❤️',
        'ratings': '⭐⭐⭐⭐'
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red[50]!,
            Colors.green[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Customer Reviews ',
                  style: TextStyle(
                    fontSize: AppDimens().front_medium,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica",
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.amber[700],
                  size: AppDimens().front_medium,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reviews.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  width: 260,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.orange[50]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.orange[100]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and rating in row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              review['name'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDimens().front_small,
                                color: AppColor().colorPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            review['ratings'] ?? '',
                            style: TextStyle(
                              fontSize: AppDimens().front_small,
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Review text
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[200]!,
                            ),
                          ),
                          child: Text(
                            review['review'] ?? '',
                            style: TextStyle(
                              fontSize: AppDimens().front_small,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Decorative element
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Member ship card section

  Widget _membershipCardsSection() {
    final List<Map<String, String>> memberships = [
      {
        'title': 'Silver Member',
        'benefits': 'Free delivery on orders above ₹499\nPriority support',
        'price': '\$4.99/month',
      },
      {
        'title': 'Gold Member',
        'benefits':
            'Free delivery on all orders\nExclusive discounts\nPriority support',
        'price': '\$9.99/month',
      },
      {
        'title': 'Platinum Member',
        'benefits':
            'All Gold benefits\nEarly access to sales\nDedicated concierge',
        'price': '\$19.99/month',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Membership Cards 🎟️',
            style: TextStyle(
              fontSize: AppDimens().front_medium,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: memberships.length,
            itemBuilder: (context, index) {
              final card = memberships[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor().colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor().colorPrimary, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card['title'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimens().front_small,
                        color: AppColor().colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card['benefits'] ?? '',
                      style: TextStyle(
                        fontSize: AppDimens().front_small,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      card['price'] ?? '',
                      style: TextStyle(
                        fontSize: AppDimens().front_small,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 🦶 Bottom Navigation Bar Widget
 
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.to(() => StoreTypeSearch()),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          enabled: false,
          keyboardType: TextInputType.text,
          controller: controller.searchController,
          style: TextStyle(color: AppColor().blackColor),
          decoration: InputDecoration(
            hintText: "Search by Services...",
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: AppDimens().front_regular,
            ),
            prefixIcon: Icon(Icons.search, color: AppColor().colorPrimary),
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 2),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.filter_list_sharp,
                color: AppColor().whiteColor,
                size: 24,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor().colorPrimary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor().colorPrimary),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // 🏪 Business Category
Widget _buildBusinessCategory() {
  return Obx(
    () => Container(
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor().colorPrimary.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("All Categories", () {
            Get.to(() => StoreTypeScreen());
          }),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.black26,
          ),
          const SizedBox(height: 14),

          /// 👉 Changed ListView to GridView
          SizedBox(
  height: 300, // adjust as needed
  child: GridView.builder(
    physics: const BouncingScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 3 columns
      crossAxisSpacing: 0, // 👉 no horizontal gap
      mainAxisSpacing: 0,  // 👉 no vertical gap
      childAspectRatio: 1,
    ),
    itemCount: controller.BusinessCategory.length,
    itemBuilder: (context, index) {
      final item = controller.BusinessCategory[index];
      return GestureDetector(
        onTap: () {
          controller.selectedBusinessCategory.value = item;
          Get.to(() => StoreTypeScreen());
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                imageUrl: item.photos![0].path.toString(),
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image, size: 50),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: AppDimens().front_12,
                fontWeight: FontWeight.w600,
                fontFamily: "Helvetica",
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    },
  ),
)
        ],
      ),
    ),
  );
}
  // 🖼 Banner Carousel
  Widget _buildBanner() {
    return Container(
      child: Obx(() => _buildCarousel(homePageController)),
    );
  }

  // 🏥 Healthcare Section
  Widget _buildHealthCare() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor().colorPrimary.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Healthcare", () {
              // 👉 Handle "Show more" tap here
              Get.to(() => StoreTypeScreen());
            }),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black26, // You can change this to match your theme
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.hospitalList.length,
                itemBuilder: (context, index) {
                  final item = controller.hospitalList[index];
                  return GestureDetector(
                    onTap: () {
                      controller.selectedBusinessCategory.value = item;
                      Get.to(() => StoreTypeScreen());
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor().colorPrimary, width: 1.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: CachedNetworkImage(
                                imageUrl: item.photos![0].path.toString(),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.name ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: AppDimens().front_12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Helvetica",
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🏷 Section Title Widget
  Widget _sectionTitle(String title, [VoidCallback? onShowMoreTapped]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppDimens().front_medium,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Colors.black87,
            ),
          ),
          if (onShowMoreTapped != null)
            GestureDetector(
              onTap: onShowMoreTapped,
              child: Text(
                'Show more',
                style: TextStyle(
                  fontSize: AppDimens().front_small,
                  fontWeight: FontWeight.w500,
                  color: AppColor().colorPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

// widget for banner
  Widget _sectionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 2.7, // Adjust based on your banner's shape
            child: Image.asset(
              ImageRes().bannerImage2,
              fit: BoxFit.cover, // Ensures full coverage without cutting
            ),
          ),
        ),
      ),
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
    return CarouselSlider(
      items: controller.bannerList.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor().colorPrimary.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: item.path ?? '',
              errorWidget: (context, url, error) =>
                  Image.asset(ImageRes().bannerImage2),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 160.0,
        autoPlay: true,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }


  // these function logic foor fast screen 
  
  Future<void> _refreshHomeScreen() async {
  print("🔄 Refreshing Home Screen...");

  await userProfileController.getUserDetails();
  await _determinePosition(); // important

  await controller.getStoreOfferApi();   // ADD THIS
  await controller.getStoreVideoApi();   // ADD THIS
  await controller.getHomePharmacyList();

  await homePageController.getBannerList();
  await addressController.getAddreessListing();

  print("✅ Home Screen Refreshed!");
}


}
