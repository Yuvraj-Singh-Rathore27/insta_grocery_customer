import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import '../../../controller/customer_event_controller.dart';
import '../../../res/AppColor.dart';

class PostCustomerEventScreen extends StatelessWidget {
  PostCustomerEventScreen({super.key});

  final controller = Get.put(CustomerEventController());
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    await controller.pickEventImage(false); // uses upload logic
  }

  @override
  Widget build(BuildContext context) {
    controller.clearEventForm();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Add New Event",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= CATEGORY SECTION =================
            const Text(
              "Select Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return DropdownButtonFormField<int>(
                value: controller.selectedCategoryId.value == 0
                    ? null
                    : controller.selectedCategoryId.value,
                items: controller.categories
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name ?? '', style: TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onChanged: (v) {
  if (v == null) return;

  controller.selectedCategoryId.value = v;

  // clear old subcategory
  controller.selectedSubCategoryId.value = 0;
  controller.subCategories.clear();

  // load new subcategories
  controller.getCustomerEventSubCategory(v);
},
                decoration: InputDecoration(
                  hintText: "Choose category",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              );
            }),

            const SizedBox(height: 15),

const Text(
  "Select Subcategory",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
),

const SizedBox(height: 12),

Obx(() {
  // Loading state
  if (controller.isLoadingSubCategory.value) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: CircularProgressIndicator(),
      ),
    );
  }

  return DropdownButtonFormField<int>(
    value: controller.selectedSubCategoryId.value == 0
        ? null
        : controller.selectedSubCategoryId.value,

    items: controller.subCategories
        .map((e) => DropdownMenuItem(
              value: e.id,
              child: Text(e.name ?? ''),
            ))
        .toList(),

    onChanged: (v) {
      // If category not selected → show alert
      if (controller.selectedCategoryId.value == 0) {
        Get.snackbar(
          "Select Category",
          "Please select category first",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      controller.selectedSubCategoryId.value = v ?? 0;
    },

    decoration: InputDecoration(
      hintText: controller.selectedCategoryId.value == 0
          ? "Select category first"
          : "Choose subcategory",
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: const Icon(Icons.keyboard_arrow_down),
    ),
  );
}),
            const SizedBox(height: 30),
            const Text(
              "Event Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // ================= EVENT DETAILS FIELDS =================
            _buildLabel("Event organizer"),
            _textField("Enter organizer name", controller.organizerController),
            
            const SizedBox(height: 15),
            _buildLabel("Event Title"),
            _textField("Your Event Title", controller.titleController),
            
            const SizedBox(height: 15),
            _buildLabel("Description"),
            _textField("Tell us about your event...", controller.descriptionController,
                maxLines: 4),
            const SizedBox(height: 15),
            _buildLabel("Hashtag"),
            _textField("Tell us about your event...", controller.hashtagController,
                maxLines: 4),

            const SizedBox(height: 30),
            const Divider(height: 1, color: Colors.grey),

            const SizedBox(height: 30),
            const Text(
              "Event Time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20,),
            // ================= DATE & TIME =================
            Row(
              children: [
                Expanded(child: _datePicker(context)),
                const SizedBox(width: 15),
                Expanded(child: _timePicker(context)),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(height: 1, color: Colors.grey),
                        const SizedBox(height: 30),

            Row(
              children: [
                Expanded(child: _datePickerEndDate(context)),
                const SizedBox(width: 15),
                Expanded(child: _timePickerEndTime(context)),
              ],
            ),
                        const Divider(height: 1, color: Colors.grey),


            const SizedBox(height: 30),

            const SizedBox(height: 30),
            // ================= FEE SECTION =================
            const Text(
              "Event Fee",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

 

Obx(() {
  return Row(
    children: [
      _feeChip("Free", "🎁", isSelected: controller.feeType.value == "free"),
      SizedBox(width: 12),
      _feeChip("Paid", "🎟️", isSelected: controller.feeType.value == "paid"),
    ],
  );
}),
            const SizedBox(height: 15),
            Obx(() {
              return controller.feeType.value == "paid"
                  ? _textField("Price", TextEditingController(),
                      keyboard: TextInputType.number,
                      onChanged: (v) => controller.price.value = double.tryParse(v) ?? 0)
                  : const SizedBox();
            }),

            const SizedBox(height: 30),
            const Divider(height: 1, color: Colors.grey),

            const SizedBox(height: 30),
            // ================= LOCATION SECTION =================
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "Event Location",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 14),
    Obx(() {
  final hasLocation = controller.latitude.value.isNotEmpty;

  return GestureDetector(
    onTap: () => controller.pickCurrentLocation(),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
           Colors.red.shade400,
            Colors.red.shade600,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            hasLocation
                ? "Location Selected"
                : "Tap to Select Venue Location",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            hasLocation
                ? controller.addressController.text
                : "Fetch current GPS address automatically",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}),

const SizedBox(height: 18),
const Text(
              "Enter Location Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15,),
_textField(
  "Venue / Full Address",
  controller.addressController,
),


    /// SELECT LOCATION CARD
     ],
)
,
            const SizedBox(height: 30),
            const Divider(height: 1, color: Colors.grey),

            const SizedBox(height: 30),
            // ================= IMAGE UPLOAD SECTION =================
            const Text(
              "Event Image",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
           

            Obx(() {
              final hasImage = controller.eventImageList.isNotEmpty;
              return GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasImage ? Colors.transparent : Colors.grey.shade300,
                      width: 2,
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: hasImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            controller.eventImageList.first.path ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _uploadPlaceholder(),
                          ),
                        )
                      : _uploadPlaceholder(),
                ),
              );
            }),

            const SizedBox(height: 40),
             const Divider(height: 1, color: Colors.grey),
                         const SizedBox(height: 40),


const Text(
  "Live Preview",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

_livePreview(),
  const SizedBox(height: 40),
             const Divider(height: 1, color: Colors.grey),
                         const SizedBox(height: 40),



            // ================= BUTTONS =================
            Row(
              children: [
               
                Expanded(
                  child: Obx(() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: AppColor().colorPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: controller.isPostingEvent.value
        ? null
        : () => controller.postCustomerEvent(),
    child: controller.isPostingEvent.value
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
        : Text(
            "Publish Event",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor().whiteColor,
            ),
          ),
  );
})

                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET BUILDERS =================

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _textField(
  String hint,
  TextEditingController controller, {
  int maxLines = 1,
  TextInputType keyboard = TextInputType.text,
  Function(String)? onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radius
          borderSide: BorderSide(color: Colors.red.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radius
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 12 : 0,
        ),
      ),
      style: TextStyle(fontSize: 16),
    ),
  );
}
        Widget _feeChip(String label, String emoji, {required bool isSelected}) {
  return ChoiceChip(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: TextStyle(fontSize: 16)),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    selected: isSelected,
    onSelected: (_) => controller.feeType.value = label.toLowerCase(),
    backgroundColor: Colors.grey.shade100,
    selectedColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: isSelected ? Colors.red : Colors.grey.shade300,
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  );
}

  Widget _datePicker(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel("Start Date"),
      TextField(
        controller: controller.dateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: "DD-MM-YYYY",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );

          if (date != null) {
            // ✅ API FORMAT
            controller.dateController.text =
                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    ],
  );
}


  Widget _timePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Start Time"),
        TextField(
          controller: controller.timeController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "HH:MM",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: Icon(Icons.access_time, color: Colors.grey),
          ),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              // Format as HH:MM like in your screenshot
              final hour = time.hour.toString().padLeft(2, '0');
              final minute = time.minute.toString().padLeft(2, '0');
              controller.timeController.text = "$hour:$minute:00";
            }
          },
        ),
      ],
    );
  }




  // end date and end time 

   Widget _datePickerEndDate(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel("End Date"),
      TextField(
        controller: controller.endDateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: "DD-MM-YYYY",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );

          if (date != null) {
            // ✅ API FORMAT
            controller.endDateController.text =
                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    ],
  );
}


  Widget _timePickerEndTime(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel("End Time"),
      TextField(
        controller: controller.endTimeController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: "HH:MM",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Icon(Icons.access_time, color: Colors.grey),
        ),
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            final hour = time.hour.toString().padLeft(2, '0');
            final minute = time.minute.toString().padLeft(2, '0');

            // ✅ CORRECT CONTROLLER
            controller.endTimeController.text = "$hour:$minute:00";
          }
        },
      ),
    ],
  );
}

  Widget _uploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload,
          size: 50,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 10),
        Text(
          "Click to upload or drag and drop",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
        Text(
          "PNG, JPG, GIF up to 10MB",
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }


  Widget _livePreview() {
  return Obx(() {
    final hasImage = controller.eventImageList.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE PREVIEW
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: hasImage
                ? Image.network(
                    controller.eventImageList.first.path ?? '',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 160,
                    color: Colors.red.shade100,
                    child: const Center(
                      child: Text(
                        "Event Image Preview",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DATE & TIME
                Text(
                  "${controller.dateController.text.isEmpty ? "Date" : controller.dateController.text}  |  "
                  "${controller.timeController.text.isEmpty ? "Time" : controller.timeController.text}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 8),

                // TITLE
                Text(
                  controller.titleController.text.isEmpty
                      ? "Your Event Title"
                      : controller.titleController.text,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                // DESCRIPTION
                Text(
                  controller.descriptionController.text.isEmpty
                      ? "Tell us about your event..."
                      : controller.descriptionController.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 10),

                // ORGANIZER
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person,
                          size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.organizerController.text.isEmpty
                          ? "Organizer Name"
                          : controller.organizerController.text,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

               
              ],
            ),
          )
        ],
      ),
    );
  });
}

}