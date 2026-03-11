import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:get_storage/get_storage.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();
  final GetStorage box = GetStorage();

  static const String storeKey = 'DEEPLINK_STORE_ID';

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    // Cold start
    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      _saveUri(uri);
    }

    // Background / running
    _appLinks.uriLinkStream.listen((uri) {
      _saveUri(uri);
    });
  }

  void _saveUri(Uri uri) {
  String? storeId;

  // ✅ Case 1: Custom scheme → myapp://store/227
  if (uri.scheme == 'myapp' && uri.host == 'store') {
    if (uri.pathSegments.isNotEmpty) {
      storeId = uri.pathSegments.first;
    }
  }

  // ✅ Case 2: HTTPS → https://myapp.com/store/227
  else if (uri.scheme == 'https' &&
      uri.pathSegments.length >= 2 &&
      uri.pathSegments[0] == 'store') {
    storeId = uri.pathSegments[1];
  }

  if (storeId != null && storeId.isNotEmpty) {
    box.write(storeKey, storeId);
    print('🔥 DeepLink stored: $storeId');
  }
}

  /// Read once from Splash
  String? consumeStoreId() {
    final id = box.read(storeKey);
    box.remove(storeKey);
    return id;
  }
}
