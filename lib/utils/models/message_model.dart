class MessageModel {
  String message;

  MessageModel({
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
  @override
  String toString() => message;
}
