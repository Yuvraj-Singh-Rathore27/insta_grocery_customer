class ScanTestListModel {
  String? name;
  int? scanCategoryId;
  bool? isActive;
  String? description;
  int? id;
  bool isSelected=false;

  ScanTestListModel(
      {this.name,
        this.scanCategoryId,
        this.isActive,
        this.description,
        this.id,
        required this.isSelected});

  ScanTestListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    scanCategoryId = json['scan_category_id'];
    isActive = json['is_active'];
    description = json['description'];
    id = json['id'];
    isSelected = json['is_selected']?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['scan_category_id'] = this.scanCategoryId;
    data['is_active'] = this.isActive;
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_selected'] = this.isSelected;
    return data;
  }
}