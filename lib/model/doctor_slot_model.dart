class DoctorSlotModel {
  int? slotTypeId;
  bool? isDeleted;
  int? appointmentTypeId;
  String? slotStartTime;
  String? slotEndTime;
  int? hospitalDoctorId;
  int? doctorId;
  Null? createdById;
  bool? isSlotAvailable;
  int? visitTypeId;
  int? id;
  bool? isActive;

  DoctorSlotModel(
      {this.slotTypeId,
        this.isDeleted,
        this.appointmentTypeId,
        this.slotStartTime,
        this.slotEndTime,
        this.hospitalDoctorId,
        this.doctorId,
        this.createdById,
        this.isSlotAvailable,
        this.visitTypeId,
        this.id,
        this.isActive});

  DoctorSlotModel.fromJson(Map<String, dynamic> json) {
    slotTypeId = json['slot_type_id'];
    isDeleted = json['is_deleted'];
    appointmentTypeId = json['appointment_type_id'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    hospitalDoctorId = json['hospital_doctor_id'];
    doctorId = json['doctor_id'];
    createdById = json['created_by_id'];
    isSlotAvailable = json['is_slot_available'];
    visitTypeId = json['visit_type_id'];
    id = json['id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_type_id'] = this.slotTypeId;
    data['is_deleted'] = this.isDeleted;
    data['appointment_type_id'] = this.appointmentTypeId;
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['hospital_doctor_id'] = this.hospitalDoctorId;
    data['doctor_id'] = this.doctorId;
    data['created_by_id'] = this.createdById;
    data['is_slot_available'] = this.isSlotAvailable;
    data['visit_type_id'] = this.visitTypeId;
    data['id'] = this.id;
    data['is_active'] = this.isActive;
    return data;
  }
}