import 'package:flutter/material.dart';

import '../models/product_params.dart';
import 'accordion_page.dart';
import 'browse_page.dart';
import 'product_grid_page.dart';
import 'settings_page.dart';

class DemoTabs extends StatefulWidget {
  const DemoTabs({
    super.key,
    required this.selectedProductParams,
    required this.onProductParamsSelected,
    required this.onLogout,
  });

  final ProductParams? selectedProductParams;
  final ValueChanged<ProductParams> onProductParamsSelected;
  final VoidCallback onLogout;

  @override
  State<DemoTabs> createState() => _DemoTabsState();
}

class _DemoTabsState extends State<DemoTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ProductGridPage(),
      BrowsePage(onProductParamsSelected: widget.onProductParamsSelected),
      AccordionPage(selectedParams: widget.selectedProductParams),
      SettingsPage(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.travel_explore),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.unfold_more),
            label: 'Accordion',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
