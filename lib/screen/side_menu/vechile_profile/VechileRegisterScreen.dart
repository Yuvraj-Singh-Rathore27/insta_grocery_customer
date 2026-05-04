import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/vechile_controller.dart';
import '../../../model/vechile_model.dart';
import '../../../model/file_model.dart';

class VehiclePostScreen extends StatelessWidget {
  VehiclePostScreen({super.key});

  final controller = Get.find<VehicleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Complete Registration",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDriverSection(),
            const SizedBox(height: 20),
            _buildVehicleSection(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.directions_car, color: Colors.white, size: 35),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Complete Registration",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Fill all the details below to get started",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.person_outline, "Driver Details"),
          const SizedBox(height: 16),
          _textField(
            "Driver Name",
            controller.nameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 12),
          _textField(
            "Contact Number",
            controller.phoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _textField(
            "License Number",
            controller.licenseController,
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 12),
          _textField(
            "License Expiry Date",
            controller.expiryController,
            icon: Icons.calendar_today,
            suffixIcon: Icons.event,
          ),
          const SizedBox(height: 20),
          _uploadSection(
            title: "Driver Photo",
            fileList: controller.driverPhotoList,
            onUpload: () => _showImagePickerOptions('driver_photo'),
            icon: Icons.camera_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.directions_car_outlined, "Vehicle Details"),
          const SizedBox(height: 16),
          
          // Category Dropdown
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          
          // Subcategory Dropdown
          _buildSubCategoryDropdown(),
          const SizedBox(height: 16),
          
          _textField(
            "Vehicle Number",
            controller.vehicleNumberController,
            icon: Icons.confirmation_number,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 12),
          _textField(
            "Make & Model",
            controller.modelController,
            icon: Icons.build,
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _textField(
                  "Year",
                  controller.yearController,
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  "Color",
                  controller.colorController,
                  icon: Icons.color_lens,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Seating Capacity
          _buildSeatingCapacity(),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _textField(
                  "Base Charges",
                  controller.baseController,
                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  "Rate per KM",
                  controller.rateController,
                  icon: Icons.trending_up,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // RC Document
          _uploadSection(
            title: "RC Document",
            fileList: controller.rcDocumentList,
            onUpload: () => _showImagePickerOptions('rc_document'),
            icon: Icons.description,
          ),
          const SizedBox(height: 16),
          
          // Insurance Document
          _uploadSection(
            title: "Insurance Document",
            fileList: controller.insuranceDocumentList,
            onUpload: () => _showImagePickerOptions('insurance_document'),
            icon: Icons.security,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      if (controller.isLoadingCategories.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Category",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Category>(
                isExpanded: true,
                hint: Text(
                  "Select Category",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                value: controller.categoryList.contains(controller.selectedCategory.value)
                    ? controller.selectedCategory.value
                    : null,
                items: controller.categoryList.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.name ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: controller.onCategorySelected,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.red),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSubCategoryDropdown() {
    return Obx(() {
      if (controller.selectedCategory.value == null) {
        return const SizedBox();
      }
      
      if (controller.isLoadingSubCategories.value) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Subcategory",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SubCategory>(
                isExpanded: true,
                hint: Text(
                  "Select Subcategory",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                value: controller.selectedSubCategory.value,
                items: controller.subCategoryList.map((subCategory) {
                  return DropdownMenuItem(
                    value: subCategory,
                    child: Text(
                      subCategory.name ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: controller.onSubCategorySelected,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.red),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSeatingCapacity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Seating Capacity",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [2, 4, 6, 8].map((seat) {
            final isSelected = controller.selectedSeat.value == seat;
            return GestureDetector(
              onTap: () => controller.selectedSeat.value = seat,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    "$seat",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _uploadSection({
    required String title,
    required RxList<FileModel> fileList,
    required VoidCallback onUpload,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onUpload,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Obx(() {
              if (fileList.isNotEmpty) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        fileList.first.path ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, color: Colors.red, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                "File uploaded",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => fileList.clear(),
                          customBorder: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    "Tap to upload",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Supported: JPG, PNG",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions(String type) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Choose Option",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Select how you want to upload",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _pickerOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  color: Colors.blue,
                  onTap: () {
                    Get.back();
                    controller.pickImageFromCamera(type);
                  },
                ),
                _pickerOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  color: Colors.green,
                  onTap: () {
                    Get.back();
                    controller.pickImageFromGallery(type);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _pickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isSubmitting.value ? null : controller.submitAll,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 55),
          elevation: controller.isSubmitting.value ? 0 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: controller.isSubmitting.value
    ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5,
        ),
      )
    : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.vehicleId.value == 0
                ? "Complete Registration"   // 👉 First time
                : "Update Details",        // 👉 Edit mode
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            controller.vehicleId.value == 0
                ? Icons.arrow_forward
                : Icons.edit,
            size: 18,
          ),
        ],
      ),
      ),
    ));
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _textField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    IconData? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.red, size: 20)
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.red, size: 20)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}