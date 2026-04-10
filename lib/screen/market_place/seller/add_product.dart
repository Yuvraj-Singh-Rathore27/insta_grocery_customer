import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/sellercontroller.dart';
import 'package:insta_grocery_customer/model/ProductModel.dart';
import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/items/product_list_type_item.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppDimens.dart';
import '../../../../res/ImageRes.dart';
import '../../../../utills/constant.dart';
import '../../../controller/mp_add_product_controller.dart';
import './map_picker_screen.dart';

class AddProduct extends StatelessWidget {
  final ProductModel? product;
  final bool isEdit;
  
  AddProduct({this.product, this.isEdit = false});
  
  // Get the controller instance - this is correct way with GetX
  final MpAddProductController addProductController = Get.put(MpAddProductController());
  
  @override
  Widget build(BuildContext context) {
    // Load product for edit only once
    if (isEdit && product != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addProductController.loadProductForEdit(product!);
      });
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              
              // Basic Info Section
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              
              // Category & Brand Section
              _buildCategoryBrandSection(),
              const SizedBox(height: 24),
              
              // Location Section
              _buildLocationSection(),
              const SizedBox(height: 24),
              
              // Photos Section
              _buildPhotosSection(context),
              const SizedBox(height: 32),
               // Live Preview Section
              _buildLivePreviewSection(),
              const SizedBox(height: 24),
              
