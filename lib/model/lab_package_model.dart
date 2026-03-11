class PackageModel {
  String? packageName;
  String? description;
  int? id;
  List<TestPackageAssociation>? testPackageAssociation;
  List<LabTestsCharges>? labTestsCharges;
  bool isSelected=false;

  PackageModel(
      {this.packageName,
        this.description,
        this.id,
        this.testPackageAssociation,
        this.labTestsCharges,
        required this.isSelected});

  PackageModel.fromJson(Map<String, dynamic> json) {
    packageName = json['package_name'];
    description = json['description'];
    id = json['id'];
    isSelected = json['is_selected']?? false;
    if (json['test_package_association'] != null) {
      testPackageAssociation = <TestPackageAssociation>[];
      json['test_package_association'].forEach((v) {
        testPackageAssociation!.add(new TestPackageAssociation.fromJson(v));
      });
    }
    if (json['lab_tests_charges'] != null) {
      labTestsCharges = <LabTestsCharges>[];
      json['lab_tests_charges'].forEach((v) {
        labTestsCharges!.add(new LabTestsCharges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_name'] = this.packageName;
    data['description'] = this.description;
    data['is_selected'] = this.isSelected;
    data['id'] = this.id;
    if (this.testPackageAssociation != null) {
      data['test_package_association'] =
          this.testPackageAssociation!.map((v) => v.toJson()).toList();
    }
    if (this.labTestsCharges != null) {
      data['lab_tests_charges'] =
          this.labTestsCharges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TestPackageAssociation {
  int? packageId;
  int? id;
  LabTests? labTests;

  TestPackageAssociation({this.packageId, this.id, this.labTests});

  TestPackageAssociation.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    id = json['id'];
    labTests = json['lab_tests'] != null
        ? new LabTests.fromJson(json['lab_tests'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_id'] = this.packageId;
    data['id'] = this.id;
    if (this.labTests != null) {
      data['lab_tests'] = this.labTests!.toJson();
    }
    return data;
  }
}

class LabTests {
  String? description;
  bool? isActive;
  String? name;
  int? id;

  LabTests({this.description, this.isActive, this.name, this.id});

  LabTests.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    isActive = json['is_active'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class LabTestsCharges {
  int? packageId;
  int? id;
  var charges;
  int? labId;

  LabTestsCharges({this.packageId, this.id, this.charges, this.labId});

  LabTestsCharges.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    id = json['id'];
    charges = json['charges'];
    labId = json['lab_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_id'] = this.packageId;
    data['id'] = this.id;
    data['charges'] = this.charges;
    data['lab_id'] = this.labId;

    return data;
  }
}