class MessageModel {
  bool status;
  String message;

  MessageModel({
    required this.status,
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };

  @override
  String toString() => message;
}
