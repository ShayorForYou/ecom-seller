// // To parse this JSON ShopInfo, do
// //
// //     final shopInfoResponse = shopInfoResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// ShopInfoResponse shopInfoResponseFromJson(String str) => ShopInfoResponse.fromJson(json.decode(str));
//
// String shopInfoResponseToJson(ShopInfoResponse ShopInfo) => json.encode(ShopInfo.toJson());
//
// class ShopInfoResponse {
//   ShopInfoResponse({
//     this.shopInfo,
//     this.success,
//     this.status,
//   });
//
//   ShopInfo? shopInfo;
//   bool? success;
//   var status;
//
//   factory ShopInfoResponse.fromJson(Map<String, dynamic> json) => ShopInfoResponse(
//     shopInfo: ShopInfo.fromJson(json["data"]),
//     success: json["success"],
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": shopInfo!.toJson(),
//     "success": success,
//     "status": status,
//   };
// }
//
// class ShopInfo {
//   ShopInfo({
//     this.id,
//     this.userId,
//     this.name,
//     this.title,
//     this.description,
//     this.deliveryPickupLatitude,
//     this.deliveryPickupLongitude,
//     this.logo,
//     this.packageInvalidAt,
//     this.productUploadLimit,
//     this.sellerPackage,
//     this.sellerPackageImg,
//     this.uploadId,
//     this.sliders,
//     this.slidersId,
//     this.address,
//     this.adminToPay,
//     this.is_submitted_form,
//     this.phone,
//     this.facebook,
//     this.google,
//     this.twitter,
//     this.instagram,
//     this.youtube,
//     this.cashOnDeliveryStatus,
//     this.bank_payment_status,
//     this.bankName,
//     this.bankAccName,
//     this.bankAccNo,
//     this.bankRoutingNo,
//     this.rating,
//     this.verified,
//     this.verifiedImg,
//     this.verifyText,
//     this.email,
//     this.products,
//     this.orders,
//     this.sales,
//   });
//
//   var id;
//   var userId;
//   String? name;
//   String? title;
//   String? description;
//   dynamic deliveryPickupLatitude;
//   dynamic deliveryPickupLongitude;
//   String? logo;
//   String? packageInvalidAt;
//   var productUploadLimit;
//   String? sellerPackage;
//   String? sellerPackageImg;
//   String? uploadId;
//   List<String>? sliders;
//   dynamic slidersId;
//   String? address;
//   var adminToPay;
//   bool? is_submitted_form;
//   String? phone;
//   String? facebook;
//   String? google;
//   String? twitter;
//   dynamic instagram;
//   String? youtube;
//   var cashOnDeliveryStatus;
//   var bank_payment_status;
//   String? bankName;
//   String? bankAccName;
//   String? bankAccNo;
//   var bankRoutingNo;
//   double? rating;
//   bool? verified;
//   String? verifiedImg;
//   String? verifyText;
//   String? email;
//   var products;
//   var orders;
//   String? sales;
//
//   factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
//     id: json["id"],
//     userId: json["user_id"],
//     name: json["name"],
//     title: json["title"],
//     description: json["description"],
//     deliveryPickupLatitude: json["delivery_pickup_latitude"]??"",
//     deliveryPickupLongitude: json["delivery_pickup_longitude"]??"",
//     logo: json["logo"],
//     packageInvalidAt: json["package_invalid_at"],
//     productUploadLimit: json["product_upload_limit"],
//     sellerPackage: json["seller_package"],
//     sellerPackageImg: json["seller_package_img"],
//     uploadId: json["upload_id"],
//     sliders: List<String>.from(json["sliders"].map((x) => x)),
//     slidersId: json["sliders_id"],
//     address: json["address"],
//     adminToPay: json["admin_to_pay"],
//     is_submitted_form: json["is_submitted_form"],
//     phone: json["phone"],
//     facebook: json["facebook"],
//     google: json["google"],
//     twitter: json["twitter"],
//     instagram: json["instagram"],
//     youtube: json["youtube"],
//     cashOnDeliveryStatus: json["cash_on_delivery_status"],
//     bank_payment_status: json["bank_payment_status"],
//     bankName: json["bank_name"],
//     bankAccName: json["bank_acc_name"],
//     bankAccNo: json["bank_acc_no"],
//     bankRoutingNo: json["bank_routing_no"]??"",
//     rating: json["rating"].toDouble(),
//     verified: json["verified"],
//     verifiedImg: json["verified_img"],
//     verifyText: json["verify_text"],
//     email: json["email"],
//     products: json["products"],
//     orders: json["orders"],
//     sales: json["sales"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "name": name,
//     "title": title,
//     "description": description,
//     "delivery_pickup_latitude": deliveryPickupLatitude,
//     "delivery_pickup_longitude": deliveryPickupLongitude,
//     "logo": logo,
//     "package_invalid_at": packageInvalidAt,
//     "product_upload_limit": productUploadLimit,
//     "seller_package": sellerPackage,
//     "seller_package_img": sellerPackageImg,
//     "upload_id": uploadId,
//     "sliders": List<dynamic>.from(sliders!.map((x) => x)),
//     "sliders_id": slidersId,
//     "address": address,
//     "admin_to_pay": adminToPay,
//     "is_submitted_form": is_submitted_form,
//     "phone": phone,
//     "facebook": facebook,
//     "google": google,
//     "twitter": twitter,
//     "instagram": instagram,
//     "youtube": youtube,
//     "cash_on_delivery_status": cashOnDeliveryStatus,
//     "bank_payment_status": bank_payment_status,
//     "bank_name": bankName,
//     "bank_acc_name": bankAccName,
//     "bank_acc_no": bankAccNo,
//     "bank_routing_no": bankRoutingNo,
//     "rating": rating,
//     "verified": verified,
//     "verified_img": verifiedImg,
//     "verify_text": verifyText,
//     "email": email,
//     "products": products,
//     "orders": orders,
//     "sales": sales,
//   };
// }

