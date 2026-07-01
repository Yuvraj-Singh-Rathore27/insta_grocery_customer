import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/FeedbackController.dart';
import '../../../res/AppColor.dart';
import 'feedback_success_screen.dart';

class _MoodOption {
  final int value;
  final String label;
  final IconData icon;

  const _MoodOption(this.value, this.label, this.icon);
}

const List<_MoodOption> _moods = [
  _MoodOption(1, "Bad", Icons.sentiment_very_dissatisfied_rounded),
  _MoodOption(2, "Poor", Icons.sentiment_dissatisfied_rounded),
  _MoodOption(3, "Okay", Icons.sentiment_neutral_rounded),
  _MoodOption(4, "Good", Icons.sentiment_satisfied_rounded),
  _MoodOption(5, "Great", Icons.sentiment_very_satisfied_rounded),
];

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController controller = Get.put(FeedbackController());

  /// 0 = rating step, 1 = details step
  int _step = 0;

  void _goToDetailsStep() => setState(() => _step = 1);

  void _goBackToRatingStep() => setState(() => _step = 0);

  Future<void> _handleSubmit() async {
    final bool success = await controller.submitFeedback();
    if (success) {
      Get.off(() => const FeedbackSuccessScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _step == 0 ? "Share Feedback" : "Tell Us More",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            if (_step == 1) {
              _goBackToRatingStep();
            } else {
              Get.back();
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: _step == 0
            ? _buildRatingStep(key: const ValueKey("rating"))
            : _buildDetailsStep(key: const ValueKey("details")),
      ),
    );
  }

  /// ================= STEP 1: RATING =================
  Widget _buildRatingStep({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor().colorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "CUSTOMER SATISFACTION",
              style: TextStyle(
                color: AppColor().colorPrimary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "How are we doing?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Inter",
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your feedback helps us improve our service and build a better experience for you.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 44),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moods.map((mood) {
                final bool isSelected = controller.rating.value == mood.value;

                return GestureDetector(
                  onTap: () => controller.setRating(mood.value),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColor().colorPrimary.withOpacity(0.12)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColor().colorPrimary
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          mood.icon,
                          color: isSelected
                              ? AppColor().colorPrimary
                              : Colors.grey.shade400,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mood.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColor().colorPrimary
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 60),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  disabledBackgroundColor: AppColor().colorPrimary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed:
                    controller.rating.value > 0 ? _goToDetailsStep : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= STEP 2: DETAILS =================
  Widget _buildDetailsStep({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's on your mind?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Inter",
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Help us improve by sharing your thoughts. Your feedback directly shapes our roadmap.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "SELECT A CATEGORY",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () {
              if (controller.isLoadingTypes.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.feedbackTypeList.isEmpty) {
                return Text(
                  "No categories available right now.",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                );
              }

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.feedbackTypeList.map((type) {
                  final bool isSelected =
                      controller.selectedFeedbackType.value?.id == type.id;

                  return GestureDetector(
                    onTap: () => controller.selectFeedbackType(type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor().colorPrimary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        type.name ?? "",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 26),
          Text(
            "DETAILS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.descriptionController,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: "Tell me more...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: controller.isSubmitting.value ? null : _handleSubmit,
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.send_rounded,
                              color: Colors.white, size: 16),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
