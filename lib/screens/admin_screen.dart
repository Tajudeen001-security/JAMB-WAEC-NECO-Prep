import 'package:flutter/material.dart';
import '../services/premium_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int count = 0;
  bool busy = false;

  Future<void> generate() async {
    setState(() => busy = true);
    final total = await PremiumService().generateCodes(count: 5000);
    if (!mounted) return;
    setState(() { count = total; busy = false; });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('JRI PREP Admin')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(children: [
        const Text('Administrator', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text(PremiumService.adminEmail),
        const SizedBox(height: 24),
        Card(child: ListTile(
          leading: const Icon(Icons.key),
          title: const Text('Activation inventory'),
          subtitle: Text(count == 0 ? 'Not generated on this installation' : '$count codes available'),
          trailing: ElevatedButton(onPressed: busy ? null : generate, child: Text(busy ? '...' : 'Generate 5,000')),
        )),
        const SizedBox(height: 14),
        const Card(child: Padding(padding: EdgeInsets.all(16),
          child: Text('Production note: payment verification, code inventory and device binding must be moved to a private server before release. This local admin panel is for development/testing and does not securely authenticate an administrator.'))),
      ]),
    ),
  );
}
