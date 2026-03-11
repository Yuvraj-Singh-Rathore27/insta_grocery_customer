import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/customer_event_model.dart';
import '../webservices/WebServicesHelper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../model/file_model.dart';
import '../webservices/ApiUrl.dart';
import '../model/responsemodel/FileUploadResponseModel.dart';
import '../utills/Utils.dart';
import '../screen/dialog/helperProgressBar.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import '../preferences/UserPreferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';



import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screen/side_menu/event_managment/event_detail_screen_all.dart';








class CustomerEventController extends GetxController {
 // ================= TEXT CONTROLLERS =================
TextEditingController titleController = TextEditingController();
TextEditingController organizerController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController hashtagController=TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController timeController = TextEditingController();
// end date  and time 
TextEditingController endDateController=TextEditingController();
TextEditingController endTimeController=TextEditingController();


// ================= IMAGE =================
var pickedImage = Rxn<File>(); // selected event image

// IMAGE FILE DATA (like resume)
RxList<FileModel> eventImageList = <FileModel>[].obs;
PickedFile? pickedFile;


late GetStorage store;
String userId = '';
String accessToken = '';

RxBool isRegistering = false.obs;
RxList<int> registeredEventIds = <int>[].obs;


RxList<CustomerEventModel> allEvents = <CustomerEventModel>[].obs;
RxList<CustomerEventModel> myEvents = <CustomerEventModel>[].obs;

RxMap<int, List<EventUser>> eventRegisteredUsers =
    <int, List<EventUser>>{}.obs;

    List<EventUser> usersForEvent(int eventId) {
  return eventRegisteredUsers[eventId] ?? [];
}






// ================= EVENT FORM VALUES =================
var feeType = "free".obs;
var price = 0.0.obs;
var latitude = "".obs;
var longitude = "".obs;


RxBool isSearchOpen = false.obs;
TextEditingController searchController = TextEditingController();

RxList<CustomerEventModel> filteredEvents = <CustomerEventModel>[].obs;


RxInt selectedCategoryId = 0.obs;

// ================= LOADING STATES =================
RxBool isLoading = false.obs;
RxBool isLoadingCategory = false.obs;
RxBool isPostingEvent = false.obs;
RxBool isFilterOpen = false.obs;
RxBool isFilterOpen1 = false.obs;


// ================= DATA LISTS =================
RxList<EventCategory> categories = <EventCategory>[].obs;
// RxList<EventSubCategory> subCategories = <EventSubCategory>[].obs;

RxList<EventUser> user_detail=<EventUser>[].obs;

RxMap<MarkerId, Marker> eventMarkers = <MarkerId, Marker>{}.obs;
RxList<CustomerEventModel> nearbyEvents = <CustomerEventModel>[].obs;



RxList<EventCategory> subCategories = <EventCategory>[].obs;
RxInt selectedSubCategoryId = 0.obs;
RxBool isLoadingSubCategory = false.obs;
 

  @override
  void onInit() {
    print("🟡 CustomerEventController INIT");
    super.onInit();
    store = GetStorage();
  userId = store.read(UserPreferences.user_id)?.toString() ?? '';
  accessToken = store.read(UserPreferences.access_token) ?? '';
    getCustomerEventCategory();
     // load category
     getAllEvents();   // 🔥
  getMyEvents(); 
   
        // load events
  }

  // ================= EVENT CATEGORY =================
Future<void> getCustomerEventCategory() async {
  try {
    isLoadingCategory.value = true;

    final response =
        await WebServicesHelper().getCustomerEventCategory({});

    if (response != null && response['status'] == 200) {

      final List<EventCategory> list =
          (response['data'] as List)
              .map((e) => EventCategory.fromJson(e))
              .toList();

      // ✅ SORT THE LIST (NOT categories)
      list.sort((a, b) =>
    (a.name ?? '')
        .trim()
        .toLowerCase()
        .compareTo((b.name ?? '').trim().toLowerCase()));
        print("Sorted Category Names:");
for (var c in list) {
  print(c.name);
}

      // ✅ THEN ASSIGN
      categories.assignAll(list);

      print("Sorted Categories => ${categories.length}");
    }
  } catch (e) {
    debugPrint("Event Category Error: $e");
  } finally {
    isLoadingCategory.value = false;
  }
}

