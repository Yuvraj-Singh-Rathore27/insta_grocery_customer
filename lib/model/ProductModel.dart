import 'package:get/get.dart';

import 'file_model.dart';

class ProductModel {
  bool isInterested = false;

  String? productSubType;
  String? product_id;
  String? name;
  String? description;
  String? hashtag;
  int? pharmacyId;
  bool? isDeleted;
  String? companyName;
  String? category;
  String? brand;
  String? strength;
  int? updatedBy;
  String? createdAt;
  String? productType;
  int? packSize;
  int? updatedById;
  String? updatedAt;
  String? compositions;
  int? quntityadded;
  var price;
  var discount_price;
  int? id;
  String? sizes;
  dynamic specification;
  String? quntity;
  String? images;
  String? packageDetails;
  List<String>? image_url;
  bool? isfavorite;
  String? medicine_type;
  String? logo;
  dynamic activate;
dynamic isActiveApi;
dynamic status;

  // New fields
  String? title;
  String? productCode;
  String? selfLife;
  String? manufacturerDetails;
  String? discountPercentage;
  String? barCode;
  int? mpCategoryId;
  int? mpSubCategoryId;
  int? brandId;
  String? stateName;
  String? cityName;
  String? latitude;
  String? longitude;
  int? userId;
  int? createdBy;
  int? createdById;

