import 'dart:ui';

import 'package:flutter/material.dart';
import '../res/AppColor.dart';
import '../res/AppString.dart';
import '../res/ImageRes.dart';
import '../webservices/ApiUrl.dart';

class TopBarOnlyBack extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool menuback;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  //const TopBar({Key key}) : super(key: key);
  TopBarOnlyBack(
      {required this.title,
      required this.menuback,
      required this.onPressed,
      required this.onTitleTapped})
      : preferredSize = const Size.fromHeight(60.0);

  @override
  State<TopBarOnlyBack> createState() => _TopBarState(this.menuback);
}

class _TopBarState extends State<TopBarOnlyBack> with TickerProviderStateMixin {
  bool menuicon=false;
  bool menuback=false;

  _TopBarState( bool menuback){
    this.menuback=menuback;

  }
  Tween<double> _tween = Tween(begin: .85, end: 1.1);
  bool isAnimationActive = false;

  //bool isNormalWidget=false;

  @override
  dispose() {
//    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: 60,
            child: Container(
              // color: AppColor().whiteColor,
              padding: EdgeInsets.all(5),

              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      menuicon?GestureDetector(
                        onTap: () {
                          //  Scaffold.of(context).openDrawer();
                        },
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Image.asset(
                              color: AppColor().colorPrimary,
                              ImageRes().img_menu,
                              height: 35,
                              width: 30,
                            ),

                          )
                        ),
                      )
                          :GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Image.asset(
                                ImageRes().img_back,
                                color: AppColor().colorPrimary,
                                height: 35,
                                width: 30,
                              ),

                            )
                        ),
                      ),

                    ],
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Image.asset(ImageRes().acopo_logo,
                            color: AppColor().colorPrimary,
                            fit: BoxFit.contain, height: 50, width: 100)),
                  ),
                ],
              ),
            )));
  }
}
