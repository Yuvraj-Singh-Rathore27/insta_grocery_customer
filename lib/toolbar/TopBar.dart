import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/vender_controller.dart';
import '../res/AppColor.dart';
import '../res/AppDimens.dart';
import '../res/ImageRes.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool menuicon;
  final bool iconnotifiction;
  final bool is_supporticon;
  final bool is_whatsappicon;
  final bool menuback;
  final bool is_wallaticon;
  final Function onPressed; // for location tap (future)
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  TopBar({
    required this.title,
    required this.menuicon,
    required this.menuback,
    required this.iconnotifiction,
    required this.is_wallaticon,
    required this.is_supporticon,
    required this.is_whatsappicon,
    required this.onPressed,
    required this.onTitleTapped,
  }) : preferredSize = const Size.fromHeight(80.0);

  @override
  State<TopBar> createState() =>
      _TopBarState(menuicon, menuback, iconnotifiction);
}

class _TopBarState extends State<TopBar> with TickerProviderStateMixin {
  bool menuicon;
  bool menuback;
  bool iconnotifiction;
  late final PharmacyController controller;

  _TopBarState(this.menuicon, this.menuback, this.iconnotifiction);

  @override
  void initState() {
    super.initState();
    controller = Get.put(PharmacyController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ---------------- Branding Section ----------------
  Widget _buildBranding() {
    return InkWell(
      onTap: () => widget.onTitleTapped(),
      borderRadius: BorderRadius.circular(12),
      splashColor: AppColor().colorPrimary.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo box

            const SizedBox(width: 10),
            // Location column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      ImageRes().locationImage,
                      height: 18,
                      width: 16,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => {
                        widget.onPressed(),
                        print("these clicked")
                      },
                      child: Obx(() => Text(
      controller.city.value.isEmpty
          ? "Select Location"
          : controller.city.value,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: AppDimens().front_medium,
        fontFamily: "Inter",
        color: AppColor().blackColor,
      ),
    )),

                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      ImageRes().downarrow,
                      height: 14,
                      width: 16,
                      fit: BoxFit.contain,
                      color: AppColor().colorPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Notification Bell ----------------
  Widget _buildNotificationBell() {
    return GestureDetector(
      onTap: () {
        // Future: Get.to(() => const NotificationPage());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              ImageRes().notification_s_c,
              color: AppColor().colorPrimary,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            // Optional badge
            Positioned(
              right: -2,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
                child: const Center(
                  child: Text(
                    '3', // Replace with dynamic count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Menu Icon ----------------
  Widget _buildMenuIcon(BuildContext scaffoldContext) {
    return GestureDetector(
      onTap: () {
        if (menuicon) {
          // Open right-side drawer
          Scaffold.of(scaffoldContext).openDrawer();
        } else {
          Navigator.maybePop(scaffoldContext);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Image.asset(
          menuicon ? ImageRes().img_menu : ImageRes().img_back,
          color: AppColor().colorPrimary,
          height: 28,
          width: 28,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ---------------- Build ----------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: widget.preferredSize.height,
        color: AppColor().whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Branding (Frebbo logo + text)
            Builder(
              builder: (scaffoldContext) => _buildMenuIcon(scaffoldContext),
            ),
            _buildBranding(),

            // Right: Notification + Menu
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNotificationBell(),
                const SizedBox(width: 8),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
