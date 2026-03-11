import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/ImageRes.dart';
import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/product_listing/product_listing_sub_category.dart';
import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/store_video.dart';
import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/store_offer.dart';

import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/vender_map_direction.dart';
import 'package:insta_grocery_customer/toolbar/TopBar.dart';

import '../../../controller/vender_controller.dart';
import '../../../model/DoctorListModel.dart';
import '../../../model/pharmacy_model.dart';
import '../../../res/AppColor.dart';
import '../../../utills/Utils.dart';
import '../../../webservices/ApiUrl.dart';
import 'EquirySucess.dart';

class StoreDetailsPage extends StatefulWidget {
  const StoreDetailsPage({super.key});

  @override
  State<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
 final PharmacyController controller = Get.find();
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor().colorGrayLess2,
      appBar: TopBar(
          title: '',
          menuicon: false,
          menuback: true,
          iconnotifiction: true,
          is_wallaticon: true,
          is_supporticon: false,
          is_whatsappicon: false,
          onPressed: () => {},
          onTitleTapped: () => {}),
      body: SingleChildScrollView(
        child: Column(
          children: [
            

            // Title and Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo/Image at top
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: (controller.selectedPharmacy.value.photos == null ||
                    controller.selectedPharmacy.value.photos!.isEmpty)
                ? Image.asset(
                    ImageRes().bannerImage1,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                :
                // Banner Image
                //    Image.network(controller.selectedPharmacy.value.photos!.last.path!,// Replace with your asset path
                //   width: double.infinity,
                //   height: 200,
                //   fit: BoxFit.cover,
                // ),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor().homeBannerBg),
                    child: Obx(() => Banner(controller)),
                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Clinic Name

                      Text(
                        controller.selectedPharmacy.value.name.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8),

                      // Rating and Status Row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  "4.8",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "(256 reviews)",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 80),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Open Now",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Services Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          _serviceTag("Dentistry"),
                          _serviceTag("Implants"),
                          _serviceTag("Whitening"),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Location
                      // Row(
                      //   children: [
                      //     Icon(Icons.location_on_outlined,
                      //         size: 18, color: Colors.grey[600]),
                      //     SizedBox(width: 6),
                      //     Text(
                      //        controller.selectedPharmacy.value.fullAddress?.address??"",
                      //       style: TextStyle(
                      //         color: Colors.grey[600],
                      //         fontSize: 14,
                      //       ),
                      //       maxLines: 2,
                      //     ),
                      //   ],
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined,size: 18,color: Colors.grey,),
                          const SizedBox(width: 6,),
                          Expanded(child: Text(
                            controller.selectedPharmacy.value.fullAddress?.address??"",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,

                          ))
                        ],
                      ),

                      SizedBox(height: 15),
                Row(
  children: [
   
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Obx(() {
            final distance = controller.selectedPharmacy.value.distance;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary, // subtle background
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                distance == null
                    ? "Calculating..."
                    : "${distance.toStringAsFixed(2)} km away",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600, // bold for emphasis
                  color:  Colors.white
                ),
              ),
            );
          }),
        ],
      ),
    ),
  ],
),
const SizedBox(height: 15),


                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _actionButton(Icons.info_outline, "About Us",
                                onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StoreDetailsDialog();
                                },
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _actionButton(Icons.call, "Call", onTap: () {
                              Utils().launchCallerApp(
                                controller.selectedPharmacy.value.contactNumber
                                    .toString(),
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _actionButton(Icons.directions, "Directions",
                                onTap: () {
                              controller.createLog(
                                controller.selectedPharmacy.value.id,
                                ApiUrl.EVENT_DIRECTION,
                              );
                              Get.to(() => VenderMapDirection(
                                    latitude: double.parse(
                                      controller.selectedPharmacy.value.latitude
                                          .toString(),
                                    ),
                                    longitude: double.parse(
                                      controller
                                          .selectedPharmacy.value.longitude
                                          .toString(),
                                    ),
                                  ));
                            }),
                          ),
                          const SizedBox(width: 8),
                          

                          Expanded(
                            child: _actionButton(Icons.shopping_cart, "Products", onTap:   () {
                                controller.selectedPharmacy.value =
                                    controller.selectedPharmacy.value;
                                controller.getMainCatgory().then(
                                      (value) =>
                                          showGridDialog(controller, context),
                                    );
                              },),
                              
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

// Helper widget for service tags

        const   Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Quick info",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // First row of buttons
                    Row(
                      children: [
                        Expanded(
                          child: _enquiryButton(
                            icon: Icons.info_outline,
                            text: "About Us",
                            color: Colors.blue,
                            onTap: () {
                              // Add book appointment functionality
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _enquiryButton(
                            icon: Icons.phone,
                            text: "Call",
                            color: Colors.green,
                            onTap: () {
                              Utils().launchCallerApp(
                                controller.selectedPharmacy.value.contactNumber
                                    .toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Second row of buttons
                    Row(
                      children: [
                        Expanded(
                          child: _enquiryButton(
                            icon: Icons.schedule,
                            text: "Check Direction",
                            color: Colors.orange,
                            onTap: () {
                              // Add check availability functionality
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _enquiryButton(
                            icon: Icons.request_quote,
                            text: "View Products",
                            color: Colors.purple,
                          onTap: () async {
  await controller.getMainCatgory();   // Load categories first

  if (controller.categoryList.isEmpty) {
    Utils.showCustomTosst("No categories available");
     Get.to(ProductListingSubCategory());
  }

  controller.selectedCategory.value = controller.categoryList.first;

  Get.to(() => ProductListingSubCategory());
  print("CATEGORY LIST SIZE = ${controller.categoryList.length}");
},

                          ),
                        ),
                        
                        
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                         Expanded(
                          child: _enquiryButton(
                            icon: Icons.video_call,
                            text: "View Videos",
                            color: AppColor().colorPrimary,
                            onTap: () {
                             Get.to(const MyStoreVideosScreen());
                              
                            },
                          ),
                        ),
                        const SizedBox(width: 8,),

                        Expanded(
                          child: _enquiryButton(
                            icon: Icons.local_offer,
                            text: "View Offer",
                            color: Colors.teal,
                            onTap: () {
                             Get.to( StoreOfferScreen(
                               storeId: controller.selectedPharmacy.value.id!,
                             ));
                              
                            },
                          ),
                        ),
                        


                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(),

            // Services Offered
            // Services Offered Section
            Container(
              margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Enquiries",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() => SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.servicesList.length,
                          itemBuilder: (context, index) {
                            final item = controller.servicesList[index];

                            return GestureDetector(
                              onTap: () {
                                controller.selectedServices.value = item;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PatientFormDialog();
                                  },
                                );
                              },
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Service Icon/Image
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Image.network(
                                          (item.logo!=null&&item.logo!.isNotEmpty)?(item.logo!.first.path??""):"",
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.medical_services,
                                              color: Colors.blue,
                                              size: 30,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    // Service Name
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        item.name ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                          fontFamily: "Helvetica",
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
            Obx(() => controller.doctorList.length > 0
                ? Column(children: [
                    Divider(),

                    // Horizontal Doctor Listing
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Available Doctors',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 160, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.doctorList.length,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemBuilder: (context, index) {
                          var doctor = controller.doctorList[index];
                          return _buildDoctorCard(doctor);
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(),
                  ])
                : Container()),

            // // Review
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold)),
            //       ListTile(
            //         contentPadding: EdgeInsets.zero,
            //         leading: CircleAvatar(
            //           backgroundImage: AssetImage('assets/user.png'), // Replace with user photo
            //         ),
            //         title: Text("John Doe"),
            //         subtitle: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text("March 10, 2024", style: TextStyle(fontSize: 12)),
            //             SizedBox(height: 4),
            //             Row(
            //               children: List.generate(5, (index) => Icon(Icons.star, color: Colors.amber, size: 18)),
            //             ),
            //             SizedBox(height: 6),
            //             Text("Excellent service and a friendly staff! The test drive experience was smooth."),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Save/Share
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: // Add this after your Quick Enquiries section

// Exclusive Offers Section
                  Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Exclusive Offers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),

                    // 15% Off Offer
                    _offerCard(
                      title: "15% Off on Dental Whitening",
                      subtitle: "Valid until Dec 31, 2024",
                      icon: Icons.local_offer,
                      color: Colors.orange,
                      buttonText: "Claim Now",
                      onTap: () {
                        // Add claim functionality
                      },
                    ),

                    SizedBox(height: 12),

                    // Free Consultation Offer
                    _offerCard(
                      title: "Free Consultation for New Patients",
                      subtitle: "First visit completely free",
                      icon: Icons.medical_services,
                      color: Colors.green,
                      buttonText: "Book Now",
                      onTap: () {
                        // Add book now functionality
                      },
                    ),

                    SizedBox(height: 12),

                    // Health+ Membership Offer
                    _offerCard(
                      title: "Join Frebbo Health+ for Priority",
                      subtitle: "Premium membership benefits",
                      icon: Icons.workspace_premium,
                      color: Colors.purple,
                      buttonText: "Join Now",
                      onTap: () {
                        // Add join now functionality
                      },
                    ),
                  ],
                ),
              ),

// Add this helper widget for offer cards
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border),
                      label: Text("Save")),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.share),
                      label: Text("Share")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Container(
            height: 32,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _enquiryButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue[700],
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _quickButton({
    required String icon,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon,
              height: 25,
              width: 25,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for service tags

// Updated _actionButton method with improved styling
  Widget _actionButton(IconData icon, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.blue[700]),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getServicesListApi();
      controller.getDoctorsListUrl();
      controller.createLog(
          controller.selectedPharmacy.value.id, ApiUrl.EVENT_DETAILS_VIEW);
    });
    controller.calculateDistanceForSelectedPharmacy();
  }

  void showGridDialog(PharmacyController controller, BuildContext context) {
    controller.getMainCatgory();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Category',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.pop(context), // Close the bottom sheet
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Scrollable GridView
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio:
                      1 / 1.4, // Adjust ratio based on your design
                  children: controller.categoryList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectedCategory.value = item;
                        Navigator.pop(context); // Close the bottom sheet
                        Get.to(() => ProductListingSubCategory());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          item.logo.toString() +
                                              "?v=${DateTime.now().millisecondsSinceEpoch}",
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.fill,
                                          headers: {
                                            'Cache-Control': 'no-cache'
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        color: Colors.black.withOpacity(0.5),
                                        child: Text(
                                          item.name ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Helvetica",
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget Banner(PharmacyController controller) {
    if (controller.selectedPharmacy.value.profile_photo != "") {
      Photos photos = new Photos();
      photos.path = controller.selectedPharmacy.value.profile_photo;
      controller.selectedPharmacy.value.photos?.add(photos);
    }
    return Padding(
      padding: const EdgeInsets.all(0),
      child: CarouselSlider(
        items: controller.selectedPharmacy.value.photos
            ?.map(
              (item) => InkWell(
                onTap: () async {},
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        // child: Image(
                        //     width: width,
                        //     fit: BoxFit.fill,
                        //     image: AssetImage(ImageRes().bannerImage2)),
                        child: CachedNetworkImage(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          imageUrl: item.path ?? '',
                          errorWidget: (context, url, error) => Image(
                              width: width,
                              fit: BoxFit.fill,
                              image: AssetImage(ImageRes().bannerImage2)),
                        )),
                  ),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          disableCenter: true,
          viewportFraction: .9,
          aspectRatio: 3,
          enlargeCenterPage: false,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          onPageChanged: (index, reason) {
            // controller.currentIndexSlider.value = index;
          },
        ),
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModelList doctor) {
    return GestureDetector(
      onTap: () => _showVisibilityDialog(doctor, true),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile + Name + Availability
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: doctor.profilePhoto!.isNotEmpty
                          ? NetworkImage(doctor.profilePhoto!.first)
                          : null,
                      backgroundColor: Colors.blue.shade50,
                      child: doctor.profilePhoto!.isEmpty
                          ? Icon(Icons.person,
                              size: 24, color: Colors.blue.shade400)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name ?? 'Unknown Doctor',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialities != null &&
                                doctor.specialities!.isNotEmpty
                            ? doctor.specialities!
                                .map((e) => e
                                    .name) // Ensure 'name' exists in your model
                                .join(', ')
                            : '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Working Hours

            const SizedBox(height: 10),

            // Languages
            if (doctor.languages != null && doctor.languages!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Languages: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                      doctor.languages!.join(', '),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 8),

            // Fee
            Row(
              children: [
                const Text(
                  'Fee: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '₹ ${doctor.fees}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),

            // Book Consultation Button
          ],
        ),
      ),
    );
  }

//  here is Doctor Detail Dialog Box visinlity  box

  void _showVisibilityDialog(DoctorModelList doctor, bool newVisibility) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===== Header =====
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Doctor Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: AppColor().colorPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== Profile Section =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue.shade100,
                          Colors.purple.shade100
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Photo with Verified Badge
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: doctor.profilePhoto!.isNotEmpty
                                  ? NetworkImage(doctor.profilePhoto!.first)
                                  : null,
                              backgroundColor: Colors.grey.shade200,
                              child: doctor.profilePhoto!.isEmpty
                                  ? Icon(Icons.person,
                                      size: 35, color: Colors.grey.shade600)
                                  : null,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.check,
                                  size: 14, color: Colors.white),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Name
                        Text(
                          doctor.name.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Speciality
                        Text(
                          doctor.specialities != null &&
                                  doctor.specialities!.isNotEmpty
                              ? doctor.specialities!
                                  .map((e) => e
                                      .name) // Ensure 'name' exists in your model
                                  .join(', ')
                              : '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Qualifications
                        if (doctor.qualification!.isNotEmpty)
                          Text(
                            doctor.qualification.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Registration Number
                        if (doctor.registrationNumber != null &&
                            doctor.registrationNumber!.isNotEmpty)
                          Text(
                            "Reg. No: ${doctor.registrationNumber}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),

                        const SizedBox(height: 12),

                        // Languages
                        if (doctor.languages!.isNotEmpty)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: doctor.languages!
                                .map((language) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.language,
                                              size: 14,
                                              color: Colors.grey.shade700),
                                          const SizedBox(width: 4),
                                          Text(
                                            language,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(
                    height: 1,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),

                  // ===== Details in Simple List Format =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Experience
                        _buildSimpleDetailRow(
                          icon: Icons.work,
                          iconColor: Colors.green,
                          title: "Experience",
                          value: "${doctor.experienceYears ?? ''} Years",
                        ),

                        const SizedBox(height: 12),

                        // Special Interest
                        if (doctor.areasOfExpertise != null &&
                            doctor.areasOfExpertise!.isNotEmpty)
                          _buildSimpleDetailRow(
                            icon: Icons.favorite,
                            iconColor: Colors.red,
                            title: "Special Interest",
                            value: doctor.areasOfExpertise != null &&
                                    doctor.areasOfExpertise is List
                                ? (doctor.areasOfExpertise as List).join(', ')
                                : doctor.areasOfExpertise?.toString() ?? '',
                          ),

                        const SizedBox(height: 12),

                        // Awards
                        if (doctor.awards != null && doctor.awards!.isNotEmpty)
                          _buildSimpleDetailRow(
                            icon: Icons.star,
                            iconColor: Colors.yellow,
                            title: "Awards & Recognition",
                            value: doctor.awards!.join(', '),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Colors.red),
                  const SizedBox(height: 16),

                  // ===== About Section =====
                  if (doctor.description != null &&
                      doctor.description!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "About ${doctor.name.toString()}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doctor.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ===== Consultation Details =====
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.red,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Consultation Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Consultation Fee
                        _buildConsultationDetailItem(
                          iconColor: Colors.green,
                          icon: Icons.currency_rupee,
                          title: "Consultation Fee",
                          value: "₹${doctor.fees ?? ''}",
                        ),

                        const SizedBox(height: 8),

                        // Available Hours
                        if (doctor.availabilityTime != null &&
                            doctor.availabilityTime!.isNotEmpty)
                          Column(
                            children: [
                              _buildConsultationDetailItem(
                                iconColor: Colors.red,
                                icon: Icons.access_time,
                                title: "Available Hours",
                                value: doctor.availabilityTime!
                                    .map((e) => e.toString())
                                    .join('\n'),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),

                        // Weekly Holiday
                        _buildConsultationDetailItem(
                          iconColor: Colors.blue,

                          icon: Icons.calendar_today,
                          title: "Weekly Holiday",
                          value: "Sunday", // You can make this dynamic
                        ),

                        const SizedBox(height: 8),

                        // Consultation Mode
                        _buildConsultationDetailItem(
                          iconColor: Colors.black,

                          icon: Icons.video_call,
                          title: "Consultation Mode",
                          value: "In-person", // You can make this dynamic
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== Awards & Recognitions Section =====
                  if (doctor.awards!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Awards & Recognitions",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: doctor.awards!
                                .map((award) => Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo
                                            .shade50, // You can customize per award
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.emoji_events,
                                              size: 18,
                                              color: Colors.deepPurple),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              award,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // ===== Close Button =====
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade700!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Helper widget for simple detail rows (like in the first image)
  Widget _buildSimpleDetailRow({
    required String title,
    required String value,
    IconData? icon,
    Color? iconColor, // Optional icon color
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              icon,
              size: 18,
              color: iconColor ?? Colors.grey.shade700,
            ),
          ),
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

// Helper widget for consultation detail items
  Widget _buildConsultationDetailItem({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = Colors.blueGrey, // Default color, but can be overridden
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
// ---------------------------------->>>>>>>>>>>>>>>

// --- Helper for Availability (Enhancement: Layout and Contrast) ---
  Widget _buildAvailabilityCard(List<AvailabilityTime>? availabilityTime) {
    if (availabilityTime?.length == 0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16), // Increased padding
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        // Removed the border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Used a deeper blue for the icon

              const SizedBox(width: 16),
              const Text(
                "⏰ Availability",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E2749),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Increased spacing
          Column(
            children: [
              for (int index = 0; index < availabilityTime!.length; index++)
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8), // More vertical padding
                  decoration: BoxDecoration(
                    // Lighter divider for cleaner look
                    border: index < availabilityTime!.length - 1
                        ? const Border(
                            bottom: BorderSide(
                                color: Color(0xFFE0E0E0), width: 1.0))
                        : null,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 38), // Adjusted alignment
                      Expanded(
                        child: Text(
                          "${availabilityTime?[index].to} - ${availabilityTime?[index].from}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  //  Doctor Detail Dialog box

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Gallery"),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.getFromGallery(false);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("Camera"),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.getFromGallery(true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailRow(BuildContext context, String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    // This will be called by the controller after successful submission
    // No need to call it manually here
  }
}

class StoreDetailsDialog extends StatelessWidget {
  final PharmacyController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor().colorPrimary,
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // About Us content with icon
            _buildAboutUsSection(
                controller.selectedPharmacy.value.description ?? ''),
            SizedBox(height: 20.0),

            // Business Hours with icon
            _buildInfoRow(Icons.access_time, 'Business Hours',
                'Opens: ${controller.selectedPharmacy.value.openTime ?? ''} – Closes: ${controller.selectedPharmacy.value.closeTime ?? ''}'),
            SizedBox(height: 12.0),
            // // Holidays with icon
            // _buildInfoRow(Icons.event_busy, 'Holidays', 'Sunday'),
            // SizedBox(height: 12.0),

            // GST Number with icon
            _buildInfoRow(Icons.receipt, 'GST Number',
                controller.selectedPharmacy.value.gstNumber ?? ''),
            SizedBox(height: 12.0),

            // Address with icon
            _buildInfoRow(Icons.location_on, 'Address',
                controller.selectedPharmacy.value.fullAddress?.address ?? ''),
            SizedBox(height: 20.0),

            // Close Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutUsSection(String aboutus) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.medical_information_outlined,
          color: AppColor().colorPrimary,
          size: 20.0,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            aboutus ?? '',
            style: TextStyle(
              fontSize: 14.0,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColor().colorPrimary,
          size: 20.0,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor().colorPrimary,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PatientFormDialog extends StatelessWidget {
  final PharmacyController controller = Get.find();   // FIXED

  PatientFormDialog({Key? key}) : super(key: key);

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Image Source",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CAMERA
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      controller.getFromGallery(true);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Icon(Icons.camera_alt,
                              color: Colors.blue, size: 28),
                        ),
                        SizedBox(height: 8),
                        Text("Camera"),
                      ],
                    ),
                  ),

                  // GALLERY
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      controller.getFromGallery(false);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green.withOpacity(0.1),
                          child: Icon(Icons.photo_library,
                              color: Colors.green, size: 28),
                        ),
                        SizedBox(height: 8),
                        Text("Gallery"),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Inquiry details',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(height: 20),

            // NAME FIELD
            Text("Name", style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: _buildField(
                controller.vehiclenameController,
                "Enter Name",
              ),
            ),

            SizedBox(height: 16),

            // DESCRIPTION FIELD
            Text("Description", style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: _buildField(
                controller.descriptionController,
                "Enter Description",
                maxLines: 4,
              ),
            ),

            SizedBox(height: 20),

            // IMAGE UPLOAD
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Upload Image",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 10),

                GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: controller.fileList.isNotEmpty
                        ? Stack(
                            children: [
                              ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox.expand(
              child: Image.network(
                ApiUrl.apiUrl + controller.fileList[0].path.toString(),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stack) =>
                    Center(child: Icon(Icons.upload_file, size: 40)),
              ),
            ),
          ),
                              // REMOVE BUTTON
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.fileList.clear();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.grey.shade600),
                                SizedBox(height: 8),
                                Text("Tap to upload image",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            )),

            SizedBox(height: 20),

            // BUTTON ROW
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool ok = await controller.addIntrestedServicesByUser();
                      if (ok) showCustomSucessDialog(context);
                    },
                    child: Text("Submit"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}

void showCustomSucessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must tap a button to close
    builder: (BuildContext context) {
      return SuccessDialog(
        referenceNumber: '12344',
        onGoHome: () {
          // Navigate to the home screen
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
        onViewEnquiries: () {
          // Navigate to the enquiries list screen
          Navigator.of(context).pushNamed('/my-enquiries');
        },
      );
    },
  );

 

}
