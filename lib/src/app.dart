import 'package:flix_inpage/flix_inpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/product_params.dart';
import 'pages/demo_tabs.dart';
import 'pages/login_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _useSandbox = false;
  String? _initError;
  ProductParams? _selectedProductParams;

  @override
  void initState() {
    super.initState();
    _loadInitializedFlag();
  }

  Future<void> _loadInitializedFlag() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isInitialized = prefs.getBool('is_initialized') ?? false;
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
      await FlixBridge.initialize(
        username: username,
        password: password,
        useSandbox: _useSandbox,
      );

      if (!mounted) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_initialized', true);

      setState(() {
        _isInitialized = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _initError = 'Sign in failed. Please check your credentials and try again.';
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_initialized');

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