  Future<void> getCustomerEventSubCategory(int categoryId) async {
  try {
    isLoadingSubCategory.value = true;

    final response =
        await WebServicesHelper().getCustomerEventSubCategory({
      "event_category_id": categoryId,
    });

    if (response != null && response['status'] == 200) {
      final List<EventCategory> list =
          (response['data'] as List)
              .map((e) => EventCategory.fromJson(e))
              .toList();

      // ✅ SORT SUBCATEGORY
      list.sort((a, b) =>
          (a.name ?? '')
              .trim()
              .toLowerCase()
              .compareTo((b.name ?? '').trim().toLowerCase()));

      subCategories.assignAll(list);
    }
  } catch (e) {
    debugPrint("SubCategory Error: $e");
  } finally {
    isLoadingSubCategory.value = false;
  }
}

  // add a search event By using name and hashtag accourding 
  Future<void> searchEvents(String keyword, {bool isMyEvents = false}) async {
  try {
    if (keyword.trim().isEmpty) {
      if (isMyEvents) {
        await getMyEvents();
      } else {
        await getAllEvents();
      }
      return;
    }

    final Map<String, dynamic> param = {
      "accessToken": accessToken,
    };

    // if searching in My Events screen
    if (isMyEvents) {
      param["user_id"] = userId;
    }

    if (keyword.startsWith("#")) {
      param["hashtag"] = keyword;
    } else {
      param["title"] = keyword;
    }

    final response =
        await WebServicesHelper().getCustomerEvent(param);

    if (response != null && response['status'] == 200) {
      List data = response['data'];

      final events =
          data.map((e) => CustomerEventModel.fromJson(e)).toList();

      if (isMyEvents) {
        myEvents.assignAll(events);
      } else {
        allEvents.assignAll(events);
      }
    }
  } catch (e) {
    print("Search error => $e");
  }
}


  // ================= EVENTS LIST =================
//   Future<void> getCustomerEvents() async {
//   try {
//     isLoading.value = true;

//     final response =
//         await WebServicesHelper().getCustomerEvent({
//       "user_id": userId,
//       "accessToken": accessToken,
//     });

//     if (response != null && response['status'] == 200) {
//       List data = response['data'];

//       List<CustomerEventModel> list =
//           data.map((e) => CustomerEventModel.fromJson(e)).toList();

//       // ✅ store all events
//       allEvents.assignAll(list);

//       // ✅ store only my events (filtered by user id)
//       final uid = int.tryParse(userId) ?? 0;

//       myEvents.assignAll(
//         list.where((e) => e.userId == uid).toList(),
//       );
//     }
//   } catch (e) {
//     debugPrint("Event Error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }


Future<void> getAllEvents() async {
  try {
    isLoading.value = true;

    final response =
        await WebServicesHelper().getCustomerEvent({
      "accessToken": accessToken,
    });

    if (response != null && response['status'] == 200) {
      List data = response['data'];

      allEvents.assignAll(
        data.map((e) => CustomerEventModel.fromJson(e)).toList(),
      );
      applyFilters(); 

    
    }
  } catch (e) {
    print("ERROR => $e");
  } finally {
    isLoading.value = false;
  }
}


Future<void> getMyEvents() async {
  final response =
      await WebServicesHelper().getCustomerEvent({
    "user_id": userId,
    "accessToken": accessToken,
  });

  if (response != null && response['status'] == 200) {
    List data = response['data'];

    myEvents.assignAll(
      data.map((e) => CustomerEventModel.fromJson(e)).toList(),
    );
    print("🟢 STORED IN allEvents => ${myEvents.length}");
  }
}



