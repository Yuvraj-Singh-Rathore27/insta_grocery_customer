import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/address_managment/clientSetLocation.dart';


import '../../controller/homepage_controller.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../../toolbar/SliderBar.dart';
import '../../toolbar/TopBar.dart';
import '../controller/BaseController.dart';
import 'home/home_screen.dart';



class DashBord extends StatefulWidget {
  int indexShow=0;
  String game_call="";

  DashBord(this.indexShow, this.game_call);

  DashBordState createState() => DashBordState(indexShow, game_call);
}

class DashBordState extends State<DashBord> {
  BaseController controller = Get.put(BaseController());


  late double height, width;
  int indexCus;
  String game_call;
  DashBordState(this.indexCus, this.game_call);

  final List<Widget> _children = [
     Home(),

  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width =MediaQuery.of(context).size.width;
    //internet check
    controller.indexCus.value=indexCus;
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          Container(
              width: width,
              color: AppColor().whiteColor,
          ),
       SizedBox(
          width: width,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            drawer: SideMenuBar(),
            appBar: TopBar(
              title: '',
              menuicon: true,
              menuback: false,
              iconnotifiction: true,
              is_wallaticon: true,
              is_supporticon: false,
              is_whatsappicon: false,
              onPressed: ()=>{
                Get.to(ClientLocationSetOnMap(type: "pickup"))

              },
              onTitleTapped: ()=>{

              }
            ),
            body: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 20,
                    width: 50,

                    //color: Colors.red,
                  ),
                ),
              ),
              Obx(() => _children[controller.indexCus.value]),

            ]),
          ),
        ),
        ],
      ),
    );

  }

  Widget backgroudImage() {
    return Container(
      width: width,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.black, Colors.black12],
          begin: Alignment.bottomCenter,
          end: Alignment.center,
        ).createShader(bounds),
        blendMode: BlendMode.darken,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_bg_full.webp'),
            ),
          ),
        ),
      ),
    );
  }




  @override
  void dispose() {
    super.dispose();
  }

}
