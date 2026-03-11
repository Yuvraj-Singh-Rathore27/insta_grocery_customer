class DoctorModelList {
  int? id;
  int? storeId;
  String? name;
  String? description;
  String? fees;
  List<String>? awards;
  String? qualification;
  String? registrationNumber;
  List<String>? profilePhoto;
  List<String>? languages;
  int? experienceYears;
  String? areasOfExpertise;
  List<AvailabilityTime>? availabilityTime;
  Store? store;
  List<Specialities>? specialities;
  List<int>? specialityIds;
  bool? isActive;
  bool? isDeleted;

  DoctorModelList(
      {this.id,
        this.storeId,
        this.name,
        this.description,
        this.fees,
        this.awards,
        this.qualification,
        this.registrationNumber,
        this.profilePhoto,
        this.languages,
        this.experienceYears,
        this.areasOfExpertise,
        this.availabilityTime,
        this.store,
        this.specialities,
        this.specialityIds,
        this.isActive,
        this.isDeleted});

  DoctorModelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    name = json['name'];
    description = json['description'];
    fees = json['fees']??'';
    awards = json['awards'] != null ? List<String>.from(json['awards']) : [];
    qualification = json['qualification'];
    registrationNumber = json['registration_number'];
    profilePhoto = json['profile_photo'] != null ? List<String>.from(json['profile_photo']) : [];
    languages = json['languages'] != null ? List<String>.from(json['languages']) : [];
    experienceYears = json['experience_years'];
    areasOfExpertise = json['areas_of_expertise'];

    if (json['availability_time'] != null) {
      availabilityTime = <AvailabilityTime>[];
      json['availability_time'].forEach((v) {
        availabilityTime!.add(AvailabilityTime.fromJson(v));
      });
    } else {
      availabilityTime = [];
    }

    store = json['store'] != null ? Store.fromJson(json['store']) : null;

    if (json['specialities'] != null) {
      specialities = <Specialities>[];
      json['specialities'].forEach((v) {
        specialities!.add(Specialities.fromJson(v));
      });
    } else {
      specialities = [];
    }

    specialityIds = json['speciality_ids'] != null ? List<int>.from(json['speciality_ids']) : [];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['fees'] = this.fees;
    data['awards'] = awards;
    data['qualification'] = this.qualification;
    data['registration_number'] = this.registrationNumber;
    data['profile_photo'] = this.profilePhoto;
    data['languages'] = this.languages;
    data['experience_years'] = this.experienceYears;
    data['areas_of_expertise'] = this.areasOfExpertise;
    if (this.availabilityTime != null) {
      data['availability_time'] =
          this.availabilityTime!.map((v) => v.toJson()).toList();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.specialities != null) {
      data['specialities'] = this.specialities!.map((v) => v.toJson()).toList();
    }
    data['speciality_ids'] = this.specialityIds;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}
class Specialities {
  int? id;
  String? name;
  Specialities({this.id,this.name});

  Specialities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

}


class AvailabilityTime {
  String? to;
  String? from;

  AvailabilityTime({this.to, this.from});

  AvailabilityTime.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    from = json['from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    data['from'] = this.from;
    return data;
  }
}

class Store {
  int? id;
  String? name;

  Store({this.id, this.name});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}