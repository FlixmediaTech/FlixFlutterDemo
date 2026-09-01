import 'package:flix_inpage/flix_inpage.dart';
import 'package:flutter/material.dart';

import '../models/product_params.dart';
import '../widgets/photo_placeholder.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.productTitle,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.params,
  });

  final String productTitle;
  final String? imageUrl;
  final String price;
  final String currency;
  final ProductParams params;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FlixInpageHtmlViewController _controller =
      FlixInpageHtmlViewController();
  final ScrollController _scrollController = ScrollController();
  Object? _flixError;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                widget.productTitle.isEmpty
                    ? 'Product name'
                    : widget.productTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.imageUrl == null || widget.imageUrl!.isEmpty
                      ? const PhotoPlaceholder()
                      : Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const PhotoPlaceholder(),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Price: ${widget.price.isEmpty ? '99.99' : widget.price} ${widget.currency}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (_flixError != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Failed to load product content.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _flixError.toString(),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => setState(() => _flixError = null),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              )
            else
              FlixInpageHtmlView(
                controller: _controller,
                parentScrollController: _scrollController,
                productParams: widget.params.toMap(),
                baseURL: 'https://www.example.com',
                contentMode: 'compact',
                flixConfig: const {
                  'showMore': {
                    'maxHeight': 1000,
                    'buttonStyle': 'text',
                    'buttonText': 'Show More',
                    'buttonTextExpanded': 'Show Less',
                    'buttonColor': '#0066cc',
                    'gradientColor': '#ffffff',
                  }
                },
                onError: (error) {
                  if (!mounted) return;
                  setState(() => _flixError = error);
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: FilledButton(
            onPressed: () {
              _controller.callLogFromApp('cartButtonTapped');
            },
            child: const Text('Buy now'),
          ),
        ),
      ),
    );
  }
}
