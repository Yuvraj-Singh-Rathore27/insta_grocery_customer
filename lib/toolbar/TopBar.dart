import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/address_controller.dart';
import '../controller/vender_controller.dart';
import '../res/AppColor.dart';
import '../res/ImageRes.dart';
import '../screen/address_managment/clientSetLocation.dart';

/// Default action for the location pill. Screens that need something else
/// pass their own `onPressed` / `onTitleTapped`.
/// `ClientLocationSetOnMap` does a `Get.find<AddressController>()`, so make
/// sure the controller is alive before pushing the screen — the pill is shown
/// on screens that were never routed through the dashboard.
void openLocationPicker() {
  if (!Get.isRegistered<AddressController>()) {
    Get.put(AddressController());
  }
  Get.to(() => ClientLocationSetOnMap(type: "pickup"));
}

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool menuicon;
  final bool iconnotifiction;
  final bool is_supporticon;
  final bool is_whatsappicon;
  final bool menuback;
  final bool is_wallaticon;
  final VoidCallback onPressed; // location tap
  final VoidCallback onTitleTapped;

  /// Badge shown on the bell. Hidden when 0.
  final int notificationCount;

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
    this.onPressed = openLocationPicker,
    this.onTitleTapped = openLocationPicker,
    this.notificationCount = 3,
  }) : preferredSize = const Size.fromHeight(80.0);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with TickerProviderStateMixin {
  late final PharmacyController controller;

  Color get _primary => AppColor().colorPrimary;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PharmacyController());
  }

  // ---------------- Branding Section ----------------
  /// Location pill. The city label fires `onPressed` and the surrounding pill
  /// fires `onTitleTapped` — some screens route those two to different places.
  /// Both default to [openLocationPicker], so the whole pill is tappable
  /// unless a screen deliberately overrides it.
  Widget _buildBranding() {
    return InkWell(
      onTap: () => widget.onTitleTapped(),
      borderRadius: BorderRadius.circular(30),
      splashColor: _primary.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _primary.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageRes().locationImage,
              height: 16,
              width: 14,
              fit: BoxFit.contain,
              color: _primary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: GestureDetector(
                onTap: () => widget.onPressed(),
                child: Obx(
                  () => Text(
                    controller.city.value.isEmpty
                        ? "Select Location"
                        : controller.city.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                      color: AppColor().blackColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Image.asset(
              ImageRes().downarrow,
              height: 12,
              width: 14,
              fit: BoxFit.contain,
              color: _primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Screen title, shown instead of the location pill when a caller passes one.
  Widget _buildTitle() {
    return GestureDetector(
      onTap: () => widget.onTitleTapped(),
      behavior: HitTestBehavior.opaque,
      child: Text(
        widget.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: "Inter",
          color: AppColor().blackColor,
        ),
      ),
    );
  }

  // ---------------- Notification Bell ----------------
  Widget _buildNotificationBell() {
    return _iconButton(
      onTap: () {
        // Future: Get.to(() => const NotificationPage());
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            ImageRes().notification_s_c,
            color: _primary,
            height: 22,
            width: 22,
            fit: BoxFit.contain,
          ),
          if (widget.notificationCount > 0)
            Positioned(
              right: -5,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor().whiteColor, width: 1.6),
                ),
                child: Center(
                  child: Text(
                    widget.notificationCount > 99
                        ? "99+"
                        : "${widget.notificationCount}",
                    style: TextStyle(
                      color: AppColor().whiteColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- Menu Icon ----------------
  Widget _buildMenuIcon(BuildContext scaffoldContext) {
    return _iconButton(
      onTap: () {
        if (widget.menuicon) {
          Scaffold.of(scaffoldContext).openDrawer();
        } else {
          Navigator.maybePop(scaffoldContext);
        }
      },
      child: Image.asset(
        widget.menuicon ? ImageRes().img_menu : ImageRes().img_back,
        color: _primary,
        height: 22,
        width: 22,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Soft tinted square that both the menu and the bell sit in, so the two
  /// ends of the bar read as a matched pair.
  Widget _iconButton({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: _primary.withOpacity(0.06),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        splashColor: _primary.withOpacity(0.12),
        child: SizedBox(
          height: 42,
          width: 42,
          child: Center(child: child),
        ),
      ),
    );
  }

  // ---------------- Build ----------------
  @override
  Widget build(BuildContext context) {
    final bool hasTitle = widget.title.trim().isNotEmpty;

    return SafeArea(
      bottom: false,
      child: Container(
        height: widget.preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor().whiteColor,
          border: Border(
            bottom: BorderSide(color: AppColor().colorGrayLess, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Builder(
              builder: (scaffoldContext) => _buildMenuIcon(scaffoldContext),
            ),
            const SizedBox(width: 10),

            // Centre section flexes, so a long city or title ellipsises
            // instead of pushing the bell off screen.
            Expanded(
              child: Align(
                alignment: hasTitle ? Alignment.center : Alignment.centerLeft,
                child: hasTitle ? _buildTitle() : _buildBranding(),
              ),
            ),

            if (widget.iconnotifiction) ...[
              const SizedBox(width: 10),
              _buildNotificationBell(),
            ],
          ],
        ),
      ),
    );
  }
}
