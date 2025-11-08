class ProductModel {
  String? id;
  String name;
  String? description;
  String? brand;
  double price;
  String? image_path;
  String skin_type;

  ProductModel({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.brand,
    this.image_path,
    required this.skin_type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'brand': brand,
      'image_path': image_path,
      'skin_type': skin_type,
    }..removeWhere((_, v) => v == null); // drop nulls for cleaner payload
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic v) => v == null ? 0.0 : (v as num).toDouble();

    List<String>? images;
    if (map['images'] != null) {
      images = List<String>.from(map['images'] as List);
    } else if (map['product_images'] != null) {
      images = (map['product_images'] as List)
          .map((e) => e['url'] as String)
          .toList();
    }

    return ProductModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: parseDouble(map['price']),
      brand: map['brand']?.toString(),
      image_path: images?.isNotEmpty == true ? images!.first : map['image_path'],
      skin_type: map['skin_type'] as String,
    );
  }
}
