class CommonModelNew {
  int ?stateId;
  int ?id;
  String ?name;
  String ?description;
  String ?button_name;
  List<Photos>? logo;

  CommonModelNew({this.stateId, this.id, this.name,
    this.description,
    this.button_name,
  });

  CommonModelNew.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    id = json['id'];
    name = json['name'];
    description = json['description']??'';
    button_name = json['button_name']??'';
    if (json['logo'] != null) {
      logo = <Photos>[];
      json['logo'].forEach((v) {
        logo!.add(new Photos.fromJson(v));
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
    if (this.logo != null) {
      data['logo'] =
          this.logo!.map((v) => v.toJson()).toList();
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