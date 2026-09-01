import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _signup = true;
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    setState(() { _busy = true; _error = null; });
    final auth = AuthService();
    final ok = _signup
        ? await auth.signUp(name: _name.text, identifier: _identifier.text, password: _password.text)
        : await auth.login(_identifier.text, _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    } else {
      setState(() => _error = _signup
          ? 'Account already exists, or your details are invalid. Password must be at least 6 characters.'
          : 'Incorrect login details.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_signup ? 'Create Account' : 'Login')),
    body: ListView(padding: const EdgeInsets.all(24), children: [
      Text(_signup ? 'Create your student account' : 'Welcome back',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      if (_signup) TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())),
      if (_signup) const SizedBox(height: 14),
      TextField(controller: _identifier, decoration: const InputDecoration(labelText: 'Email or phone number', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Colors.red))),
      const SizedBox(height: 22),
      SizedBox(height: 52, child: ElevatedButton(
        onPressed: _busy ? null : _submit,
        child: _busy ? const CircularProgressIndicator() : Text(_signup ? 'Create Account' : 'Login'))),
      TextButton(onPressed: _busy ? null : () => setState(() { _signup = !_signup; _error = null; }),
        child: Text(_signup ? 'Already have an account? Login' : 'Create a new account')),
    ]),
  );
}
