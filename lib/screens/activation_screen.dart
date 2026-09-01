import 'package:flutter/material.dart';
import '../models/premium.dart';
import '../services/premium_service.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});
  @override State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final code = TextEditingController();
  PremiumPlan plan = PremiumPlan.jamb;
  PremiumDuration duration = PremiumDuration.month;
  bool busy = false;

  Future<void> activate() async {
    setState(() => busy = true);
    final ok = await PremiumService().activate(code.text, plan, duration);
    if (!mounted) return;
    setState(() => busy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Premium activated on this installation.' : 'Invalid or already-used activation code.'),
    ));
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Activate Premium')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Enter activation code', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('Your activation is tied to this installation and expires automatically.'),
      const SizedBox(height: 18),
      TextField(controller: code, textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(labelText: '16-character code', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      DropdownButtonFormField<PremiumPlan>(
        value: plan, decoration: const InputDecoration(labelText: 'Access', border: OutlineInputBorder()),
        items: PremiumPlan.values.map((p) => DropdownMenuItem(value: p, child: Text(p == PremiumPlan.jamb ? 'JAMB' : p == PremiumPlan.jambWaec ? 'JAMB + WAEC' : 'ALL ACCESS'))).toList(),
        onChanged: (v) => setState(() => plan = v!)),
      const SizedBox(height: 14),
      DropdownButtonFormField<PremiumDuration>(
        value: duration, decoration: const InputDecoration(labelText: 'Duration', border: OutlineInputBorder()),
        items: PremiumDuration.values.map((d) => DropdownMenuItem(value: d, child: Text(d == PremiumDuration.week ? '1 Week' : d == PremiumDuration.month ? '1 Month' : '1 Year'))).toList(),
        onChanged: (v) => setState(() => duration = v!)),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: busy ? null : activate,
        child: busy ? const CircularProgressIndicator() : const Text('Activate')),
    ]),
  );
}
