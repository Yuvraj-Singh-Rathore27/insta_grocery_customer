
class UserModel{

  var id,first_name,last_name,email,email_verified_at,profile_image,phone_number,type;

  static UserModel? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserModel dataBean = UserModel();
    dataBean.id = map['id'];
    dataBean.first_name = map['first_name'];
    dataBean.last_name = map['last_name'];
    dataBean.email = map['email'];
    dataBean.email_verified_at = map['email_verified_at']??'';
    dataBean.profile_image = map['profile_image'];
    dataBean.phone_number = map['phone_number'];
    dataBean.type = map['type'];

    return dataBean;
  }

  Map toJson() => {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "email":email,
      "email_verified_at":email_verified_at,
      "profile_image":profile_image,
      "phone_number":phone_number,
      "type":type,
  };


}