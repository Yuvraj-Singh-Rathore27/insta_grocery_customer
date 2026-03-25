// ============================================
// SKILL PROGRAM RESPONSE
// ============================================
import '../skill_program.dart';
class SkillProgramResponse {
  final bool? error;
  final int? code;
  final int? status;
  final String? message;
  final List<SkillProgram>? data;
  final int? total;
  final int? page;
  final int? size;
  final int? pages;
  final dynamic nextPage;
  final dynamic previousPage;

  SkillProgramResponse({
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

  factory SkillProgramResponse.fromJson(Map<String, dynamic> json) {
    return SkillProgramResponse(
      error: json['error'],
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<SkillProgram>.from(
              json['data'].map((x) => SkillProgram.fromJson(x)))
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

// ============================================
// SKILL PROGRAM MAIN MODEL
// ============================================
