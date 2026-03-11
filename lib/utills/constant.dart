import 'package:flutter/cupertino.dart';

import '../res/AppColor.dart';

class Constant{

  static  getBorderButtonWhite(){

    return BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: AppColor().red));


  }
  static  getBorderWhite(){

    return BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: AppColor().whiteColor));


  }
  static  getBorderSelected(){

    return BoxDecoration(
        color: AppColor().selectedBgColor,
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    border: Border.all(color: AppColor().selectedBgColor));


  }

  static getBorderUnSelected(){

    return BoxDecoration(
        color: AppColor().searchFillterColor2,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: AppColor().searchFillterColor2));

  }

  static  getNewSelectedBoader(){

    return BoxDecoration(
        color: AppColor().selectedBgColor1,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: AppColor().whiteColor,
        width: 1));
  }
  static  getNewSelectedBoaderDyn(id){

    return BoxDecoration(
        color:id,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: AppColor().whiteColor,
            width: 1));
  }
  static  getNotSelectedExperienced(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().colorGrayLess,
            width: 1),
        color: AppColor().whiteColor);
  }
  static  getProdocyBoarder(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().red,
            width: 1),
        color: AppColor().whiteColor);
  }

  static  getProdocyUnBoarder(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor().whiteColor);
  }



  static  getServicesBoarder(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().red,
            width: 1),
        color: AppColor().colorAccentChn2);
  }

  static  getServicesUnBoarder(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor().colorAccentChn2);
  }



  static  getPrimaryBoarder(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().red,
            width: 1),
        color: AppColor().red);
  }


  static  getSelectedExperienced(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().colorAccentChn,
            width: 1),
        color: AppColor().colorExp);
  }

  static  getBgEditTextBox(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().colorPrimary,
            width: 1),
        color: AppColor().whiteColor);
  }
  static  getBgEditTextBox2(){

    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColor().colorPrimary,
            width: 1),
        color: AppColor().searchFillterColor2);
  }
  String convertTo12HourFormat(String time) {
    // Split the time into hours, minutes, and seconds
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String minutes = parts[1];
    String seconds = parts[2];

    // Determine AM or PM suffix
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert hour from 24-hour to 12-hour format
    if (hour > 12) {
      hour = hour - 12;
    } else if (hour == 0) {
      hour = 12;
    }

    // Format the time in 12-hour format
    String formattedTime = '${hour.toString().padLeft(2, '0')}:$minutes:$seconds $period';

    return formattedTime;
  }




}