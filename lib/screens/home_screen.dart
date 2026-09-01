import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'subject_screen.dart';
import 'jamb_mock_setup_screen.dart';
import 'scores_screen.dart';
import 'premium_screen.dart';
import 'activation_screen.dart';
import 'admin_screen.dart';
import '../services/auth_service.dart';

class PremiumAdminEmail { static const value = 'gbadamositajudeenwan@gmail.com'; }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(blurRadius: 16, offset: Offset(0, 6))],
                      ),
                      child: const Center(
                        child: Text('JRI', style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w900,
                          color: AppColors.primary, letterSpacing: -2)),
                      ),
                    ),
                    const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivationScreen())),
                    icon: const Icon(Icons.vpn_key_outlined), label: const Text('Enter Code'),
                  )),
                  const SizedBox(width: 10),
                  FutureBuilder<String?>(
                    future: AuthService().currentIdentifier(),
                    builder: (context, snapshot) => snapshot.data == PremiumAdminEmail.value
                        ? Expanded(child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
                            icon: const Icon(Icons.admin_panel_settings_outlined), label: const Text('Admin'),
                          )) : const SizedBox.shrink(),
                  ),
                ]),
                const SizedBox(height: 14),
                    const Text('JRI PREP', style: TextStyle(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('JAMB • WAEC • NECO', style: TextStyle(
                      color: Colors.white.withOpacity(.9), fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Prepare • Practice • Excel', style: TextStyle(
                      color: Colors.white.withOpacity(.75), fontSize: 12)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(delegate: SliverChildListDelegate([
                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PremiumScreen())),
                    child: const Padding(
                      padding: EdgeInsets.all(18),
                      child: Row(children: [
                        Icon(Icons.workspace_premium, color: Colors.amber, size: 34),
                        SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Premium Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(height: 3),
                          Text('Unlock JAMB, WAEC, NECO and more', style: TextStyle(fontSize: 12)),
                        ])),
                        Icon(Icons.chevron_right),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _QuickActionCard(icon: Icons.history_edu, title: 'My Scores',
                    subtitle: 'View results', color: Colors.indigo,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScoresScreen())))),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickActionCard(icon: Icons.school, title: 'JAMB Mock',
                    subtitle: '4 subjects • /400', color: AppColors.primary,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JambMockSetupScreen())))),
                ]),
                const SizedBox(height: 28),
                const Text('Choose Your Exam', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text('Questions remain available offline when the API is unavailable.', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                ...examTypes.entries.map((e) => _ExamCard(code: e.key, title: e.value, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectScreen(examType: e.key)));
                })),
                const SizedBox(height: 22),
                Card(color: Colors.green.shade50, child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(children: [
                    Icon(Icons.cloud_off, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(child: Text('Offline question bank is used automatically if the online question service fails.', style: TextStyle(fontSize: 13))),
                  ]),
                )),
                const SizedBox(height: 24),
                const Center(child: Text('© 2026 JRI PREP • Built for Nigerian students',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                const SizedBox(height: 12),
              ])),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle;
  final Color color; final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override Widget build(BuildContext context) => Card(child: InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(16),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 28), const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]))));
}

class _ExamCard extends StatelessWidget {
  final String code; final String title; final VoidCallback onTap;
  const _ExamCard({required this.code, required this.title, required this.onTap});
  @override Widget build(BuildContext context) {
    final icons = {'utme': Icons.school, 'wassce': Icons.menu_book, 'neco': Icons.assignment, 'post-utme': Icons.account_balance};
    return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
      onTap: onTap, leading: Icon(icons[code] ?? Icons.quiz, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: const Text('Practice • Timed CBT • Instant scoring'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    ));
  }
}
