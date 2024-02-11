class UserModel {
  final String id;
  final String username;
  final int avatarNumber;
  bool isConnected = false;
  bool isTyping = false;

  UserModel({required this.username, required this.avatarNumber, required this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json["username"], avatarNumber: json["avatar_number"], id: json["id"]);
  }

  static List<UserModel> fromJsons(List jsons) {
    List<UserModel> users = [];
    for (Map<String, dynamic> json in jsons) {
      users.add(UserModel.fromJson(json));
    }
    return users;
  }
}
