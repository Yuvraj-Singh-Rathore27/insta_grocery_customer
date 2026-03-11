import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/utills/Utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controller/login_controller.dart';
import '../../controller/singup_controller.dart';
import '../../customwiget/my_elevated_button.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  RegisterController controller = Get.put(RegisterController());
  late double height, width;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _formSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: AppColor().colorPrimary.withOpacity(0.5),
      end: AppColor().colorPrimary,
    ).animate(_animationController);

    _formSlideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
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
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _colorAnimation.value!,
                  _colorAnimation.value!.withOpacity(0.9),
                  _colorAnimation.value!.withOpacity(0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated Background Elements
                _buildAnimatedBackground(),

                // Main Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Back Button with Animation
                         Container(
                           alignment: Alignment.topLeft,
                           child:  Transform.translate(
                             offset: Offset(-_slideAnimation.value, 0),
                             child: FadeTransition(
                               opacity: _fadeAnimation,
                               child: _buildBackButton(),
                             ),
                           ),
                         ),

                          SizedBox(height: 20),

                          // Title with Animation
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 32,
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

                          SizedBox(height: 8),

                          // Subtitle with Animation
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Please enter your details to get started',
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

                          SizedBox(height: 40),

                          // Registration Form with Animation
                          Transform.translate(
                            offset: Offset(0, _formSlideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildRegistrationForm(),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Action Button with Animation
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildActionButton(),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Login Redirect with Animation
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildLoginRedirect(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Floating animated circles
        Positioned(
          top: 100,
          left: -30,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor().whiteColor.withOpacity(0.08),
              ),
            ),
          ),
        ),
        Positioned(
          top: 300,
          right: -40,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor().whiteColor.withOpacity(0.06),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          left: 50,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor().whiteColor.withOpacity(0.05),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor().whiteColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor().whiteColor.withOpacity(0.3),
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColor().whiteColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Obx(() => AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: controller.showOtpScreen == true
          ? _buildOtpVerificationForm()
          : _buildPersonalDetailsForm(),
    ));
  }

  Widget _buildPersonalDetailsForm() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColor().whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColor().whiteColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // First Name Field
          _buildTextField(
            controller: controller.nameController,
            label: "First Name",
            icon: ImageRes().img_icon_user,
            onChanged: (value) => controller.name.value = value,
          ),

          SizedBox(height: 20),

          // Last Name Field
          _buildTextField(
            controller: controller.lastController,
            label: "Last Name",
            icon: ImageRes().img_icon_user,
            onChanged: (value) => controller.lastName.value = value,
          ),

          SizedBox(height: 20),

          // Mobile Number Field with Country Code
          _buildMobileNumberField(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String icon,
    required Function(String) onChanged,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword ,
      style: TextStyle(color: AppColor().whiteColor),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColor().whiteColor.withOpacity(0.8),
          fontSize: 14,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor().whiteColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor().whiteColor,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(

              Icons.visibility,

            color: AppColor().whiteColor,
          ),
          onPressed: () {

          },
        )
            : Padding(
          padding: EdgeInsets.all(12),
          child: Image(
            width: 16,
            height: 16,
            color: AppColor().whiteColor,
            image: AssetImage(icon),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNumberField() {
    return Row(
      children: [
        // Country Code Picker
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showCountyPiker(controller),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: AppColor().whiteColor.withOpacity(0.5),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                    '+${controller.countryCode.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      color: AppColor().whiteColor,
                    ),
                  )),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColor().whiteColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 15),

        // Mobile Number Input
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(color: AppColor().whiteColor),
            controller: controller.mobileNumberController,
            onChanged: (value) => controller.mobile_number.value = value,
            decoration: InputDecoration(
              labelText: "Mobile Number",
              labelStyle: TextStyle(
                color: AppColor().whiteColor.withOpacity(0.8),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor().whiteColor.withOpacity(0.5),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor().whiteColor,
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.all(12),
                child: Image(
                  width: 16,
                  height: 16,
                  color: AppColor().whiteColor,
                  image: AssetImage(ImageRes().img_icon_mobile),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerificationForm() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColor().whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColor().whiteColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: AppColor().whiteColor,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'Enter the 4-digit code sent to your mobile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Inter",
              fontWeight: FontWeight.normal,
              color: AppColor().whiteColor.withOpacity(0.8),
            ),
          ),

          SizedBox(height: 25),

          Container(
            height: 70,
            child: PinCodeTextField(
              showCursor: true,
              autoFocus: true,
              length: 4,
              obscureText: false,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor().whiteColor,
              ),
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                borderWidth: 2.0,
                fieldOuterPadding: EdgeInsets.all(8),
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                activeFillColor: AppColor().whiteColor.withOpacity(0.1),
                selectedFillColor: AppColor().whiteColor.withOpacity(0.15),
                inactiveFillColor: AppColor().whiteColor.withOpacity(0.05),
                activeColor: AppColor().whiteColor,
                inactiveColor: AppColor().whiteColor.withOpacity(0.5),
                selectedColor: AppColor().whiteColor,
                fieldHeight: 60,
                fieldWidth: 60,
              ),
              animationType: AnimationType.fade,
              animationDuration: Duration(milliseconds: 200),
              enablePinAutofill: true,
              onChanged: (code) {
                Utils().customPrint("Changed: " + code);
                if (code.length == 4) {
                  controller.otp.value = code;
                }
              },
              onCompleted: (code) {
                if (code.length == 4) {
                  controller.otp.value = code;
                }
              },
              appContext: context,
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Didn\'t receive the code? ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor().whiteColor.withOpacity(0.7),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Resend OTP logic
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor().whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Obx(() => MyElevatedButton(
      onPressed: () {
        controller.showOtpScreen == true
            ? controller.onSignupApiCall(context)
            : controller.genrateOptApiCall(context);
      },
      borderRadius: BorderRadius.circular(25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.showOtpScreen == true
                ? 'Verify & Create Account'
                : 'Continue to OTP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor().colorPrimary,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_rounded,
            color: AppColor().colorPrimary,
            size: 18,
          ),
        ],
      ),
    ));
  }

  Widget _buildLoginRedirect() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  color: AppColor().whiteColor.withOpacity(0.8),
                ),
              ),
              Text(
                'Login here',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCountyPiker(RegisterController controller) {
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