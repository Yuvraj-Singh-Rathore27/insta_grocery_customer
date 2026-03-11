
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/JobModel.dart';
import '../model/JobTasksModel.dart';
import '../model/responsemodel/JobDetailsResponse.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class JobDetailsController extends GetxController{

  SharedPreferences? prefs;
  String access_token="";
  JobModel ? currentJob;
  BuildContext? buildContext;
  List<JobTasksModel> jobList = <JobTasksModel>[].obs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    access_token= await prefs?.getString(UserPreferences.access_token)??'';

    // getJobList();
  }
  Future<void> setData(JobModel data)async {
    currentJob=data;
    access_token= await prefs?.getString(UserPreferences.access_token)??'';

    getJobList();
  }

  Future<void> getJobList() async {
    access_token= await prefs?.getString(UserPreferences.access_token)??'';

    // Map<String, dynamic>? response = await WebServicesHelper().getJobDetails(access_token,currentJob?.jobID??'');
    //
    // if (response != null) {
    //   JobDetailsResponse jobtaskResponse =
    //   JobDetailsResponse.fromJson(response);
    //   try {
    //     if (jobtaskResponse.status == 200) {
    //       if(jobtaskResponse.jobTasks!=null){
    //         if(jobList.length>0){
    //           jobList.clear();
    //         }
    //         jobList.addAll(jobtaskResponse.jobTasks??[]);
    //       }
    //
    //      // Utils.showCustomTosst(jobtaskResponse.message??'Job fatched successfully!');
    //       // hideProgress(context);
    //       // Get.to(() => DashBord(0, ""));
    //
    //     } else {
    //       // Utils.showCustomTosst("Job list");
    //       // hideProgress(context);
    //     }
    //
    //   } catch (E) {
    //     // hideProgress(context);
    //
    //   }
    // } else {
    //   //hideProgress(context);
    // }

  }

}