import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';

import '../../../controller/MySupportController.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBar.dart';

class MySuggestionsPage extends StatefulWidget {
  const MySuggestionsPage({Key? key}) : super(key: key);

  @override
  State<MySuggestionsPage> createState() => _MySuggestionsPageState();
}

class _MySuggestionsPageState extends State<MySuggestionsPage> {
  MySupportController controller = Get.put(MySupportController());
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
        body:  Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // width: 300,// <-- TextField width
                height: 150, // <-- TextField height
                child:   TextField(
                  obscureText: false,

                  controller: controller.SuggestionInputController,
                  onChanged: (value) => {
                    controller.suggestionText.value = value,
                  },
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(filled: true, hintText: 'Enter a message'),

                ),
              ),

              const SizedBox(
                height: 50,
              ),

          GestureDetector(
            onTap: ()=>{
            controller.submitSuggestion(context),
          },
            child:
              Center(
                  child: Container(
                    height: 50,
                    // width: 300,
                    decoration: BoxDecoration(
                        color: AppColor().colorPrimary,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    // width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(

                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColor().whiteColor),
                      ),

                    ) ,
                  )

              ))


            ],
          ),
        ));
  }
}
