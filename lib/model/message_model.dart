class MessageModel {
  final String userId;
  final String text;
  final DateTime createdAt;

  MessageModel({required this.userId, required this.text, required this.createdAt});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      userId: json["user_id"],
      text: json["text"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }

  static List<MessageModel> fromJsons(List jsons) {
    List<MessageModel> messages = [];
    for (Map<String, dynamic> json in jsons) {
      messages.add(MessageModel.fromJson(json));
    }
    return messages;
  }
}
