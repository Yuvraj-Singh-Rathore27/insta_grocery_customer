
import 'package:flutter/cupertino.dart';

import '../screen/forget_password/forget_screen.dart';
import '../screen/forget_password/password_reset_screen.dart';
import '../screen/login/login_screen.dart';
import '../screen/register/register_screen.dart';
import '../screen/splash/splash_screen.dart';

class Routes {
  // Route name constants
  static const String Splace = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forget_password = '/forget_password';
  static const String reset_password = '/reset_password';
  static const String dashboard = '/DashBoard';
  static const String home = '/Home';
  static const String job_details = '/job_details';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.login: (context) => LoginScreen(),
      Routes.Splace: (context) => Splash(),
      Routes.forget_password: (context) => ForgetPasswordScreen(),
      Routes.reset_password: (context) => ResetPasswordScreen(),
      Routes.register: (context) => RegisterScreen(),
    };
  }
}
