class ChatMessage {
  final int sender;
  final int receiver;
  final int product; 
  final String message;
  final DateTime timestamp;

  ChatMessage(this.sender, this.receiver,this.product, this.message, this.timestamp);

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'product' : product,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
