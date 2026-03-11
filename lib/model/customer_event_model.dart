class CustomerEventModel {
  int? id;
  String? title;
  String? organizerName;
  String? description;
  String? hashtag;
  String? eventDate;
  String? eventTime;
  String? eventEndDate;
  String? eventEndTime;
  String? feeType;
  double? price;
  String? address;
  String? latitude;
  String? longitude;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? userId;
EventUser? user;
int? eventId;              // from registration api
int? registrationUserId;  // user_id from api
EventUser? registeredUser; // user object


  EventCategory? category;
  EventSubCategory? subCategory;
  List<EventImage>? image;

  CustomerEventModel({
    this.id,
    this.title,
    this.organizerName,
    this.description,
    this.hashtag,
    this.eventDate,
    this.eventTime,
    this.eventEndDate,
    this.eventEndTime,
    this.feeType,
    this.price,
    this.address,
    this.latitude,
    this.longitude,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.subCategory,
    this.image,
    this.user,
    this.userId,
    this.eventId,
    this.registeredUser,
    this.registrationUserId
    

  });

//   factory CustomerEventModel.fromJson(Map<String, dynamic> json) {
//     return CustomerEventModel(
//       id: json['id'],
//       title: json['title'],
//       organizerName: json['organizer_name'],
//       description: json['description'],
//       eventDate: json['event_date'],
//       eventTime: json['event_time'],
//       eventEndDate: json['event_end_date'],
//       eventEndTime: json['event_end_time'],
//       feeType: json['fee_type'],
//       price: json['price'],
//       address: json['address'],
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       isActive: json['is_active'],
//       isDeleted: json['is_deleted'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       category: json['category'] != null
//           ? EventCategory.fromJson(json['category'])
//           : null,
//       image: json['image'] != null && json['image'] is List
//           ? (json['image'] as List)
//               .where((v) => v != null && v is Map<String, dynamic>)
//               .map<EventImage>((v) => EventImage.fromJson(v))
//               .toList()
//           : null,
//            user: json['user'] != null
//         ? EventUser.fromJson(json['user'])
//         : null,

//     userId: json['user'] != null
//         ? json['user']['id']
//         : json['created_by_id'],
//         // Registration API support
// eventId: json['event_id'],
// registrationUserId: json['user_id'],

// registeredUser: json['user'] != null
//     ? EventUser.fromJson(json['user'])
//     : null,

//     );
//   }


factory CustomerEventModel.fromJson(Map<String, dynamic> json) {
  // Detect which API response this is
  final bool isRegistrationApi = json.containsKey('event_id');

  return CustomerEventModel(
    // ---------- COMMON FIELDS ----------
    title: json['title'],
    organizerName: json['organizer_name'],
    description: json['description'],
    hashtag:json['hashtag'],
    eventDate: json['event_date'],
    eventTime: json['event_time'],
    eventEndDate: json['event_end_date'],
    eventEndTime: json['event_end_time'],
    feeType: json['fee_type'],
    price: json['price'],
    address: json['address'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    isActive: json['is_active'],
    isDeleted: json['is_deleted'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],

    category: json['category'] != null
        ? EventCategory.fromJson(json['category'])
        : null,
    subCategory: json['subcategory'] != null
        ? EventSubCategory.fromJson(json['subcategory'])
        : null,

    image: json['image'] != null && json['image'] is List
        ? (json['image'] as List)
            .where((v) => v != null && v is Map<String, dynamic>)
            .map<EventImage>((v) => EventImage.fromJson(v))
            .toList()
        : null,

    // ---------- EVENT API (event list) ----------
    id: !isRegistrationApi ? json['id'] : null,
    userId: !isRegistrationApi ? json['created_by_id'] : null,
    user: (!isRegistrationApi && json['user'] != null)
        ? EventUser.fromJson(json['user'])
        : null,

    // ---------- REGISTRATION API ----------
    eventId: isRegistrationApi ? json['event_id'] : null,
    registrationUserId: isRegistrationApi ? json['user_id'] : null,
    registeredUser: (isRegistrationApi && json['user'] != null)
        ? EventUser.fromJson(json['user'])
        : null,
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['organizer_name'] = organizerName;
    json['description'] = description;
    json['hashtag']=hashtag;
    json['event_date'] = eventDate;
    json['event_time'] = eventTime;
    json['event_end_date']=eventEndDate;
    json['event_end_time']=eventEndTime;
    json['fee_type'] = feeType;
    json['price'] = price;
    
    json['address'] = address;
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    json['is_active'] = isActive;
    json['is_deleted'] = isDeleted;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;

    if (category != null) {
      json['category'] = category!.toJson();
    }
    if (subCategory != null) {
      json['subcategory'] = subCategory!.toJson();
    }


    if (image != null) {
      json['image'] = image!.map((v) => v.toJson()).toList();
    }

    return json;
  }
}


class EventUser {
  int? id;
  String? name;
  String?mobile;

  EventUser({this.id, this.name,this.mobile});

  factory EventUser.fromJson(Map<String, dynamic> json) {
    return EventUser(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile':mobile
    };
  }
}


class EventCategory {
  int? id;
  String? name;
  String? image;

  EventCategory({this.id, this.name, this.image});

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    String? imagePath;

    final imageData = json['image'];

    if (imageData != null && imageData is List && imageData.isNotEmpty) {
      final firstImage = imageData.first;

      if (firstImage is Map<String, dynamic>) {
        imagePath = firstImage['path']?.toString();
      }
    }

    return EventCategory(
      id: json['id'],
      name: json['name'],
      image: imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
class EventSubCategory {
  int? id;
  String? name;

  EventSubCategory({this.id, this.name});

  factory EventSubCategory.fromJson(Map<String, dynamic> json) {
    return EventSubCategory(
      id: json['id'],
      name: json['name'],    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}


class EventImage {
  String? name;
  String? path;

  EventImage({this.name, this.path});

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      name: json['name'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
    };
  }
}
