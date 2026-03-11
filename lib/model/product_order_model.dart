class ProductOrderModel {
  int? id;
  var name;
  var quantity;
  var totalAmount;

  ProductOrderModel({this.id, this.name, this.quantity, this.totalAmount});

  ProductOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

