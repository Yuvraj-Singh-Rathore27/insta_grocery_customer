import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBarClass {
  const ProgressBarClass();


  hideProgress(BuildContext context) async {
    Navigator.pop(context);

  }

//new progress bar not dissmissible
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7)
              ,child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

}