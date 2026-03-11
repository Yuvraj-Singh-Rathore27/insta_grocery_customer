import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controller/login_controller.dart';
import '../../customwiget/my_elevated_button.dart';
import '../../preferences/UserPreferences.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../../utills/Utils.dart';
import '../daskboard/DashBord.dart';
import '../forget_password/forget_screen.dart';
import '../forget_password/password_reset_screen.dart';
import '../otp_verifiction/otp_verifiction_screen.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  LoginController login_controller = Get.put(LoginController());
  late double height, width;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor().colorPrimary,
              AppColor().colorPrimary.withOpacity(0.9),
              AppColor().colorPrimary.withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Elements
            Positioned(
              top: -50,
              right: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor().whiteColor.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor().green_color_light?.withOpacity(0.1) ?? Colors.green.withOpacity(0.1),
                ),
              ),
            ),
            // Floating animated circles
            _buildFloatingCircle(100, 100, 60),
            _buildFloatingCircle(MediaQuery.of(context).size.width - 80, 200, 40),
            _buildFloatingCircle(50, MediaQuery.of(context).size.height - 150, 70),

            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          // Logo with animation
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 100, 10, 10),
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Image(
                                    width: 300,
                                    fit: BoxFit.contain,
                                    image: AssetImage(ImageRes().logoGrocery),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Login Title with animation
                          Transform.translate(
                            offset: Offset(-_slideAnimation.value, 0),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                    color: AppColor().whiteColor,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Subtitle with animation
                          Transform.translate(
                            offset: Offset(_slideAnimation.value, 0),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please enter your details',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.normal,
                                    color: AppColor().whiteColor.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Login Form with animation
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: _buildLoginForm(),
                            ),
                          ),

                          Spacer(),

                          // Register section with animation
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: _buildRegisterSection(),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircle(double left, double top, double size) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor().whiteColor.withOpacity(0.05),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor().whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor().whiteColor.withOpacity(0.2),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Obx(() => login_controller.login_type == 'mobile_login'
              ? _buildMobileLogin()
              : _buildEmailLogin()),

          const SizedBox(height: 30),

          // Login Button with animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: Obx(() => MyElevatedButton(
              onPressed: () {
                login_controller.login_type.value == 'mobile_login'
                    ? login_controller.onSubmit(context)
                    : login_controller.apiLoginWithPssword(context);
              },
              borderRadius: BorderRadius.circular(20),
              child: Text(
                login_controller.login_type.value == 'mobile_login'
                    ? 'Get OTP'
                    : 'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor().colorPrimary,
                ),
              ),
            )),
          ),

          const SizedBox(height: 20),

          MyElevatedButton(
            onPressed: () {
              login_controller.mobileNumber.value = '8107357227';
              login_controller.onSubmit(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: Text(
              'Login As Guest',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor().colorPrimary,
              ),
            ),
          )

          // Login type toggle (commented in original, keeping structure)
          // _buildLoginTypeToggle(),
        ],
      ),
    );
  }

  Widget _buildMobileLogin() {
    return Column(
      children: [
        Row(
          children: [
            // Country Code Picker
            InkWell(
              onTap: () {
                showCountyPiker(login_controller);
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                      '+${login_controller.countryCode.value}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.normal,
                        color: AppColor().whiteColor,
                      ),
                    )),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColor().whiteColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColor().whiteColor),
                obscureText: false,
                controller: login_controller.mobileController,
                onChanged: (value) => {
                  login_controller.mobileNumber.value = value,
                },
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: TextStyle(color: AppColor().whiteColor.withOpacity(0.8)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColor().whiteColor.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColor().whiteColor),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: Image(
                      width: 20,
                      height: 20,
                      color: AppColor().whiteColor,
                      image: AssetImage(ImageRes().img_icon_mobile),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailLogin() {
    return Column(
      children: [
        TextField(
          style: TextStyle(color: AppColor().whiteColor),
          controller: login_controller.emailController,
          onChanged: (value) => {
            login_controller.email.value = value,
          },
          decoration: InputDecoration(
            labelText: "Email ID",
            labelStyle: TextStyle(color: AppColor().whiteColor.withOpacity(0.8)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor().whiteColor.withOpacity(0.5)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor().whiteColor),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: Image(
                width: 20,
                height: 20,
                color: AppColor().whiteColor,
                image: AssetImage(ImageRes().img_icon_user),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          obscureText: !login_controller.passwordVisible.value,
          style: TextStyle(color: AppColor().whiteColor),
          controller: login_controller.passwordController,
          onChanged: (value) => {
            login_controller.password.value = value,
          },
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: TextStyle(color: AppColor().whiteColor.withOpacity(0.8)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor().whiteColor.withOpacity(0.5)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor().whiteColor),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                login_controller.passwordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColor().whiteColor,
              ),
              onPressed: () {
                login_controller.passwordVisible.value =
                !login_controller.passwordVisible.value;
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => {
              Get.to(() => ForgetPasswordScreen()),
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Forgot Password?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  color: AppColor().whiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?  ',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.normal,
            color: AppColor().whiteColor.withOpacity(0.9),
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => RegisterScreen());
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Text(
                  'Register here',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().whiteColor,
                  ),
                ),
                Container(
                  height: 1,
                  width: 80,
                  color: AppColor().green_color_light ?? Colors.green,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void showCountyPiker(LoginController controller) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        controller.countryCode.value = country.phoneCode.toString();
        print('Select country: ${country.phoneCode}');
      },
    );
  }
}