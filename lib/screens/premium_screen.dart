import 'package:flutter/material.dart';
import '../models/premium.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Access')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Choose your access', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Pay, then send your payment screenshot to jrilicense@gmail.com for manual verification.'),
          const SizedBox(height: 18),
          ...premiumOptions.map((option) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.amber),
              title: Text(option.planName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(option.durationName),
              trailing: Text('₦' + option.price.toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          )),
          const SizedBox(height: 10),
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text(
            'Payment options\n\nOPay\nAccount: 9160654415\nName: Gbadamosi Tajudeen Olajide\n\nZenith Bank\nAccount: 9160654415\nName: Gbadamosi Tajudeen Olajide',
            style: TextStyle(height: 1.5),
          ))),
          const SizedBox(height: 12),
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text(
            'After payment, include your account identifier and selected plan in the email. Activation is issued only after payment is verified. Never share your password.',
          ))),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Payment proof'),
                content: const Text('Send your payment screenshot to:\n\njrilicense@gmail.com\n\nInclude your name, email/phone and selected plan.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
              ),
            ),
            icon: const Icon(Icons.email_outlined),
            label: const Text('Show payment-proof instructions'),
          ),
        ],
      ),
    );
  }
}