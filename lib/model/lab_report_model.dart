class LabReportDetails {
  var urea;
  var creatinine;
  var bloodSugerPp;
  var labReportDate;
  var bloodSugerFasting;

  LabReportDetails(
      {this.urea,
        this.creatinine,
        this.bloodSugerPp,
        this.labReportDate,
        this.bloodSugerFasting});

  LabReportDetails.fromJson(Map<String, dynamic> json) {
    urea = json['urea'];
    creatinine = json['creatinine'];
    bloodSugerPp = json['blood_suger_pp'];
    labReportDate = json['lab_report_date'];
    bloodSugerFasting = json['blood_suger_fasting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urea'] = this.urea;
    data['creatinine'] = this.creatinine;
    data['blood_suger_pp'] = this.bloodSugerPp;
    data['lab_report_date'] = this.labReportDate;
    data['blood_suger_fasting'] = this.bloodSugerFasting;
    return data;
  }
}