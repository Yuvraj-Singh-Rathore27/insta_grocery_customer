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
import '../../../toolbar/TopBar.dart';

class AddProduct extends StatelessWidget {
  final ProductModel? product;
  final bool isEdit;
  AddProduct({this.product,this.isEdit=false});
  MpAddProductController addProductController =
      Get.put(MpAddProductController());
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if (isEdit && product != null) {
  addProductController.loadProductForEdit(product!);
}

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       
        title: Text("Add Products",style: TextStyle(fontWeight: FontWeight.bold,color: AppColor().colorPrimary),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Photos',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        color: AppColor().blackColorMore,
                      ),
                    ),
                    Text(
                      '${addProductController.fileList.length}/12',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: AppColor().blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              _buildVisualsSection(context),
              SizedBox(height: 20),
              // 1. Basic Product Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Basic Product Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildBasicProductInfoSection(),
              SizedBox(height: 20),
              // Category & Brand Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Category & Brand Selection',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColor,
                  ),
                ),
              ),
              SizedBox(height: 16),

              _buildCategoryBrandSection(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Composition and Specification',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColor,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // 2. Composition and Specification
              _buildCompositionSpecificationSection(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Packaging and Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: AppColor().blackColorMore,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // 3. Packaging and Quantity
              _buildPackagingQuantitySection(),
              SizedBox(height: 20),

              // 4. Price and Discounts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Price and Discounts',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColor,
                  ),
                ),
              ),
              SizedBox(height: 16),

              _buildPriceDiscountSection(),
              SizedBox(height: 20),

              // 5. Visuals

              // 6. Location
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: AppColor().blackColorMore,
                  ),
                ),
              ),
              SizedBox(height: 16),

              _buildLocationSection(),
              SizedBox(height: 20),

              // 7. Manufacturer and Branding Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Manufacturer and Branding Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: AppColor().blackColorMore,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildManufacturerBrandingSection(),
              SizedBox(height: 20),

              // Submit Button
              _buildSubmitButton(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget 1: Category & Brand Selection
  Widget _buildCategoryBrandSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Selection
          _buildSectionTitle('Select Category *'),
          SizedBox(height: 10),
         Obx(()=>
           _buildDropdownSelector(
            addProductController.selectedMainCategory.value.name ??
                'Select Category',
            () => showDropDownList(
              addProductController,
              addProductController.categoryList,
              'category',
            ),
          ),
         ),

          // Sub Category Selection
          SizedBox(height: 15),
          _buildSectionTitle('Select Sub Category'),
          SizedBox(height: 10),
          Obx(()=>_buildDropdownSelector(
            addProductController.selectedSubCategory.value.name ??
                'Select Sub Category',
            () => showDropDownList(
              addProductController,
              addProductController.subCategoryList,
              'subcategory',
            ),
          ),),

          // Brands Selection
          SizedBox(height: 15),
          _buildSectionTitle('Select Brands *'),
          SizedBox(height: 10),
         Obx(()=> _buildDropdownSelector(
            addProductController.selectedBrands.value.name ?? 'Select Brands',
            () => showDropDownList(
              addProductController,
              addProductController.brandsList,
              'brands',
            ),
          ),)
        ],
      ),
    );
  }

  // Widget 1: Basic Product Information
  Widget _buildBasicProductInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Field
          _buildSectionTitle('Product Title *'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.titleController,
            'Enter Product Title',
            TextInputType.text,
          ),

          // Product Name Field
          SizedBox(height: 15),
          _buildSectionTitle('Product Name *'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.nameController,
            'Enter Product Name',
            TextInputType.text,
          ),

          // Product Code Field
          SizedBox(height: 15),
          _buildSectionTitle('Product Code'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.productCodeController,
            'Enter Product Code',
            TextInputType.text,
          ),

          // Bar Code Field
          SizedBox(height: 15),
          _buildSectionTitle('Bar Code'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.barCodeController,
            'Bar Code',
            TextInputType.text,
          ),

          // Description Field
          SizedBox(height: 15),
          _buildSectionTitle('Product Description'),
          SizedBox(height: 10),
          _buildMultilineTextField(
            addProductController.decriptionController,
            'Enter Product Description',
            TextInputType.multiline,
            80,
          ),
           const SizedBox(height: 15),
          _buildSectionTitle('Product Hashtag'),
         const SizedBox(height: 10),
          _buildMultilineTextField(
            addProductController.hashtagController,
            'Enter Product hashtag',
            TextInputType.multiline,
            80,
          ),
        ],
      ),
    );
  }

  // Widget 2: Composition and Specification
  Widget _buildCompositionSpecificationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compositions Field
          _buildSectionTitle('Compositions'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.compositionsController,
            'Enter Compositions',
            TextInputType.text,
          ),

          // Strength Field
          SizedBox(height: 15),
          _buildSectionTitle('Strength'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.strengthController,
            'Strength',
            TextInputType.text,
          ),

          // Self Life Field
          SizedBox(height: 15),
          _buildSectionTitle('Self Life'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.selfLifeController,
            'Self Life',
            TextInputType.text,
          ),
        ],
      ),
    );
  }

  // Widget 3: Packaging and Quantity
  Widget _buildPackagingQuantitySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Pack Size'),
                    SizedBox(height: 10),
                    _buildTextField(
                      addProductController.packSizeController,
                      'Pack Size',
                      TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Quantity'),
                    SizedBox(height: 10),
                    _buildTextField(
                      addProductController.quantityController,
                      'Quantity',
                      TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Sizes Field
          SizedBox(height: 15),
          _buildSectionTitle('Sizes'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.sizesController,
            'Enter Sizes',
            TextInputType.text,
          ),
        ],
      ),
    );
  }

  // Widget 4: Price and Discounts
  Widget _buildPriceDiscountSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Fields
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Product Price *'),
                    SizedBox(height: 10),
                    _buildTextField(
                      addProductController.productpriceController,
                      'Price',
                      TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Offer Price'),
                    SizedBox(height: 10),
                    _buildTextField(
                      addProductController.productOfferpriceController,
                      'Offer Price',
                      TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Discount Percentage
          SizedBox(height: 15),
          _buildSectionTitle('Discount Percentage'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.discountPercentageController,
            'Discount %',
            TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  // Widget 5: Visuals
  Widget _buildVisualsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Photo counter and info
      const SizedBox(height: 30,),
          Center(
              child: Icon(
            Icons.camera,
            color: AppColor().colorPrimary,
            size: 60,
          )),
          SizedBox(height:30 ),

          Center(
            child: Text(
              'Upload up to 12 photos (Max 5MB each)',
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: AppColor().blackColor,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Upload button
          GestureDetector(
            onTap: () => showCustomDialog(
                context, addProductController, "Upload Images"),
            child: Center(
              child: Container(
                width: 200,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  
                  color: AppColor().colorPrimary,
                ),
                child: Center(
                  child: Text(
                    'Select Photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      color: AppColor().whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Uploaded Images Preview
          Obx(() {
            if (addProductController.fileList.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  _buildSectionTitle('Uploaded Images'),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: addProductController.fileList.length,
                    itemBuilder: (context, index) {
                      var file = addProductController.fileList[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            file.path != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      file.path!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: Icon(Icons.image,
                                              size: 30,
                                              color: Colors.grey.shade400),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.image,
                                        size: 30, color: Colors.grey.shade400),
                                  ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  addProductController.fileList.removeAt(index);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return SizedBox();
          }),
        ],
      ),
    );
  }

  // Widget 6: Location
  // Widget 6: Location
Widget _buildLocationSection() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // State Dropdown
        _buildSectionTitle('Select State *'),
        SizedBox(height: 10),
       Obx(()=> _buildStateDropdownSelector(
          addProductController.selectedState.value.name ?? 'Select State',
          () => showDropDownList(
            addProductController,
            addProductController.stateList,
            'state',
          ),
        ),),
        // City ID Field
        SizedBox(height: 15),
        _buildSectionTitle('Select City'),
        SizedBox(height: 10),
        
        Obx(()=> _buildCityDropdownSelector(
          addProductController.selectedCity.value.name ?? 'Select city',
          () => showDropDownList(
            addProductController,
            addProductController.cityList,
            'city',
          ),
        ),),

        // Coordinates
        SizedBox(height: 15),
        Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Latitude'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.latitudeController,
            'Latitude',
            TextInputType.text,
          ),
        ],
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Longitude'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.longitudeController,
            'Longitude',
            TextInputType.text,
          ),
        ],
      ),
    ),
  ],
),

