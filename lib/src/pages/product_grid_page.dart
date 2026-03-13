import 'package:flutter/material.dart';

import '../models/product_params.dart';
import '../models/remote_product.dart';
import '../services/product_service.dart';
import '../widgets/photo_placeholder.dart';
import 'product_page.dart';

class ProductGridPage extends StatefulWidget {
  const ProductGridPage({super.key});

  @override
  State<ProductGridPage> createState() => _ProductGridPageState();
}

class _ProductGridPageState extends State<ProductGridPage> {
  late Future<List<RemoteProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().fetchProducts();
  }

  void _reload() {
    setState(() {
      _productsFuture = ProductService().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: FutureBuilder<List<RemoteProduct>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reload,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? const <RemoteProduct>[];
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductTile(
                product: product,
                onTap: () {
                  final trimmedTitle = product.title.trim();
                  final titleParts = trimmedTitle.isEmpty
                      ? const <String>[]
                      : trimmedTitle.split(RegExp(r'\s+'));
                  final brand = titleParts.isEmpty ? '' : titleParts.first;
                  final params = ProductParams(
                    mpn: product.mpn,
                    ean: product.ean,
                    distId: '6',
                    isoCode: product.isoCode,
                    flIsoCode: '',
                    brand: brand,
                    title: product.title,
                    price: product.price,
                    currency: 'EUR',
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProductPage(
                        productTitle: product.title,
                        imageUrl: product.image,
                        price: product.price,
                        currency: 'EUR',
                        params: params,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, required this.onTap});

  final RemoteProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.image == null || product.image!.isEmpty
                      ? const PhotoPlaceholder()
                      : Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const PhotoPlaceholder(),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '\$${product.price}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
