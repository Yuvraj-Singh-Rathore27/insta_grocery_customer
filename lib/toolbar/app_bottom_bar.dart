import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/AppColor.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/daskboard/orders/my_orders_screen.dart';
import '../screen/daskboard/settings/my_profile_screen.dart';
import '../screen/market_place/buyer/buyer_super_category.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;

  /// Optional override. When it is null the bar navigates to the tapped tab's
  /// screen itself, so every screen hosting the bar switches the same way.
  final Function(int)? onTap;

  const AppBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  void _handleTap(int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        // Home is the root tab: drop the pushed tab screens instead of
        // stacking another dashboard on top of them.
        Get.offAll(() => DashBord(0, ""));
        break;
      case 1:
        Get.to(() => const MyOrdersScreen());
        break;
      case 2:
        Get.to(() => MarketPlaceSuperCategoryScreen());
        break;
      case 3:
        Get.to(() => const MyProfileScreen());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppColor().whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomItem(
              index: 0,
              label: "Home",
              icon: Icons.home_rounded,
            ),
            _bottomItem(
              index: 1,
              label: "Orders",
              icon: Icons.receipt_long_rounded,
            ),
            _bottomItem(
              index: 2,
              label: "Market Place",
              icon: Icons.production_quantity_limits_outlined
              ,
            ),
            _bottomItem(
              index: 3,
              label: "Profile",
              icon: Icons.person_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor().colorPrimary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 26,
                color: isSelected
                    ? AppColor().colorPrimary
                    : AppColor().grey_Li,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1 : 0.6,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColor().colorPrimary
                      : AppColor().grey_Li,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
