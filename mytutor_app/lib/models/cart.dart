class Cart {
  String? cartid;
  String? subname;
  String? subsession;
  String? subprice;
  String? cartqty;
  String? subid;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.subname,
      this.subsession,
      this.subprice,
      this.cartqty,
      this.subid,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cart_id'];
    subname = json['subject_name'];
    subsession = json['subject_sessions'];
    subprice = json['subject_price'];
    cartqty = json['cart_quan'];
    subid = json['subject_id'];
    pricetotal = json['pricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartid;
    data['subject_name'] = subname;
    data['subject_sessions'] = subsession;
    data['subject_price'] = subprice;
    data['cart_quan'] = cartqty;
    data['subject_id'] = subid;
    data['pricetotal'] = pricetotal;
    return data;
  }
}