class CreateGigModel {
  String fullName;
  String title;
  String phoneNumber;
  String email;
  String location;
  String city;
  int serviceRadius;
  double latitude;
  double longitude;
  String workPreference;

  int categoryId;
  int subcategoryId;

  List<String> skills;
  String experienceLevel;
  double price;
  String bio;

  int userId;
  int createdBy;
  int createdById;

  /// 🔥 Optional UI Linking (not sent to API)
  GigsSuperCategoryModel? superCategory;
  GigsCategoryModel? category;
  GigsSubCategoryModel? subCategory;

  CreateGigModel({
    required this.fullName,
    required this.title,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.city,
    required this.serviceRadius,
    required this.latitude,
    required this.longitude,
    required this.workPreference,
    required this.categoryId,
    required this.subcategoryId,
    required this.skills,
    required this.experienceLevel,
    required this.price,
    required this.bio,
    required this.userId,
    required this.createdBy,
    required this.createdById,
    this.superCategory,
    this.category,
    this.subCategory,
  });

  /// 🔥 Convert to API JSON (IMPORTANT)
  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "title": title,
      "phone_number": phoneNumber,
      "email": email,
      "location": location,
      "city": city,
      "service_radius": serviceRadius,
      "latitude": latitude,
      "longitude": longitude,
      "work_preference": workPreference,
      "category_id": categoryId,
      "subcategory_id": subcategoryId,
      "skills": skills,
      "experience_level": experienceLevel,
      "price": price,
      "bio": bio,
      "user_id": userId,
      "created_by": createdBy,
      "created_by_id": createdById,
    };
  }
}

class GigsSubCategoryModel {
  final int id;
  final String name;
  final int? categoryId;
  final String categoryName;

  GigsSubCategoryModel({
    required this.id,
    required this.name,
    this.categoryId,
    required this.categoryName,
  });

  factory GigsSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return GigsSubCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      categoryId: json['category_id'],
      categoryName: json['gigs_works_category']?['name'] ?? "",
    );
  }
}

class GigsCategoryModel {
  final int id;
  final String name;
  final int? superCategoryId;

  GigsCategoryModel({
    required this.id,
    required this.name,
    this.superCategoryId,
  });

  factory GigsCategoryModel.fromJson(Map<String, dynamic> json) {
    return GigsCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      superCategoryId: json['super_category_id'],
    );
  }
}

class GigsSuperCategoryModel {
  final int id;
  final String name;
  final String? image;

  GigsSuperCategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory GigsSuperCategoryModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;

    if (json['image'] != null &&
        json['image'] is List &&
        json['image'].isNotEmpty) {
      imageUrl = json['image'][0]['path']; // ✅ FIX HERE
    }

    return GigsSuperCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      image: imageUrl,
    );
  }
  // Add this to your existing gigs_works_model.dart



}





// Hire Gigs Model Is HERE 


// lib/app/model/hire_model.dart

class HireModel {
  final int id;
  final int userId;
  final int profileId;
  final String description;
  final bool isActive;
  final bool isDeleted;
  final int createdBy;
  final int createdById;
  final int updatedBy;
  final int updatedById;
  final String createdAt;
  final String updatedAt;
  final HireProfile? profile;
  final HireUser? user;

  HireModel({
    required this.id,
    required this.userId,
    required this.profileId,
    required this.description,
    required this.isActive,
    required this.isDeleted,
    required this.createdBy,
    required this.createdById,
    required this.updatedBy,
    required this.updatedById,
    required this.createdAt,
    required this.updatedAt,
    this.profile,
    this.user,
  });

  factory HireModel.fromJson(Map<String, dynamic> json) {
    return HireModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      profileId: json['profile_id'] ?? 0,
      description: json['description'] ?? "",
      isActive: json['is_active'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      createdBy: json['created_by'] ?? 0,
      createdById: json['created_by_id'] ?? 0,
      updatedBy: json['updated_by'] ?? 0,
      updatedById: json['updated_by_id'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      profile: json['profile'] != null 
          ? HireProfile.fromJson(json['profile']) 
          : null,
      user: json['user'] != null 
          ? HireUser.fromJson(json['user']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_id': profileId,
      'description': description,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'created_by': createdBy,
      'created_by_id': createdById,
      'updated_by': updatedBy,
      'updated_by_id': updatedById,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile': profile?.toJson(),
      'user': user?.toJson(),
    };
  }
}

class HireProfile {
  final int id;
  final String fullName;

  HireProfile({
    required this.id,
    required this.fullName,
  });

  factory HireProfile.fromJson(Map<String, dynamic> json) {
    return HireProfile(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
    };
  }
}

class HireUser {
  final int id;
  final String firstName;
  final String? lastName;
  final String? whatsappNumber;
  final String? addressLine1;

  HireUser({
    required this.id,
    required this.firstName,
    this.lastName,
    this.whatsappNumber,
    this.addressLine1,
  });

  factory HireUser.fromJson(Map<String, dynamic> json) {
    return HireUser(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'],
      whatsappNumber: json['whatsapp_number'],
      addressLine1: json['address_line_1'],
    );
  }

  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return "$firstName $lastName";
    }
    return firstName;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'whatsapp_number': whatsappNumber,
      'address_line_1': addressLine1,
    };
  }
}