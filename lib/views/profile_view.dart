import 'package:flutter/material.dart';
import '../core/constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
              decoration: const BoxDecoration(
                color: AppColors.spcbaGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.amber,
                    child: CircleAvatar(
                      radius: 33,
                      backgroundColor: AppColors.spcbaGreen,
                      child: Text('JD', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Juan Dela Cruz', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('BSIT - 3rd Year • Section 501', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),

                  // Rank Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield, color: Colors.amber, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Academic Warrior • Level 4',
                          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // XP Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('XP Progress to Level 5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('1,240 / 2,000 XP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 1240 / 2000,
                      color: AppColors.spcbaGreen,
                      backgroundColor: Color(0xFFE0E0E0),
                      minHeight: 10,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('760 XP to Honor Scholar', style: TextStyle(fontSize: 10, color: AppColors.spcbaGreen)),
                  ),
                  const SizedBox(height: 16),

                  // Metric Cards (Total XP, Streak, Mastered)
                  Row(
                    children: [
                      _buildMetricBox('Total XP', '1,240', null),
                      const SizedBox(width: 8),
                      _buildMetricBox('Streak', '5', '🔥'),
                      const SizedBox(width: 8),
                      _buildMetricBox('Mastered', '3', '⭐'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Rank Levels List
                  const Text('Rank levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 10),

                  _buildRankItem('Lv1 — Freshman Reviewer', false, false),
                  _buildRankItem('Lv2 — Dedicated Student', false, false),
                  _buildRankItem('Lv3 — Quiz Enthusiast', false, false),
                  _buildRankItem('Lv4 — Academic Warrior ← You', true, true),
                  _buildRankItem('Lv5 — Honor Scholar', false, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String title, String val, String? icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.spcbaGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (icon != null) ...[
                  const SizedBox(width: 4),
                  Text(icon, style: const TextStyle(fontSize: 14)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem(String title, bool isCurrent, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.spcbaGreen.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.check_circle : Icons.circle_outlined,
            color: isCurrent ? AppColors.spcbaGreen : Colors.grey.shade400,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? AppColors.spcbaGreen : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}