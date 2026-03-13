import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.isLoading,
    required this.initError,
    required this.useSandbox,
    required this.onUseSandboxChanged,
    required this.onSignIn,
  });

  final bool isLoading;
  final String? initError;
  final bool useSandbox;
  final ValueChanged<bool> onUseSandboxChanged;
  final Future<void> Function(String username, String password) onSignIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isFormValid {
    return _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  Future<void> _trySignIn() async {
    if (!_isFormValid || widget.isLoading) {
      return;
    }

    await widget.onSignIn(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flix login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock, size: 48),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _trySignIn(),
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: widget.useSandbox,
                onChanged: widget.onUseSandboxChanged,
                title: const Text('Use test environment'),
                contentPadding: EdgeInsets.zero,
              ),
              if (widget.initError != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(widget.initError!),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: (!_isFormValid || widget.isLoading)
                    ? null
                    : _trySignIn,
                child: widget.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
