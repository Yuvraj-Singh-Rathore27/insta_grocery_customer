import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/AppColor.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/daskboard/orders/my_orders_screen.dart';
import '../screen/daskboard/settings/my_profile_screen.dart';
import '../screen/market_place/buyer/buyer_super_category.dart';

/// One entry in [AppBottomBar.tabs].
class AppBottomTab {
  const AppBottomTab({
    required this.label,
    required this.icon,
    required this.open,
  });

  final String label;
  final IconData icon;

  /// What tapping the tab does. Runs only when the tab isn't already current.
  final VoidCallback open;
}

/// Stable indexes for [AppBottomBar.currentIndex]. Screens refer to these
/// instead of raw numbers, so inserting a tab in the middle of the list
/// doesn't silently highlight the wrong one.
class AppTab {
  static const int home = 0;
  static const int orders = 1;
  static const int marketPlace = 2;
  static const int profile = 3;
}

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

  /// The bar's contents. To add a tab: append an entry here, add a matching
  /// constant to [AppTab], and pass it as `currentIndex` from the new screen.
  /// Nothing else needs changing — the bar divides the width evenly and
  /// starts scrolling horizontally once the tabs stop fitting.
  static final List<AppBottomTab> tabs = [
    AppBottomTab(
      label: "Home",
      icon: Icons.home_rounded,
      // Home is the root tab: drop the pushed tab screens instead of
      // stacking another dashboard on top of them.
      open: () => Get.offAll(() => DashBord(0, "")),
    ),
    AppBottomTab(
      label: "Orders",
      icon: Icons.receipt_long_rounded,
      open: () => Get.to(() => const MyOrdersScreen()),
    ),
    AppBottomTab(
      label: "Market Place",
      icon: Icons.production_quantity_limits_outlined,
      open: () => Get.to(() => MarketPlaceSuperCategoryScreen()),
    ),
    AppBottomTab(
      label: "Profile",
      icon: Icons.person_rounded,
      open: () => Get.to(() => const MyProfileScreen()),
    ),
  ];

  /// Below this an item's label gets too cramped to read, so the bar scrolls
  /// rather than squeezing the tabs any further.
  static const double _minItemWidth = 68;

  void _handleTap(int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }
    if (index == currentIndex) return;

    tabs[index].open();
  }

  @override
  Widget build(BuildContext context) {
    // Grow with the user's font-size setting (capped) so the labels never get
    // clipped by the bar's fixed height.
    final double textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.3);
    final double contentWidth = MediaQuery.of(context).size.width - 24;
    final bool scrolls = tabs.length * _minItemWidth > contentWidth;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Container(
        height: 72 * textScale,
        clipBehavior: Clip.antiAlias,
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
        child: scrolls
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: tabs.length,
                itemBuilder: (context, index) => SizedBox(
                  width: _minItemWidth,
                  child: _bottomItem(index),
                ),
              )
            // Each item takes an equal share of the bar so a long label can't
            // push the row past the screen edge.
            : Row(
                children: [
                  for (int i = 0; i < tabs.length; i++)
                    Expanded(child: _bottomItem(i)),
                ],
              ),
      ),
    );
  }

  Widget _bottomItem(int index) {
    final AppBottomTab tab = tabs[index];
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor().colorPrimary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        // Icon (22) + gap (3) + label (~13) = 38 inside the 44 the bar leaves,
        // with headroom for the capped text scale. The outer FittedBox is the
        // backstop: if anything still doesn't fit it shrinks rather than
        // overflowing.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: Icon(
                  tab.icon,
                  size: 22,
                  color:
                      isSelected ? AppColor().colorPrimary : AppColor().grey_Li,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isSelected ? 1 : 0.6,
                child: Text(
                  tab.label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.1,
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
      ),
    );
  }
}
