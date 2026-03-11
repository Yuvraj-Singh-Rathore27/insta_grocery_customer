class StoreOfferModel {
  int? id;
  String? name;
  String? description;
  bool? isActive;
  bool? isDeleted;
  bool? isBlocked;
  String? createdAt;
  String? updatedAt;
  String? durationType; // "TODAY", "FLASH", "MULTI_DAY"
  String? startDate;
  String? endDate;
  bool? showCountdown;
  int? offerCategoryId;
 OfferCategoryModel? category;
OfferSubCategoryModel? subcategory;
  int? storeId;
  StoreInfo? store;
  List<OfferImage>? image;

  StoreOfferModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.isDeleted,
    this.isBlocked,
    this.createdAt,
    this.updatedAt,
    this.durationType,
    this.startDate,
    this.endDate,
    this.showCountdown,
    this.offerCategoryId,
    this.category,
    this.subcategory,
    this.storeId,
    this.store,
    this.image,
  });

  factory StoreOfferModel.fromJson(Map<String, dynamic> json) {
    return StoreOfferModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      isBlocked: json['is_blocked'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      durationType: json['duration_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      showCountdown: json['show_countdown'],
      offerCategoryId: json['offer_category_id'],
      category: json['category'] != null
    ? OfferCategoryModel.fromJson(json['category'])
    : null,

subcategory: json['subcategory'] != null
    ? OfferSubCategoryModel.fromJson(json['subcategory'])
    : null,

      storeId: json['store_id'],
      store: json['store'] != null ? StoreInfo.fromJson(json['store']) : null,
      image: json['image'] != null && json['image'] is List
          ? (json['image'] as List)
              .where((v) => v != null && v is Map<String, dynamic>)
              .map<OfferImage>((v) => OfferImage.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['description'] = description;
    json['is_active'] = isActive;
    json['is_deleted'] = isDeleted;
    json['is_blocked'] = isBlocked;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    json['duration_type'] = durationType;
    json['start_date'] = startDate;
    json['end_date'] = endDate;
    json['show_countdown'] = showCountdown;
    json['offer_category_id'] = offerCategoryId;
    json['store_id'] = storeId;
    
    if (store != null) {
      json['store'] = store!.toJson();
    }
    
    if (image != null) {
      json['image'] = image!.map((v) => v.toJson()).toList();
    }
   if (category != null) {
  json['category'] = category!.toJson();
}

if (subcategory != null) {
  json['subcategory'] = subcategory!.toJson();
}
    
    return json;
  }

  // Helper methods for share functionality
  bool get isValid => isActive == true && isDeleted == false && isBlocked == false;
  
  String get formattedStartDate {
    if (startDate == null) return '';
    try {
      final date = DateTime.parse(startDate!).toLocal();
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return startDate ?? '';
    }
  }
  
  String get formattedEndDate {
    if (endDate == null) return '';
    try {
      final date = DateTime.parse(endDate!).toLocal();
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return endDate ?? '';
    }
  }
  
  String get timeLeft {
    if (endDate == null || showCountdown != true) return '';
    try {
      final end = DateTime.parse(endDate!).toLocal();
      final now = DateTime.now().toLocal();
      final difference = end.difference(now);
      
      if (difference.isNegative) return 'Expired';
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ${difference.inHours.remainder(24)}h left';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m left';
      } else {
        return '${difference.inMinutes}m left';
      }
    } catch (e) {
      return '';
    }
  }

  String getCountdown(DateTime now) {
  if (endDate == null || showCountdown != true) return '';

  try {
    final end = DateTime.parse(endDate!).toLocal();
    final diff = end.difference(now);

    if (diff.isNegative) return 'Expired';

    if (diff.inDays > 0) {
      return '${diff.inDays}d ${diff.inHours.remainder(24)}h';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ${diff.inMinutes.remainder(60)}m';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ${diff.inSeconds.remainder(60)}s';
    } else {
      return '${diff.inSeconds}s';
    }
  } catch (_) {
    return '';
  }
}
String get offerStatus {
  if (endDate == null) return "Running";

  try {
    final end = DateTime.parse(endDate!).toLocal();
    return DateTime.now().isAfter(end) ? "Expired" : "Running";
  } catch (e) {
    return "Running";
  }
}


}

class StoreInfo {
  int? id;
  String? name;
  String? latitude;
  String? longitude;

  StoreInfo({this.id, this.name, this.latitude, this.longitude});

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    return json;
  }
  
  String get googleMapsLink {
    if (latitude == null || longitude == null) return '';
    return 'https://maps.google.com/?q=$latitude,$longitude';
  }
}


class OfferCategoryModel {
  int? id;
  String? name;
  List<OfferImage>? image;  // ✅ FIXED

  OfferCategoryModel({this.id, this.name, this.image});

  factory OfferCategoryModel.fromJson(Map<String, dynamic> json) {
    return OfferCategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != null && json['image'] is List
          ? (json['image'] as List)
              .map((v) => OfferImage.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image?.map((v) => v.toJson()).toList(),
    };
  }
}

class OfferSubCategoryModel {
  int? id;
  String? name;

  OfferSubCategoryModel({this.id, this.name});

  factory OfferSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return OfferSubCategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
class OfferImage {
  String? name;
  String? path;
  int? size;

  OfferImage({this.name, this.path, this.size});

  factory OfferImage.fromJson(Map<String, dynamic> json) {
    return OfferImage(
      name: json['name'],
      path: json['path'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['path'] = path;
    json['size'] = size;
    return json;
  }
}