  ProductModel({
    this.productSubType,
    this.product_id,
    this.name,
    this.description,
    this.hashtag,

    this.pharmacyId,
    this.isDeleted,
    this.companyName,
    this.category,
    this.brand,
    this.strength,
    this.updatedBy,
    this.createdAt,
    this.productType,
    this.packSize,
    this.updatedById,
    this.updatedAt,
    this.compositions,
    this.price,
    this.discount_price,
    this.id,
    this.images,
    this.sizes,
    this.specification,
    this.quntity,
    this.quntityadded,
    this.packageDetails,
    this.image_url,
    this.isfavorite,
    this.medicine_type,
    this.logo,
    this.title,
    this.productCode,
    this.selfLife,
    this.manufacturerDetails,
    this.discountPercentage,
    this.barCode,
    this.mpCategoryId,
    this.mpSubCategoryId,
    this.brandId,
    this.stateName,
    this.cityName,
    this.latitude,
    this.longitude,
    this.userId,
    this.createdBy,
    this.createdById,
    
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productSubType = json['product_sub_type'];
    print("productSubType: $productSubType");

    product_id = _toString(json['product_id']) ?? "";
    print("product_id: $product_id");

    name = json['name'];
    print("name: $name");

    description = json['description'] ?? '';
    print("description: $description");
    hashtag=json['hashtag']??'';
    print("hashtag: $hashtag",);

    pharmacyId = _toInt(json['pharmacy_id']);
    print("pharmacyId: $pharmacyId");

    isDeleted = json['is_deleted'] == true;
    print("isDeleted: $isDeleted");

    companyName = json['company_name'];
    print("companyName: $companyName");

    category = json['category'];
    print("category: $category");

    brand = json['brand'];
    print("brand: $brand");

    strength = json['strength'];
    print("strength: $strength");

    updatedBy = _toInt(json['updated_by']);
    print("updatedBy: $updatedBy");

    createdAt = json['created_at'];
    print("createdAt: $createdAt");

    productType = json['product_type'];
    print("productType: $productType");

    packSize = _toInt(json['pack_size']);
    print("packSize: $packSize");

    updatedById = _toInt(json['updated_by_id']);
    print("updatedById: $updatedById");

    updatedAt = json['updated_at'];
    print("updatedAt: $updatedAt");

    compositions = json['compositions'];
    print("compositions: $compositions");

    price = json['price'] ?? "0";
    print("price: $price");

    discount_price = (json['discount_price'] == null || json['discount_price'].toString().isEmpty) ? "0" : json['discount_price'];
    print("discount_price: $discount_price");

    id = _toInt(json['id']);
    print("id: $id");

    sizes = json['sizes'];
    print("sizes: $sizes");

    images = json['images'];
    print("images: $images");

    logo = json['logo'];
    print("logo: $logo");

    packageDetails = json['packaging_details'] ?? "";
    print("packageDetails: $packageDetails");

    medicine_type = json['medicine_type'] ?? "";
    print("medicine_type: $medicine_type");

    isfavorite = json['isfavorite'] ?? false;
    print("isfavorite: $isfavorite");
    
    isInterested = json['is_interested'] ?? false;
    print("isInterested: $isInterested");
    
    if (json['image_url'] != null) {
      image_url = json['image_url'].split('|').map((url) => url.trim()).toList().cast<String>();
      print("image_url: $image_url");
    }

    quntity = json['quntity'];
    print("quntity: $quntity");

    quntityadded = _toInt(json['quntityadded']) ?? 0;
    print("quntityadded: $quntityadded");

    // New fields
    title = json['title'];
    print("title: $title");

    productCode = json['product_code'];
    print("productCode: $productCode");

    selfLife = json['self_life'];
    print("selfLife: $selfLife");

    manufacturerDetails = json['manufacturer_details'];
    print("manufacturerDetails: $manufacturerDetails");

    discountPercentage = json['discount_percentage'];
    print("discountPercentage: $discountPercentage");

    barCode = json['bar_code'];
    print("barCode: $barCode");

    mpCategoryId = _toInt(json['mp_category_id']);
    print("mpCategoryId: $mpCategoryId");

    mpSubCategoryId = _toInt(json['mp_sub_category_id']);
    print("mpSubCategoryId: $mpSubCategoryId");

    brandId = _toInt(json['brand_id']);
    print("brandId: $brandId");

    stateName = json['state_name'];
    print("stateId: $stateName");

    cityName = json['city_name'];
    print("cityId: $cityName");

    latitude = json['latitude'];
    print("latitude: $latitude");

    longitude = json['longitude'];
    print("longitude: $longitude");

    userId = _toInt(json['user_id']);
    print("userId: $userId");

    createdBy = _toInt(json['created_by']);
    print("createdBy: $createdBy");

    createdById = _toInt(json['created_by_id']);
    print("createdById: $createdById");
    activate = json['activate'];
isActiveApi = json['is_active'];
status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "name": name,
      "description": description,
      "hashtag":hashtag,
      "product_code": productCode,
      "self_life": selfLife,
      "manufacturer_details": manufacturerDetails,
      "discount_price": discount_price,
      "discount_percentage": discountPercentage,
      "price": price,
      "images": images,
      "logo": logo,
      "compositions": compositions,
      "sizes": sizes,
      "quantity": quntity,
      "company_name": companyName,
      "strength": strength,
      "pack_size": packSize,
      "specification": specification ?? [],
      "bar_code": barCode,
      "mp_category_id": mpCategoryId,
      "mp_sub_category_id": mpSubCategoryId,
      "brand_id": brandId,
      "state_name": stateName,
      "city_name": cityName,
      "latitude": latitude,
      "longitude": longitude,
      "user_id": userId,
      "created_by": createdBy,
      "created_by_id": createdById,
      "updated_by": updatedBy,
      "updated_by_id": updatedById,
    };
  }

  // Helper method to safely convert to int
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  // Helper method to safely convert to String
  String? _toString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
  bool get isActive {
  if (activate != null) {
    return activate == true || activate == 1 || activate == "1";
  }
  if (isActiveApi != null) {
    return isActiveApi == true || isActiveApi == 1;
  }
  if (status != null) {
    return status.toString().toLowerCase() == "active";
  }
  return false;
}

}



class MpSuperCategoryModel {
  int? id;
  String? name;
  String? description;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  List<SuperCategoryImage>? images;

  MpSuperCategoryModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  MpSuperCategoryModel.fromJson(Map<String, dynamic> json) {
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
        images!.add(SuperCategoryImage.fromJson(v));
      });
    }
  }
}

class SuperCategoryImage {
  String? name;
  String? path;

  SuperCategoryImage({this.name, this.path});

  SuperCategoryImage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }
}