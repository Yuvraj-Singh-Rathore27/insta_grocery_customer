import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';


import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _MorePageState();
}

class _MorePageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(
            title: '',
            menuicon: false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            onPressed: () => {},
            onTitleTapped: () => {}),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                // decoration: ,
                decoration: BoxDecoration(
                    color: AppColor().colorBottom,
                    border: Border.all(width: 1, color: AppColor().colorBottom),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    )),

                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'General Notifications',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              color: AppColor().blackColor),
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(ImageRes().forwardArrow)))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: AppColor().colorBottom,
              //       border: Border.all(width: 1, color: AppColor().colorBottom),
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(5),
              //       )),
              //   height: 50,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Padding(
              //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              //           child: Text(
              //             'Doctor Notifications',
              //             textAlign: TextAlign.start,
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontFamily: "Inter",
              //                 fontWeight: FontWeight.normal,
              //                 color: AppColor().blackColor),
              //           )),
              //       Container(
              //           margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              //           child: Image(
              //               width: 20,
              //               height: 20,
              //               image: AssetImage(ImageRes().forwardArrow)))
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: AppColor().colorBottom,
              //       border: Border.all(width: 1, color: AppColor().colorBottom),
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(5),
              //       )),
              //   height: 50,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Padding(
              //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              //           child: Text(
              //             'Hospital Notifications',
              //             textAlign: TextAlign.start,
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontFamily: "Inter",
              //                 fontWeight: FontWeight.normal,
              //                 color: AppColor().blackColor),
              //           )),
              //       Container(
              //           margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              //           child: Image(
              //               width: 20,
              //               height: 20,
              //               image: AssetImage(ImageRes().forwardArrow)))
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: AppColor().colorBottom,
              //       border: Border.all(width: 1, color: AppColor().colorBottom),
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(5),
              //       )),
              //   height: 50,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Padding(
              //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              //           child: Text(
              //             'Clinic Notifications',
              //             textAlign: TextAlign.start,
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontFamily: "Inter",
              //                 fontWeight: FontWeight.normal,
              //                 color: AppColor().blackColor),
              //           )),
              //       Container(
              //           margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              //           child: Image(
              //               width: 20,
              //               height: 20,
              //               image: AssetImage(ImageRes().forwardArrow)))
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Container(
                decoration: BoxDecoration(
                    color: AppColor().colorBottom,
                    border: Border.all(width: 1, color: AppColor().colorBottom),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    )),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          ' Pharmacy Notifications',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              color: AppColor().blackColor),
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(ImageRes().forwardArrow)))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColor().colorBottom,
                    border: Border.all(width: 1, color: AppColor().colorBottom),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    )),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Laboratory Notifications',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              color: AppColor().blackColor),
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(ImageRes().forwardArrow)))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColor().colorBottom,
                    border: Border.all(width: 1, color: AppColor().colorBottom),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    )),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Scan center Notifications',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              color: AppColor().blackColor),
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(ImageRes().forwardArrow)))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: AppColor().colorBottom,
              //       border: Border.all(width: 1, color: AppColor().colorBottom),
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(5),
              //       )),
              //   height: 50,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Padding(
              //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              //           child: Text(
              //             'Home care Notifications',
              //             textAlign: TextAlign.start,
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontFamily: "Inter",
              //                 fontWeight: FontWeight.normal,
              //                 color: AppColor().blackColor),
              //           )),
              //       Container(
              //           margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              //           child: Image(
              //               width: 20,
              //               height: 20,
              //               image: AssetImage(ImageRes().forwardArrow)))
              //     ],
              //   ),
              // ),

            ],
          ),
        ));
  }
}
