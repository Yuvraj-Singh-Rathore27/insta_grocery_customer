class Message {
  String? sender;
  String? content;
  String? timestamp;

  Message({this.sender, this.content, this.timestamp});

  Message.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    content = json['content'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['content'] = this.content;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
