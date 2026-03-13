class ProductParams {
  const ProductParams({
    required this.mpn,
    required this.ean,
    required this.distId,
    required this.isoCode,
    required this.flIsoCode,
    required this.brand,
    required this.title,
    required this.price,
    required this.currency,
  });

  final String mpn;
  final String ean;
  final String distId;
  final String isoCode;
  final String flIsoCode;
  final String brand;
  final String title;
  final String price;
  final String currency;

  Map<String, dynamic> toMap() {
    return {
      'mpn': mpn,
      'ean': ean,
      'distId': distId,
      'isoCode': isoCode,
      'flIsoCode': flIsoCode,
      'brand': brand,
      'title': title,
      'price': price,
      'currency': currency,
    };
  }
}
