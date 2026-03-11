class StoreTypeModel {
  final int id;
  final String name;

  const StoreTypeModel({
    required this.id,
    required this.name,
  });

  factory StoreTypeModel.fromJson(Map<String, dynamic> json) {
    return StoreTypeModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}



class JobListingModel {
  int? id;
  int? storeId;

  String? jobTitle;
  String? description;
  String? jobType;

  int? experienceMin;
  int? experienceMax;

  int? salaryFrom;
  int? salaryTo;

  String? cityName;
  String? stateName;
  String? latitude;
  String? longitude;

  List<String> skills = [];
  String? lastApplyDate;

  StoreTypeModel? storeType;

  JobListingModel({
    this.id,
    this.storeId,
    this.jobTitle,
    this.description,
    this.jobType,
    this.experienceMin,
    this.experienceMax,
    this.salaryFrom,
    this.salaryTo,
    this.cityName,
    this.stateName,
    this.latitude,
    this.longitude,
    List<String>? skills,
    this.lastApplyDate,
    this.storeType,
  }) {
    this.skills = skills ?? [];
  }

  // ================= FROM JSON =================
  factory JobListingModel.fromJson(Map<String, dynamic> json) {
    return JobListingModel(
      id: _parseInt(json['id']),
      storeId: _parseInt(json['store_id']),
      jobTitle: json['title']?.toString(),
      description: json['description']?.toString(),
      jobType: json['job_type']?.toString(),

      experienceMin: _parseInt(json['experience_min']),
      experienceMax: _parseInt(json['experience_max']),

      salaryFrom: _parseInt(json['salary_from']),
      salaryTo: _parseInt(json['salary_to']),

      cityName: json['city_name']?.toString(),
      stateName: json['state_name']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),

      lastApplyDate: json['last_apply_date']?.toString(),

      storeType: json['store_type'] is Map
          ? StoreTypeModel.fromJson(
              Map<String, dynamic>.from(json['store_type']),
            )
          : null,

      skills: _parseSkills(json['skills']),
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'title': jobTitle,
      'description': description,
      'job_type': jobType,
      'experience_min': experienceMin,
      'experience_max': experienceMax,
      'salary_from': salaryFrom,
      'salary_to': salaryTo,
      'city_name': cityName,
      'state_name': stateName,
      'latitude': latitude,
      'longitude': longitude,
      'last_apply_date': lastApplyDate,
      'store_type': storeType?.toJson(),
      'skills': skills.map((e) => {'skill': e}).toList(),
    };
  }

  // ================= HELPERS =================
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  static List<String> _parseSkills(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => e['skill']?.toString())
          .whereType<String>()
          .toList();
    }
    return [];
  }
}
