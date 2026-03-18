import '../internship_program.dart';

class InternshipProgramResponse {
  final bool? error;
  final int? code;
  final int? status;
  final String? message;
  final List<InternshipProgram>? data;

  final int? total;
  final int? page;
  final int? size;
  final int? pages;
  final dynamic nextPage;
  final dynamic previousPage;

  InternshipProgramResponse({
    this.error,
    this.code,
    this.status,
    this.message,
    this.data,
    this.total,
    this.page,
    this.size,
    this.pages,
    this.nextPage,
    this.previousPage,
  });

  factory InternshipProgramResponse.fromJson(Map<String, dynamic> json) {
    return InternshipProgramResponse(
      error: json['error'],
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<InternshipProgram>.from(
              json['data'].map((x) => InternshipProgram.fromJson(x)))
          : [],
      total: json['total'],
      page: json['page'],
      size: json['size'],
      pages: json['pages'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}



class InternshipImage {
  final String? url;
  final String? size;
  final String? type;

  InternshipImage({this.url, this.size, this.type});

  factory InternshipImage.fromJson(Map<String, dynamic> json) {
    return InternshipImage(
      url: json['url'],
      size: json['size'],
      type: json['type'],
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