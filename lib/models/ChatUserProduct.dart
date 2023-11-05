class ChatUserProduct {
  final int sender_id;
  final int product_id; 

  ChatUserProduct(this.sender_id,this.product_id);

  Map<String, dynamic> toJson() {
    return {
      'sender': sender_id,
      'product' : product_id,
    };
  }
}