import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBar.dart';
import 'cms_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
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
              GestureDetector(
                onTap: () => {
                  Get.to(() => CmsPage()),
                },
                child: Container(
                  // decoration: ,
                  decoration: BoxDecoration(
                      color: AppColor().colorBottom,
                      border:
                          Border.all(width: 1, color: AppColor().colorBottom),
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
                            'About us ',
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
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => {
                  Get.to(() => CmsPage()),
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor().colorBottom,
                      border:
                          Border.all(width: 1, color: AppColor().colorBottom),
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
                            'Privacy Policy',
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
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () => {
                        Get.to(() => CmsPage()),
                      },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor().colorBottom,
                        border:
                            Border.all(width: 1, color: AppColor().colorBottom),
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
                              'Terms of use',
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
                  )),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () => {
                        Get.to(() => CmsPage()),
                      },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor().colorBottom,
                        border:
                            Border.all(width: 1, color: AppColor().colorBottom),
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
                              'Contact us',
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
                  ))
            ],
          ),
        ));
  }
}
