class DailyVitals {
  var spo2;
  var pulse;
  var vitalDate;
  var spo2Status;
  var systolicBp;
  var temperature;
  var diastolicBp;
  var pulseStatus;
  var respirationCount;
  var respirationStatus;
  var systolicBpStatus;
  var temperatureStatus;
  var diastolicBpStatus;

  DailyVitals(
      {this.spo2,
        this.pulse,
        this.vitalDate,
        this.spo2Status,
        this.systolicBp,
        this.temperature,
        this.diastolicBp,
        this.pulseStatus,
        this.respirationCount,
        this.respirationStatus,
        this.systolicBpStatus,
        this.temperatureStatus,
        this.diastolicBpStatus});

  DailyVitals.fromJson(Map<String, dynamic> json) {
    spo2 = json['spo2'];
    pulse = json['pulse'];
    vitalDate = json['vital_date'];
    spo2Status = json['spo2_status'];
    systolicBp = json['systolic_bp'];
    temperature = json['temperature'];
    diastolicBp = json['diastolic_bp'];
    pulseStatus = json['pulse_status'];
    respirationCount = json['respiration_count'];
    respirationStatus = json['respiration_status'];
    systolicBpStatus = json['systolic_bp_status'];
    temperatureStatus = json['temperature_status'];
    diastolicBpStatus = json['diastolic_bp_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spo2'] = this.spo2;
    data['pulse'] = this.pulse;
    data['vital_date'] = this.vitalDate;
    data['spo2_status'] = this.spo2Status;
    data['systolic_bp'] = this.systolicBp;
    data['temperature'] = this.temperature;
    data['diastolic_bp'] = this.diastolicBp;
    data['pulse_status'] = this.pulseStatus;
    data['respiration_count'] = this.respirationCount;
    data['respiration_status'] = this.respirationStatus;
    data['systolic_bp_status'] = this.systolicBpStatus;
    data['temperature_status'] = this.temperatureStatus;
    data['diastolic_bp_status'] = this.diastolicBpStatus;
    return data;
  }
}
