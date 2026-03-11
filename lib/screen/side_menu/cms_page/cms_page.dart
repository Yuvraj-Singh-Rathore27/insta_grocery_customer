import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../toolbar/TopBar.dart';

class CmsPage extends StatefulWidget {
  const CmsPage({Key? key}) : super(key: key);

  @override
  State<CmsPage> createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(
            title: 'About Us',
            menuicon: false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            onPressed: () => {},
            onTitleTapped: () => {}),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(10),
          child: Text(
            '''
Your privacy is important to us. This Privacy Policy explains how Frebbo collects, uses, and protects your information.  

1. Information We Collect  
- Location data: used to show nearby automobiles and services.  
- Other data: like email or name, if you create an account.  

2. How We Use Information  
- To provide location-based results.  
- To personalize your experience.  

3. Data Storage & Sharing  
- We do not share your location data with third parties.  
- Data is stored securely only as long as needed.  

4. Your Choices  
- You can deny location permission and still browse manually.  
- Contact us to delete your account and data.  

5. Contact Us  
:frebboconnect@gmail.com
          ''',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        )));
  }
}
