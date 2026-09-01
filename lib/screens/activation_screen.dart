import 'package:flutter/material.dart';
import '../services/premium_service.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final code = TextEditingController();
  bool busy = false;
  String? message;
  bool success = false;

  Future<void> activate() async {
    setState(() {
      busy = true;
      message = null;
    });
    final ok = await PremiumService().activate(code.text);
    if (!mounted) return;
    setState(() {
      busy = false;
      success = ok;
      message = ok
          ? 'Premium activated on this device. Access expires automatically at the end of your plan.'
          : 'Invalid, already used, or wrong code. Codes are device-bound after first use.';
    });
    if (ok) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activate Premium')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Enter activation code',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'After you pay and send your screenshot to jrilicense@gmail.com, '
            'we will send you a code. Paste it here. It works only on this device.',
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: code,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Code (XXXX-XXXX-XXXX-XXXX-XXXX)',
              border: OutlineInputBorder(),
              helperText: '20 characters (dashes optional)',
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(
                color: success ? Colors.green.shade800 : Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: busy ? null : activate,
              child: busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Activate on this device'),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Tips\n'
                '• One code = one device\n'
                '• Plan (JAMB / JAMB+WAEC / ALL) and duration are built into the code\n'
                '• Do not share your code after activation',
                style: TextStyle(height: 1.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
