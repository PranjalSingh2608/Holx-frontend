class ChatUserProduct {
  final int sender_id;
  final int product_id;
  // final String sender_name;
  // final String product_name;

  ChatUserProduct(this.sender_id, this.product_id);

  Map<String, dynamic> toJson() {
    return {
      'sender': sender_id,
      'product': product_id,
      // 'sender_name':sender_name,
      // 'product_name':product_name
    };
  }
}
