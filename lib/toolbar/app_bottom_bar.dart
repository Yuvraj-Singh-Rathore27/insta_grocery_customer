import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/AppColor.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
              label: "Videos",
              icon: Icons.video_library_rounded,
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
      onTap: () => onTap(index),
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
