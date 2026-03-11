class FilterModel {
  String ? image;
  int ?id;
  String ?name;
  var color;
  bool ?isSelected;


  FilterModel({this.image, this.id, this.name, this.color,this.isSelected});

  FilterModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
    color = json['color'];
    isSelected = json['isSelected']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['isSelected'] = this.isSelected;
    return data;
  }
}