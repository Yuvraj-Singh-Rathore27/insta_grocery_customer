class StateModel {
  int ?stateId;
  int ?id;
  String ?name;
  String ?type;
  bool isSelected=false;

  StateModel({this.stateId, this.id, this.name,this.type,isSelected});

  StateModel.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    id = json['id'];
    name = json['name'];
    type = json['type']??"";
    isSelected = json['isSelected']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['isSelected'] = this.isSelected;
    return data;
  }
}