  Future<void> postCustomerEvent() async {
  try {
    if (isPostingEvent.value) return;
    if (!validateEventForm()) return;
    isPostingEvent.value = true;
    final uid = int.tryParse(userId) ?? 0;

    final Map<String, dynamic> param = {
      "title": titleController.text,
      "organizer_name": organizerController.text,
      "description": descriptionController.text,
      "hashtag":hashtagController.text,
      "event_date": dateController.text,
      "event_time": timeController.text,
      "event_end_date":endDateController.text,
      "event_end_time":endTimeController.text,
      "fee_type": feeType.value,
      "price": price.value,
      "address": addressController.text,
      "latitude": latitude.value,
      "longitude": longitude.value,
      "image": eventImageList.map((e) => e.toJson()).toList(),
 // later you can send file
      "event_category_id": selectedCategoryId.value,
      "event_subcategory_id": selectedSubCategoryId.value,
      "user_id": uid,
      "created_by": uid,
      "created_by_id": uid,
      "updated_by": uid,
      "updated_by_id": uid,
    };

    final response =
        await WebServicesHelper().postCustomerEvent(param);

    if (response != null && response['status'] == 200) {
     Get.snackbar(
  "Success",
  "Event Created",
  snackPosition: SnackPosition.TOP,
  backgroundColor: const Color(0xFF2E7D32),
  colorText: Colors.white,
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  borderRadius: 14,
  boxShadows: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
  icon: const Icon(Icons.verified, color: Colors.white),
);


    clearEventForm();

      // await getCustomerEvents(); // refresh
    }
  } catch (e) {
    debugPrint("postCustomerEvent ERROR => $e");
  } finally {
    isPostingEvent.value = false;
  }
}


Future<void> uploadEventImage(File image) async {
  BuildContext? context = Get.context;
  String filePath = ApiUrl.fileUploadResume; // same API used

  showLoaderDialog(context!);

  Map<String, dynamic>? response =
      await WebServicesHelper().fileUpload(filePath, image);

  if (response != null) {
    FileUploadResponseModel baseResponse =
        FileUploadResponseModel.fromJson(response);

    if (baseResponse.status == 200) {
      FileModel uploadedFile = FileModel(
        name: baseResponse.data?.name,
        path: baseResponse.data?.path,
      );

      eventImageList.clear();
      eventImageList.add(uploadedFile);

      Utils.showCustomTosst("Image uploaded");
    }
  }

  hideProgress(context);
}


Future<void> registerForEvent(int eventId) async {
  try {
    if (isRegistering.value) return;
    isRegistering.value = true;

    final uid = int.tryParse(userId) ?? 0;

    final param = {
      "event_id": eventId,
      "user_id": uid,
      "created_by": uid,
      "created_by_id": uid,
      "accessToken": accessToken,
    };

    final response =
        await WebServicesHelper().registerCustomerEvent(param);

    if (response != null && response['status'] == 200) {
      registeredEventIds.add(eventId);

      Get.snackbar(
        "Success",
        "You have registered for this event",
        snackPosition: SnackPosition.TOP,
      );
    }
  } catch (e) {
    debugPrint("Register Event Error => $e");
  } finally {
    isRegistering.value = false;
  }
}





Future<void> pickEventImage(bool isCamera) async {
  pickedFile = await ImagePicker().getImage(
    source: isCamera ? ImageSource.camera : ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );

  if (pickedFile != null) {
    File imageFile = File(pickedFile!.path);
    await uploadEventImage(imageFile);
  }
}

Future<void> getRegisteredUsersByEvent(int eventId) async {
  try {
    final uid = int.tryParse(userId) ?? 0;

    final res = await WebServicesHelper().getRegisterationCustomer(
      eventId: eventId,
      userId: uid,
      page: 1,
      size: 50,
    );

    if (res != null && res['status'] == 200) {
      List data = res['data'];

      List<EventUser> users = data
          .map((e) => EventUser.fromJson(e['user']))
          .toList();

      eventRegisteredUsers[eventId] = users;

      print("✅ Users for event $eventId => ${users.length}");
    }
  } catch (e) {
    print("❌ getRegisteredUsersByEvent error => $e");
  }
}


// these to show a call option 
Future<void> makePhoneCall(String number) async {
  // remove everything except digits and +
  String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');

  final Uri uri = Uri(
    scheme: 'tel',
    path: cleanNumber,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    Get.snackbar("Error", "Cannot open dialer");
  }
}



double _degToRad(double deg) => deg * (pi / 180);

double calculateDistance(double sLat, double sLng, double eLat, double eLng) {
  const earthRadius = 6371;

  double dLat = _degToRad(eLat - sLat);
  double dLng = _degToRad(eLng - sLng);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(sLat)) *
          cos(_degToRad(eLat)) *
          sin(dLng / 2) *
          sin(dLng / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}


// these to show a nearby events 
Future<void> loadNearbyEventsOnMap() async {
  Position pos = await Geolocator.getCurrentPosition();

  nearbyEvents.clear();
  eventMarkers.clear();

  for (var event in allEvents) {
    if (event.latitude != null && event.longitude != null) {
      double distance = calculateDistance(
        pos.latitude,
        pos.longitude,
        double.parse(event.latitude!),
        double.parse(event.longitude!),
      );

      if (distance <= 5) {
        nearbyEvents.add(event);

        final markerId = MarkerId(event.id.toString());

        eventMarkers[markerId] = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(event.latitude!),
            double.parse(event.longitude!),
          ),

          // 👇 THIS IS THE MAGIC
          onTap: () {
            Get.to(() => EventDetailScreenAll(event: event));
          },

          infoWindow: InfoWindow(
            title: event.title,
            snippet: event.address,
            onTap: () {
              Get.to(() => EventDetailScreenAll(event: event));
            },
          ),
        );
      }
    }
  }

  eventMarkers.refresh();
}

