import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../controller/vender_controller.dart';
import '../../../model/storeOfferModel.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../../../model/common_model.dart';

class StoreOfferTypeScreen extends StatefulWidget {
  final int initialIndex;

  const StoreOfferTypeScreen({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<StoreOfferTypeScreen> createState() => _StoreOfferTypeScreen();
}


class _StoreOfferTypeScreen extends State<StoreOfferTypeScreen> {
  final PharmacyController controller = Get.put(PharmacyController());
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // controller.loadStoreGroups();

    currentIndex = widget.initialIndex;

    _pageController = PageController(
      viewportFraction: 0.9,
      initialPage: currentIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.getStoreOfferApi();
      controller.getBusinessTypecategory();

    });
  }

  void _goLeft() {
    if (currentIndex > 0) {
      currentIndex--;
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goRight() {
    if (currentIndex < controller.storeOfferList.length - 1) {
      currentIndex++;
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Store Offers")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          
                _storeGroupDropdown(),   // ✅ STORE GROUP
            _storeTypeDropdown(),  
            // ✅ STORE TYPE
          Expanded(
  child: Obx(() {
    if (controller.isLoadingBusinessCategory.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.homeOfferList.isEmpty) {
      return const Center(child: Text("No offers available"));
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: controller.homeOfferList.length,
      onPageChanged: (index) {
        setState(() => currentIndex = index);
      },
      itemBuilder: (context, index) {
        return _offerCard(controller.homeOfferList[index]);
      },
    );
  }),
),

          ],
        ),
      )
    );
  }

  Widget _offerCard(StoreOfferModel offer) {
  final imageUrl = _getOfferImageUrl(offer);
  controller.fetchStoreLocation(offer);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
    child: Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Background Image with overlay
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Image
                    imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                    // Dark Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.2),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with share button - FIXED POSITION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Obx(() {
  final timeLeft =
      offer.getCountdown(controller.currentTime.value);

  if (timeLeft.isEmpty) return const SizedBox();

  return Text(
    '⏳ $timeLeft left',
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );
}),
                        // Empty container to push share button to right
                        const SizedBox(width: 40), // Adjust as needed
                        
                        // Share Button - Now clickable
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _shareOffer(offer);
                            },
                            icon: const Icon(Icons.share, 
                                color: Colors.white, 
                                size: 24),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Offer Details
