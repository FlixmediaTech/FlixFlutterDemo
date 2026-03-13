import 'package:flutter/material.dart';

import '../models/product_params.dart';
import '../widgets/labeled_field.dart';
import 'product_page.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key, required this.onProductParamsSelected});

  final ValueChanged<ProductParams> onProductParamsSelected;

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final _mpnController = TextEditingController(text: 'lego_10297');
  final _eanController = TextEditingController(text: '5702017151847');
  final _distIdController = TextEditingController(text: '6');
  final _isoCodeController = TextEditingController(text: 'it');
  final _flIsoCodeController = TextEditingController();
  final _brandController = TextEditingController(text: 'Lego');
  final _titleController = TextEditingController(
    text: 'Lego Boutique Hotel Game Toy',
  );
  final _priceController = TextEditingController(text: '300');
  final _currencyController = TextEditingController(text: 'USD');

  bool get _isFormValid {
    return _mpnController.text.trim().isNotEmpty &&
        _distIdController.text.trim().isNotEmpty &&
        _isoCodeController.text.trim().isNotEmpty;
  }

  ProductParams _currentParams() {
    return ProductParams(
      mpn: _mpnController.text.trim(),
      ean: _eanController.text.trim(),
      distId: _distIdController.text.trim(),
      isoCode: _isoCodeController.text.trim(),
      flIsoCode: _flIsoCodeController.text.trim(),
      brand: _brandController.text.trim(),
      title: _titleController.text.trim(),
      price: _priceController.text.trim(),
      currency: _currencyController.text.trim(),
    );
  }

  Future<void> _browse() async {
    if (!_isFormValid) {
      return;
    }

    final params = _currentParams();
    widget.onProductParamsSelected(params);

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductPage(
          productTitle: params.title.isEmpty ? 'Product name' : params.title,
          imageUrl: null,
          price: params.price,
          currency: params.currency,
          params: params,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mpnController.dispose();
    _eanController.dispose();
    _distIdController.dispose();
    _isoCodeController.dispose();
    _flIsoCodeController.dispose();
    _brandController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse product')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Product identifiers',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LabeledField(
            label: 'MPN (required)',
            controller: _mpnController,
            onChanged: (_) => setState(() {}),
          ),
          LabeledField(label: 'EAN', controller: _eanController),
          LabeledField(
            label: 'Distributor ID (required)',
            controller: _distIdController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          LabeledField(label: 'Brand', controller: _brandController),
          LabeledField(label: 'Title', controller: _titleController),
          LabeledField(label: 'Price', controller: _priceController),
          LabeledField(label: 'Currency', controller: _currencyController),
          const SizedBox(height: 16),
          Text('Locale', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          LabeledField(
            label: 'isoCode (required)',
            controller: _isoCodeController,
            onChanged: (_) => setState(() {}),
          ),
          LabeledField(label: 'flIsoCode', controller: _flIsoCodeController),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _isFormValid ? _browse : null,
            icon: const Icon(Icons.travel_explore),
            label: const Text('Browse'),
          ),
          if (!_isFormValid)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Enter all required parameters to browse.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
