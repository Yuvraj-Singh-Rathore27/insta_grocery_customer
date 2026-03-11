
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../res/ImageRes.dart';
class HomeGroupCategory extends StatelessWidget {
  final String data;
  const HomeGroupCategory({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{

      },
      child:  Container(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 5,
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Row(children: [
                        Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(ImageRes().img_date)),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Jan 30, 2023'),
                      ]))
                ],
              )),
        ),
      ),

    );
  }
}
