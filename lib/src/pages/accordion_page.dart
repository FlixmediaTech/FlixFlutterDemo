import 'package:flix_inpage/flix_inpage.dart';
import 'package:flutter/material.dart';

import '../models/product_params.dart';
import '../widgets/photo_placeholder.dart';

class AccordionPage extends StatefulWidget {
  const AccordionPage({super.key, required this.selectedParams});

  final ProductParams? selectedParams;

  @override
  State<AccordionPage> createState() => _AccordionPageState();
}

class _AccordionPageState extends State<AccordionPage> {
  bool _isExpanded = false;
  final FlixInpageHtmlViewController _controller =
      FlixInpageHtmlViewController();

  ProductParams get _params {
    return widget.selectedParams ??
        const ProductParams(
          mpn: 'lego_10297',
          ean: '5702017151847',
          distId: '6',
          isoCode: 'it',
          flIsoCode: '',
          brand: 'Lego',
          title: 'Lego Boutique Hotel Game Toy',
          price: '300',
          currency: 'USD',
        );
  }

  @override
  Widget build(BuildContext context) {
    final params = _params;

    return Scaffold(
      appBar: AppBar(title: const Text('Accordion')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              params.title.isEmpty ? 'Product name' : params.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (widget.selectedParams == null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'To change the displayed product, choose a different one in the Browse tab.',
                    ),
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: SizedBox(height: 150, child: PhotoPlaceholder()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Text('Price: ${params.price} ${params.currency}'),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            title: const Text('Full product description'),
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
            children: [
              FlixInpageHtmlView(
                controller: _controller,
                productParams: params.toMap(),
                baseURL: 'https://www.example.com',
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec erat justo, varius eget commodo vitae, lacinia ut tortor. Curabitur dictum orci et lectus sollicitudin, eu malesuada elit semper. Nullam posuere vel risus quis feugiat. Nulla sit amet vestibulum nulla, eget finibus tortor. Proin pulvinar libero quis risus finibus, non sagittis est euismod.',
            ),
          ),
        ],
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
