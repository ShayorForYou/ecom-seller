// // To parse this JSON data, do
// //
// //     final top12ProductResponse = top12ProductResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// OrdersByCriteria ordersByCriteriaFromJson(String str) => OrdersByCriteria.fromJson(json.decode(str));
//
// String top12ProductResponseToJson(OrdersByCriteria data) => json.encode(data.toJson());
//
// class OrdersByCriteria {
//   OrdersByCriteria({
//     this.data,
//   });
//
//   List<CriteriaProducts>? data;
//
//   factory OrdersByCriteria.fromJson(Map<String, dynamic> json) => OrdersByCriteria(
//     data: List<CriteriaProducts>.from(json["data"].map((x) => CriteriaProducts.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }
//
// class CriteriaProducts {
//   CriteriaProducts({
//     this.id,
//     this.name,
//     this.thumbnailImg,
//     this.price,
//     this.currentStock,
//     this.status,
//     this.category,
//     this.featured,
//   });
//
//   int? id;
//   String? name;
//   String? thumbnailImg;
//   String? price;
//   var currentStock;
//   bool? status;
//   String? category;
//   bool? featured;
//
//   factory CriteriaProducts.fromJson(Map<String, dynamic> json) => CriteriaProducts(
//     id: json["id"],
//     name: json["name"],
//     thumbnailImg: json["thumbnail_img"],
//     price: json["price"],
//     currentStock: json["current_stock"],
//     status: json["status"],
//     category: json["category"],
//     featured: json["featured"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "thumbnail_img": thumbnailImg,
//     "price": price,
//     "current_stock": currentStock,
//     "status": status,
//     "category": category,
//     "featured": featured,
//   };
// }


import 'dart:convert';

OrdersByCriteria ordersByCriteriaFromJson(String str) => OrdersByCriteria.fromJson(json.decode(str));

String ordersByCriteriaResponseToJson(OrdersByCriteria data) => json.encode(data.toJson());

class OrdersByCriteria {
  OrdersByCriteria({
    this.data,
    this.links,
    this.meta,
  });

  List<CriteriaProducts>? data;
  Links? links;
  Meta? meta;

  factory OrdersByCriteria.fromJson(Map<String, dynamic> json) => OrdersByCriteria(
    data: List<CriteriaProducts>.from(json["data"].map((x) => CriteriaProducts.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links!.toJson(),
    "meta": meta!.toJson(),
  };
}

class CriteriaProducts {
  CriteriaProducts({
    this.id,
    this.name,
    this.thumbnailImg,
    this.price,
    this.currentStock,
    this.status,
    this.category,
    this.featured,
  });

  int? id;
  String? name;
  String? thumbnailImg;
  String? price;
  var currentStock;
  bool? status;
  String? category;
  bool? featured;

  factory CriteriaProducts.fromJson(Map<String, dynamic> json) => CriteriaProducts(
    id: json["id"],
    name: json["name"],
    thumbnailImg: json["thumbnail_img"],
    price: json["price"],
    currentStock: json["current_stock"],
    status: json["status"],
    category: json["category"],
    featured: json["featured"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail_img": thumbnailImg,
    "price": price,
    "current_stock": currentStock,
    "status": status,
    "category": category,
    "featured": featured,
  };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  String? prev;
  String? next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  dynamic from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  dynamic to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}