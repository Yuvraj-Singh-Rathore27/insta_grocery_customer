import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controller/vender_controller.dart';
import '../../../res/AppColor.dart';
import '../../../model/storeVideoModel.dart';
import '../../common/video_player_screen.dart';

class MyStoreVideosScreen extends StatefulWidget {
  const MyStoreVideosScreen({super.key});

  @override
  State<MyStoreVideosScreen> createState() => _MyStoreVideosScreenState();
}

class _MyStoreVideosScreenState extends State<MyStoreVideosScreen> {
  late final PharmacyController controller;
  RxBool isSharingVideo = false.obs;
RxDouble downloadProgress = 0.0.obs;

  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<PharmacyController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllVideoCategoryApi();
      controller.getStoreVideoApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double h = size.height;
    final double w = size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: _buildCleanAppBar(w),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Obx(() {
          if (controller.isLoadingVideos.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              _buildReelsView(h, w),

              // 🔥 Top gradient for readability
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: h * 0.18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 🔥 Category overlay
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                left: 0,
                right: 0,
                child: _buildCategoryList(),
              ),
            ],
          );
        }),
          ],
        ),
      ),
    );
  }

  // ================= CLEAN APP BAR =================
  PreferredSizeWidget _buildCleanAppBar(double w) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: w * 0.06,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Store Videos",
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.055,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ================= CATEGORY LIST =================
  Widget _buildCategoryList() {
    return Obx(() {
      if (controller.videoCategouryList.isEmpty) {
        return const SizedBox();
      }

      return SizedBox(
        height: 40,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          scrollDirection: Axis.horizontal,
          itemCount: controller.videoCategouryList.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final category = controller.videoCategouryList[index];
            final bool isSelected =
                controller.selectedCategoryVideo.value?.id == category.id;

            return GestureDetector(
              onTap: () {
                controller.selectedCategoryVideo.value = category;
                controller.currentVideoIndex.value = 0;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor().colorPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ================= REELS VIEW =================
  Widget _buildReelsView(double h, double w) {
    final videos = controller.filteredVideos;

    if (videos.isEmpty || controller.isLoadingVideos.value) {
  return const Center(
    child: CircularProgressIndicator(color: Colors.white),
  );
}


    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      onPageChanged: (index) {
        controller.currentVideoIndex.value = index;

        // 🔥 LOAD DETAIL (LIKE / COMMENT COUNT + USERS)
        controller.getVideoDetail(videos[index].id);
      },
      itemBuilder: (context, index) {
        return _reelVideoItem(videos[index], index, h, w);
      },
    );
  }

  // ================= SINGLE VIDEO =================
  Widget _reelVideoItem(VideoModel video, int index, double h, double w) {
    return Obx(() {
      final bool isActive = controller.currentVideoIndex.value == index;

      final videoData = video.video.isNotEmpty ? video.video[0] : null;

      final String? videoUrl = videoData?['path'];
      final double actionBaseBottom = h * 0.12;
      final double duration = (videoData?['duration'] ?? 0).toDouble();

     if (videoUrl == null || videoUrl.isEmpty) {
  return Container(
    color: Colors.black,
    child: const Center(
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );
}


      return Stack(
        children: [
          VideoPlayerScreen(
            videoUrl: videoUrl,
            autoPlay: isActive,
          ),

//           // ❤️ Like / Dislike
//           Positioned(
//   left: 12,
//   bottom: actionBaseBottom,
//    // leave space for buttons
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Text(
//         video.name.isNotEmpty ? video.name : "Store",
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style:  TextStyle(
//           color: AppColor().blackColor
//           ,
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       const SizedBox(height: 6),
//       Text(
//         video.description.isNotEmpty
//             ? video.description
//             : "No description available",
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//         style:  TextStyle(
//           color:AppColor().blackColor ,
//           fontSize: 16,
//         ),
//       ),
//     ],
//   ),
// ),

          // 🏪 STORE NAME + DESCRIPTION (BOTTOM LEFT)
          Positioned(
            right: w * 0.04,
            bottom: actionBaseBottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ❤️ Like
                Obx(() {
                  final detail = controller.videoDetailMap[video.id];

                  // total likes from detail API
                  final int totalLikes = detail?.totalLike ?? 0;

                  // 🔍 get current user's reaction safely
                  final myReaction = detail?.reactions.firstWhereOrNull(
                    (r) => r['user']?['id'] == int.tryParse(controller.user_id),
                  );

                  final bool isLiked = (myReaction?['reaction'] ?? 0) == 1;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        iconSize: w * 0.09,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                        ),
                        onPressed: () async {
                          // 🔥 toggle reaction
                          final int nextReaction = isLiked ? 0 : 1;

                          // 🔥 preserve existing comment
                          // final String oldComment = myReaction?['comment'] ?? '';

                          await controller.postVideoReaction(
                            videoId: video.id,
                            reaction: nextReaction,
                          );

                          // 🔥 refresh detail for correct count + UI
                          // await controller.getVideoDetail(video.id);
                        },
                      ),
                      Text(
                        totalLikes.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.032,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 18),

                // 💬 Comment
                Obx(() {
                  final detail = controller.videoDetailMap[video.id];

                  // total comments from detail API
                  final int totalComments = detail?.totalComment ?? 0;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // 🔥 ALWAYS load latest detail before opening comments
                          await controller.getVideoDetail(video.id);

                          _openCommentSheet(video.id);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.comment_rounded,
                              color: Colors.white,
                              size: w * 0.075,
                            ),

                            // 🔥 COMMENT COUNT BADGE
                            if (totalComments > 0)
                              Positioned(
                                top: -6,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    totalComments.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 18),

                // 🔗 Share
                Column(
                  children: [
                    IconButton(
                      iconSize: w * 0.075,
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () => _shareVideo(video),
                    ),
                    Text(
                      "Share",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.032,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  // ================= HELPERS =================
  String formatDuration(double seconds) {
    final int mins = seconds ~/ 60;
    final int secs = (seconds % 60).toInt();
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  Widget _videoErrorUI() {
    return const Center(
      child: Icon(Icons.videocam_off, size: 64, color: Colors.white54),
    );
  }

  Widget _emptyView() {
    return const Center(
      child: Text(
        "No videos available",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _shareVideo(VideoModel video) async {
  final videoData =
      video.video.isNotEmpty ? video.video[0] : null;
  final String? videoUrl = videoData?['path'];

  if (videoUrl == null || videoUrl.isEmpty) {
    Get.snackbar("Error", "Video not available");
    return;
  }

  await _downloadAndShareVideo(videoUrl);
}


  void _openCommentSheet(int videoId) {
    commentController.clear();

    // 🔥 Load latest detail before opening
    controller.getVideoDetail(videoId);

    Get.bottomSheet(
      Obx(() {
final detail = controller.videoDetailMap[videoId];
        final reactions = detail?.reactions ?? [];

        // show only valid comments
        final comments = reactions
            .where((r) =>
                r['comment'] != null &&
                r['comment'].toString().trim().isNotEmpty)
            .toList();

        return SafeArea(
          child: Container(
            height: Get.height * 0.8,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Column(
              children: [
                // ================= DRAG HANDLE =================
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                const Divider(height: 16),

                // ================= COMMENT LIST =================
                Expanded(
                  child: comments.isEmpty
                      ? const Center(
                          child: Text(
                            "Be the first to comment 👋",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: comments.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final r = comments[index];
                            final userName = r['user']?['user_name'] ?? "User";

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  child: Icon(Icons.person, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          r['comment'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),

                const Divider(height: 16),

                // ================= ADD COMMENT =================
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.send,
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _submitComment(videoId),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        splashRadius: 22,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: () => _submitComment(videoId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Future<void> _submitComment(int videoId) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    await controller.postVideoReaction(
      videoId: videoId,
      comment: text, // 🔥 reaction preserved internally
    );

    commentController.clear();
  }

  Future<void> _downloadAndShareVideo(String videoUrl) async {
  try {
    isSharingVideo.value = true;
    downloadProgress.value = 0.0;

    final tempDir = await getTemporaryDirectory();
    final filePath =
        "${tempDir.path}/reel_video_${DateTime.now().millisecondsSinceEpoch}.mp4";

    await Dio().download(
      videoUrl,
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          downloadProgress.value = received / total;
        }
      },
    );

    await Share.shareXFiles(
      [XFile(filePath)],
      text: "Hey, I am using Frebbo Connect App - My Store Video is, you can check it out 🔥\nhttps://play.google.com/store/apps/details?id=com.insta.grocery.customer",
    );
  } catch (e) {
    Get.snackbar("Error", "Unable to share video");
  } finally {
    isSharingVideo.value = false;
    downloadProgress.value = 0.0;
  }
}

}

