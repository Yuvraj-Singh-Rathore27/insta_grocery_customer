import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'notifiction_list.dart';

class NotifictionScreen extends StatefulWidget {
  const NotifictionScreen({Key? key}) : super(key: key);

  @override
  State<NotifictionScreen> createState() => _MessageState();
}

class _MessageState extends State<NotifictionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child:ListView.builder(
          // the number of items in the list
            itemCount: 10,
            // display each item of the product list
            itemBuilder: (context, index) {
              return NotifictionList();
            })
    );
  }
}
