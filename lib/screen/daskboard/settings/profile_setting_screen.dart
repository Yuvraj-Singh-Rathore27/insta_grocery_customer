import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingState();
}

class _SettingState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:  const Center(
        child: Text('Setting'),
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     SizedBox(
      //       height: 30,
      //     ),
      //     // Image(
      //     //     width: 100,
      //     //     height: 100,
      //     //     fit: BoxFit.contain,
      //     //     image: AssetImage(ImageRes().img_user)),
      //     // SizedBox(
      //     //   height: 20,
      //     // ),
      //     // Text(
      //     //   'Kyle Maddox',
      //     //   style: TextStyle(
      //     //       fontWeight: FontWeight.normal, color: AppColor().grey_Li),
      //     // ),
      //     // SizedBox(
      //     //   height: 5,
      //     // ),
      //     // Text(
      //     //   'Kylemaddox@gmail.com',
      //     //   style: TextStyle(
      //     //       fontWeight: FontWeight.normal, color: AppColor().grey_Li),
      //     // ),
      //     // SizedBox(
      //     //   height: 20,
      //     // ),
      //     // Column(
      //     //   children: [
      //     //     Container(
      //     //       margin: EdgeInsets.fromLTRB(10,10,10,0),
      //     //       child:   Card(
      //     //           shape: RoundedRectangleBorder(
      //     //               borderRadius: BorderRadius.all(Radius.circular(5))),
      //     //           elevation: 5,
      //     //           child: Padding(
      //     //             padding: const EdgeInsets.all(15),
      //     //             child: Column(
      //     //               children: [
      //     //                 Row(
      //     //                   children: [
      //     //                     Expanded(child:  Align(
      //     //                       alignment: Alignment.centerLeft,
      //     //                       child: Text(
      //     //                         'Profile Setting',
      //     //                         style: TextStyle(
      //     //                             fontWeight: FontWeight.bold,
      //     //                             color: AppColor().green_color),
      //     //                       ),
      //     //                     )),
      //     //                     Image(
      //     //                         width: 20,
      //     //                         height: 20,
      //     //                         image: AssetImage(ImageRes().right_arrow)),
      //     //                   ],
      //     //
      //     //                 ),
      //     //               ],
      //     //
      //     //             ),
      //     //           )),
      //     //
      //     //     ),
      //     //     Container(
      //     //       margin: EdgeInsets.fromLTRB(10,10,10,0),
      //     //       child:   Card(
      //     //           shape: RoundedRectangleBorder(
      //     //               borderRadius: BorderRadius.all(Radius.circular(5))),
      //     //           elevation: 5,
      //     //           child: Padding(
      //     //             padding: const EdgeInsets.all(15),
      //     //             child: Column(
      //     //               children: [
      //     //                 Row(
      //     //                   children: [
      //     //                     Expanded(child:  Align(
      //     //                       alignment: Alignment.centerLeft,
      //     //                       child: Text(
      //     //                         'Setting',
      //     //                         style: TextStyle(
      //     //                             fontWeight: FontWeight.bold,
      //     //                             color: AppColor().green_color),
      //     //                       ),
      //     //                     )),
      //     //                     Image(
      //     //                         width: 20,
      //     //                         height: 20,
      //     //                         image: AssetImage(ImageRes().right_arrow)),
      //     //                   ],
      //     //
      //     //                 ),
      //     //               ],
      //     //
      //     //             ),
      //     //           )),
      //     //
      //     //     ),
      //     //   ],
      //     //
      //     // )
      //
      //
      //   ],
      // ),
    );
  }
}
