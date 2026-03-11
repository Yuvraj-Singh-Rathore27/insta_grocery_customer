class CommonModel {
  int ?stateId;
  int ?id;
  String ?name;
  String ?description;
  String ?logo;
  String ?button_name;
  List<Photos>? photos;

  CommonModel({this.stateId, this.id, this.name,
    this.description,
    this.button_name,
  });

  CommonModel.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    id = json['id'];
    name = json['name'];
    description = json['description']??'';
    button_name = json['button_name']??'';
    logo = json['logo'].toString()??"";
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    if (this.photos != null) {
      data['photos'] =
          this.photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }



}

class Photos {
  String? path;

  Photos({this.path});

  Photos.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}