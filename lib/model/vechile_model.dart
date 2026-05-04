class Category {
  final int id;
  final String name;
  final List<CategoryImage>? image;

  Category({
    required this.id,
    required this.name,
    this.image,

  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: (json['image'] as List?)
          ?.map((e) => CategoryImage.fromJson(e))
          .toList(),
    
    );
  }
}


class CategoryImage {
  final String? name;
  final String? path;

  CategoryImage({this.name, this.path});

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      name: json['name'],
      path: json['path'],
    );
  }
}
class SubCategory {
  final int id;
  final String name;
  final List<SubCategoryImage>? image;

  SubCategory({
    required this.id,
    required this.name,
    this.image,

  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
       image: (json['image'] as List?)
          ?.map((e) => SubCategoryImage.fromJson(e))
          .toList(),
    );
  }
}

class SubCategoryImage {
  final String? name;
  final String? path;

  SubCategoryImage({this.name, this.path});

  factory SubCategoryImage.fromJson(Map<String, dynamic> json) {
    return SubCategoryImage(
      name: json['name'],
      path: json['path'],
    );
  }
}

class Driver {
  final int id;
  final String name;
  final String contactNumber;
  final String licenseNumber;
  final String licenseExpiryDate;
  final Document image;

  Driver({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.image,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contact_number'],
      licenseNumber: json['license_number'],
      licenseExpiryDate: json['license_expiry_date'],
      image: Document.fromJson(json['image'] ?? {}),
    );
  }
}

class Document {
  final String? name;
  final String? path;

  Document({
    this.name,
    this.path,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'],
      path: json['path'],
    );
  }
}


class Vehicle {
  final int id;
  final String vehicleNumber;
  final String makeModel;
  final int year;
  final double latitude;
  final double longitude;
  final String color;
  final int seatingCapacity;
  final double baseCharges;
  final double ratePerKm;

  final Category category;
  final SubCategory subCategory;
  final Driver driver;

  final Document rcDocument;
  final Document insuranceDocument;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.makeModel,
    required this.year,
    required this.latitude,
    required this.longitude,
    required this.color,
    required this.seatingCapacity,
    required this.baseCharges,
    required this.ratePerKm,
    required this.category,
    required this.subCategory,
    required this.driver,
    required this.rcDocument,
    required this.insuranceDocument,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      vehicleNumber: json['vehicle_number'],
      makeModel: json['make_model'],
      year: json['year'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      color: json['color'],
      seatingCapacity: json['seating_capacity'],
      baseCharges: (json['base_charges'] ?? 0).toDouble(),
      ratePerKm: (json['rate_per_km'] ?? 0).toDouble(),

      category: Category.fromJson(json['category']),
      subCategory: SubCategory.fromJson(json['subcategory']),
      driver: Driver.fromJson(json['driver']),

      rcDocument: Document.fromJson(json['rc_document'] ?? {}),
      insuranceDocument: Document.fromJson(json['insurance_document'] ?? {}),
    );
  }
}

