import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/utills/Utils.dart';
import 'package:insta_grocery_customer/utills/constant.dart';
import 'package:insta_grocery_customer/webservices/ApiUrl.dart';
import '../../../../controller/vender_controller.dart';
import '../../../../model/pharmacy_model.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppDimens.dart';
import '../../../../res/ImageRes.dart';
import '../../place_order/order_on_phone_call.dart';
import '../main_category/main_category.dart';
import '../product_listing/product_listing_sub_category.dart';
import '../store_details.dart';
import '../vender_map_direction.dart';

class VenderItem extends StatelessWidget {
  final PharmacyController controller = Get.put(PharmacyController());
  final PharmayModel data;

  VenderItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOpen = checkIfOpen(data.startTime, data.endTime);
    var startTime = convertTo12HourFormat(data.startTime.toString());
    var endTime = convertTo12HourFormat(data.endTime.toString());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Top Image Banner + Open Now Badge
          GestureDetector(
            onTap: () {
              controller.selectedPharmacy.value = data;
              Get.to(() => StoreDetailsPage());
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors
                        .grey.shade100, // subtle background while image loads
                    child: (data.profile_photo == null ||
                            data.profile_photo!.isEmpty)
                        ? Image.asset(
                            ImageRes().logoGrocery,
                            fit: BoxFit.cover, // ensures full logo visibility
                          )
                        : Image.network(
                            data.profile_photo!,
                            fit: BoxFit.cover, // fills container cleanly
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              ImageRes().logoGrocery,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOpen ? "Open Now" : "Closed",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: GestureDetector(
                    onTap: () {
                      controller.addFavoritesPharmacy(data.id.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        ImageRes().sideMenuMyFavorites,
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🏥 Vendor Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        data.name ?? '',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColor().blackColor,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Prevent text overflow
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$startTime - $endTime",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 📞 Buttons Row (varies by category)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: controller.selectedVenderCategory.value.name ==
                    "Grocery stores"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton(
                        icon: Icons.call,
                        label: 'Call',
                        color: Colors.green,
                        onTap: () {
                          controller.createLog(data.id, ApiUrl.EVENT_CALL);
                          Utils()
                              .launchCallerApp(data.contactNumber.toString());
                        },
                      ),
                      _actionButton(
                        icon: Icons.directions,
                        label: 'Direction',
                        color: Colors.blue,
                        onTap: () {
                          controller.createLog(data.id, ApiUrl.EVENT_DIRECTION);
                          Get.to(() => VenderMapDirection(
                                latitude:
                                    double.parse(data.latitude.toString()),
                                longitude:
                                    double.parse(data.longitude.toString()),
                              ));
                        },
                      ),
                      _actionButton(
                        icon: Icons.upload_rounded,
                        label: 'Uploads',
                        color: Colors.orange,
                        onTap: () {
                          controller.selectedPharmacy.value = data;
                          Get.to(() => OrderOnPhoneCall());
                        },
                      ),
                      _actionButton(
                        icon: Icons.shopping_bag,
                        label: 'Products',
                        color: AppColor().colorPrimary,
                        onTap: () {
                          controller.selectedPharmacy.value = data;
                          controller.getMainCatgory().then(
                              (value) => showGridDialog(controller, context));
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton(
                        icon: Icons.call,
                        label: 'Call',
                        color: Colors.green,
                        onTap: () {
                          controller.createLog(data.id, ApiUrl.EVENT_CALL);
                          Utils()
                              .launchCallerApp(data.contactNumber.toString());
                        },
                      ),
                      _actionButton(
                        icon: Icons.directions,
                        label: 'Direction',
                        color: Colors.blue,
                        onTap: () {
                          controller.createLog(data.id, ApiUrl.EVENT_DIRECTION);
                          Get.to(() => VenderMapDirection(
                                latitude:
                                    double.parse(data.latitude.toString()),
                                longitude:
                                    double.parse(data.longitude.toString()),
                              ));
                        },
                      ),
                      _actionButton(
                        icon: Icons.more_horiz,
                        label: 'View more',
                        color: AppColor().colorPrimary,
                        onTap: () {
                          controller.selectedPharmacy.value = data;
                          Get.to(() => StoreDetailsPage());
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkIfOpen(String? start, String? end) {
    // Temporary mock logic
    return true;
  }
}

// -----------------------------------------------------------------------------
// Bottom Sheet Category Selector (unchanged from your version)
// -----------------------------------------------------------------------------
void showGridDialog(PharmacyController controller, BuildContext context) {
  controller.getMainCatgory();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 500,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.1,
                children: controller.categoryList.map((item) {
                  return GestureDetector(
                    onTap: () {
                      controller.selectedCategory.value = item;
                      Navigator.pop(context);
                      Get.to(() => ProductListingSubCategory());
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(
                              children: [
                                Image.network(
                                  item.logo.toString() +
                                      "?v=${DateTime.now().millisecondsSinceEpoch}",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fill,
                                  headers: {'Cache-Control': 'no-cache'},
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
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

String convertTo12HourFormat(String time) {
  try {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String minutes = parts[1];
    String seconds = parts.length > 2 ? parts[2] : "00";

    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '${hour.toString().padLeft(2, '0')}:$minutes:$seconds $period';
  } catch (e) {
    return time;
  }
}
