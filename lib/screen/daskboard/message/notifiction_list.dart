
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';

class NotifictionList extends StatelessWidget {
  const NotifictionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    width: 50,
                    height: 50,
                    image: AssetImage(ImageRes().img_user)),
                SizedBox(width: 10,),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lawn & Garden Maintance',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor().green_color),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'desctiptipmsaas hvsadhgasaghghdsaghdhgsa',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: AppColor().wallet_medium_grey),
                      ),
                    ),
                  ],
                )),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '1 Day Ago',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor().wallet_medium_grey),
                  ),

                ),
              ],
            )),
      ),
    );
  }
}
