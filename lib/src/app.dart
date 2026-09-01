import 'package:flix_inpage/flix_inpage.dart';
import 'package:flutter/material.dart';

import 'models/product_params.dart';
import 'pages/demo_tabs.dart';
import 'services/flix_auth_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlixAuthService _authService = FlixAuthService();

  bool _isInitialized = false;
  bool _isLoading = false;
  bool _useSandbox = false;
  String? _initError;
  ProductParams? _selectedProductParams;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _initError = null;
    });

    try {
      var didAuthenticateWithCredentials = false;

      await FlixBridge.initializeWithTokenProvider(
        useSandbox: _useSandbox,
        tokenProvider: () async {
          if (!didAuthenticateWithCredentials) {
            final token = await _authService.authenticate(
              username: 'flixmediaqa',
              password: r'FlixQa99&$',
              useSandbox: _useSandbox,
            );
            didAuthenticateWithCredentials = true;
            return token;
          }
          return _authService.refreshToken();
        },
      );

      if (!mounted) return;
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _initError = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flix Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _isInitialized
          ? DemoTabs(
              selectedProductParams: _selectedProductParams,
              onProductParamsSelected: (params) {
                setState(() {
                  _selectedProductParams = params;
                });
              },
              onLogout: () {
                setState(() {
                  _isInitialized = false;
                  _selectedProductParams = null;
                });
              },
            )
          : Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Flix SDK Demo',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Production'),
                          Switch(
                            value: _useSandbox,
                            onChanged: (val) => setState(() => _useSandbox = val),
                          ),
                          const Text('Alpha'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_initError != null) ...[
                        Text(
                          _initError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _signIn,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
