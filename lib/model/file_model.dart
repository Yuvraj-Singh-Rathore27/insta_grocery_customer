class FileModel {
  String? path;
  String? name;

  FileModel({this.path, this.name});

  FileModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['name'] = this.name;
    return data;
  }
}
