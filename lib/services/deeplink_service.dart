import 'package:app_links/app_links.dart';

class DeepLinkService {
  
  final AppLinks _appLinks = AppLinks();

  // 🔥 GLOBAL STORE ID
  static String? pendingStoreId;

  void initDeepLinks() {
    _appLinks.getInitialAppLink().then((uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    });

    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    if (uri.pathSegments.length >= 2 &&
        uri.pathSegments[0] == 'store') {
      pendingStoreId = uri.pathSegments[1];

      print("✅ Pending Store ID: $pendingStoreId");
    }
  }
}