import 'dart:convert';

ShopInfoResponse shopInfoResponseFromJson(String str) => ShopInfoResponse.fromJson(json.decode(str));

String shopInfoResponseToJson(ShopInfoResponse shopInfo) => json.encode(shopInfo.toJson());

class ShopInfoResponse {
  ShopInfoResponse({
    this.shopInfo,
    this.success,
    this.status,
    this.childUsers,
  });

  ShopInfo? shopInfo;
  bool? success;
  int? status; // Changed to int
  List<ChildUser>? childUsers; // New field

  factory ShopInfoResponse.fromJson(Map<String, dynamic> json) => ShopInfoResponse(
    shopInfo: ShopInfo.fromJson(json["data"]),
    success: json["success"],
    status: json["status"],
    childUsers: json["child_users"] != null ? List<ChildUser>.from(json["child_users"].map((x) => ChildUser.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "data": shopInfo!.toJson(),
    "success": success,
    "status": status,
    "child_users": childUsers != null ? List<dynamic>.from(childUsers!.map((x) => x.toJson())) : null,
  };
}

class ShopInfo {
  ShopInfo({
    this.id,
    this.userId,
    this.name,
    this.title,
    this.description,
    this.deliveryPickupLatitude,
    this.deliveryPickupLongitude,
    this.logo,
    this.packageInvalidAt,
    this.productUploadLimit,
    this.sellerPackage,
    this.sellerPackageImg,
    this.uploadId,
    this.sliders,
    this.slidersId,
    this.address,
    this.adminToPay,
    this.phone,
    this.facebook,
    this.google,
    this.twitter,
    this.instagram,
    this.youtube,
    this.cashOnDeliveryStatus,
    this.bankPaymentStatus,
    this.bankName,
    this.bankAccName,
    this.bankAccNo,
    this.bankRoutingNo,
    this.rating,
    this.verified,
    this.isSubmittedForm,
    this.verifiedImg,
    this.verifyText,
    this.email,
    this.products,
    this.orders,
    this.sales,
  });

  int? id; // Changed to int
  int? userId; // Changed to int
  String? name;
  String? title;
  String? description;
  double? deliveryPickupLatitude; // Changed to double
  double? deliveryPickupLongitude; // Changed to double
  String? logo;
  String? packageInvalidAt;
  int? productUploadLimit; // Changed to int
  String? sellerPackage;
  String? sellerPackageImg;
  String? uploadId;
  List<String>? sliders;
  dynamic slidersId;
  String? address;
  String? adminToPay;
  String? phone;
  String? facebook;
  String? google;
  String? twitter;
  String? instagram; // Changed to String
  String? youtube;
  int? cashOnDeliveryStatus; // Changed to int
  int? bankPaymentStatus; // Changed to int
  String? bankName;
  String? bankAccName;
  String? bankAccNo;
  String? bankRoutingNo; // Changed to String
  double? rating; // Changed to double
  bool? verified;
  bool? isSubmittedForm; // Changed to bool
  String? verifiedImg;
  String? verifyText;
  String? email;
  int? products; // Changed to int
  int? orders; // Changed to int
  String? sales;

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    title: json["title"],
    description: json["description"],
    deliveryPickupLatitude: json["delivery_pickup_latitude"]?.toDouble(), // Handling null and converting to double
    deliveryPickupLongitude: json["delivery_pickup_longitude"]?.toDouble(), // Handling null and converting to double
    logo: json["logo"],
    packageInvalidAt: json["package_invalid_at"],
    productUploadLimit: json["product_upload_limit"],
    sellerPackage: json["seller_package"],
    sellerPackageImg: json["seller_package_img"],
    uploadId: json["upload_id"],
    sliders: json["sliders"] != null ? List<String>.from(json["sliders"].map((x) => x.toString())) : null,
    slidersId: json["sliders_id"],
    address: json["address"],
    adminToPay: json["admin_to_pay"],
    phone: json["phone"],
    facebook: json["facebook"],
    google: json["google"],
    twitter: json["twitter"],
    instagram: json["instagram"],
    youtube: json["youtube"],
    cashOnDeliveryStatus: json["cash_on_delivery_status"],
    bankPaymentStatus: json["bank_payment_status"],
    bankName: json["bank_name"],
    bankAccName: json["bank_acc_name"],
    bankAccNo: json["bank_acc_no"],
    bankRoutingNo: json["bank_routing_no"],
    rating: json["rating"]?.toDouble(), // Handling null and converting to double
    verified: json["verified"],
    isSubmittedForm: json["is_submitted_form"],
    verifiedImg: json["verified_img"],
    verifyText: json["verify_text"],
    email: json["email"],
    products: json["products"],
    orders: json["orders"],
    sales: json["sales"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "title": title,
    "description": description,
    "delivery_pickup_latitude": deliveryPickupLatitude,
    "delivery_pickup_longitude": deliveryPickupLongitude,
    "logo": logo,
    "package_invalid_at": packageInvalidAt,
    "product_upload_limit": productUploadLimit,
    "seller_package": sellerPackage,
    "seller_package_img": sellerPackageImg,
    "upload_id": uploadId,
    "sliders": sliders != null ? List<dynamic>.from(sliders!.map((x) => x)) : null,
    "sliders_id": slidersId,
    "address": address,
    "admin_to_pay": adminToPay,
    "phone": phone,
    "facebook": facebook,
    "google": google,
    "twitter": twitter,
    "instagram": instagram,
    "youtube": youtube,
    "cash_on_delivery_status": cashOnDeliveryStatus,
    "bank_payment_status": bankPaymentStatus,
    "bank_name": bankName,
    "bank_acc_name": bankAccName,
    "bank_acc_no": bankAccNo,
    "bank_routing_no": bankRoutingNo,
    "rating": rating,
    "verified": verified,
    "is_submitted_form": isSubmittedForm,
    "verified_img": verifiedImg,
    "verify_text": verifyText,
    "email": email,
    "products": products,
    "orders": orders,
    "sales": sales,
  };
}

class ChildUser {
  ChildUser({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory ChildUser.fromJson(Map<String, dynamic> json) => ChildUser(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

