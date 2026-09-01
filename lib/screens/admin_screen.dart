import 'package:flutter/material.dart';
import '../services/premium_service.dart';

/// Info-only admin notes. Codes are generated offline with tools/generate_activation_codes.py
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JRI PREP Admin')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Administrator guide', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(PremiumService.supportEmail, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'How to issue codes after payment\n\n'
                '1. User pays to OPay/Zenith 9160654415 (Gbadamosi Tajudeen Olajide)\n'
                '2. User emails screenshot to jrilicense@gmail.com with name, phone/email and plan\n'
                '3. You verify the transfer\n'
                '4. Send them ONE unused code from tools/activation_codes_5000.txt\n'
                '5. Code plan is embedded: J=JAMB, W=JAMB+WAEC, A=ALL; 7=week, M=month, Y=year\n\n'
                'Generate more codes anytime:\n'
                'python tools/generate_activation_codes.py --count 5000 --out activation_codes_5000.txt\n\n'
                'Keep the full code list private. Do not commit public dumps of unused codes if the repo is public.',
                style: TextStyle(height: 1.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