Text(
                      offer.name ?? "Offer",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      offer.description ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),

                    
                    const SizedBox(height: 16),

              
                    
                    _storeInfo(offer),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Claim Offer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
    ),
  );
}
  String? _getOfferImageUrl(StoreOfferModel offer) {
    if (offer.image != null &&
        offer.image!.isNotEmpty &&
        offer.image!.first.path != null &&
        offer.image!.first.path!.isNotEmpty) {
      return offer.image!.first.path;
    }
    return null;
  }

  Widget _storeInfo(StoreOfferModel offer) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Icon
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange,
              child: Icon(Icons.store, color: Colors.white, size: 18),
            ),

            const SizedBox(width: 10),

            // Text Area (Responsive)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Store Name
                  Text(
                    offer.store?.name ?? "Store",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 4),

                      // Location text responsive
                      Expanded(
                        child: Text(
                          controller.storeLocationMap[offer.store?.id] ??
                              "Fetching location...",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        "4.7",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}


  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_offer,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  // ============ SHARE LOGIC ============
  void _shareOffer(StoreOfferModel offer) async {
    // Show loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      String? imageUrl;
      if (offer.image != null && offer.image!.isNotEmpty) {
        imageUrl = offer.image!.first.path;
      }

      // Agar image hai to download karenge
      File? imageFile;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageFile = await _downloadImage(imageUrl);
      }

      // Share text create karein
      final String shareText = '''
🎉 EXCLUSIVE OFFER 🎉

${offer.name ?? ""}
${offer.description ?? ""}
${offer.timeLeft != null && offer.timeLeft!.isNotEmpty
          ? "⏰ Offer ends in: ${offer.timeLeft}\n"
          : "⏰ Limited time offer\n"}
📍 Store: ${offer.store?.name ?? "Our Store"}
📌 Store Location: ${controller.storeLocationMap[offer.store?.id] ??
                        "Fetching location..."}
👉 Hurry! Grab this amazing deal now!
#SpecialOffer #Discount #${offer.store?.name?.replaceAll(' ', '') ?? 'Shopping'},
Hey, I am using Frebbo Connect App - My Store Video is, you can check it out 🔥,
https://play.google.com/store/apps/details?id=com.insta.grocery.customer
''';

      // Close loading dialog
      Get.back();

      // Share with or without image
      if (imageFile != null && await imageFile.exists()) {
        // Image ke saath share karein
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: shareText,
          subject: '🔥 ${offer.name ?? "Special Offer"}',
        );

        // Temporary file delete karein
        await imageFile.delete();
      } else {
        // Sirf text share karein
        Share.share(
          shareText,
          subject: '🔥 ${offer.name ?? "Special Offer"}',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog

      Get.snackbar(
        "Error",
        "Failed to share: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Fallback: sirf text share karein
      final String fallbackText = '''
${offer.name ?? ""}
${offer.description ?? ""}
📍 ${offer.store?.name ?? ""}
''';

      Share.share(fallbackText);
    }
  }

  // Image download function
  Future<File?> _downloadImage(String imageUrl) async {
    try {
      final dio = Dio();

      // Temporary directory mein file save karein
      final tempDir = await getTemporaryDirectory();
      final fileName = 'offer_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${tempDir.path}/$fileName';

      // Download image
      await dio.download(
        imageUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          maxRedirects: 5,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      return File(filePath);
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  // Alternative: With progress indicator (optional)
  void _shareOfferWithProgress(StoreOfferModel offer) {
    // Show progress dialog
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              "Preparing offer for sharing...",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    _downloadAndShare(offer);
  }

  Future<void> _downloadAndShare(StoreOfferModel offer) async {
    try {
      String? imageUrl;
      if (offer.image != null && offer.image!.isNotEmpty) {
        imageUrl = offer.image!.first.path;
      }

      File? imageFile;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Download with progress updates
        imageFile = await _downloadImageWithProgress(imageUrl);
      }

      // Create share text
      final String shareText = _createShareText(offer);

      Get.back(); // Close dialog

      if (imageFile != null && await imageFile.exists()) {
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: shareText,
          subject: '🔥 ${offer.name ?? "Special Offer"}',
        );

        // Cleanup
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            if (await imageFile!.exists()) {
              await imageFile!.delete();
            }
          } catch (e) {
            print('Error deleting temp file: $e');
          }
        });
      } else {
        Share.share(shareText);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Sharing failed");
      _fallbackShare(offer);
    }
  }

  Future<File?> _downloadImageWithProgress(String imageUrl) async {
    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    final fileName = 'share_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${tempDir.path}/$fileName';

    try {
      await dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            // Progress update kar sakte hain agar chahiye
            print('Downloading: ${(received / total * 100).toInt()}%');
          }
        },
      );

      // Check file size
      final file = File(filePath);
      final fileSize = await file.length();

      if (fileSize > 0) {
        return file;
      } else {
        await file.delete();
        return null;
      }
    } catch (e) {
      print('Download failed: $e');

      // Delete partial file if exists
      try {
        final tempFile = File(filePath);
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {}

      return null;
    }
  }

  String _createShareText(StoreOfferModel offer) {
    return '''
🎉 EXCLUSIVE OFFER 🎉

${offer.name ?? ""}

${offer.description ?? ""}

${offer.timeLeft != null ? "⏰ ${offer.timeLeft!}\n" : ""}
📍 ${offer.store?.name ?? "Our Store"}

👉 Don't miss this deal!

#Offer #${offer.store?.name?.replaceAll(' ', '') ?? 'Store'}
''';
  }

  void _fallbackShare(StoreOfferModel offer) {
    final String text = '''
${offer.name ?? "Special Offer"}
${offer.description ?? ""}
📍 ${offer.store?.name ?? ""}
''';

    Share.share(text);
  }


 Widget _storeGroupDropdown() {
  return Obx(() {
    if (controller.BusinessCategory.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: const Text("Select Store Group"),
          value: controller.selectedBusinessCategoryId.value == 0
              ? null
              : controller.selectedBusinessCategoryId.value,
          items: controller.BusinessCategory.map((group) {
            return DropdownMenuItem<int>(
              value: group.id,
              child: Text(group.name ?? ""),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            controller.selectedBusinessCategoryId.value = value;

            // set full model also (for API use)
            controller.selectedBusinessCategory.value =
                controller.BusinessCategory
                    .firstWhere((e) => e.id == value);

            controller.getStoreTypeCategory();
          },
        ),
      ),
    );
  });
}


Widget _storeTypeDropdown() {
  return Obx(() {
    if (controller.venderCategory.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: const Text("Select Store Type"),
          value: controller.selectedVenderCategoryId.value == 0
              ? null
              : controller.selectedVenderCategoryId.value,
          items: controller.venderCategory.map((type) {
            return DropdownMenuItem<int>(
              value: type.id,
              child: Text(type.name ?? ""),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            controller.selectedVenderCategoryId.value = value;

            // set full model also (for API use)
            controller.selectedVenderCategory.value =
                controller.venderCategory
                    .firstWhere((e) => e.id == value);
          },
        ),
      ),
    );
  });
}



}