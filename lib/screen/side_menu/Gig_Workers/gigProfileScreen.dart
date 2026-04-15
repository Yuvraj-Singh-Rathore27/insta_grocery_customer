import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/job_module/myPostedJobScreen.dart';
import 'package:insta_grocery_customer/screen/market_place/buyer/buyer_home.dart';
import 'package:insta_grocery_customer/screen/side_menu/Gig_Workers/gigWorkerAddProfile.dart';
import '../../../controller/gigs_works_controller.dart';

import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final GigsController controller = Get.find<GigsController>();


  @override
Widget build(BuildContext context) {
  controller.checkAndLoadProfile(); // 🔥 ADD THIS

  return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.grey.shade100,
    elevation: 0,
    centerTitle: true,
    title: const Text(
      "Profile",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    leading: Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_back, color: Colors.red.shade400),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.more_vert, color: Colors.red.shade400),
        ),
      ),
    ],
  );
}

  Widget _buildBody() {
    return Obx(() {
      /// Loading State
      if (controller.isLoadingProfile.value) {
        return const Center(child: CircularProgressIndicator());
      }

      /// No Data State
      if (!controller.hasExistingProfile.value) {
        return _buildEmptyState();
      }

      /// Data Display State
      return _buildProfileContent();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No Profile Found",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create your profile to get started",
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
             Get.to(() => CreateProfileScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Create Profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileCard(),
        _buildActionButtons(),
        const SizedBox(height: 20),
        _buildAboutSection(),
        _buildSkillsSection(),
        _buildLocationSection(),
        _buildCategorySection(),
        _buildPricingSection(),
      ],
    ),
  );
}

  Widget _buildProfileCard() {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 10),
        )
      ],
    ),
    child: Column(
      children: [

        /// PROFILE IMAGE
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: controller.profileImagePath.value.isNotEmpty
                  ? NetworkImage(controller.profileImagePath.value)
                  : null,
              child: controller.profileImagePath.value.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt,
                  size: 16, color: Colors.white),
            )
          ],
        ),

        const SizedBox(height: 12),

        /// NAME
        Text(
          capitalize(controller.fullNameController.text.isEmpty
              ? "Your Name"
              : controller.fullNameController.text,),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        /// TITLE
        Text(
          capitalizeFirstLetter(controller.titleController.text.isEmpty
              ? "Your Title"
              : controller.titleController.text,),
          style: TextStyle(color: Colors.grey.shade600),
        ),

        const SizedBox(height: 14),

        /// STATUS + SWITCH
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  controller.isProfileActive.value
                      ? "Active"
                      : "Inactive",
                  style: TextStyle(
                    color: controller.isProfileActive.value
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(width: 10),
            Obx(() => Switch(
                  value: controller.isProfileActive.value,
                  onChanged: (value) {
                    controller.toggleProfileStatus(value);
                  },
                )),
          ],
        ),

        const Divider(height: 24),

        /// STATS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            _StatItem("4.9", "Rating"),
            _StatItem("124", "Jobs"),
            _StatItem("98%", "Success"),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildProfileImage() {
  // Check if we have an image path
  if (controller.profileImagePath.value.isNotEmpty) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipOval(
          child: Image.network(
            controller.profileImagePath.value,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('Image loading error: $error');
              print('Image path: ${controller.profileImagePath.value}');
              return _buildDefaultProfileImage();
            },
          ),
        ),
        _buildCameraIcon(),
      ],
    );
  }
  
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      _buildDefaultProfileImage(),
      _buildCameraIcon(),
    ],
  );
}

Widget _buildDefaultProfileImage() {
  return CircleAvatar(
    radius: 50,
    backgroundColor: Colors.grey.shade200,
    child: Icon(Icons.person, size: 50, color: Colors.grey.shade400),
  );
}

Widget _buildCameraIcon() {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: const Icon(
      Icons.camera_alt,
      size: 16,
      color: Colors.white,
    ),
  );
}


  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _OutlinedButton(
            icon: Icons.edit,
            label: "Edit Profile",
            onPressed: () => Get.to(()=>CreateProfileScreen()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OutlinedButton(
            icon: Icons.share,
            label: "Share",
            onPressed: () {
               shareProfile(); 
            },
          ),
        ),
      ],
    );
  }

  void shareProfile() {
  final name = controller.fullNameController.text;
  final title = controller.titleController.text;
  final category = controller.selectedCategoryName.value;
  final subCategory = controller.selectedSubCategoryName.value;
  final bio = controller.bioController.text;

  final text = '''
👤 *$name*
💼 $title

📌 Category: $category
📂 Sub Category: $subCategory

📝 About:
$bio

📲 Connect with me!
''';

  Share.share(text);
}

  Widget _buildAboutSection() {
    if (controller.bioController.text.isEmpty) return const SizedBox.shrink();
    
    return _SectionCard(
      title: "About",
      child: Text(
        controller.bioController.text,
        style: TextStyle(color: Colors.grey.shade700, height: 1.5),
      ),
    );
  }

  Widget _buildSkillsSection() {
    if (controller.selectedSkillsList.isEmpty) return const SizedBox.shrink();
    
    return _SectionCard(
      title: "Skills",
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.selectedSkillsList
            .map((skill) => Chip(
                  label: Text(capitalizeFirstLetter(skill)),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade700),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLocationSection() {
    if (controller.locationController.text.isEmpty && 
        controller.cityController.text.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return _SectionCard(
      title: "Location",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.locationController.text.isNotEmpty)
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    controller.locationController.text,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          if (controller.cityController.text.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              controller.cityController.text,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
          if (controller.serviceRadiusController.text.isNotEmpty &&
              int.tryParse(controller.serviceRadiusController.text) != null &&
              int.parse(controller.serviceRadiusController.text) > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Service Radius: ${controller.serviceRadiusController.text} km",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    if (controller.selectedCategoryName.value.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return _SectionCard(
      title: "Category",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryChip(
            icon: Icons.category,
            label: controller.selectedCategoryName.value,
          ),
          if (controller.selectedSubCategoryName.value.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildCategoryChip(
              icon: Icons.subdirectory_arrow_right,
              label: controller.selectedSubCategoryName.value,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  

  Widget _buildPricingSection() {
    if (controller.priceController.text.isEmpty) return const SizedBox.shrink();
    
    return _SectionCard(
      title: "Pricing",
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_rupee, size: 20, color: Colors.green.shade700),
            const SizedBox(width: 4),
             Text(
             capitalizeFirstLetter( controller.priceType.value,),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              controller.priceController.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Stat Item Widget
class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

/// Reusable Outlined Button
class _OutlinedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _OutlinedButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}

/// Reusable Section Card
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
  
}



