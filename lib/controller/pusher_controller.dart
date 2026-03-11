import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../model/pharmcy_booking_model.dart';
import '../preferences/UserPreferences.dart';
import '../utills/constant.dart';
class PusherController extends GetxController{
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final _apiKey="b1c1fddec9aa995a6c68";
  final _appId="892135";
  final _secret="d4122290583e98557933";
  final _cluster="mt1";
  var channelName="";
  RxDouble startLat=0.0.obs  ;
  RxDouble startEnd=0.0.obs  ;
  late PusherChannel myChannel;
  late GetStorage store ;
  String userId="";
  String accessToken="";
  late PharmacyBookingModel bookingModel;

  PusherController({required this.bookingModel}){
    this.bookingModel=bookingModel;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    store = GetStorage();
    userId= GetStorage().read(UserPreferences.user_id);
    accessToken= GetStorage().read(UserPreferences.access_token);
    print("HealthJobController Userid => ${userId}");
    print("HealthJobController accessToken => ${accessToken}");
    channelName="private-track-${bookingModel.deliveryBoyBookingModel?.id.toString()}";

    connectPusher();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

  }

  Future<void> connectPusher() async {

    try {
      await pusher.init(
        apiKey: _apiKey,
        cluster: _cluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: "<Your Authendpoint Url>",
        onAuthorizer: onAuthorizer
      );
      myChannel= await pusher.subscribe(channelName: channelName);
      print("Name is==> "+myChannel.channelName);
      await pusher.connect();

    } catch (e) {
      log("ERROR: $e");
    }
  }
  dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
    String secret = _secret;
    String stringToSign = "$socketId:$channelName";

    List<int> secretBytes = utf8.encode(secret);
    List<int> stringToSignBytes = utf8.encode(stringToSign);

    Hmac hmac = Hmac(sha256, secretBytes);
    Digest signature = hmac.convert(stringToSignBytes);

    String auth = "$_apiKey:${signature.toString()}";

    print("stringToSign===> ${stringToSign}");
    print("auth===> ${auth}");

    return {
      "auth": auth,
      // "channel_data": '{"user_id": $userId}',
      // "shared_secret": _secret
    };
  }

  void onTriggerEventPressed(String event_name, Map data) async {
    try {
    print("channelName==> $channelName");
    await  myChannel.trigger(PusherEvent(
          channelName: channelName,
          eventName: "client-location_update",
          data: data.toString(),
        userId:userId.toString()));
    }catch (e) {
      print('Error triggering event: $e');
    }

  }




  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    log("onEvent: $event");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  Future<List<LatLng>> getRoute(double slatitude,double longitude,double dlatitude,double dlongitude  ) async {
    print('origin=${slatitude},${longitude}&destination=${dlatitude},${dlongitude}');

    // dlatitude=28.5089564;
    // dlongitude=77.2100563;
    List<LatLng> points= <LatLng>[];
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${slatitude},${longitude}&destination=${dlatitude},${dlongitude}&key=AIzaSyAhch18P_emZhw7RkyewrmLNk8Snhs0w4U'));

    print("response===> ${response.body}");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
       points = _decodePolyline(json['routes'][0]['overview_polyline']['points']);
      return points;
    }
    return points;
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }






}