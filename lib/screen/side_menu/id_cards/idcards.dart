import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import '../../../controller/user_profile_controller.dart';
import '../../../toolbar/TopBar.dart';

class IdCards extends StatefulWidget {
  const IdCards({Key? key}) : super(key: key);

  @override
  State<IdCards> createState() => _CmsPageState();
}

class _CmsPageState extends State<IdCards> {
  UserProfileController controller = Get.put(UserProfileController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(
            title: 'About Us',
            menuicon: false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            onPressed: () => {},
            onTitleTapped: () => {}),
        body: Center(
          child: Container(

            child: Obx(() => Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child:Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        const Text(
                          'CARD MEMBER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                          ),
                        ),



                        const SizedBox(height: 20),

                        Text(
                          controller.userData.value.data!.contactNumber??'',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              width: 300, // Set your desired width
                              height: 300, // Set your desired height
                              child: QrImageView(
                                size: 300,
                                data: controller.userData.value.data!.contactNumber ?? '',
                                version: QrVersions.auto,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Text(
                        //   'EXP.12/31/2024',
                        //   style: TextStyle(
                        //     color: Colors.white.withOpacity(0.8),
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w400,
                        //     letterSpacing: 1.0,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )
            )),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getUserDetails();

  }
}