              // Submit Button
              _buildSubmitButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }
  
  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        isEdit ? "Edit Product" : "Add Product",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColor().colorPrimary,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }
  
  // ==================== LIVE PREVIEW SECTION ====================
  Widget _buildLivePreviewSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColor().colorPrimary.withOpacity(0.1), Colors.white],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColor().colorPrimary.withOpacity(0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.preview, color: AppColor().colorPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Live Preview',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor().colorPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Preview Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image & Basic Info Row
              Row(
                children: [
                  // Product Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      image: addProductController.fileList.isNotEmpty && 
                             addProductController.fileList.first.path != null
                          ? DecorationImage(
                              image: NetworkImage(addProductController.fileList.first.path!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: addProductController.fileList.isEmpty
                        ? Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 28)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  
                  // Product Name & Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addProductController.titleController.text.isEmpty
                              ? 'Product Name'
                              : addProductController.titleController.text,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // Regular Price
                            Text(
                              '₹${addProductController.productpriceController.text.isEmpty ? '0' : addProductController.productpriceController.text}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor().colorPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Offer Price (if exists)
                            if (addProductController.productOfferpriceController.text.isNotEmpty &&
                                addProductController.productOfferpriceController.text != '0') ...[
                              const SizedBox(width: 8),
                              Text(
                                '₹${addProductController.productOfferpriceController.text}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${_calculateDiscountPercentage()}% OFF',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 24),
              
              // Product Details Grid
              _buildDetailRow(
                icon: Icons.person_outline,
                label: 'Posted By',
                value: addProductController.nameController.text.isEmpty
                    ? 'Not specified'
                    : addProductController.nameController.text,
              ),
              
              const SizedBox(height: 12),
              
              // Categories Section
              if (addProductController.selectedSuperCategory.value.name != null ||
                  addProductController.selectedMainCategory.value.name != null ||
                  addProductController.selectedSubCategory.value.name != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Super Category
                      if (addProductController.selectedSuperCategory.value.name != null)
                        _buildCategoryRow(
                          'Super Category',
                          addProductController.selectedSuperCategory.value.name!,
                          Icons.category_outlined,
                        ),
                      
                      // Main Category
                      if (addProductController.selectedMainCategory.value.name != null) ...[
                        if (addProductController.selectedSuperCategory.value.name != null)
                          const SizedBox(height: 8),
                        _buildCategoryRow(
                          'Category',
                          addProductController.selectedMainCategory.value.name!,
                          Icons.folder_outlined,
                        ),
                      ],
                      
                      // Sub Category
                      if (addProductController.selectedSubCategory.value.name != null) ...[
                        if (addProductController.selectedMainCategory.value.name != null ||
                            addProductController.selectedSuperCategory.value.name != null)
                          const SizedBox(height: 8),
                        _buildCategoryRow(
                          'Sub Category',
                          addProductController.selectedSubCategory.value.name!,
                          Icons.subdirectory_arrow_right_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              
              // Location (if selected)
              if (addProductController.selectedCity.value.name != null &&
                  addProductController.selectedState.value.name != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.location_on,
                  label: 'Location',
                  value: '${addProductController.selectedCity.value.name}, ${addProductController.selectedState.value.name}',
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper: Build detail row
Widget _buildDetailRow({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: Colors.grey.shade600),
      const SizedBox(width: 8),
      SizedBox(
        width: 80,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black, // Changed from grey to black
            fontWeight: FontWeight.w500, // Added slight weight for better visibility
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

// Helper: Build category row
Widget _buildCategoryRow(String label, String value, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 14, color: AppColor().colorPrimary),
      const SizedBox(width: 8),
      Text(
        '$label: ',
        style: TextStyle(
          fontSize: 11,
          color: Colors.black, // Changed from grey to black
          fontWeight: FontWeight.w500, // Added weight for better visibility
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColor().colorPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

// Helper: Calculate discount percentage
String _calculateDiscountPercentage() {
  final priceText = addProductController.productpriceController.text;
  final offerText = addProductController.productOfferpriceController.text;
  
  if (priceText.isEmpty || offerText.isEmpty) return '0';
  
  final price = double.tryParse(priceText) ?? 0;
  final offer = double.tryParse(offerText) ?? 0;
  
  if (price <= 0 || offer <= 0 || offer >= price) return '0';
  
  final discount = ((price - offer) / price * 100).round();
  return discount.toString();
}


  // ==================== BASIC INFO SECTION ====================
  Widget _buildBasicInfoSection() {
    return _buildSectionCard(
      title: 'Basic Information',
      children: [
        _buildTextField(
          controller: addProductController.titleController,
          label: 'Product Name',
          hint: 'Enter product name',
          icon: Icons.shopping_bag_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: addProductController.nameController,
          label: 'Posted By',
          hint: 'Enter seller name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: addProductController.productpriceController,
                label: 'Price (₹)',
                hint: '0',
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: addProductController.productOfferpriceController,
                label: 'Offer Price (₹)',
                hint: '0',
                icon: Icons.local_offer_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // ==================== CATEGORY & BRAND SECTION ====================
  Widget _buildCategoryBrandSection() {
    return _buildSectionCard(
      title: 'Category & Brand',
      children: [
        Obx(() => _buildDropdownField(
          label: 'Super Category',
          value: addProductController.selectedSuperCategory.value.name ?? 'Select Super Category',
          onTap: () => _showBottomSheet(addProductController.superCategoryList, 'super_category'),
          icon: Icons.category_outlined,
        )),
        const SizedBox(height: 16),
        Obx(() => _buildDropdownField(
          label: 'Category',
          value: addProductController.selectedMainCategory.value.name ?? 'Select Category',
          onTap: () => _showBottomSheet(addProductController.categoryList, 'category'),
          icon: Icons.folder_outlined,
        )),
        const SizedBox(height: 16),
        Obx(() => _buildDropdownField(
          label: 'Sub Category',
          value: addProductController.selectedSubCategory.value.name ?? 'Select Sub Category',
          onTap: () => _showBottomSheet(addProductController.subCategoryList, 'subcategory'),
          icon: Icons.subdirectory_arrow_right_outlined,
        )),
      ],
    );
  }
  
  // ==================== LOCATION SECTION ====================
 Widget _buildLocationSection() {
  return _buildSectionCard(
    title: 'Location',
    children: [
      Obx(() {
        final city = addProductController.selectedCity.value.name;
        final state = addProductController.selectedState.value.name;

        final hasLocation =
            (city != null && city.isNotEmpty) &&
            (state != null && state.isNotEmpty);

        return GestureDetector(
          onTap: () {
            _openLocationPicker(); // 🔥 OPEN SEARCH + LOCATION UI
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.location_on,
                    color: AppColor().colorPrimary, size: 22),
                const SizedBox(width: 12),

                /// 📍 LOCATION TEXT
                Expanded(
                  child: Text(
                    hasLocation
                        ? "$city, $state"
                        : "Select Location",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          hasLocation ? FontWeight.w500 : FontWeight.normal,
                      color: hasLocation
                          ? Colors.black
                          : Colors.grey.shade600,
                    ),
                  ),
                ),

                /// ➡️ ICON
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        );
      }),
    ],
  );
}


void _openLocationPicker() {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          /// 🔍 SEARCH FIELD
          TextField(
            onChanged: (value) {
  addProductController.searchCity(value);
},
            decoration: InputDecoration(
              hintText: "Search City",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          SizedBox(height: 12),

          /// 📍 CURRENT LOCATION
          ListTile(
            leading: Icon(Icons.my_location, color: Colors.green),
            title: Text("Use Current Location"),
            onTap: () async {
              await addProductController.fetchCurrentLocation();
              Get.back();
            },
          ),

          Divider(),

          /// 🔍 SEARCH RESULTS
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount:
                    addProductController.placeSuggestions.length,
                itemBuilder: (context, index) {
                  final item =
                      addProductController.placeSuggestions[index];

                  return ListTile(
                    title: Text(item['description']),
                    onTap: () async {
                      print(item);
                      await addProductController
                          .selectPlace(item['place_id']);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  );
}
  // ==================== PHOTOS SECTION ====================
  Widget _buildPhotosSection(BuildContext context) {
    return Obx(() => _buildSectionCard(
      title: 'Product Photos',
      trailing: Text(
        '${addProductController.fileList.length}/12',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColor().colorPrimary,
        ),
      ),
      children: [
        Center(
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined, color: AppColor().colorPrimary, size: 48),
              const SizedBox(height: 8),
              Text(
                'Upload up to 12 photos',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Max 5MB each',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showImagePickerDialog(context),
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text('Select Photos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              if (addProductController.fileList.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildImageGrid(),
              ],
            ],
          ),
        ),
      ],
    ));
  }
  
  // ==================== IMAGE GRID ====================
  Widget _buildImageGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uploaded Images',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: addProductController.fileList.length,
          itemBuilder: (context, index) {
            final file = addProductController.fileList[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: file.path != null
                      ? Image.network(
                          file.path!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image, color: Colors.grey.shade400),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image, color: Colors.grey.shade400),
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => addProductController.fileList.removeAt(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  
  // ==================== SUBMIT BUTTON ====================
  Widget _buildSubmitButton(BuildContext context) {
  return Obx(() => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: addProductController.isLoading.value
          ? null
          : () => _showConfirmationDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: addProductController.isLoading.value
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              isEdit ? "Update Product" : "Publish Product",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    ),
  ));
}

// Simple confirmation dialog
void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isEdit ? "Update Product?" : "Publish Product?"),
        content: Text(isEdit 
            ? "Are you sure you want to update this product?"
            : "Are you sure you want to publish this product?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Just close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog first
              _publishProduct(); // Then publish
            },
            child: Text(
              "Yes",
              style: TextStyle(color: AppColor().colorPrimary),
            ),
          ),
        ],
      );
    },
  );
}

// Method to handle actual publish/update
void _publishProduct() {
  if (isEdit) {
    addProductController.updateMarketPlaceProduct(product!.id!);
  } else {
    addProductController.postMarketPlaceProduct();
  }
}


  // ==================== HELPER WIDGETS ====================
  Widget _buildSectionCard({
    required String title,
    Widget? trailing,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w500,
            color: Colors.black, // Changed from default to black
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14),
            onChanged: (value) {
              // Trigger update for live preview
              addProductController.update();
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey.shade500) : null,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDropdownField({
    required String label,
    required String value,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w500,
            color: Colors.black, // Changed from default to black
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 14,
                            color: value.contains('Select') ? Colors.grey.shade500 : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // ==================== HELPER METHODS ====================
  void _showBottomSheet(List data, String type) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select $type',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(data[index].name ?? ''),
                      onTap: () {
                        addProductController.onSelectCatrgory(data[index], type);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showImagePickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
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
                'Upload Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildImagePickerOption(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          addProductController.getFromGallery(false, "Upload Images");
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImagePickerOption(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          addProductController.getFromGallery(true, "Upload Images");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor().colorPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor().colorPrimary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}