import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/feedback_model.dart';
import '../preferences/UserPreferences.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class FeedbackController extends GetxController {
  late GetStorage store;
  String userId = "";
  String accessToken = "";

  TextEditingController descriptionController = TextEditingController();

  RxList<FeedbackTypeModel> feedbackTypeList = <FeedbackTypeModel>[].obs;
  Rxn<FeedbackTypeModel> selectedFeedbackType = Rxn<FeedbackTypeModel>();

  /// 0 = not rated yet, 1-5 maps to Bad..Great
  RxInt rating = 0.obs;

  RxBool isLoadingTypes = false.obs;
  RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    getFeedbackTypes();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  void loadUserData() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    accessToken = store.read(UserPreferences.access_token) ?? "";
  }

  Future<void> getFeedbackTypes() async {
    try {
      isLoadingTypes.value = true;
      final response = await WebServicesHelper().getFeedbackTypes();
      if (response != null && response['data'] != null) {
        feedbackTypeList.value = (response['data'] as List)
            .map((e) => FeedbackTypeModel.fromJson(e))
            .toList();

        if (feedbackTypeList.isNotEmpty) {
          selectedFeedbackType.value = feedbackTypeList.first;
        }
      }
    } catch (e) {
      debugPrint("❌ [FEEDBACK] Type Error: $e");
    } finally {
      isLoadingTypes.value = false;
    }
  }

  void selectFeedbackType(FeedbackTypeModel type) {
    selectedFeedbackType.value = type;
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<bool> submitFeedback() async {
    if (selectedFeedbackType.value == null) {
      Utils.showCustomTosstError("Please select a feedback category.");
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please describe your feedback.");
      return false;
    }

    try {
      isSubmitting.value = true;

      final int parsedUserId = int.tryParse(userId) ?? 0;

      final feedbackModel = FeedbackModel(
        feedbackTypeId: selectedFeedbackType.value!.id,
        userId: parsedUserId,
        title: selectedFeedbackType.value!.name ?? "Feedback",
        description: descriptionController.text.trim(),
        rating: rating.value,
        createdBy: parsedUserId,
        createdById: parsedUserId,
        updatedBy: parsedUserId,
        updatedById: parsedUserId,
      );

      final response = await WebServicesHelper()
          .postFeedback(feedbackModel.toJson(), accessToken);

      if (response != null) {
        descriptionController.clear();
        rating.value = 0;
        return true;
      } else {
        Utils.showCustomTosstError("Network issues, please try after some time");
        return false;
      }
    } catch (e) {
      debugPrint("❌ [FEEDBACK] Submit Error: $e");
      Utils.showCustomTosstError("Something went wrong, please try again.");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
