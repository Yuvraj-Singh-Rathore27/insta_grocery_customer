
class CandidateData {
  int? id;
  String? fullName;
  String? resumeHeadline;
  String? gender;
  String? birthDate;
  String? experience;
  String? jobType;
  String? jobCategory;
  double? expectedSalary;
  bool? accommodation;

  String? contactNumber;
  String? email;

  List<dynamic>? languages;
  List<dynamic>? skills;

  String? jobSpeciality;
  List<dynamic>? jobSubSpeciality;

  String? qualification;

  String? preferredCountry;
  String? preferredState;
  String? preferredCity;
  bool? anyCity;

  bool? isActive;
  bool? isDeleted;

  Category? category;
  SubCategory? subcategory;

  List<FileItem>? resume;
  List<FileItem>? certificate;
  List<FileItem>? photo;
  List<FileItem>? shortVideo;

  CandidateData({
    this.id,
    this.fullName,
    this.resumeHeadline,
    this.gender,
    this.birthDate,
    this.experience,
    this.jobType,
    this.jobCategory,
    this.expectedSalary,
    this.accommodation,
    this.contactNumber,
    this.email,
    this.languages,
    this.skills,
    this.jobSpeciality,
    this.jobSubSpeciality,
    this.qualification,
    this.preferredCountry,
    this.preferredState,
    this.preferredCity,
    this.anyCity,
    this.isActive,
    this.isDeleted,
    this.category,
    this.subcategory,
    this.resume,
    this.certificate,
    this.photo,
    this.shortVideo,
  });

  CandidateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    resumeHeadline = json['resume_headline'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    experience = json['experience'];
    jobType = json['job_type'];
    jobCategory = json['job_category'];
    expectedSalary = (json['expected_salary'] ?? 0).toDouble();
    accommodation = json['accommodation'];

    contactNumber = json['contact_number'];
    email = json['email'];

    languages = json['languages'];
    skills = json['skills'];

    jobSpeciality = json['job_speciality'];
    jobSubSpeciality = json['job_sub_speciality'];

    qualification = json['qualification'];

    preferredCountry = json['preferred_country'];
    preferredState = json['preferred_state'];
    preferredCity = json['preferred_city'];
    anyCity = json['any_city'];

    isActive = json['is_active'];
    isDeleted = json['is_deleted'];

    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;

    subcategory = json['subcategory'] != null
        ? SubCategory.fromJson(json['subcategory'])
        : null;

    resume = _parseFileList(json['resume']);
    certificate = _parseFileList(json['certificate']);
    photo = _parseFileList(json['photo']);
    shortVideo = _parseFileList(json['short_video']);
  }

  List<FileItem>? _parseFileList(dynamic data) {
    if (data == null) return [];

    List<FileItem> list = [];

    if (data is List) {
      for (var item in data) {
        if (item is List) {
          for (var sub in item) {
            if (sub != null) list.add(FileItem.fromJson(sub));
          }
        } else if (item is Map<String, dynamic>) {
          list.add(FileItem.fromJson(item));
        }
      }
    } else if (data is Map<String, dynamic>) {
      list.add(FileItem.fromJson(data));
    }

    return list;
  }
}

class FileItem {
  String? name;
  String? path;
  String? fileName;
  String? fileUrl;

  FileItem({this.name, this.path, this.fileName, this.fileUrl});

  FileItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class SubCategory {
  int? id;
  String? name;
  Category? category;

  SubCategory({this.id, this.name, this.category});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }
}