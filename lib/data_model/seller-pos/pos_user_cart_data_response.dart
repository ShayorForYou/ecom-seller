// To parse this JSON data, do
//
//     final posUserCartDataResponse = posUserCartDataResponseFromJson(jsonString);

import 'dart:convert';

PosUserCartDataResponse posUserCartDataResponseFromJson(String str) =>
    PosUserCartDataResponse.fromJson(json.decode(str));

String posUserCartDataResponseToJson(PosUserCartDataResponse data) =>
    json.encode(data.toJson());

class PosUserCartDataResponse {
  bool? result;
  UserCartData? data;

  PosUserCartDataResponse({
    this.result,
    this.data,
  });

  factory PosUserCartDataResponse.fromJson(Map<String, dynamic> json) =>
      PosUserCartDataResponse(
        result: json["result"],
        data: json["data"] == null ? null : UserCartData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data?.toJson(),
      };
}

class UserCartData {
  CartData? cartData;
  String? subtotal;
  String? tax;
  String? shippingCost;
  String? shippingCost_str;
  String? discount;
  String? total;

  UserCartData({
    this.cartData,
    this.subtotal,
    this.tax,
    this.shippingCost,
    this.shippingCost_str,
    this.discount,
    this.total,
  });

  factory UserCartData.fromJson(Map<String, dynamic> json) => UserCartData(
        cartData: json["cart_data"] == null
            ? null
            : CartData.fromJson(json["cart_data"]),
        subtotal: json["subtotal"],
        tax: json["tax"],
        shippingCost: json["shippingCost"],
        shippingCost_str: json["shippingCost_str"],
        discount: json["discount"],
        total: json["Total"],
      );

  Map<String, dynamic> toJson() => {
        "cart_data": cartData?.toJson(),
        "subtotal": subtotal,
        "tax": tax,
        "shippingCost": shippingCost,
        "shippingCost_str": shippingCost_str,
        "discount": discount,
        "Total": total,
      };
}

class CartData {
  List<Datum>? data;

  CartData({
    this.data,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

// Map v = {
//   "result": true,
//   "data": {
//     "cart_data": {
//       "data": [
//         {
//           "id": 47,
//           "thumbnail_image": "https:\/\/sobdak.xyz\/public\/uploads\/all\/sjJNyrKU54XxCfhklLo0wxDVXzFH7KkdUSEklzNF.jpg",
//           "stock_id": 32,
//           "product_name": "Smart refregerator",
//           "variation": "",
//           "price": "\u09f345,000.00",
//           "tax": "\u09f30.00",
//           "cart_quantity": 1,
//           "min_purchase_qty": 1,
//           "stock_qty": 20
//         }
//       ]
//     },
//     "subtotal": "\u09f345,000.00",
//     "tax": "\u09f30.00",
//     "shippingCost": null,
//     "shippingCost_str": "\u09f30.00",
//     "discount": "\u09f30.00",
//     "Total": "\u09f345,000.00"
//   }
// };

class Datum {
  int? id;
  String? thumbnailImage;
  int? stockId;
  String? productName;
  String? variation;
  var price;
  var tax;
  int? cartQuantity;
  int? minPurchaseQty;
  int? stockQty;

  Datum({
    this.id,
    this.thumbnailImage,
    this.stockId,
    this.productName,
    this.variation,
    this.price,
    this.tax,
    this.cartQuantity,
    this.minPurchaseQty,
    this.stockQty,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        thumbnailImage: json["thumbnail_image"],
        stockId: json["stock_id"],
        productName: json["product_name"],
        variation: json["variation"],
        price: json["price"],
        tax: json["tax"],
        cartQuantity: json["cart_quantity"],
        minPurchaseQty: json["min_purchase_qty"],
        stockQty: json["stock_qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "thumbnail_image": thumbnailImage,
        "stock_id": stockId,
        "product_name": productName,
        "variation": variation,
        "price": price,
        "tax": tax,
        "cart_quantity": cartQuantity,
        "min_purchase_qty": minPurchaseQty,
        "stock_qty": stockQty,
      };
}
