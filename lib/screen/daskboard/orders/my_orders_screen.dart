import 'package:flutter/material.dart';

import '../../../res/AppColor.dart';
import '../../../toolbar/app_bottom_bar.dart';

/// Orders tab of [AppBottomBar]. The order-history API is not wired up yet,
/// so this only renders the empty state and keeps the tab navigable.
class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(
            color: AppColor().blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: BackButton(color: AppColor().blackColor),
      ),
      // Scrollable so the empty state still fits in landscape or with a large
      // system font scale.
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 64,
                  color: AppColor().grey_Li.withOpacity(0.4),
                ),
                const SizedBox(height: 14),
                Text(
                  "No orders yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor().blackColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Your orders will show up here once you place one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor().grey_Li.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: AppTab.orders),
    );
  }
}
