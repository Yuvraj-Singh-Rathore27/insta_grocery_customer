class ResumeDetailsResponse {
  bool? error;
  int? code;
  int? status;
  String? message;
  List<Data>? data;

  ResumeDetailsResponse(
      {this.error, this.code, this.status, this.message, this.data});

  ResumeDetailsResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  bool? accommodation;
  String? name;
  String? contactNumber;
  int? updatedById;
  String? resumeHeadline;
  String? email;
  int? id;
  String? gender;
  bool? isActive;
  String? birthDate;
  List<Resume>? resume;
  bool? isDeleted;
  var experience;
  String? userType;
  String? jobType;
  int? createdById;
  var expectedSalary;
  List<JobSeekerLocationAssociation>? jobSeekerLocationAssociation;

  Data(
      {this.userId,
        this.accommodation,
        this.name,
        this.contactNumber,
        this.updatedById,
        this.resumeHeadline,
        this.email,
        this.id,
        this.gender,
        this.isActive,
        this.birthDate,
        this.resume,
        this.isDeleted,
        this.experience,

        this.userType,
        this.jobType,
        this.createdById,
        this.expectedSalary,
        this.jobSeekerLocationAssociation});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    accommodation = json['accommodation'];
    name = json['name'];
    contactNumber = json['contact_number'];
    updatedById = json['updated_by_id'];
    resumeHeadline = json['resume_headline'];
    email = json['email'];
    id = json['id'];
    gender = json['gender'];
    isActive = json['is_active'];
    birthDate = json['birth_date'];
    if (json['resume'] != null) {
      resume = <Resume>[];
      json['resume'].forEach((v) {
        resume!.add(new Resume.fromJson(v));
      });
    }
    isDeleted = json['is_deleted'];
    experience = json['experience'];
    userType = json['user_type'];
    jobType = json['job_type'];
    createdById = json['created_by_id'];
    expectedSalary = json['expected_salary'];
    if (json['job_seeker_location_association'] != null) {
      jobSeekerLocationAssociation = <JobSeekerLocationAssociation>[];
      json['job_seeker_location_association'].forEach((v) {
        jobSeekerLocationAssociation!
            .add(new JobSeekerLocationAssociation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['accommodation'] = this.accommodation;
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['updated_by_id'] = this.updatedById;
    data['resume_headline'] = this.resumeHeadline;
    data['email'] = this.email;
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['is_active'] = this.isActive;
    data['birth_date'] = this.birthDate;
    if (this.resume != null) {
      data['resume'] = this.resume!.map((v) => v.toJson()).toList();
    }
    data['is_deleted'] = this.isDeleted;
    data['experience'] = this.experience;
    data['user_type'] = this.userType;
    data['job_type'] = this.jobType;
    data['created_by_id'] = this.createdById;
    data['expected_salary'] = this.expectedSalary;
    if (this.jobSeekerLocationAssociation != null) {
      data['job_seeker_location_association'] =
          this.jobSeekerLocationAssociation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Resume {
  String? path;

  Resume({this.path});

  Resume.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}

class JobSeekerLocationAssociation {
  int? jobSeekerId;
  int? id;
  int? cityId;
  City? city;

  JobSeekerLocationAssociation(
      {this.jobSeekerId, this.id, this.cityId, this.city});

  JobSeekerLocationAssociation.fromJson(Map<String, dynamic> json) {
    jobSeekerId = json['job_seeker_id'];
    id = json['id'];
    cityId = json['city_id'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_seeker_id'] = this.jobSeekerId;
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    return data;
  }
}

class City {
  int? id;
  bool? isDeleted;
  String? name;
  int? stateId;

  City({this.id, this.isDeleted, this.name, this.stateId});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['is_deleted'];
    name = json['name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_deleted'] = this.isDeleted;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    return data;
  }
}