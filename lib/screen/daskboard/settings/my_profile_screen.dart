import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/user_profile_controller.dart';
import '../../../res/AppColor.dart';
import '../../../toolbar/app_bottom_bar.dart';
import '../../../utills/Utils.dart';
import '../../address_managment/address_listing.dart';
import '../../change_password/chage_password_screen.dart';
import '../../login/login_screen.dart';
import '../../side_menu/cms_page/cms_page.dart';
import '../../side_menu/notifiction/my_notifiction.dart';
import '../../side_menu/supports/my_support_page.dart';
import '../orders/my_orders_screen.dart';

/// Profile tab of [AppBottomBar]: the logged-in user's details plus shortcuts
/// to the account screens that already exist in the app.
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final UserProfileController controller = Get.put(UserProfileController());

  // Everything on this screen is tinted from the app's primary red so the
  // gradient, glows and icon chips stay in one family.
  final Color _primary = AppColor().colorPrimary;

  /// Page gutter — tighter on small phones.
  double get _hPad => MediaQuery.of(context).size.width < 360 ? 14 : 18;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              _primary.withOpacity(0.14),
              const Color(0xFFFFF6F5),
              AppColor().whiteColor,
            ],
            stops: const [0.0, 0.35, 0.75],
          ),
        ),
        child: Stack(
          children: [
            // Soft glow behind the header, keeps the top of the page from
            // looking like a flat wash.
            Positioned(
              top: -90,
              right: -70,
              child: _glow(220, _primary.withOpacity(0.18)),
            ),
            Positioned(
              top: 120,
              left: -80,
              child: _glow(180, const Color(0xFFFFC9A8).withOpacity(0.35)),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(_hPad, 10, _hPad, 24),
                // On tablets the column stops stretching and stays centred
                // instead of spreading tiles across the full width.
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _backButton(),
                        const SizedBox(height: 18),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColor().blackColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _profileCard(),
                        const SizedBox(height: 24),

                        /// GROUP 1 — everyday account screens
                        _tile(
                          icon: Icons.receipt_long_rounded,
                          label: "My Orders",
                          onTap: () => Get.to(() => const MyOrdersScreen()),
                        ),
                        _tile(
                          icon: Icons.location_on_outlined,
                          label: "My Addresses",
                          onTap: () => Get.to(() => const AddressListing()),
                        ),
                        _tile(
                          icon: Icons.notifications_none_rounded,
                          label: "Notifications",
                          onTap: () => Get.to(() => const NotificationPage()),
                        ),

                        const SizedBox(height: 18),

                        /// GROUP 2 — security & help
                        _tile(
                          icon: Icons.lock_outline_rounded,
                          label: "Change Password",
                          onTap: () =>
                              Get.to(() => const ChangePasswordScreen()),
                        ),
                        _tile(
                          icon: Icons.support_agent_rounded,
                          label: "Help & Support",
                          onTap: () => Get.to(() => const MySupportsPage()),
                        ),
                        _tile(
                          icon: Icons.privacy_tip_outlined,
                          label: "Privacy & Policy",
                          onTap: () => Get.to(() => CmsPage()),
                        ),

                        const SizedBox(height: 18),

                        /// GROUP 3 — destructive
                        _tile(
                          icon: Icons.logout_rounded,
                          label: "Logout",
                          danger: true,
                          onTap: _showLogoutDialog,
                        ),

                        const SizedBox(height: 18),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Version 1.0.1",
                              style: TextStyle(
                                color: _primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: AppTab.profile),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
        ),
      ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColor().whiteColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: AppColor().blackColor,
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() {
        final user = controller.userData.value.data;
        final String name =
            "${user?.firstName ?? ""} ${user?.lastName ?? ""}".trim();
        final String displayName = name.isNotEmpty ? name : "Guest User";
        final String email = user?.email ?? "";
        final String phone = user?.contactNumber ?? "";
        final String address =
            (user?.userProfile?.addressLine1 ?? "").toString().trim();

        return Column(
          children: [
            _avatar(displayName),
            const SizedBox(height: 14),
            Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor().blackColor,
              ),
            ),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor().grey_Li.withOpacity(0.75),
                ),
              ),
            ],
            if (phone.isNotEmpty || address.isNotEmpty) ...[
              const SizedBox(height: 8),
              _metaRow(phone, address),
            ],
            const SizedBox(height: 18),
            _editProfileButton(),
          ],
        );
      }),
    );
  }

  /// Avatar falls back to the name's initial — the profile API sends no photo.
  Widget _avatar(String displayName) {
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : "U";

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [_primary.withOpacity(0.35), _primary.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        height: 86,
        width: 86,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [_primary, AppColor().colorPrimary_dark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColor().whiteColor, width: 3),
        ),
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColor().whiteColor,
          ),
        ),
      ),
    );
  }

  /// "phone · 📍address" line under the email, matching the reference layout.
  Widget _metaRow(String phone, String address) {
    final List<Widget> parts = [];

    if (phone.isNotEmpty) {
      parts.add(_metaChip(Icons.phone_rounded, phone));
    }
    if (address.isNotEmpty) {
      if (parts.isNotEmpty) {
        parts.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "•",
              style: TextStyle(color: AppColor().grey_Li.withOpacity(0.45)),
            ),
          ),
        );
      }
      parts.add(_metaChip(Icons.location_on_rounded, address));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: parts,
    );
  }

  Widget _metaChip(IconData icon, String value) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _primary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor().grey_Li.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editProfileButton() {
    return GestureDetector(
      // No update-profile API exists yet — swap this for the edit screen once
      // it lands.
      onTap: () => Utils.showCustomTosst("Profile editing is coming soon"),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [_primary, AppColor().colorPrimary_dark],
          ),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_outlined,
              size: 17,
              color: AppColor().whiteColor,
            ),
            const SizedBox(width: 8),
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColor().whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final Color tint = danger ? AppColor().red : _primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tint.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, size: 20, color: tint),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: danger ? tint : AppColor().blackColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColor().grey_Li.withOpacity(0.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Same clear-and-return-to-login flow the side menu uses.
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: _primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              GetStorage().erase();

              Get.offAll(() => LoginScreen(), transition: Transition.fadeIn);
            },
            child: Text(
              "Logout",
              style: TextStyle(color: AppColor().whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