SizedBox(height: 15),

GestureDetector(
  onTap: () {
    addProductController.fetchCurrentLocation();
  },
  child: Container(
    height: 48,
    decoration: BoxDecoration(
      color: AppColor().colorPrimary,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        "📍 Use My Current Location",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
  ),
),

      ],
    ),
  );
}

  // Widget 7: Manufacturer and Branding Details
  Widget _buildManufacturerBrandingSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Name Field
          _buildSectionTitle('Company Name'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.companyNameController,
            'Enter Company Name',
            TextInputType.text,
          ),

          // Manufacturer Details Field
          SizedBox(height: 15),
          _buildSectionTitle('Manufacturer Details'),
          SizedBox(height: 10),
          _buildTextField(
            addProductController.manufacturerDetailsController,
            'Manufacturer Details',
            TextInputType.text,
          ),
        ],
      ),
    );
  }

  // Helper Widget Methods
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontFamily: "Inter",
        fontWeight: FontWeight.bold,
        color: AppColor().blackColor,
      ),
    );
  }

  Widget _buildTextField(
  TextEditingController controller,
  String hintText,
  TextInputType keyboardType, {
  int maxLines = 1,
  bool readOnly = false, // NEW: Add readOnly parameter
}) {
  return Container(
    height: maxLines > 1 ? null : AppDimens().input_text_width,
    padding: EdgeInsets.only(left: 10.0, bottom: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColor().colorPrimary),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly, // NEW: Use readOnly parameter
      style: TextStyle(
        color: AppColor().blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        fontFamily: "Inter",
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[800],
          fontSize: 12,
        ),
      ),
    ),
  );
}
  Widget _buildMultilineTextField(
    TextEditingController controller,
    String hintText,
    TextInputType keyboardType,
    double height,
  ) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor().colorPrimary),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        maxLines: null,
        expands: false,
        style: TextStyle(
          color: AppColor().blackColor,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: "Inter",
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[800],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSelector(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens().input_text_width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor().colorPrimary),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: AppDimens().front_regular,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                color: AppColor().blackColor,
              ),
            ),
            SvgPicture.asset(ImageRes().downArrowSvg),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          showCustomDialog(context, addProductController, "Upload Images"),
      child: Container(
        height: AppDimens().input_text_width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor().colorAccentChn, width: 1),
          color: AppColor().colorExp,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Image',
              style: TextStyle(
                fontSize: AppDimens().front_small,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                color: AppColor().blackColor,
              ),
            ),
            SizedBox(width: 10),
            SvgPicture.asset(ImageRes().uploadeDoc),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xffEBF4FF),
      ),
      child: GestureDetector(
        onTap: () {
if (isEdit) {
  addProductController.updateMarketPlaceProduct(product!.id!);
} else {
  addProductController.postMarketPlaceProduct();
}
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          height: 25,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor().colorPrimary,
          ),
          child: Center(
            child: Text(
              "Add Product",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: "UltimaPro",
                fontStyle: FontStyle.normal,
                fontSize: AppDimens().front_larger,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Existing methods (keep these as they are)
  void showDropDownList(
    MpAddProductController addProductController,
    List data,
    String type,
  ) {
    BuildContext context = Get.context as BuildContext;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () => {
                                  addProductController.onSelectCatrgory(
                                      data[index], type),
                                  Navigator.pop(context),
                                },
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(data[index].name ?? ''),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    ).then((_) {
    // This ensures UI updates after the bottom sheet is closed
    addProductController.update();
  });
  }

  void showCustomDialog(
    BuildContext context,
    MpAddProductController controller,
    String type,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width - 20,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please select Option',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().colorPrimary,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          Navigator.of(context).pop(),
                          controller.getFromGallery(false, type),
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor().colorPrimary),
                            color: AppColor().colorPrimary,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text(
                            'Gallery',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              color: AppColor().whiteColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => {
                          Navigator.of(context).pop(),
                          controller.getFromGallery(true, type),
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: width - 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor().colorPrimary),
                            color: AppColor().colorPrimary,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text(
                            'Camera',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              color: AppColor().whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildStateDropdownSelector(String value, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: AppDimens().input_text_width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor().colorPrimary),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppDimens().front_regular,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                color: AppColor().blackColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SvgPicture.asset(ImageRes().downArrowSvg),
        ],
      ),
    ),
  );
}

Widget _buildCityDropdownSelector(String value, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: AppDimens().input_text_width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor().colorPrimary),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppDimens().front_regular,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
                color: AppColor().blackColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SvgPicture.asset(ImageRes().downArrowSvg),
        ],
      ),
    ),
  );
}