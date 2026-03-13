class RemoteProduct {
  const RemoteProduct({
    required this.mpn,
    required this.ean,
    required this.isoCode,
    required this.title,
    required this.price,
    required this.image,
  });

  final String mpn;
  final String ean;
  final String isoCode;
  final String title;
  final String price;
  final String? image;

  factory RemoteProduct.fromJson(Map<String, dynamic> json) {
    return RemoteProduct(
      mpn: (json['mpn'] ?? '').toString(),
      ean: (json['ean'] ?? '').toString(),
      isoCode: (json['isoCode'] ?? '').toString(),
      title: (json['title'] ?? json['mpn'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      image: json['image']?.toString(),
    );
  }
}
