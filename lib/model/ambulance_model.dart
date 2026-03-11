class AmbulanceTypeModel {
  int ?id;
  String ?name;
  String ?type;
  bool isSelected=false;

  AmbulanceTypeModel({ this.id, this.name,this.type,isSelected});

  AmbulanceTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type']??"";
    isSelected = json['isSelected']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['isSelected'] = this.isSelected;
    return data;
  }
}