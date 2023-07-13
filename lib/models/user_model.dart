class UserModel {
  String? name;
  String? address;
  String? email;
  String? phoneNumber;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Username'];
    address = json['Alamat'];
    email = json['Email'];
    phoneNumber = json['PhoneNo'];
  }
}
