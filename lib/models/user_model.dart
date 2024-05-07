class UserModel{
  final String id;
  final String email;

  UserModel({required this.id, required this.email});

  Map<String, dynamic> toJson(){
    return {
      "userid": id
    };
  }
}