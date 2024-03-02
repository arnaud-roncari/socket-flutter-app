enum MessageStatus {
  success,
  loading,
  failed,
}

class MessageModel {
  final String id;
  final String userId;
  final String text;
  bool hasBeenRead;
  final DateTime createdAt;

  MessageStatus status;
  final String? requestUuid;

  MessageModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.hasBeenRead,
    required this.createdAt,
    this.status = MessageStatus.success,
    this.requestUuid,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      userId: json["user_id"],
      hasBeenRead: json["has_been_read"],
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
