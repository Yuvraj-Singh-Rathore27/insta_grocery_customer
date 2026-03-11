class BloodGroup {
  bool? isSelected=false;
  String? name;

  BloodGroup({
    this.isSelected,
    this.name,
  });

  BloodGroup.fromJson(Map<String, dynamic> json) {
    isSelected = json['isSelected'];
    name = json['name'];
  }
}
