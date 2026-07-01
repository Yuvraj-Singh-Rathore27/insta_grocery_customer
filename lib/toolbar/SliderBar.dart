import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:insta_grocery_customer/controller/user_profile_controller.dart';
import 'package:insta_grocery_customer/controller/vender_controller.dart';

import '../preferences/UserPreferences.dart';
import '../res/AppColor.dart';
import '../screen/login/login_screen.dart';
import '../screen/side_menu/cms_page/cms_page.dart';
import '../screen/side_menu/feedback/feedback_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenuBar extends StatelessWidget {
  SideMenuBar({super.key});

  final UserProfileController controller = Get.put(UserProfileController());

  UserPreferences? userPreferences;

  @override
  Widget build(BuildContext context) {
    userPreferences = UserPreferences(context);

    Get.put(PharmacyController());

    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              /// ================= HEADER =================
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor().colorPrimary,
                        AppColor().colorPrimary.withOpacity(0.82),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor().colorPrimary.withOpacity(0.20),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// LEFT ICON
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.dashboard_customize_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Obx(
                              () => Text(
                                controller.userData.value.data?.userProfile
                                        ?.firstName ??
                                    "Guest User",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        controller.userData.value.data
                                                ?.contactNumber ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// RIGHT BUTTON
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              /// ================= MENU =================
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    /// HOME
                    buildMenuTile(
                      icon: Icons.home_rounded,
                      title: "Home",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    /// PRIVACY
                    buildMenuTile(
                      icon: Icons.privacy_tip_rounded,
                      title: "Privacy & Policy",
                      onTap: () {
                        Navigator.pop(context);

                        Get.to(
                          () => CmsPage(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 350),
                        );
                      },
                    ),

                    /// FEEDBACK
                    buildMenuTile(
                      icon: Icons.feedback_rounded,
                      title: "Feedback",
                      onTap: () {
                        Navigator.pop(context);

                        Get.to(
                          () => const FeedbackScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 350),
                        );
                      },
                    ),

                    /// DELETE ACCOUNT
                    buildMenuTile(
                      icon: Icons.delete_forever_rounded,
                      title: "Delete Account",
                      iconColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        showDeleteAccount(context);
                      },
                    ),
                    buildMenuTile1(
                      icon: Icons.emergency,
                      title: "SOS",
                      onTap: () {
                        Navigator.pop(context);

                        Future.delayed(
                          const Duration(milliseconds: 200),
                          () => showSOSDialog(context),
                        );
                      },
                    ),

                    /// LOGOUT
                    buildMenuTile(
                      icon: Icons.logout_rounded,
                      title: "Logout",
                      
                      iconColor: Colors.red,
                      onTap: () {
                        showAlertDialog(context);
                      },
                    ),

                    const SizedBox(height: 30),

                    /// VERSION
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor().colorPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Version 1.0.1",
                          style: TextStyle(
                            color: AppColor().colorPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= MENU TILE =================
  Widget buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 350),
        tween: Tween<double>(begin: 0.9, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          elevation: 3,
          shadowColor: Colors.black12,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            splashColor: AppColor().colorPrimary.withOpacity(0.15),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                children: [
                  /// ICON BOX
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColor().colorPrimary)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColor().colorPrimary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// TITLE
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// ARROW
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuTile1({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 350),
        tween: Tween<double>(begin: 0.9, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          elevation: 3,
          shadowColor: Colors.black12,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            splashColor: AppColor().colorPrimary.withOpacity(0.15),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                children: [
                  /// ICON BOX
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColor().colorPrimary)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColor().colorPrimary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// TITLE
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= LOGOUT DIALOG =================
  void showAlertDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
        ),
        actions: [
          /// CANCEL
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColor().colorPrimary,
              ),
            ),
          ),

          /// LOGOUT
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor().colorPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              await preferences.remove('token');
              await preferences.remove('user_id');
              await preferences.clear();

              userPreferences?.removeValues();

              final store = GetStorage();
              store.erase();

              Get.offAll(
                () => LoginScreen(),
                transition: Transition.fadeIn,
              );
            },
            child:  Text("Logout",style: TextStyle(color: AppColor().whiteColor),),
          ),
        ],
      ),
    );
  }

  /// ================= DELETE ACCOUNT =================
  void showDeleteAccount(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          "Delete Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to delete account?",
        ),
        actions: [
          /// CANCEL
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColor().colorPrimary,
              ),
            ),
          ),

          /// DELETE
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              controller.deleteAccount();

              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              await preferences.remove('token');
              await preferences.remove('user_id');
              await preferences.clear();

              userPreferences?.removeValues();

              final store = GetStorage();
              store.erase();

              Get.offAll(
                () => LoginScreen(),
                transition: Transition.fadeIn,
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

void showSOSDialog(BuildContext context) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.emergency,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Text("Emergency SOS"),
        ],
      ),
      content: const Text(
        "Are you sure you want to call Emergency Services (100)?",
      ),
      actions: [
        /// Cancel
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),

        /// Call
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          icon: const Icon(Icons.call,color: Colors.white,),
          label: const Text("Call 100",style: TextStyle(color: Colors.white),),
          onPressed: () async {
            Get.back();

            final Uri phoneUri = Uri(
              scheme: 'tel',
              path: '100',
            );

            if (await canLaunchUrl(phoneUri)) {
              await launchUrl(phoneUri);
            }
          },
        ),
      ],
    ),
  );
}
