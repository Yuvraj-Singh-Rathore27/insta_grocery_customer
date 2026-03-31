
class InternshipProgram {
  final int? id;
  final String? postingType;
  final String? heading;
  final String? duration;
  final String? charges;
  final String? postedBy;
  final bool? accommodation;
  final String? location;
  final String? internshipType;

  final List<InternshipImage>? image;

  final int? categoryId;
  final int? subcategoryId;
  final int? storeId;

  final InternshipCategory? category;
  final InternshipSubCategory? subcategory;
  final InternshipStore? store;

  final bool? isActive;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;

  InternshipProgram({
    this.id,
    this.postingType,
    this.heading,
    this.duration,
    this.charges,
    this.postedBy,
    this.accommodation,
    this.location,
    this.internshipType,
    this.image,
    this.categoryId,
    this.subcategoryId,
    this.storeId,
    this.category,
    this.subcategory,
    this.store,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory InternshipProgram.fromJson(Map<String, dynamic> json) {
    return InternshipProgram(
      id: json['id'],
      postingType: json['posting_type'],
      heading: json['heading'],
      duration: json['duration'],
      charges: json['charges'],
      postedBy: json['posted_by'],
      accommodation: json['accommodation'],
      location: json['location'],
      internshipType: json['internship_type'],

      image: json['image'] != null
          ? List<InternshipImage>.from(
              json['image'].map((x) => InternshipImage.fromJson(x)))
          : [],

      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      storeId: json['store_id'],

      category: json['category'] != null
          ? InternshipCategory.fromJson(json['category'])
          : null,

      subcategory: json['subcategory'] != null
          ? InternshipSubCategory.fromJson(json['subcategory'])
          : null,

      store: json['store'] != null
          ? InternshipStore.fromJson(json['store'])
          : null,

      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}






class InternshipImage {
  final String? path;
  
  final String? name;

  InternshipImage({this.path, this.name,});

  factory InternshipImage.fromJson(Map<String, dynamic> json) {
    return InternshipImage(
      path: json['path'],
      
      name: json['name'],
    );
  }
}






class InternshipCategory {
  final int? id;
  final String? name;

  InternshipCategory({this.id, this.name});

  factory InternshipCategory.fromJson(Map<String, dynamic> json) {
    return InternshipCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}






class InternshipSubCategory {
  final int? id;
  final String? name;

  InternshipSubCategory({this.id, this.name});

  factory InternshipSubCategory.fromJson(Map<String, dynamic> json) {
    return InternshipSubCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}






class InternshipStore {
  final int? id;
  final String? name;

  InternshipStore({this.id, this.name});

  factory InternshipStore.fromJson(Map<String, dynamic> json) {
    return InternshipStore(
      id: json['id'],
      name: json['name'],
    );
  }
}


class InternshipSuperCategoryModel {
  int? id;
  String? name;
  String? description;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  List<InternshipSuperCategoryImage>? images;

  InternshipSuperCategoryModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  InternshipSuperCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['image'] != null) {
      images = [];
      json['image'].forEach((v) {
        images!.add(InternshipSuperCategoryImage.fromJson(v));
      });
    }
  }
}


class InternshipSuperCategoryImage {
  String? name;
  String? path;

  InternshipSuperCategoryImage({this.name, this.path});

  InternshipSuperCategoryImage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }
}