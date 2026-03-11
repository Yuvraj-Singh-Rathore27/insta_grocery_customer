import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/utills/Utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controller/otp_verifiction_controller.dart';
import '../../customwiget/my_elevated_button.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../daskboard/DashBord.dart';

class OtpVerifictionScreen extends StatefulWidget {
  final otp;
  final mobileNumber;
  const OtpVerifictionScreen({
    Key? key,
    required this.otp,
    required this.mobileNumber
  }) : super(key: key);

  @override
  State<OtpVerifictionScreen> createState() => _OtpVerifictionScreenState();
}

class _OtpVerifictionScreenState extends State<OtpVerifictionScreen>
    with SingleTickerProviderStateMixin {
  OtpVerificationController controller = Get.put(OtpVerificationController());
  late double height, width;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    controller.mobile_number.value = widget.mobileNumber;

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

    _slideAnimation = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: AppColor().colorPrimary.withOpacity(0.5),
      end: AppColor().colorPrimary,
    ).animate(_animationController);

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
                          Transform.translate(
                            offset: Offset(-_slideAnimation.value, 0),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: _buildBackButton(),
                              ),
                            ),
                          ),

                          // SizedBox(height: 20),

                          // OTP Illustration with Animation
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(ImageRes().img_otp),
                                  height: 180,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Title with Animation
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'OTP Verification',
                                  textAlign: TextAlign.center,
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

                          SizedBox(height: 15),

                          // Description with Animation
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'We have sent the verification code to your mobile number',
                                  textAlign: TextAlign.center,
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

                          SizedBox(height: 25),

                          // Mobile Number with Animation
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${widget.mobileNumber.substring(0, 6)}****',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  color: AppColor().whiteColor,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 40),

                          // OTP Input Field with Animation
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildOtpInputField(),
                            ),
                          ),

                          SizedBox(height: 50),

                          // Verify Button with Animation
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: MyElevatedButton(
                                onPressed: () {
                                  controller.onSubmit(context);
                                },
                                borderRadius: BorderRadius.circular(25),
                                child: Text(
                                  'Verify & Continue',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColor().colorPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Resend Code Section with Animation
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildResendSection(),
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

  Widget _buildOtpInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: AppColor().whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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
            'Enter 4-digit Code',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              color: AppColor().whiteColor.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 20),
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
                  // Auto-submit on complete
                  // controller.onSubmit(context);
                }
              },
              appContext: context,
            ),
          ),
          SizedBox(height: 10),
          Obx(() => Text(
            '${controller.otp.value.length}/4 digits entered',
            style: TextStyle(
              fontSize: 12,
              color: AppColor().whiteColor.withOpacity(0.7),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildResendSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor().whiteColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Didn\'t receive the code?  ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Inter",
              fontWeight: FontWeight.normal,
              color: AppColor().whiteColor.withOpacity(0.8),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Add resend logic here
                _triggerResendAnimation();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'Resend Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().whiteColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerResendAnimation() {
    // Add resend logic here
    _animationController.reset();
    _animationController.forward();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification code sent again!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}