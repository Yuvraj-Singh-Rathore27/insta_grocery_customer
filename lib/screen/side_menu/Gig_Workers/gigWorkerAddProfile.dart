import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import '../../../controller/gigs_works_controller.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final GigsController controller = Get.find<GigsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkAndLoadProfile();
      controller.getSuperCategories();
      controller.fullNameController.addListener(() {
    controller.update();
  });

  controller.titleController.addListener(() {
    controller.update();
  });

  controller.bioController.addListener(() {
    controller.update();
  });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.isEditMode.value
                  ? "Edit Profile"
                  : "Create Profile",
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// PROFILE IMAGE
              buildCard(
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            controller.profileImagePath.value.isNotEmpty
                                ? NetworkImage(
                                    controller.profileImagePath.value)
                                : null,
                        child: controller.profileImagePath.value.isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.isUploadingImage.value
                              ? null
                              : () => controller.pickAndUploadImage(),
                          child: Container(
                            decoration:  BoxDecoration(
                              color: AppColor().colorPrimary,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: controller.isUploadingImage.value
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              /// BASIC INFO
              buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("Basic Information"),
                    const SizedBox(height: 20,),
                    TextFiledTitle("Enter Your Full Name"),
                    textField("Full Name", controller.fullNameController),
                    TextFiledTitle("Enter Your Title"),
                    textField("Professional Title",

                        controller.titleController),
                    TextFiledTitle("Enter Your Phone Number"),

                        
                    textField("Phone Number", controller.phoneController),
                    TextFiledTitle("Enter Your Email Address"),
                    textField("Email Address", controller.emailController),
                  ],
                ),
              ),

              /// LOCATION
              buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("Location"),
                    const SizedBox(height: 20,),
                      TextFiledTitle("Enter Your City Name"),
                    textField("City", controller.cityController),
                    TextFiledTitle("Press Button to Fetch Current Location"),

                    Row(
                      children: [
                        Expanded(
                          child: textField("Address",
                              controller.locationController),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.isGettingLocation.value
                              ? null
                              : () => controller.getCurrentLocation(),
                          style: buttonStyle(),
                          child: controller.isGettingLocation.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Icon(Icons.my_location,
                                  color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// CATEGORY
              Obx(() => buildCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("Category Selection"),
      const SizedBox(height: 20,),


      TextFiledTitle("Select Super Category"),

      /// SUPER CATEGORY
      DropdownButtonFormField<int>(
        value: controller.selectedSuperCategoryId.value == 0
            ? null
            : controller.selectedSuperCategoryId.value,
        decoration: inputDecoration("Select Super Category"),
        items: controller.superCategoryList.map((c) {
          return DropdownMenuItem(
            value: c.id,
            child: Text(c.name),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            final selected = controller.superCategoryList
                .firstWhere((c) => c.id == value);

            controller.getCategory(
              superCategoryId: value,
              superCategoryName: selected.name,
            );
          }
        },
      ),

      const SizedBox(height: 12),
      TextFiledTitle("Select  Category"),

      /// ❗ MESSAGE: SELECT SUPER CATEGORY FIRST
      if (controller.selectedSuperCategoryId.value == 0)
        const Text(
          "⚠️ Please select Super Category first",
          style: TextStyle(color: Colors.orange),
        ),

      /// ⏳ LOADING CATEGORY
      if (controller.isCategoryLoading.value)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(child: CircularProgressIndicator()),
        ),

      /// ❌ NO CATEGORY FOUND
      if (controller.selectedSuperCategoryId.value != 0 &&
          controller.categoryList.isEmpty &&
          !controller.isCategoryLoading.value)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "❌ No categories available for this Super Category",
            style: TextStyle(color: Colors.red),
          ),
        ),

      /// ✅ CATEGORY DROPDOWN
      if (controller.categoryList.isNotEmpty)
        DropdownButtonFormField<int>(
          value: controller.selectedCategoryId.value == 0
              ? null
              : controller.selectedCategoryId.value,
          decoration: inputDecoration("Select Category"),
          items: controller.categoryList.map((c) {
            return DropdownMenuItem(
              value: c.id,
              child: Text(c.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final selected = controller.categoryList
                  .firstWhere((c) => c.id == value);

              controller.getSubCategory(
                value,
                categoryName: selected.name,
              );
            }
          },
        ),

      const SizedBox(height: 12),

      /// ❗ MESSAGE: SELECT CATEGORY FIRST
      if (controller.selectedSuperCategoryId.value != 0 &&
          controller.selectedCategoryId.value == 0 &&
          controller.categoryList.isNotEmpty)
        const Text(
          "⚠️ Please select Category first",
          style: TextStyle(color: Colors.orange),
        ),

      /// ⏳ LOADING SUB CATEGORY
      if (controller.isSubCategoryLoading.value)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(child: CircularProgressIndicator()),
        ),

      /// ❌ NO SUB CATEGORY
      if (controller.selectedCategoryId.value != 0 &&
          controller.subCategoryList.isEmpty &&
          !controller.isSubCategoryLoading.value)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "❌ No subcategories available",
            style: TextStyle(color: Colors.red),
          ),
        ),

        TextFiledTitle("Select sub Category"),

      /// ✅ SUB CATEGORY DROPDOWN
      if (controller.subCategoryList.isNotEmpty)
        DropdownButtonFormField<int>(
          value: controller.selectedSubCategoryId.value == 0
              ? null
              : controller.selectedSubCategoryId.value,
          decoration: inputDecoration("Select Sub Category"),
          items: controller.subCategoryList.map((s) {
            return DropdownMenuItem(
              value: s.id,
              child: Text(s.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final selected = controller.subCategoryList
                  .firstWhere((s) => s.id == value);

              controller.setSubCategory(value, selected.name);
            }
          },
        ),
    ],
  ),
)),
              /// SKILLS
              buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("Skills"),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                controller.skillInputController,
                            decoration:
                                inputDecoration("Enter skill"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.addSkill,
                          style: buttonStyle(),
                          child:  Text("Add",style: TextStyle(color: AppColor().whiteColor),),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      children:
                          controller.selectedSkillsList.map((skill) {
                        return Chip(
                          label: Text(skill),
                          backgroundColor: AppColor().colorPrimary,
                          labelStyle:
                              const TextStyle(color: Colors.white),
                          deleteIcon: const Icon(Icons.close,
                              color: Colors.white),
                          onDeleted: () =>
                              controller.removeSkill(skill),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Obx(() => buildCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle("Live Preview"),

      const SizedBox(height: 10),

      Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                controller.profileImagePath.value.isNotEmpty
                    ? NetworkImage(controller.profileImagePath.value)
                    : null,
            child: controller.profileImagePath.value.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.fullNameController.text.isEmpty
                      ? "Your Name"
                      : controller.fullNameController.text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                Text(
                  controller.titleController.text.isEmpty
                      ? "Your Title"
                      : controller.titleController.text,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      /// CATEGORY PREVIEW
      Text(
        "Category: ${controller.selectedCategoryName.value.isEmpty ? 'Not selected' : controller.selectedCategoryName.value}",
      ),

      Text(
        "Sub Category: ${controller.selectedSubCategoryName.value.isEmpty ? 'Not selected' : controller.selectedSubCategoryName.value}",
      ),

      const SizedBox(height: 10),

      /// SKILLS PREVIEW
      Wrap(
        spacing: 6,
        children: controller.selectedSkillsList.map((skill) {
          return Chip(
            label: Text(skill),
            backgroundColor: AppColor().colorPrimary,
            labelStyle: const TextStyle(color: Colors.white),
          );
        }).toList(),
      ),

      const SizedBox(height: 10),

      /// BIO PREVIEW
      Text(
        controller.bioController.text.isEmpty
            ? "Your bio will appear here..."
            : controller.bioController.text,
        style: TextStyle(color: Colors.grey.shade700),
      ),
    ],
  ),
)),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: buttonStyle(),
                  onPressed: (controller.isPosting.value ||
                          controller.isUpdating.value)
                      ? null
                      : () async {
                          bool success =
                              await controller.submitGigProfile();
                          if (success) {
                            Get.back(result: true);
                          }
                        },
                  child: controller.isPosting.value ||
                          controller.isUpdating.value
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : Text(
                          controller.isEditMode.value
                              ? "Update Profile"
                              : "Create Profile",style:const TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ---------- UI HELPERS ----------

  Widget buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget TextFiledTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: inputDecoration(hint),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:  BorderSide(color: AppColor().colorPrimary),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColor().colorPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}