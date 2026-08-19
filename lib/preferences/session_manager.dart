import 'package:get_storage/get_storage.dart';

import 'UserPreferences.dart';

/// Single place the login session is written, read and cleared.
///
/// It exists because the session used to be written by hand in each login
/// path, and they didn't agree: the password login saved only the user id and
/// never the access token, so those users had a half session — logged in for
/// the startup check, but sending `Bearer null` on every authenticated call.
/// The first 401 that came back then wiped the whole storage and dropped them
/// back on the login screen the next time the app was opened.
///
/// Everything session-related now goes through here so the two keys can never
/// drift apart again.
class SessionManager {
  SessionManager._();

  static GetStorage get _store => GetStorage();

  /// Storage keeps values as `dynamic` and older builds wrote the literal
  /// string "null" (from `null.toString()`), so both have to be treated as
  /// "nothing saved".
  static String _clean(dynamic value) {
    if (value == null) return "";
    final String text = value.toString().trim();
    if (text.isEmpty || text == "null") return "";
    return text;
  }

  static String get userId => _clean(_store.read(UserPreferences.user_id));

  static String get accessToken =>
      _clean(_store.read(UserPreferences.access_token));

  /// The startup gate. The token is deliberately not part of this: an expired
  /// or missing token is refreshed while the app runs (see
  /// [UserProfileController.getUserDetails]), it must not throw the customer
  /// back to the login screen on launch.
  static bool get isLoggedIn => userId.isNotEmpty;

  /// Saves a completed login. Returns false when the response carried no
  /// usable user id — the caller must then treat the login as failed instead
  /// of navigating to the dashboard on an empty session.
  static Future<bool> saveSession({
    dynamic userId,
    dynamic accessToken,
  }) async {
    final String id = _clean(userId);
    if (id.isEmpty) return false;

    // Awaited so the session is on disk before we navigate: GetStorage
    // flushes on a microtask, and a fire-and-forget write can be lost if the
    // app is killed right after login.
    await _store.write(UserPreferences.user_id, id);

    final String token = _clean(accessToken);
    if (token.isNotEmpty) {
      await _store.write(UserPreferences.access_token, token);
    }

    return true;
  }

  /// Stores a token the server handed us outside of login (the user detail
  /// endpoint returns the current one), so a rotated token is picked up
  /// without asking the customer to sign in again.
  static Future<void> saveAccessToken(dynamic accessToken) async {
    final String token = _clean(accessToken);
    if (token.isEmpty || token == SessionManager.accessToken) return;

    await _store.write(UserPreferences.access_token, token);
  }

  /// Ends the session. Only the session keys are removed — app data such as
  /// the selected store code survives, unlike the `erase()` this replaced.
  static Future<void> clear() async {
    await _store.remove(UserPreferences.user_id);
    await _store.remove(UserPreferences.access_token);
  }
}
