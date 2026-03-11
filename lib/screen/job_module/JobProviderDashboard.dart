import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:insta_grocery_customer/screen/job_module/PostResumeScreen.dart';
import 'package:insta_grocery_customer/screen/job_module/PostJobScreen.dart';
import 'package:insta_grocery_customer/screen/job_module/SimpleJobListingsScreen .dart';
import 'package:insta_grocery_customer/screen/job_module/ResumeDetailsScreen.dart';
import 'package:insta_grocery_customer/screen/job_module/myPostedJobScreen.dart';
import 'package:insta_grocery_customer/screen/job_module/resume_database_screen.dart';

import '../../../res/ImageRes.dart';

import '../../res/AppColor.dart';
import '../../../res/AppDimens.dart';


class Jobproviderdashboard extends StatelessWidget {
  Jobproviderdashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorBg,
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
          
           IconButton(onPressed: (){
            Navigator.pop(context);
           }, icon:Icon(Icons.arrow_back)),
            
           
           
            Container(
              margin: EdgeInsets.only(left:15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColor().colorPrimary,borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.work, color: AppColor().whiteColor,size: 18,),
            ),
            const SizedBox(width: 10,),
            Column(
              children: [
                
            Text("Job Provider",style: TextStyle(color: AppColor().colorPrimary,fontWeight: FontWeight.bold,fontSize: 20),),
            Text("Dashboard",style: TextStyle(color: AppColor().blackColor,fontWeight: FontWeight.w400,fontSize:15),),
              ],
            
            ),

            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 25),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColor().colorPrimary,borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.notification_add,color: AppColor().whiteColor,size: 18,),

            )
           
          ],
        ),
    
    
     
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
_WelcomeDashboard(),
            
            
           const SizedBox(height: 25,),
           
            jobProviderDashboardSection(context),
            const SizedBox(
              height: 10,
            ),
            
            const SizedBox(
              height: 10,
            ),
            _sectionBanner(),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Success Stories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            ),
            jobTestimonialCardSection()
            
          ],
        ),
      ),
    );
  }
}

// these is fo top welcome card

Widget jobProviderDashboardSection(BuildContext context) {
  return GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 1.1,
    children: [

      dashboardCard(
        icon: Icons.add,
        iconColor: Colors.red,
        title: "Post Job",
        onTap: () {
          Get.to(() => PostJobScreen());
        },
      ),

      dashboardCard(
        icon: Icons.work_outline,
        iconColor: Colors.red,
        title: "Posted Job",
        isOutlined: true,
        onTap: () {
          Get.to(() => MyPostedJobsScreen());
        },
      ),

      dashboardCard(
        icon: Icons.list,
        iconColor: Colors.red,
        title: "Resume DB",
        isOutlined: true,
        onTap: () {
          Get.to(()=>ResumeDatabaseScreen());
        },
      ),
    ],
  );
}


Widget dashboardCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required VoidCallback onTap,
  bool isOutlined = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: isOutlined ? Colors.white : iconColor,
        borderRadius: BorderRadius.circular(18),
        border: isOutlined
            ? Border.all(color: Colors.red, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: isOutlined ? Colors.red : Colors.white,
            size: 26,
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isOutlined ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}



Widget _sectionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 2.7, // Adjust based on your banner's shape
            child: Image.asset(
              ImageRes().team_member_image,
              fit: BoxFit.cover, // Ensures full coverage without cutting
            ),
          ),
        ),
      ),
    );
  }



  Widget _WelcomeDashboard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor().colorPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              /// 🔹 LEFT CONTENT (Flexible)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome TechCrop,\nSolution",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor().whiteColor,
                        fontSize: isSmallScreen ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Manage Your Job Listing and find top talent fast",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor().whiteColor.withOpacity(0.8),
                        fontSize: isSmallScreen ? 11 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// 🔹 RIGHT BUTTON
              GestureDetector(
                onTap: () {
                  // Navigate to profile
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 14,
                    vertical: isSmallScreen ? 8 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "View\nProfile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor().whiteColor,
                        fontSize: isSmallScreen ? 11 : 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}




Widget jobTestimonialCardSection() {
  final List<Map<String, dynamic>> testimonials = [
    {
      'name': 'Sarah Johnson',
      'subtitle': 'Got hired as Senior Developer at TechCorp',
      'quote': '"Frebbo Jobs helped me land my dream job in just 2 weeks!"',
      'image': 'https://i.pravatar.cc/150?img=47',
    },
    {
      'name': 'Mike Chen',
      'subtitle': 'Landed Marketing Manager role at Creative Agency',
      'quote': '"The platform made job searching so much easier and efficient."',
      'image': 'https://i.pravatar.cc/150?img=12',
    },
  ];

  return Column(
    children: testimonials.map((user) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                user['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    user['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 6),

                  // Subtitle
                  Text(
                    user['subtitle'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Quote
                  Text(
                    user['quote'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 12),

                  // ⭐⭐⭐⭐⭐ Rating
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
