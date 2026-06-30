import 'package:flix_inpage/flix_inpage.dart';
import 'package:flutter/material.dart';

import 'models/product_params.dart';
import 'pages/demo_tabs.dart';
import 'pages/login_page.dart';
import 'services/flix_auth_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlixAuthService _authService = FlixAuthService();

  bool _isInitialized = false;
  bool _isLoading = true;
  bool _useSandbox = false;
  String? _initError;
  ProductParams? _selectedProductParams;

  @override
  void initState() {
    super.initState();
    _finishInitialLoad();
  }

  void _finishInitialLoad() {
    setState(() {
      _isInitialized = false;
      _isLoading = false;
    });
  }

  Future<void> _signIn(String username, String password) async {
    if (_isLoading) {
      return;
    }

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
              username: username,
              password: password,
              useSandbox: _useSandbox,
            );
            didAuthenticateWithCredentials = true;
            return token;
          }

          return _authService.refreshToken();
        },
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _initError =
            'Token sign in failed. Please check your credentials and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isInitialized = false;
      _selectedProductParams = null;
      _initError = null;
    });
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
              onLogout: _logout,
            )
          : LoginPage(
              isLoading: _isLoading,
              initError: _initError,
              useSandbox: _useSandbox,
              onUseSandboxChanged: (value) {
                setState(() {
                  _useSandbox = value;
                });
              },
              onSignIn: _signIn,
            ),
    );
  }
}
