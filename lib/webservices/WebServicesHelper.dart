import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../res/AppString.dart';
import '../screen/login/login_screen.dart';
import '../utills/Utils.dart';
import 'ApiUrl.dart';

class WebServicesHelper {
  Future<Map<String, dynamic>?> userSignupApi(
      Map<String, dynamic> param) async {
    //net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    Utils().customPrint("param login$param");
    Utils().customPrint("Api url => ${ApiUrl.apiUrlUserSignup}");
    final response = await http.post(Uri.parse('${ApiUrl.apiUrlUserSignup}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
        });
    Utils().customPrint("response login====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      Utils.showCustomTosstError("Please enter correct email id or password .");
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      Utils.showCustomTosstError("${res["error"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils.showCustomTosstError("${res["error"]}");
      //Fluttertoast.showToast(msg: "Some Error");
      return null;
    }
  }

  /*login apis send otp*/
  Future<Map<String, dynamic>?> getUserLogin(Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("param login$param");
    Utils().customPrint("login  url => ${ApiUrl.apiUrlLoginGetOtp}");
    final response = await http.post(Uri.parse('${ApiUrl.apiUrlLoginGetOtp}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
        });
    Utils().customPrint("response login====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      // Fluttertoast.showToast(msg: "Please enter correct email id or password .");
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  /*login apis send otp*/
  Future<Map<String, dynamic>?> apiLoginOtpVarification(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("param login$param");
    Utils().customPrint("Varify Opt  url => ${ApiUrl.apiLoginOtpVarification}");
    final response = await http.post(
      Uri.parse(ApiUrl.apiLoginOtpVarification),
      body: json.encode(param),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // "BasicAuth": AppString().header_Token,
      },
    );
    Utils().customPrint("response login====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      // Fluttertoast.showToast(msg: "Please enter correct email id or password .");
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // Fluttertoast.showToast(msg: "${res["error"]}");
      //Fluttertoast.showToast(msg: "Some Error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> makeUserActive(
      Map<String, dynamic> param) async {
    Utils().customPrint("param login$param");
    Utils().customPrint("login  url => ${ApiUrl.userAciveDeactive}");
    var Url = ApiUrl.userAciveDeactive +
        param['user_id'] +
        "?activate=" +
        param['activate'];
    final response = await http
        .post(Uri.parse('${Url}'), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "BasicAuth": AppString().header_Token,
    });
    Utils().customPrint("response login====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      // Fluttertoast.showToast(msg: "Please enter correct email id or password .");
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  /*login apis send otp*/
  Future<Map<String, dynamic>?> loginWithPassword(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("param login$param");
    Utils().customPrint("Varify Opt  url =>" +
        "${ApiUrl.apiLoginWithPssword + "?username=" + param['username']}&&password=" +
        param['password']);
    final response = await http.post(
        Uri.parse(
            "${ApiUrl.apiLoginWithPssword + "?username=" + param['username']}&&password=" +
                param['password']),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "BasicAuth": AppString().header_Token,
        });
    Utils().customPrint("response login====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      // Fluttertoast.showToast(msg: "Please enter correct email id or password .");
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    } else {
      final res = json.decode(response.body.toString());

      return res;
    }
  }

/*forgetpassword */
  Future<Map<String, dynamic>?> getForgetpasswordOtp(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("param login$param");
    Utils().customPrint(
        "login  url => ${"${ApiUrl.sendOtpEmailApi + param['to_email']}&user_type=user"}");
    final response = await http.post(
        Uri.parse(
            "${ApiUrl.sendOtpEmailApi + param['to_email']}&user_type=user"),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        });
    Utils().customPrint("response forget====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      // Fluttertoast.showToast(
      //     msg: "Unauthrize".toString());
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["message"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // Fluttertoast.showToast(msg: "${res["error"]}");
      //Fluttertoast.showToast(msg: "Some Error");
      return null;
    }
  }

/*forgetpassword */
  Future<Map<String, dynamic>?> resetPasswordApi(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("param login$param");
    Utils().customPrint("login  url => ${ApiUrl.API_URL_RESET_PASSWORD_OTP}");
    final response = await http.post(
        Uri.parse('${ApiUrl.API_URL_RESET_PASSWORD_OTP}'),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        });
    Utils().customPrint("response forget====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      // Fluttertoast.showToast(
      //     msg: "Unauthrize".toString());
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // Fluttertoast.showToast(msg: "${res["error"]}");
      // Fluttertoast.showToast(msg: "Some Error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> doctorListSearchAPi(
      Map<String, dynamic> param) async {
    // Utils().customPrint("param login$param");
    String apiUrl = "";
    if (param['name'] != "") {
      apiUrl = "${ApiUrl.doctorListSearchAPi}?name=" + param['name'];
    } else {
      apiUrl = ApiUrl.doctorListSearchAPi;
    }

    Utils().customPrint("  url => ${apiUrl}");
    final response = await http.get(Uri.parse(apiUrl),
        //  body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // Fluttertoast.showToast(msg: "${res["error"]}");
      // Fluttertoast.showToast(msg: "Some Error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDoctorTimeSlot(String doctorId,
      String visit_type_id, String date, String access_token) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var ApiPath =
        "${ApiUrl.doctorTimeSlot}$doctorId&visit_type_id=$visit_type_id" +
            "&date=$date";
    Utils().customPrint("login  url => ${ApiPath}");
    final response = await http.get(Uri.parse(ApiPath),
        //  body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${access_token}',
        });
    Utils().customPrint("response ===>${response.body}");
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> createBookingApi(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("param =>$param");
    Utils().customPrint("createBookingApi  url => ${ApiUrl.createBookingApi}");
    final response = await http.post(Uri.parse(ApiUrl.createBookingApi),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        });
    Utils().customPrint("response ===>" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    } else {
      final res = json.decode(response.body.toString());

      return res;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }
    var token = 'Bearer ${param['accessToken']}';
    Utils().customPrint("param =>$param");
    Utils().customPrint("getUserDetails  url => ${ApiUrl.getUserDetailsApi}");
    String url = ApiUrl.getUserDetailsApi + param['user_id'];

    Utils().customPrint("API  url => ${url}");
    final response = await http.get(Uri.parse(url),
        // body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": token,
        });
    Utils().customPrint("response ===>" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils.showCustomTosstError("Session expired");

      return json.decode(response.body.toString());
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    } else {
      final res = json.decode(response.body.toString());

      return res;
    }
  }

  Future<Map<String, dynamic>?> getFamilyMemberList(
      Map<String, dynamic> param) async {
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("param =>$param");
    String url = ApiUrl.getFamillyMemberListApi + param['user_id'];

    Utils().customPrint("API  url => ${url}");
    var token = 'Bearer ${param['access_token']}';
    print("access_token==> ${token}");
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getRelationShipList(
      Map<String, dynamic> param) async {
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("param =>$param");
    String url = ApiUrl.getRelationShipApi;

    Utils().customPrint("API  url => ${url}");
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> deleteFamilyMember(
      Map<String, dynamic> param) async {
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("param =>$param");
    String url = ApiUrl.deleteFamilyMember + param['id'];

    Utils().customPrint("API  url => $url");
    final response = await http.delete(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> addFamilyMember(
      Map<String, dynamic> param) async {
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("param =>$param");
    String url = ApiUrl.addFamilyMemberApi;
    Utils().customPrint("API  url => ${url}");
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> geClinicList(Map<String, dynamic> param) async {
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("param =>$param");
    String url = ApiUrl.getClinicList;
    if (param['name'] != "") {
      url = "${ApiUrl.getClinicList}&name=" + param['name'];
    }

    Utils().customPrint("API  url => $url");
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getHospitalList(
      Map<String, dynamic> param) async {
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("param =>$param");
    String url = ApiUrl.getHospitalList;
    if (param['name'] != "") {
      url = "${ApiUrl.getHospitalList}?name=" + param['name'];
    }

    Utils().customPrint("API  url => $url");
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getPharmacyList(Map<String, dynamic> param) async {
  try {
    var cityId = param['city_id'];
    var lat = param['lat'];
    var lng = param['lng'];
    var storeTagId = (param['store_tag_id'] == null || param['store_tag_id'] == 'null')
        ? ''
        : param['store_tag_id'];
    var storeTypeId = param['store_type_id'];

    // Use StringBuffer for cleaner URL building
    var urlBuffer = StringBuffer(
        "${ApiUrl.getPharmacyList}?vendor_type_id=1&display_type=all&page=1&size=50");

    // Add store type if present
    if (storeTypeId != null && storeTypeId != 0) {
      urlBuffer.write("&store_type_id=$storeTypeId");
    }

    // Latitude/Longitude (optional)
    if (lat != null && lng != null && lat != 0 && lng != 0) {
      urlBuffer.write("&latitude=$lat&longitude=$lng");
    }

    // City filter
    if (cityId != null && cityId != 0) {
      urlBuffer.write("&city_id=$cityId");
    }

    // Store tag filter
    if (storeTagId.isNotEmpty) {
      urlBuffer.write("&store_tag_id=$storeTagId");
    }

    // Range (default 50, but allow override)
    var range = param['range'] ?? 50;
    urlBuffer.write("&range=$range");

    var url = urlBuffer.toString();
    Utils().customPrint("✅ Final Pharmacy API URL => $url");
    Utils().customPrint("Parameters => $param");

    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });

    Utils().customPrint("Response => ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Unauthorized / Forbidden');
      return null;
    } else {
      final res = json.decode(response.body);
      Utils().customPrint('Error Response => $res');
      return res;
    }
  } catch (e) {
    Utils().customPrint("Exception in getPharmacyList => $e");
    return null;
  }
}

// ==============================

  Future<Map<String, dynamic>?> getHomePharmacyList(
      Map<String, dynamic> param) async {
    try {
      // var storeTypeId = param['store_type_id'];
      var lat = param['lat'];
      var lng = param['lng'];
      var storeTagId =
          param['store_tag_id'] == 'null' || param['store_tag_id'] == null
              ? ''
              : param['store_tag_id'];

      // Base URL for Home Pharmacy
      var URL =
          "${ApiUrl.getPharmacyList}?display_only_active=true&page=1&size=50";

      // Latitude/Longitude
      if (lat != null && lng != null && lat != 0 && lng != 0) {
        URL += "&latitude=$lat&longitude=$lng";
      }

      // Range
      URL += "&range=50";

      // Optional filters
      // if (storeTypeId != null && storeTypeId != 0)
      //   URL += "&store_type_id=$storeTypeId";
      // if (storeTagId.isNotEmpty) URL += "&store_tag_id=$storeTagId";

      Utils().customPrint("Home Pharmacy API URL => $URL");
      Utils().customPrint("Parameters => $param");

      final response = await http.get(Uri.parse(URL), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      });

      Utils().customPrint("Response => ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Utils().customPrint('Unauthorized / Forbidden');
        return null;
      } else {
        final res = json.decode(response.body);
        Utils().customPrint('Error Response => $res');
        return res;
      }
    } catch (e) {
      Utils().customPrint("Exception in getHomePharmacyList => $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTagServiceList(
      Map<String, dynamic> param) async {
    Utils().customPrint("login  url => ${ApiUrl.API_STORE_TYPE_TAG_SERVCIES}");
    var Url = ApiUrl.API_STORE_TYPE_TAG_SERVCIES;
    if (param['store_type_id'] != null) {
      Url = ApiUrl.API_STORE_TYPE_TAG_SERVCIES +
          "&store_type_id=" +
          param['store_type_id'];
    }

    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      return res;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getFavoritePharmcyList(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var URL =
        "${ApiUrl.ListFavoritesUrl + param['user_id']}?vendor_type=${ApiUrl.providerTypePharmacy}&list_favorite_vendors=true&current_user=" +
            param['user_id'];
    Utils().customPrint("API  url => ${URL}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.get(Uri.parse(URL),
        //  body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> addFavoritesPharmacy(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("login  url => ${ApiUrl.addFavoritesUrl}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.post(Uri.parse(ApiUrl.addFavoritesUrl),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> deleteFavoritesItemPharmacy(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.DeleteFavoritesItemUrl +
        param['user_id'] +
        "?vendor_type=pharmacy&entity_id=" +
        param['entity_id'] +
        "&current_user=" +
        param['user_id'];
    Utils().customPrint("login  url => ${Url}");
    Utils().customPrint("parm  url => ${param}");

    final response =
        await http.delete(Uri.parse(Url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> getFavoriteMedicanList(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var URL =
        "${ApiUrl.ListFavoritesUrl + param['user_id']}?vendor_type=${ApiUrl.providerTypePharmacy}&list_favorite_vendors=false&is_pharmacy_product=true&pharmacy_product_type=medicine";
    Utils().customPrint("API  url => ${URL}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.get(Uri.parse(URL),
        //  body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> deleteFavoriteMedicine(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.DeleteFavoritesItemUrl +
        param['user_id'] +
        "?vendor_type=pharmacy&pharmacy_product_id=" +
        param['pharmacy_product_id'] +
        "&current_user=" +
        param['user_id'];
    Utils().customPrint("login  url => ${Url}");
    Utils().customPrint("parm  url => ${param}");

    final response =
        await http.delete(Uri.parse(Url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> pharmacyOrderCreate(
      Map<String, dynamic> param) async {
    Utils().customPrint("login  url => ${ApiUrl.pharmacyOrderCreateUrl}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.post(Uri.parse(ApiUrl.pharmacyOrderCreateUrl),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> getPharmacyOrderList(
      Map<String, dynamic> param, var status_type_id) async {
    var userId = param['user_id'];
    var Url =
        "${'${ApiUrl.pharmacyOrderListUrl + 'user_id=' + param['user_id']}&' + status_type_id}&page=1&size=50";
    Utils().customPrint("parm  url => ${param}");
    Utils().customPrint("APi Url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  /*update order status */
  Future<Map<String, dynamic>?> updatePharmacyOrderStatus(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var Url = '${ApiUrl.pharmacyUpdateOrderStatusUrl + param['order_id']}/';
    print("Url==> $Url");
    final response = await http.put(
      Uri.parse(Url),
      body: json.encode(param),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  /*update order status */
  Future<Map<String, dynamic>?> updateLabOrderStatus(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var Url = '${ApiUrl.updateLabOrderStatus + param['order_id']}/';
    print("Url==> $Url");
    final response = await http.put(
      Uri.parse(Url),
      body: json.encode(param),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //category
  Future<Map<String, dynamic>?> getPharmacyCategoryListApi(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var Url = ApiUrl.getPharmacyCategoryList;
    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //sub category
  Future<Map<String, dynamic>?> getPharmacySubCategoryCategoryListAPi(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var Url =
        ApiUrl.getPharmacySubCategoryCategoryList + param['product_type_id'];
    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //get product list
  Future<Map<String, dynamic>?> getMedicanSubcategoryList(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var mainCategory = param['product_type_id'];
    var subCategory = param['product_category_id'];
    var pharmacy_id = param['pharmacy_id'];
    var Url =
        '${"${ApiUrl.getMeidcanSubcategoty + '&product_type_id=' + mainCategory}&pharmacy_id=" + pharmacy_id}&product_category_id=' +
            subCategory;
    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

//get product list
  Future<Map<String, dynamic>?> getProductListApi(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var mainCategory = param['main_category_name'];
    var subCategory = param['sub_category_name'];
    var pharmacy_id = param['pharmacy_id'];
    var sub_category_id = param['sub_category_id'] ?? "";
    var Url = "";
    if (sub_category_id != "null") {
      Url =
          '${ApiUrl.getProductList + '&product_type_id=' + mainCategory}&category_id=' +
              subCategory +
              "&sub_category_id=" +
              sub_category_id;
    } else {
      Url =
          '${ApiUrl.getProductList + '&product_type_id=' + mainCategory}&category_id=' +
              subCategory;
    }

    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //get product list
  Future<Map<String, dynamic>?> getMeidcainProductListApi(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var mainCategory = param['main_category_name'];
    var name = param['name'];

    var Url = "";
    if (name == null || name == "") {
      Url = '${ApiUrl.getProductList + '&product_type_id=' + mainCategory}';
    } else {
      Url =
          '${ApiUrl.getProductList + '&product_type_id=' + mainCategory + "&name=${name}"}';
    }

    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //get product list
  Future<Map<String, dynamic>?> getMeidcainProductListNew(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var name = param['name'];
    var page = param['page'];
    var size = param['size'];

    var Url = '${ApiUrl.getMeidcanProductList}?page=${page}&size=${size}';
    if (name != "") {
      Url =
          '${ApiUrl.getMeidcanProductList}?page=${page}&size=${size}&name=${name}';
    }

    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getGenricMedicianProductList(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var name = param['name'];
    var page = param['page'];
    var size = param['size'];
    var medicine_type = param['medicine_type'];

    var Url =
        '${ApiUrl.getMeidcanProductList}?page=${page}&size=${size}&medicine_type=${medicine_type}';
    if (name != "") {
      Url =
          '${ApiUrl.getMeidcanProductList}?page=${page}&size=${size}&name=${name}&medicine_type=${medicine_type}';
    }

    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //scan center list

  Future<Map<String, dynamic>?> getScanCenterList(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("  url => ${ApiUrl.getScanCenterList}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.get(Uri.parse(ApiUrl.getScanCenterList),
        //  body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> scanCenterOrderCreate(
      Map<String, dynamic> param) async {
    Utils().customPrint("login  url => ${ApiUrl.scanCenterOrderCreateUrl}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.post(Uri.parse(ApiUrl.scanCenterOrderCreateUrl),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> scanTestChooseList(
      Map<String, dynamic> param) async {
    Utils().customPrint("login  url => ${ApiUrl.scanTestChooseListUrl}");
    Utils().customPrint("parm  url => ${param}");
    final response =
        await http.get(Uri.parse(ApiUrl.scanTestChooseListUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  //lab test
  Future<Map<String, dynamic>?> getLabTestListing(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    Utils().customPrint("  url => ${ApiUrl.getLabTestListing}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.get(Uri.parse(ApiUrl.getLabTestListing),
        //  body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      // Fluttertoast.showToast(msg: "${res["error"]}");
      return res;
    }
  }

  Future<Map<String, dynamic>?> bookLabTestOrderCreate(
      Map<String, dynamic> param) async {
    Utils().customPrint("login  url => ${ApiUrl.bookLabTestApi}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.post(Uri.parse(ApiUrl.bookLabTestApi),
        body: json.encode(param),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> getLabTestList(
      Map<String, dynamic> param) async {
    String URL = ApiUrl.getLabTestListUser +
        "?lab_id=${param['lab_id']}&lab_category_id=" +
        param['lab_category_id'];
    Utils().customPrint("URL => ${URL}");
    Utils().customPrint("parm  url => ${param}");
    final response = await http.get(Uri.parse(URL), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> getLabTestPackageList(
      Map<String, dynamic> param) async {
    Utils().customPrint("login  url => ${ApiUrl.getLabTestPackageList}");
    Utils().customPrint("parm  url => ${param}");
    final response =
        await http.get(Uri.parse(ApiUrl.getLabTestPackageList), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> getLabCategoryList(
      Map<String, dynamic> param) async {
    Utils().customPrint("  url => ${ApiUrl.getLabCategoryList}");
    final response =
        await http.get(Uri.parse(ApiUrl.getLabCategoryList), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> getLabSubcategoryList(
      Map<String, dynamic> param) async {
    Utils().customPrint(
        "  url => ${ApiUrl.getLabSubcategoryList + param['category_id']}");
    final response = await http.get(
        Uri.parse(ApiUrl.getLabSubcategoryList + param['category_id']),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['access_token']}',
        });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> fileUpload(String filePath, File images) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }

    Utils().customPrint("TOken $filePath");
    Utils().customPrint(" url => ${ApiUrl.uploadFileUrl + filePath}");
    String url = ApiUrl.uploadFileUrl + filePath;

    var postUri = Uri.parse(url);
    var request = http.MultipartRequest("POST", postUri);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath(
      "file",
      images.path,
      contentType: MediaType('file', 'png'),
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body.toString());
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Utils().customPrint('Login test 46');
        return null;
      } else if (response.statusCode == 400) {
        final res = json.decode(response.body.toString());
        Utils().customPrint('Login test 51');
        return null;
      } else {
        final res = json.decode(response.body.toString());
        return res;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStateList() async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("  url => ${ApiUrl.stateListApi}");
    final response =
        await http.get(Uri.parse('${ApiUrl.stateListApi}'), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "BasicAuth": AppString().header_Token,
    });
    Utils().customPrint("response ====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');

      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      ;
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getCityListAddress(String cityid) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }
    var url = ApiUrl.cityListApi + "?state_id=" + cityid;
    // Utils().customPrint("  url => ${ApiUrl.cityListApi? + cityid}");
    final response = await http.get(Uri.parse('${url}'), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "BasicAuth": AppString().header_Token,
    });
    Utils().customPrint("response ====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');

      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      ;
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getCityList() async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }

    Utils().customPrint("  url => ${ApiUrl.cityListApi}");
    final response =
        await http.get(Uri.parse('${ApiUrl.cityListApi}'), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "BasicAuth": AppString().header_Token,
    });
    Utils().customPrint("response ====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');

      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      ;
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getCityList2(var pagenumber, var size) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   // Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
    //   return null;
    // }
    var URL = "${ApiUrl.cityListApi}?page=${pagenumber}&size=${size}";
    Utils().customPrint("  url => ${URL}");
    final response = await http.get(Uri.parse('${URL}'), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "BasicAuth": AppString().header_Token,
    });
    Utils().customPrint("response ====" + '${response.body}');
    Utils().customPrint("response Code ====" + '${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');

      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      ;
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getAmbulanceTypeApi() async {
    String url = ApiUrl.driverAmbulanceTypeList;
    Utils().customPrint('url =>$url');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> driverNearMeAmbulanceApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.driverNearMeAmbulance;
    Utils().customPrint('url =>$url');
    Utils().customPrint('param =>$param');
    final response =
        await http.put(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> bookCab(Map<String, dynamic> param) async {
    String url = ApiUrl.bookCabApi;
    Utils().customPrint('url =>$url');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> bookingListAPi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.bookingListApi;
    Utils().customPrint('url =>$url');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> placeDetailsApi(var placeId) async {
    // String url = ApiUrl.placeDetailsApi;
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${ApiUrl.mapApiKey}";
    Utils().customPrint('url =>$url');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getBannerList(
      Map<String, dynamic> param) async {
    String url = ApiUrl.bannerListApi + "banner_type=" + param['banner_type'];
    if (param['banner_type'] == "Group Type") {
      url = url + "&store_group_id=" + param['store_group_id'];
    }

    Utils().customPrint('url =>$url');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getBookingStatusList(
      Map<String, dynamic> param) async {
    String url = ApiUrl.bookingStatusList;
    Utils().customPrint('url =>$url');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> submitFeedback(
      Map<String, dynamic> param) async {
    String url = ApiUrl.feedbackUrl;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> sendMessageApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.sendMessage;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> loadMessageHistory(
      Map<String, dynamic> param) async {
    var provider_type = param['provider_type'];
    var user_id = param['user_id'];
    var provider_id = param['provider_id'];
    String url =
        "${ApiUrl.sendMessage}?user_id=${user_id}&provider_id=${provider_id}&provider_type=${provider_type}";
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

/*
* Vital Section Resport
* */

  Future<Map<String, dynamic>?> addVitalApi(Map<String, dynamic> param) async {
    String url = ApiUrl.addVitalReportUrl;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> updateVitalApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.updateVitalReportUrl + param['user_id'];
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.put(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getVitalReportApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getVitalReportUrl + param['user_id'];
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> updateLabReportApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.updateLabReportUrl + param['user_id'];
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.put(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  //Job model started
  Future<Map<String, dynamic>?> getJobTaypeApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getJobTypeUrl;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //Job model started
  Future<Map<String, dynamic>?> getJobcategoryList(
    Map<String, dynamic> param) async {

  String categoryType = param['category_type'];

  String url =
      "${ApiUrl.getJobCategoryUrl}?category_type=$categoryType&order_by=created_at&descending=true&page=1&size=50";

  Utils().customPrint('url =>$url');

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    },
  );

  Utils().customPrint("response ====${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body.toString());
  } else {
    return null;
  }
}
  Future<Map<String, dynamic>?> getJobSubcategoryList(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getJobSubCategoryUrl + param['category_id'];
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getJobListApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getJobListUrl;
    Utils().customPrint('url---------------------------------------------> =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getResumeDetailsApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getResumeDetails + param['user_id'];
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }


  // get list of candidate

 Future<Map<String, dynamic>?> getListOfCandiateResume(
    Map<String, dynamic> param) async {

  String baseUrl = ApiUrl.getResumeListCandedate;

  Map<String, String> query = {};

  void addIfNotEmpty(String key, dynamic value) {
    if (value != null &&
        value.toString().trim().isNotEmpty &&
        value.toString() != "null") {
      query[key] = value.toString();
    }
  }

  addIfNotEmpty("name", param["name"]);
  addIfNotEmpty("preferred_city", param["preferred_city"]);
  addIfNotEmpty("experience", param["experience"]);
  addIfNotEmpty("expected_salary", param["expected_salary"]);
  addIfNotEmpty("category_id", param["category_id"]);
  addIfNotEmpty("subcategory_id", param["subcategory_id"]);
  // addIfNotEmpty("job_type", param["job_type"]);
// 
  if (param["accommodation"] != null) {
    query["accommodation"] = param["accommodation"].toString();
  }

  final uri = Uri.parse(baseUrl).replace(queryParameters: query);

  print("🌍 FILTER URL => $uri");

  final response = await http.get(
    uri,
    headers: {
      "accept": "application/json",
      "Authorization": "Bearer ${param['accessToken']}"
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return null;
}


 // ✅ POST Resume API
  Future<Map<String, dynamic>?> postResumeApi(
      Map<String, dynamic> param) async {
    try {
      String url = ApiUrl.postResumeUrl;

      // 🧹 Clean parameters before sending
      Map<String, dynamic> cleanedParam = _cleanParametersForBackend(param);

      Utils().customPrint('📤 POST URL => $url');
      Utils().customPrint('📦 Cleaned Param => $cleanedParam');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${cleanedParam['accessToken']}',
        },
        body: json.encode(cleanedParam),
      );

      Utils().customPrint("📩 Response Body => ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Utils().customPrint("❌ Auth Error: ${response.statusCode}");
        return null;
      } else {
        Utils().customPrint("⚠️ Server Error: ${response.statusCode}");
        return json.decode(response.body);
      }
    } catch (e) {
      Utils().customPrint("💥 Exception in postResumeApi: $e");
      return null;
    }
  }

  // ✅ PUT Resume API (Update)
  Future<Map<String, dynamic>?> updateResumeApi(
      Map<String, dynamic> param, String resumeId) async {
    try {
      String baseUrl = ApiUrl.updateResumeUrl;
      String url =
          baseUrl.endsWith('/') ? "$baseUrl$resumeId/" : "$baseUrl/$resumeId/";

      Utils().customPrint('📤 PUT URL => $url');
      Utils().customPrint('📦 Param => $param');

      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${param['accessToken']}',
        },
        body: json.encode(param),
      );

      // Handle redirect manually
      if (response.statusCode == 307 || response.statusCode == 308) {
        final newUrl = response.headers['location'];
        if (newUrl != null && newUrl.isNotEmpty) {
          Utils().customPrint('🔁 Redirected to: $newUrl');
          final redirected = await http.put(
            Uri.parse(newUrl),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": 'Bearer ${param['accessToken']}',
            },
            body: json.encode(param),
          );
          return _parseResponse(redirected);
        }
      }

      return _parseResponse(response);
    } catch (e) {
      Utils().customPrint("💥 Exception in updateResumeApi: $e");
      return null;
    }
  }

  Map<String, dynamic>? _parseResponse(http.Response response) {
    Utils().customPrint("📩 Response Body => ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    Utils().customPrint("! Server Error: ${response.statusCode}");
    if (response.body.isNotEmpty) {
      return json.decode(response.body);
    }
    return null;
  }
// ----------------------------------->
/// Get jobs posted by current user
Future<Map<String, dynamic>?> getMyPostedJobsApi(Map<String, dynamic> param) async {
  try {
    // You need to create this API endpoint with your backend team
    // It should return jobs where created_by = current user
    final uri = Uri.parse("${ApiUrl}admin/jobs/job-provider/my-jobs/").replace(
      queryParameters: {
        'user_id': param['user_id'].toString(),
        'page': param['page']?.toString() ?? '1',
        'size': param['size']?.toString() ?? '50',
      },
    );

    Utils().customPrint('url ========> ${uri.toString()}');
    Utils().customPrint('param => $param');

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['accessToken']}',
      },
    );

    Utils().customPrint("response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint("Authentication error: ${response.statusCode}");
      return null;
    } else {
      Utils().customPrint("API error: ${response.statusCode}");
      return json.decode(response.body);
    }
  } catch (e) {
    Utils().customPrint("Exception in getMyPostedJobsApi: $e");
    return null;
  }
}

/// Get applied jobs by job ID (you already have this)
Future<Map<String, dynamic>?> getListAppliedJobByJobId(Map<String, dynamic> param) async {
  try {
    final uri = Uri.parse(ApiUrl.getListAppliedJob).replace(
      queryParameters: {
        'job_id': param['job_id'].toString(),
        'page': param['page']?.toString() ?? '1',
        'size': param['size']?.toString() ?? '50',
      },
    );

    Utils().customPrint('url ========> ${uri.toString()}');
    Utils().customPrint('param => $param');

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['accessToken']}',
      },
    );

    Utils().customPrint("response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint("Authentication error: ${response.statusCode}");
      return null;
    } else {
      Utils().customPrint("API error: ${response.statusCode}");
      return json.decode(response.body);
    }
  } catch (e) {
    Utils().customPrint("Exception in getListAppliedJobByJobId: $e");
    return null;
  }
}

  // --------------------------

  // ✅ Helper: Clean Parameters Before Sending
  Map<String, dynamic> _cleanParametersForBackend(Map<String, dynamic> param) {
    Map<String, dynamic> cleaned = Map<String, dynamic>.from(param);

    const List<String> arrayFields = [
      'languages',
      'skills',
      'job_sub_speciality',
      'certificate',
      'resume',
    ];

    for (String field in arrayFields) {
      if (cleaned.containsKey(field) && cleaned[field] is List) {
        List fieldList = cleaned[field];
        if (fieldList.isEmpty) {
          switch (field) {
            case 'languages':
              cleaned[field] = ['English'];
              break;
            case 'skills':
              cleaned[field] = ['Communication'];
              break;
            case 'job_sub_speciality':
              cleaned[field] = ['General'];
              break;
            default:
              cleaned[field] = [{}];
          }
        }
      }
    }

    // ✅ Ensure file-type fields are maps, not null
    if (cleaned['photo'] == null || cleaned['photo'] is! Map) {
      cleaned['photo'] = {};
    }
    if (cleaned['short_video'] == null || cleaned['short_video'] is! Map) {
      cleaned['short_video'] = {};
    }

    return cleaned;
  }

  Future<Map<String, dynamic>?> PostapplyJobApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.applyJobUrl;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  /*Lab bookign List */

  Future<Map<String, dynamic>?> getLabOrderList(
      Map<String, dynamic> param, var status_type_id) async {
    var userId = param['user_id'];
    var Url =
        "${'${ApiUrl.bookLabTestApi + '?user_id=' + param['user_id']}&' + status_type_id}&page=1&size=50";
    Utils().customPrint("parm  url => ${param}");
    Utils().customPrint("APi Url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

// Address management

  Future<Map<String, dynamic>?> addUserAddress(
      Map<String, dynamic> param) async {
    var userId = param['user_id'];
    var Url = ApiUrl.addUserAddressUrl;

    final response =
        await http.post(Uri.parse(Url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //get user address listing
  Future<Map<String, dynamic>?> getUserAddressListing(
      Map<String, dynamic> param) async {
    var userId = param['user_id'];
    var Url = ApiUrl.userAddressListingUrl + userId;
    Utils().customPrint("parm  url => ${param}");
    Utils().customPrint("APi Url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      Utils().customPrint('Login test 51');
      return res;
    }
  }

  Future<Map<String, dynamic>?> getBusinessTypeCategory(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_BUSINESS_TYPE_CATEGORY+"&business_type="+param['business_type'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getStoreTypeCategory(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_STORE_TYPE_CATEGORY +
        "?store_group_id=" +
        param['store_group_id'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }


  // show all store type 
  Future<Map<String, dynamic>?> getAllStoreTypes({
  required String accessToken,
}) async {
  final String url = ApiUrl.API_STORE_TYPE_CATEGORY;

  Utils().customPrint("url => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
  );

  Utils().customPrint("response => ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    Utils().customPrint("Unauthorized");
    return null;
  } else {
    return json.decode(response.body);
  }
}


  Future<Map<String, dynamic>?> getMainCatgory(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_MAIN_CATEGORY + param['store_type_id'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getSubcatgory(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_SUB_CATEGORY + param['product_category_id'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getChildSubCategory(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_CHILD_SUB_CATEGORY + param['product_sub_category_id'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getProductList(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    // var Url="${ApiUrl.API_PRODUCT_LIST+param['category_id']+"&sub_category_id="+param['sub_category_id']}&store_id="+param['store_id'];
    var Url = ApiUrl.API_PRODUCT_LIST + "store_id=" + param['store_id'];
    if (param['category_id'] != null && param['category_id'] != "") {
      Url = "$Url&category_id=" + param['category_id'];
    }
    if (param['sub_category_id'] != null && param['sub_category_id'] != "") {
      Url = "$Url&sub_category_id=" + param['sub_category_id'];
    }

    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  //pharmay Details
  Future<Map<String, dynamic>?> getStoreDetails(
      Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var Url = ApiUrl.API_STORE_DETAILS + param['store_id'];
    Utils().customPrint("Url ==>$Url");
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> createLog(Map<String, dynamic> param) async {
    Utils().customPrint("param ==>$param");
    var Url = ApiUrl.API_AUDIT_LOG_CREATE;
    Utils().customPrint("Url ==>$Url");
    final response = await http.post(
      body: json.encode(param),
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );
    Utils().customPrint("response Code ====${response.statusCode}");
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getStoreTypeCategorySearch(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_STORE_TYPE_CATEGORY + "?name=" + param['name'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getServicesListGrocery(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url =
        ApiUrl.API_SERVICES_LIST + "?store_type_id=" + param['store_type_id'];
    // var Url=ApiUrl.API_SERVICES_LIST;
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> getServicesListByStoreId(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url =
        ApiUrl.API_SERVICES_LIST_BY_STORE + param['store_id'] + "/services/";
    // var Url=ApiUrl.API_SERVICES_LIST;
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> addIntrestedServicesByUser(
      Map<String, dynamic> param) async {
    print(param.toString());
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    // var Url=ApiUrl.API_SERVICES_LIST+"?store_type_id="+param['store_type_id'];
    var Url = ApiUrl.API_INTRESTED_SERVCIES;
    Utils().customPrint("url => ${Url}");
    final response =
        await http.post(Uri.parse(Url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

// get intrested services
  Future<Map<String, dynamic>?> getIntersetedServices(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.GET_API_INTRESTED_SERVCIES;
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }
//   Markte place Api started from here

// Market place product add
  // Add this method to your WebServicesHelper class


  
Future<Map<String, dynamic>?> getMarketPlaceSuperCategory(
    Map<String, dynamic> param) async {

  String url = ApiUrl.API_MP_SUPERCATEGORY_LIST;
  
  Utils().customPrint("GET market place super category  type => $url");
  
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${param['access_token']}",
      },
    );

    print("Type API Status: ${response.statusCode}");
    print("Type API Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Parsed data structure: ${data.keys}");
      return data;
    } else {
      print("Failed to load types. Status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error in API call: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> PostMarketPlaceProduct(
  String url, 
  Map<String, dynamic> data, 
  {Map<String, String>? headers}
) async {
  try {
    print("Making POST request to: $url");
    print("Request data: $data");
    
    final response = await http.post(
      Uri.parse(url),
      headers: headers ?? {},
      body: json.encode(data),
    );
    
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Request failed with status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error in POST request: $e");
    return null;
  }
}
// post message for market place product 
Future<Map<String, dynamic>?> postMarketPlaceMessage(
    Map<String, dynamic> param) async {

  String url =
      "${ApiUrl.POST_MARKET_PLACE_PRODUCT_MESSAGE}?product_id=${param['product_id']}&sender_id=${param['sender_id']}&receiver_id=${param['receiver_id']}&message=${param['message']}";

  Utils().customPrint('FINAL URL => $url');

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    },
  );

  Utils().customPrint("response ==== '${response.body}'");
  Utils().customPrint("status Message code ==== ${response.statusCode}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return json.decode(response.body);
  }
}


// Get Market Place Product
 
Future<Map<String, dynamic>?> getMarketPlaceProduct(
    Map<String, dynamic> params) async {

  var baseUrl = ApiUrl.Get_Product_Market_Place;

  // base query
  final query = <String, String>{
  "return_all": params["return_all"] ?? "false",
  "display_type": params["display_type"] ?? "active",
  "order_by": params["order_by"] ?? "created_at",
  "descending": params["descending"] ?? "true",
  "page": (params["page"] ?? "1").toString(),
  "size": (params["size"] ?? "50").toString(),
};

// send title only if not empty
if (params["title"] != null &&
    params["title"].toString().trim().isNotEmpty) {
  query["title"] = params["title"];
}

// send hashtag only if not empty
if (params["hashtag"] != null &&
    params["hashtag"].toString().trim().isNotEmpty) {
  query["hashtag"] = params["hashtag"];
}

  // 👇 OPTIONAL category filter (sirf jab bhejo)
  if (params["mp_category_id"] != null &&
      params["mp_category_id"].toString().isNotEmpty) {
    query["mp_category_id"] = params["mp_category_id"].toString();
  }

  if (params["mp_sub_category_id"] != null &&
      params["mp_sub_category_id"].toString().isNotEmpty) {
    query["mp_sub_category_id"] = params["mp_sub_category_id"].toString();
  }

  Uri uri = Uri.parse(baseUrl).replace(queryParameters: query);

  print("🌐 Final URL => $uri");

  final response = await http.get(
    uri,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${params["access_token"]}',
    },
  );

  print("📡 Response status => ${response.statusCode}");
  print("📡 Response body   => ${response.body}");

  return json.decode(response.body);
}
// Add Interset Market Place 
Future<Map<String, dynamic>?> postMarketPlaceInterest(
    Map<String, dynamic> param) async {

  String url =
      "${ApiUrl.POST_MARKET_PLACE_INTERESTED}?user_id=${param['user_id']}&product_id=${param['product_id']}";

  Utils().customPrint('FINAL URL => $url');

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    },
  );

  Utils().customPrint("response ==== '${response.body}'");
  Utils().customPrint("status code ==== ${response.statusCode}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return json.decode(response.body);
  }
}
// get market place interest
Future<Map<String, dynamic>?> getMarketPlaceInterest(Map<String, dynamic> param) async {
  // FIXED: Proper URL parameter construction
  String url = "${ApiUrl.GET_MARKET_PLACE_INTERESTED}${param['user_id']}";

  Utils().customPrint('FINAL URL => $url');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${param['accessToken']}',
      },
    );

    Utils().customPrint("response ==== '${response.body}'");
    Utils().customPrint("status code ==== ${response.statusCode}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Utils().customPrint("❌ API Error: ${response.statusCode} - ${response.body}");
      return {
        "status": response.statusCode,
        "message": "Failed to fetch data",
        "detail": response.body
      };
    }
  } catch (e) {
    Utils().customPrint("❌ Network Error: $e");
    return {
      "status": 500,
      "message": "Network error: $e"
    };
  }
}

// market place for petch api  
Future<Map<String, dynamic>?> petchProductById(Map<String, dynamic> param) async {
  String url = "${ApiUrl.PETCH_PRODUCT_BY_ID}/${param['product_id']}/?activate=${param['activate']}";

  Utils().customPrint('ACTIVATE/DEACTIVATE API URL => $url');

  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${param['accessToken']}',
      },
    );

    Utils().customPrint("Product Activaet response ==== '${response.body}'");
    Utils().customPrint("Product Activate  status code ==== ${response.statusCode}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Utils().customPrint("❌ Product Activate/Deactivate API Error: ${response.statusCode}");
      return {
        "status": response.statusCode,
        "message": "Failed to fetch product Activate/Deactivate"
      };
    }
  } catch (e) {
    Utils().customPrint("❌ Product Activate/Deactivate Network Error: $e");
    return {
      "status": 500,
      "message": "Network error: $e"
    };
  }
}



// get market  place product by id 

Future<Map<String, dynamic>?> getProductById(Map<String, dynamic> param) async {
  String url = "${ApiUrl.GET_PRODUCT_BY_ID}?product_id=${param['product_id']}";

  Utils().customPrint('PRODUCT DETAIL URL => $url');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${param['accessToken']}',
      },
    );

    Utils().customPrint("Product detail response ==== '${response.body}'");
    Utils().customPrint("Product detail status code ==== ${response.statusCode}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Utils().customPrint("❌ Product detail API Error: ${response.statusCode}");
      return {
        "status": response.statusCode,
        "message": "Failed to fetch product details"
      };
    }
  } catch (e) {
    Utils().customPrint("❌ Product detail Network Error: $e");
    return {
      "status": 500,
      "message": "Network error: $e"
    };
  }
}


// Update market place product 

Future<Map<String, dynamic>?> updateMarketPlaceProduct(
    Map<String, dynamic> param) async {

  Utils().customPrint("PUT PARAM ==> $param");

  // Validate ID
  if (param['product_id'] == null) {
    print("❌ Error: product_id is missing");
    return null;
  }

  // Build URL
  String url = "${ApiUrl.Put_Product_Market_PLACE}${param['product_id']}/";

  print("PUT URL ==> $url");

  final response = await http.put(
    Uri.parse(url),
    body: json.encode(param),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${param['access_token']}",
    },
  );

  Utils().customPrint("PUT Response Code: ${response.statusCode}");
  Utils().customPrint("PUT Response Body: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    return json.decode(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    return null;
  } else {
    return json.decode(response.body);
  }
}

  Future<Map<String, dynamic>?> getMPBrandList(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_MP_BRAND_LIST;
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }
  // 


  // ----->GET Tag List 
  Future<Map<String, dynamic>?> getTagList(Map<String, dynamic> param) async {
    print("🔥 getTagList() CALLED!");
  String url = ApiUrl.getListJobTags; 
  // example: ...job-tag-list/?display_type=all&order_by=created_at&descending=true&page=1&size=50

  // Add category_id
  if (param['category_id'] != null && param['category_id'] != '') {
    url = "$url&category_id=${param['category_id']}";
  }

  // Add subcategory_id
  if (param['subcategory_id'] != null && param['subcategory_id'] != '') {
    url = "$url&subcategory_id=${param['subcategory_id']}";
  }

  Utils().customPrint("🔥 Final TagList URL => $url");
  print("Final TagList URL========================= => $url");


  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${param['access_token']}",
    },
  );

  Utils().customPrint("🔥 TagList Response => ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  return null;
}


Future<Map<String, dynamic>?> getMpcategoryList(
    Map<String, dynamic> param) async {

  var baseUrl = ApiUrl.API_MP_CATEGORY_LIST;

  String finalUrl = baseUrl;

  // ⭐ if super category filter comes → build query
  if (param['super_category_id'] != null &&
      param['super_category_id'].toString().isNotEmpty) {

    finalUrl =
        "$baseUrl?super_category_id=${param['super_category_id']}"
        "&order_by=created_at"
        "&descending=true"
        "&display_type=active"
        "&page=1"
        "&size=50";
  }

  Utils().customPrint("CATEGORY URL => $finalUrl");

  try {
    final response = await http.get(
      Uri.parse(finalUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['access_token']}',
      },
    );

    Utils().customPrint("CATEGORY RESPONSE => ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } 
    else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } 
    else {
      return json.decode(response.body.toString());
    }
  } catch (e) {
    Utils().customPrint("CATEGORY ERROR => $e");
    return null;
  }
}


  Future<Map<String, dynamic>?> getMpSubcatgory(
      Map<String, dynamic> param) async {
    //net connectivity check
    // if (!await InternetConnectionChecker().hasConnection) {
    //   return null;
    // }
    var Url = ApiUrl.API_MP_SUB_CATEGORY_LIST + param['category_id'];
    Utils().customPrint("url => ${Url}");
    final response = await http.get(Uri.parse(Url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['access_token']}',
    });
    Utils().customPrint("response ===>" + '${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }

  Future<Map<String, dynamic>?> postJobByProviderApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.postJobByProviderUrl;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  /// Get Doctors List
  Future<Map<String, dynamic>?> getDoctorsList(
      Map<String, dynamic> param) async {
    String url = ApiUrl.API_DOCTORS_LIST + "?store_id=" + param['store_id'];
    Utils().customPrint('url =>$url');
    Utils().customPrint('param =>$param');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${param['accessToken']}',
      },
    );

    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      return json.decode(response.body.toString());
    }
  }

  // store Job Module 

  Future<Map<String, dynamic>?> getJobyStoreApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getJobByStoreApi ;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      return res;
    }
  }
  Future<Map<String, dynamic>?> PostapplyJobStoreApi(
      Map<String, dynamic> param) async {
    String url = ApiUrl.applyJobStoreUrl;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }


  // store video 

   Future<Map<String, dynamic>?> getStoreVideo(
    Map<String, dynamic> param) async {

  if (!await InternetConnectionChecker().hasConnection) {
    return null;
  }

  String url = ApiUrl.getStoreVideo;

  final storeId = param['store_id'];

  if (storeId != null &&
      storeId.toString().isNotEmpty &&
      storeId.toString() != "null") {
    // ✅ Store specific videos
    url +=
        "?store_id=$storeId"
        "&display_type=active"
        "&page=1"
        "&size=20";
  } else {
    // ✅ Home page → ALL store videos
    url +=
        "?display_type=active"
        "&page=1"
        "&size=20";
  }

  Utils().customPrint("VIDEO URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${param['access_token']}",
    },
  );

  Utils().customPrint("VIDEO RESPONSE => ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return null;
  }
}


  Future<Map<String, dynamic>?> getAllStoreVideoCategoury(
      Map<String, dynamic> param) async {
    Utils().customPrint("categoury  url => ${ApiUrl.getVideoCategoury}");
    var Url = ApiUrl.getVideoCategoury;
   
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      return res;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

   Future<Map<String, dynamic>?> postStoreReactionVideo(
      Map<String, dynamic> param) async {
    String url = ApiUrl.postStoreVideoReaction;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }

  Future<Map<String, dynamic>?> getAllStoreVideoDescreptionDetail(
      Map<String, dynamic> param) async {
    Utils().customPrint("categoury   url => ${ApiUrl.getStoreVideoTotalReaction}");
    var Url = ApiUrl.getStoreVideoTotalReaction+param['video_id'];
   
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      return res;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }



// get store offer 
Future<Map<String, dynamic>?> getStoreOffer(
    Map<String, dynamic> param) async {

  String url = ApiUrl.getStoreOffer;

  if (param['store_id'] != null) {
    // 👉 STORE PAGE (specific store)
    url +=
        "?store_id=${param['store_id']}&display_type=active"
        "&order_by=created_at"
        "&descending=true"
        "&page=1"
        "&size=50";
  } else {
    // 👉 HOME PAGE (all stores)
    url +=
        "?display_type=all"
        "&order_by=created_at"
        "&descending=true"
        "&page=1"
        "&size=10";
  }

  Utils().customPrint("GET OFFER URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${param['access_token']}",
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  return null;
}


Future<Map<String, dynamic>?> getStoreOfferSubCategory(
    Map<String, dynamic> param) async {

  // read category id from param
  String categoryId = param["offer_category_id"].toString();

  // build url dynamically
  String url =
      "${ApiUrl.getStoreOfferSubCategory}?offer_category_id=$categoryId";

  Utils().customPrint("offer SubCategory URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("response ====${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body.toString());
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    Utils().customPrint('Login test 46');
    return null;
  } else {
    return json.decode(response.body.toString());
  }
}



Future<Map<String, dynamic>?> getStoreOfferCategory(
      Map<String, dynamic> param) async {
    Utils().customPrint("customer event categoury  url => ${ApiUrl.getStoreOfferCategory}");
    var Url = ApiUrl.getStoreOfferCategory;
   
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      return res;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }



// customer event mangemnt api 

Future<Map<String, dynamic>?> getCustomerEventCategory(
      Map<String, dynamic> param) async {
    Utils().customPrint("customer event categoury  url => ${ApiUrl.getCustomerEventCategory}");
    var Url = ApiUrl.getCustomerEventCategory;
   
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Utils().customPrint('Login test 46');
      return null;
    } else if (response.statusCode == 400) {
      final res = json.decode(response.body.toString());
      return res;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }


Future<Map<String, dynamic>?> getCustomerEventSubCategory(
    Map<String, dynamic> param) async {

  // read category id from param
  String categoryId = param["event_category_id"].toString();

  // build url dynamically
  String url =
      "${ApiUrl.getCustomerEventSubCategory}&event_category_id=$categoryId";

  Utils().customPrint("SubCategory URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("response ====${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body.toString());
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    Utils().customPrint('Login test 46');
    return null;
  } else {
    return json.decode(response.body.toString());
  }
}



Future<Map<String, dynamic>?> getCustomerEvent(
    Map<String, dynamic> param) async {

  String baseUrl = ApiUrl.getCustomerEvent;
  List<String> queryList = [];

  if (param['user_id'] != null &&
      param['user_id'].toString().isNotEmpty) {
    queryList.add("user_id=${param['user_id']}");
  }

  // NEW FILTERS
  if (param['title'] != null &&
      param['title'].toString().isNotEmpty) {
    queryList.add("title=${Uri.encodeComponent(param['title'])}");
  }

  if (param['hashtag'] != null &&
      param['hashtag'].toString().isNotEmpty) {
    queryList.add("hashtag=${Uri.encodeComponent(param['hashtag'])}");
  }

  queryList.addAll([
    "display_type=all",
    "return_all=false",
    "order_by=created_at",
    "descending=true",
    "page=1",
    "size=50",
  ]);

  final url = "$baseUrl?${queryList.join("&")}";
  print("FINAL URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    },
  );

  return json.decode(response.body);
}

Future<Map<String, dynamic>?> postCustomerEvent(
      Map<String, dynamic> param) async {
    String url = ApiUrl.postCustomerEvent;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }



Future<Map<String, dynamic>?> registerCustomerEvent(
      Map<String, dynamic> param) async {
    String url = ApiUrl.registerCustomerEvent;
    Utils().customPrint('url =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }


Future<Map<String, dynamic>?> getRegisterationCustomer({
  required int eventId,
  required int userId,
  int page = 1,
  int size = 50,
}) async {
  final uri = Uri.parse(ApiUrl.getRegisterCustomerEvent).replace(
    queryParameters: {
      "event_id": eventId.toString(),
      "user_id": userId.toString(),
      "page": page.toString(),
      "size": size.toString(),
    },
  );

  Utils().customPrint("Register API URL => $uri");

  final response = await http.get(
    uri,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("Response => ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return json.decode(response.body);
  }
}





Future<Map<String, dynamic>?> getInternshipProgramSuperCategory(Map<String, dynamic> param) async {
  Utils().customPrint("Intership program super category Get api Url  url => ${ApiUrl.getInternshipprogramsupercategory}");
  var Url = ApiUrl.getInternshipprogramsupercategory;
  
  final response = await http.get(
    Uri.parse(Url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );
  Utils().customPrint("response ====${response.body}");
  if (response.statusCode == 200) {
    return json.decode(response.body.toString());
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    Utils().customPrint('Login test 46');
    return null;
  } else if (response.statusCode == 400) {
    final res = json.decode(response.body.toString());
    return res;
  } else {
    final res = json.decode(response.body.toString());
    return res;
  }
}


Future<Map<String, dynamic>?> getInternshipProgramCategory(
    Map<String, dynamic> param) async {

  String url = ApiUrl.getstoreinternshipProgramCategory;

  /// ✅ ADD QUERY PARAM
  if (param.isNotEmpty) {
    final query = Uri(queryParameters: param).query;
    url = "$url?$query";
  }

  Utils().customPrint("Final URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("response ====${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    return null;
  } else {
    return json.decode(response.body);
  }
}
  

  
Future<Map<String, dynamic>?> getInternshipProgramSubcategory(
    Map<String, dynamic> param) async {

  String url = ApiUrl.getstoreinternshipProgramsubcategory;

  // Attach query parameters
  if (param.isNotEmpty) {
    url += "?category_id=${param['category_id']}";
  }

  Utils().customPrint("SubCategory URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("response => ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    return null;
  } else {
    return json.decode(response.body);
  }
}



  Future<Map<String, dynamic>?> getInternshipProgram(
    Map<String, dynamic> param) async {

  String url =
      "${ApiUrl.getstoreinternshiProgram}"
     
      "?display_type=active&created_at&descending=true&page=1&size=50";


  Utils().customPrint("GET Intternship Program URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${param['access_token']}",
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  return null;
}


Future<Map<String, dynamic>?> postApplyInternshipProgram(
      Map<String, dynamic> param) async {
    String url = ApiUrl.getapplyinternship;
    Utils().customPrint('apply internship url  =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }


  Future<Map<String, dynamic>?> getSkillProgramSuperCategory(Map<String, dynamic> param) async {
  Utils().customPrint("skill program supercategory Get api Url  url => ${ApiUrl.getskillsupercategory}");
  var Url = ApiUrl.getskillsupercategory;
  
  final response = await http.get(
    Uri.parse(Url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );
  Utils().customPrint("response ====${response.body}");
  if (response.statusCode == 200) {
    return json.decode(response.body.toString());
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    Utils().customPrint('Login test 46');
    return null;
  } else if (response.statusCode == 400) {
    final res = json.decode(response.body.toString());
    return res;
  } else {
    final res = json.decode(response.body.toString());
    return res;
  }
}








  Future<Map<String, dynamic>?> getSkillProgramCategory(
    Map<String, dynamic> param) async {

  String baseUrl = ApiUrl.getskillprogramcategory;

  // 🔥 SAFE + CLEAN QUERY PARAM BUILD
  Uri uri = Uri.parse(baseUrl).replace(
    queryParameters: param.isNotEmpty
        ? param.map((key, value) =>
            MapEntry(key, value.toString()))
        : null,
  );

  Utils().customPrint(
      "skill program category URL => $uri");

  final response = await http.get(
    uri,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("response === ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 401 ||
      response.statusCode == 403) {
    return null;
  } else {
    return json.decode(response.body);
  }
}
  
Future<Map<String, dynamic>?> getSkillProgramSubcategory(
    Map<String, dynamic> param) async {

  String url = ApiUrl.getskillprogramsubcategory;

  // Attach query parameters
  if (param.isNotEmpty) {
    url += "?category_id=${param['category_id']}";
  }

  Utils().customPrint("SubCategory URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );

  Utils().customPrint("response => ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    return null;
  } else {
    return json.decode(response.body);
  }
}


Future<Map<String, dynamic>?> getSkillProgramType(
    Map<String, dynamic> param) async {

  String url = ApiUrl.getskillprogramtype;
  
  Utils().customPrint("GET skill program type => $url");
  
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${param['access_token']}",
      },
    );

    print("Type API Status: ${response.statusCode}");
    print("Type API Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Parsed data structure: ${data.keys}");
      return data;
    } else {
      print("Failed to load types. Status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error in API call: $e");
    return null;
  }
}



Future<Map<String, dynamic>?> getSkillProgram(
    Map<String, dynamic> param) async {
  
  // Build the base URL
  String baseUrl = ApiUrl.getskillprogram;
  
  // Create a list to hold query parameters
  List<String> queryParams = [];
  
  // Add required parameters
  
  queryParams.add("order_by=created_at");
  queryParams.add("descending=true");
  queryParams.add("page=1");
  queryParams.add("size=50");
  
  // Add filter parameters if they exist

  if (param.containsKey('category_id') && param['category_id'] != null && param['category_id'] != 0) {
    queryParams.add("category_id=${param['category_id']}");
  }
  
  if (param.containsKey('subcategory_id') && param['subcategory_id'] != null && param['subcategory_id'] != 0) {
    queryParams.add("subcategory_id=${param['subcategory_id']}");
  }
  
  if (param.containsKey('type_id') && param['type_id'] != null && param['type_id'] != 0) {
    queryParams.add("type_id=${param['type_id']}");
  }
  
  if (param.containsKey('program_mode') && param['program_mode'] != null && param['program_mode'].toString().isNotEmpty) {
    queryParams.add("program_mode=${param['program_mode']}");
  }
  
  if (param.containsKey('title') && param['title'] != null && param['title'].toString().isNotEmpty) {
    queryParams.add("title=${Uri.encodeComponent(param['title'])}");
  }
  
  if (param.containsKey('min_price') && param['min_price'] != null && param['min_price'] > 0) {
    queryParams.add("min_price=${param['min_price']}");
  }
  
  if (param.containsKey('max_price') && param['max_price'] != null && param['max_price'] > 0) {
    queryParams.add("max_price=${param['max_price']}");
  }
  
  if (param.containsKey('duration') && param['duration'] != null && param['duration'].toString().isNotEmpty) {
    queryParams.add("duration=${Uri.encodeComponent(param['duration'])}");
  }
  
  if (param.containsKey('fees_type') && param['fees_type'] != null && param['fees_type'].toString().isNotEmpty) {
    queryParams.add("fees_type=${param['fees_type']}");
  }
  
  if (param.containsKey('display_type') && param['display_type'] != null && param['display_type'].toString().isNotEmpty) {
    queryParams.add("display_type=${param['display_type']}");
  }
  
  // Join all query parameters
  String url = "$baseUrl?${queryParams.join('&')}";
  
  Utils().customPrint("GET Skill Program URL => $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${param['access_token']}",
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  return null;
}



Future<Map<String, dynamic>?> postApplySkillProgram(
      Map<String, dynamic> param) async {
    String url = ApiUrl.appliedskillprogram;
    Utils().customPrint('apply skill program url  =>$url');
    Utils().customPrint('parma =>$param');
    final response =
        await http.post(Uri.parse(url), body: json.encode(param), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${param['accessToken']}',
    });
    Utils().customPrint("response ====${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    } else {
      final res = json.decode(response.body.toString());
      // return
      return res;
    }
  }











}
