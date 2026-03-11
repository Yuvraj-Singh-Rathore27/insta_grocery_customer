
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/model/common_model.dart';

import '../../../../controller/vender_controller.dart';
import '../../../../res/ImageRes.dart';
import '../../../../utills/constant.dart';
import 'package:get/get.dart';

class CategoryProduct extends StatelessWidget {
  CommonModel data;
   CategoryProduct({Key? key, required this.data}) : super(key: key);
  PharmacyController controller = Get.put(PharmacyController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        controller.selectedSubCategory.value=data,
        controller.getProductList(),
        // controller.getChildSubCategory()
      },
      child:  Container(
        margin: EdgeInsets.all(5),
        decoration: Constant.getBorderButtonWhite(),
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child:SizedBox(
                width: 100, // Set desired width
                height: 100, // Set desired height
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    data.logo??'',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                data.name??"",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Helvetica",
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
