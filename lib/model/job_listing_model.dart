class JobListingModel {
  String? jobHeading;
  String? email;
  String? jobLocation;
  List<UploadPhotos>? uploadPhotos;
  int? id;
  var minExperience;
  int? createdBy;
  bool? isActive;
  var maxExperience;
  var createdById;
  String? createdAt;
  bool? isDeleted;
  String? jobType;
  String? workType;
  int? updatedBy;
  String? jobPostedBy;
  var salaryRange;
  int? updatedById;
  String? jobCategory;
  late String accommodation;
  String? contactNumber;

  // NEW FIELDS ADDED FROM POST PARAMETERS
  int? categoryId;
  int? subcategoryId;

  CategoryModel? category;
CategoryModel? subcategory;
  String? country;
  String? state;
  String? city;
  String? gender;
  int? salaryFrom;
  int? salaryTo;
List<String>? preferredLanguage;
  JobListingModel({
    this.jobHeading,
    this.email,
    this.jobLocation,
    this.uploadPhotos,
    this.id,
    this.minExperience,
    this.createdAt,
    this.createdBy,
    this.isActive,
    this.maxExperience,
    this.createdById,
    this.isDeleted,
    this.jobType,
    this.workType,
    this.updatedBy,
    this.jobPostedBy,
    this.salaryRange,
    this.updatedById,
    this.jobCategory,
    required this.accommodation,
    this.contactNumber,
    // NEW FIELDS
    this.categoryId,
    this.subcategoryId,
    this.country,
    this.state,
    this.city,
    this.gender,
    this.salaryFrom,
    this.salaryTo,
    this.preferredLanguage,
  });

  JobListingModel.fromJson(Map<String, dynamic> json) {
    jobHeading = json['job_heading'];
    email = json['email'];
    jobLocation = json['job_location'];
    if (json['upload_photos'] != null) {
      uploadPhotos = <UploadPhotos>[];
      json['upload_photos'].forEach((v) {
        uploadPhotos!.add(UploadPhotos.fromJson(v));
      });
    }
    id = _toInt(json['id']);
    minExperience = _toInt(json['min_experience']);
    createdBy = _toInt(json['created_by']);
    createdAt=json['created_at'];
    isActive = json['is_active'];
    maxExperience = _toInt(json['max_experience']);
    createdById = _toInt(json['created_by_id']);
    isDeleted = json['is_deleted'];
    jobType = json['job_type'];
    workType = json['work_type'];
    updatedBy = _toInt(json['updated_by']);
    jobPostedBy = json['job_posted_by'];
    salaryRange = json['salary_range'];
    updatedById = _toInt(json['updated_by_id']);
    accommodation = json['accommodation']?.toString() ?? 'Yes';

    contactNumber = json['contact_number'];

    // NEW FIELDS FROM JSON
    categoryId = _toInt(json['category_id']);

if (json['category'] != null) {
  category = CategoryModel.fromJson(json['category']);
  jobCategory = category?.name;   // ⭐ VERY IMPORTANT
}

if (json['subcategory'] != null) {
  subcategory = CategoryModel.fromJson(json['subcategory']);
}
    subcategoryId = _toInt(json['subcategory_id']);
    country = json['country'];
    state = json['state'];
    city = json['city'];
    gender = json['gender'];
    salaryFrom = _toInt(json['salary_from']);
    salaryTo = _toInt(json['salary_to']);
    preferredLanguage = json['preferred_language'] != null
    ? List<String>.from(json['preferred_language'])
    : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_heading'] = jobHeading;
    data['email'] = email;
    data['job_location'] = jobLocation;
    if (uploadPhotos != null) {
      data['upload_photos'] = uploadPhotos!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['min_experience'] = minExperience;
    data['created_by'] = createdBy;
    data['is_active'] = isActive;
    data['max_experience'] = maxExperience;
    data['created_by_id'] = createdById;
    data['is_deleted'] = isDeleted;
    data['job_type'] = jobType;
    data['work_type'] = workType;
    data['updated_by'] = updatedBy;
    data['job_posted_by'] = jobPostedBy;
    data['salary_range'] = salaryRange;
    data['updated_by_id'] = updatedById;
    data['job_category'] = jobCategory;
    data['accommodation'] = accommodation;
    data['contact_number'] = contactNumber;
    

    // NEW FIELDS TO JSON
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['subcategory_id'] = subcategoryId;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['gender'] = gender;
    data['salary_from'] = salaryFrom;
    data['salary_to'] = salaryTo;
    data['language']=preferredLanguage;

    return data;
  }

  // Helper method to format numbers with commas
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  // Helper method to get formatted salary range
  String getFormattedSalaryRange() {
    if (salaryFrom != null && salaryTo != null) {
      return '\₹${_formatNumber(salaryFrom!)} – \₹${_formatNumber(salaryTo!)}';
    } else if (salaryRange != null) {
      // Fallback to existing salaryRange if new fields are not available
      return _formatSalaryRange(salaryRange.toString());
    } else {
      return 'Salary Not Closed'; // Default fallback
    }
  }

  // Helper to format existing salaryRange field
  String _formatSalaryRange(String salaryRange) {
    if (salaryRange.contains('-')) {
      List<String> parts = salaryRange.split('-');
      if (parts.length == 2) {
        try {
          int min = int.tryParse(parts[0]) ?? 0;
          int max = int.tryParse(parts[1]) ?? 0;
          return '\₹${_formatNumber(min)} – \₹${_formatNumber(max)}';
        } catch (e) {
          return 'Salary Not Closed';
        }
      }
    }
    return '\$50,000 – \$70,000';
  }

  // Helper to get full location
  String getFullLocation() {
    List<String> locationParts = [];
    if (city != null && city!.isNotEmpty) locationParts.add(city!);
    if (state != null && state!.isNotEmpty) locationParts.add(state!);
    if (country != null && country!.isNotEmpty && country != "string") {
      locationParts.add(country!);
    }

    if (locationParts.isNotEmpty) {
      return locationParts.join(', ');
    }

    // Fallback to jobLocation if new fields are not available
    return jobLocation ?? 'Location not specified';
  }

  // Method to print all details
  void printDetails() {
    print('------ Job Listing Details ------');
    print('Job Heading: $jobHeading');
    print('Email: $email');
    print('Job Location: $jobLocation');
    print('Full Location: ${getFullLocation()}');
    print('Job Type: $jobType');
    print('Work Type: $workType');
    print('Job Category: $jobCategory');
    print('Category ID: $categoryId');
    print('Subcategory ID: $subcategoryId');
    print('Country: $country');
    print('State: $state');
    print('City: $city');
    print('Gender: $gender');
    print('Min Experience: $minExperience');
    print('Max Experience: $maxExperience');
    print('Salary From: $salaryFrom');
    print('Salary To: $salaryTo');
    print('Formatted Salary Range: ${getFormattedSalaryRange()}');
    print('Accommodation: $accommodation');
    print('Contact Number: $contactNumber');
    print('Created By: $createdBy');
    print('Created By ID: $createdById');
    print('Language--->$preferredLanguage');
    print('Updated By: $updatedBy');
    print('Updated By ID: $updatedById');
    print('Is Active: $isActive');
    print('Is Deleted: $isDeleted');
    print('Job Posted By: $jobPostedBy');
    print('Salary Range (raw): $salaryRange');
    print('ID: $id');
    print('creates at--------$createdAt');

    if (uploadPhotos != null && uploadPhotos!.isNotEmpty) {
      print('Upload Photos:');
      for (var photo in uploadPhotos!) {
        print('  - ${photo.path}');
      }
    } else {
      print('Upload Photos: None');
    }

    print('----------------------------------');
  }

  // Override toString for easy print(job)
  @override
  String toString() {
    return '''
JobListingModel(
  jobHeading: $jobHeading,
  email: $email,
  jobLocation: $jobLocation,
  fullLocation: ${getFullLocation()},
  jobType: $jobType,
  workType: $workType,
  jobCategory: $jobCategory,
  categoryId: $categoryId,
  subcategoryId: $subcategoryId,
  country: $country,
  state: $state,
  city: $city,
  gender: $gender,
  minExperience: $minExperience,
  maxExperience: $maxExperience,
  salaryFrom: $salaryFrom,
  salaryTo: $salaryTo,
  formattedSalaryRange: ${getFormattedSalaryRange()},
  accommodation: $accommodation,
  contactNumber: $contactNumber,
  createdBy: $createdBy,
  updatedBy: $updatedBy,
  isActive: $isActive,
  isDeleted: $isDeleted,
  jobPostedBy: $jobPostedBy,
  id: $id,
  uploadPhotos: ${uploadPhotos?.map((e) => e.path).toList()}
)
''';
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

class UploadPhotos {
  String? path;

  UploadPhotos({this.path});

  UploadPhotos.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    return data;
  }
}


class CategoryModel {
  int? id;
  String? name;

  CategoryModel({this.id, this.name});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}