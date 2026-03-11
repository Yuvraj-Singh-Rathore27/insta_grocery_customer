import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/store_job_model.dart';
import '../model/responsemodel/store_job_response_model.dart';
import '../preferences/UserPreferences.dart';
import '../webservices/WebServicesHelper.dart';

class JobPostController extends GetxController {
  // ================= LOADING STATES =================
  RxBool isLoading = false.obs;
  RxBool isLoadingStoreTypes = false.obs;
   
  // ================= DATA =================
  RxList<JobListingModel> jobs = <JobListingModel>[].obs;
  RxList<StoreTypeModel> storeTypes = <StoreTypeModel>[].obs;

  RxInt selectedStoreTypeId = 0.obs;
  RxList<int> appliedJobIds = <int>[].obs;

  late GetStorage store;
  String accessToken = '';
  String userId = '';

  @override
  void onInit() {
    super.onInit();

    store = GetStorage();
    accessToken = store.read(UserPreferences.access_token) ?? '';
    userId = store.read(UserPreferences.user_id)?.toString() ?? '';

    getAllStoreTypes(); // ✅ load all store types
    getJobs();          // ✅ load jobs
  }

  // ================= STORE TYPES (ALL) =================
  Future<void> getAllStoreTypes() async {
    try {
      isLoadingStoreTypes.value = true;

      final response = await WebServicesHelper().getAllStoreTypes(
        accessToken: accessToken,
      );

      if (response != null && response['status'] == 200) {
        final List<StoreTypeModel> types = (response['data'] as List)
            .map((e) => StoreTypeModel.fromJson(e))
            .toList();

        // ✅ Optional: Add "All" filter at top
        storeTypes.assignAll(types);
      }
    } catch (e) {
      debugPrint("StoreType Error: $e");
    } finally {
      isLoadingStoreTypes.value = false;
    }
  }

  // ================= JOBS (WITH FILTER) =================
  Future<void> getJobs() async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> params = {
        "accessToken": accessToken,
        "page": "1",
        "size": "50",
        "order_by": "created_at",
        "descending": "true",
      };

      // ✅ Apply filter only if selected
      if (selectedStoreTypeId.value != 0) {
        params["store_type_id"] = selectedStoreTypeId.value.toString();
      }

      final response = await WebServicesHelper().getJobyStoreApi(params);

      if (response != null) {
        final model = JobListResponse.fromJson(response);
        jobs.assignAll(model.jobListing ?? []);
      }
    } catch (e) {
      debugPrint("Job Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER METHODS =================
  void filterByStoreType(int storeTypeId) {
    selectedStoreTypeId.value = storeTypeId;
    getJobs();
  }

  void clearFilter() {
    selectedStoreTypeId.value = 0;
    getJobs();
  }

  // ================= APPLY JOB =================
  Future<void> applyJobApi(int jobId, JobListingModel job) async {
   try{
     final response = await WebServicesHelper().PostapplyJobStoreApi({
      "store_id": job.storeId,
      "user_id": userId,
      "job_id": jobId,
    });

    if (response != null && response['status'] == 200) {
      appliedJobIds.add(jobId);
      Get.snackbar(
        "Success",
        "Job applied successfully",
        snackPosition: SnackPosition.TOP,
      );

    }
    else{
      Get.snackbar(
        "Errors",
        response?["message"]??"Failed to Apply JOb",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white

      );
    }
   }catch(e){
    debugPrint("Apply Job Error:$e");
   }
  }
}
