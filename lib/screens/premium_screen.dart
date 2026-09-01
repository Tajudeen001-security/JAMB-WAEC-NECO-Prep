import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/premium.dart';
import '../services/premium_service.dart';
import 'activation_screen.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Access')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Choose your access',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            '1) Pay into the account below\n'
            '2) Send payment screenshot to jrilicense@gmail.com\n'
            '3) Include your name, email/phone and selected plan\n'
            '4) We reply with an activation code for this device',
            style: TextStyle(height: 1.45),
          ),
          const SizedBox(height: 18),
          ...premiumOptions.map(
            (option) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                title: Text(option.planName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(option.durationName),
                trailing: Text(
                  '₦${option.price}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment accounts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _BankRow(
                    bank: 'OPay',
                    number: '9160654415',
                    name: 'Gbadamosi Tajudeen Olajide',
                    onCopy: () => _copy(context, '9160654415'),
                  ),
                  const Divider(height: 24),
                  _BankRow(
                    bank: 'Zenith Bank (EasyPay / Easy Zenith)',
                    number: '9160654415',
                    name: 'Gbadamosi Tajudeen Olajide',
                    onCopy: () => _copy(context, '9160654415'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('After payment', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text(
                    'Email screenshot to:\njrilicense@gmail.com\n\n'
                    'Write: your full name, email or phone used in the app, and the plan you paid for '
                    '(e.g. ALL ACCESS – 1 Month).',
                    style: TextStyle(height: 1.45),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _copy(context, PremiumService.supportEmail),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy support email'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivationScreen()),
                );
              },
              icon: const Icon(Icons.vpn_key),
              label: const Text('I already have a code — Activate'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  final String bank;
  final String number;
  final String name;
  final VoidCallback onCopy;

  const _BankRow({
    required this.bank,
    required this.number,
    required this.name,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(bank, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                'Account: $number\nName: $name',
                style: const TextStyle(height: 1.4),
              ),
            ),
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              tooltip: 'Copy account number',
            ),
          ],
        ),
      ],
    );
  }
}