Future<void> loadNearbyEventsOnMapByCategory() async {
  Position pos = await Geolocator.getCurrentPosition();

  nearbyEvents.clear();
  eventMarkers.clear();

  for (var event in allEvents) {

    final lat = double.tryParse(event.latitude ?? '');
    final lng = double.tryParse(event.longitude ?? '');

    if (lat == null || lng == null) continue;

    // CATEGORY FILTER
    if (selectedCategoryId.value != 0 &&
        event.category?.id != selectedCategoryId.value) {
      continue;
    }

    // SUBCATEGORY FILTER (if used)
    if (selectedSubCategoryId.value != 0 &&
        event.subCategory?.id != selectedSubCategoryId.value) {
      continue;
    }

    // DISTANCE FILTER
    double distance = calculateDistance(
      pos.latitude,
      pos.longitude,
      lat,
      lng,
    );

    if (distance <= 5) {
      nearbyEvents.add(event);

      final markerId = MarkerId(event.id.toString());

      eventMarkers[markerId] = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        onTap: () {
          Get.to(() => EventDetailScreenAll(event: event));
        },
        infoWindow: InfoWindow(
          title: event.title,
          snippet: event.address,
        ),
      );
    }
  }

  nearbyEvents.refresh();
  eventMarkers.refresh();
}

// tehse to show a share image 

Future<File?> downloadImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/event_image.jpg');

    await file.writeAsBytes(response.bodyBytes);
    return file;
  } catch (e) {
    print("Image download error => $e");
    return null;
  }
}

void applyFilters() {
  filteredEvents.assignAll(
    allEvents.where((event) {

      // Category filter
      if (selectedCategoryId.value != 0 &&
          event.category?.id != selectedCategoryId.value) {
        return false;
      }
      if (selectedSubCategoryId.value != 0 &&
          event.subCategory?.id != selectedSubCategoryId.value) {
        return false;
      }

     

      return true;
    }).toList(),
  );
}


// valdiation for event post 
bool validateEventForm() {
  if (titleController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Title is required");
    return false;
  }

  if (organizerController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Organizer name is required");
    return false;
  }

  if (dateController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Event date is required");
    return false;
  }

  if (timeController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Event time is required");
    return false;
  }

  if (endDateController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Event end date is required");
    return false;
  }

  if (endTimeController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Event end time is required");
    return false;
  }

  if (selectedCategoryId.value == 0) {
    Get.snackbar("Validation", "Please select event category");
    return false;
  }

  if (selectedSubCategoryId.value == 0) {
    Get.snackbar("Validation", "Please select event subcategory");
    return false;
  }

  if (addressController.text.trim().isEmpty) {
    Get.snackbar("Validation", "Address is required");
    return false;
  }

  if (latitude.value == 0 || longitude.value == 0) {
    Get.snackbar("Validation", "Please select location");
    return false;
  }

  return true;
}






  // ================= FILTER =================
 void filterByCategory(int categoryId) async {
  selectedCategoryId.value = categoryId;

  // reset subcategory
  selectedSubCategoryId.value = 0;
  subCategories.clear();

  if (categoryId != 0) {
    await getCustomerEventSubCategory(categoryId);
  }

  applyFilters();
}
  void clearFilter() {
  selectedCategoryId.value = 0;
  selectedSubCategoryId.value = 0;
  subCategories.clear();

  applyFilters();
}


  Future<void> pickCurrentLocation() async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission", "Location permission denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    Placemark place = placemarks.first;

    addressController.text =
        "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  } catch (e) {
    debugPrint("Location error => $e");
  }
}


void filterBySubCategory(int subCategoryId) {
  selectedSubCategoryId.value = subCategoryId;
  applyFilters();
}


void clearEventForm() {
  // Text fields
  titleController.clear();
  organizerController.clear();
  descriptionController.clear();
  addressController.clear();
  dateController.clear();
  timeController.clear();
  endDateController.clear();
  endTimeController.clear();

  // Reactive values
  feeType.value = "free";
  price.value = 0.0;
  latitude.value = "";
  longitude.value = "";
  selectedCategoryId.value = 0;

  // Image
  eventImageList.clear();
  pickedImage.value = null;
  pickedFile = null;
}


}
