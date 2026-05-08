import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFEDE7F6); // soft lavender
  static const periodCycle = Color(0xFFF8BBD0); // pink/rose
  static const mentalWellness = Color(0xFFBBDEFB); // light blue
  static const fitness = Color(0xFFC8E6C9); // light green
  static const pubertyHealth = Color(0xFFFFF9C4); // light yellow
  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.black54;
  static const textOnAccent = Colors.white;
}

class PubertyHealthPage extends StatefulWidget {
  const PubertyHealthPage({super.key});
  @override
  State<PubertyHealthPage> createState() => _PubertyHealthPageState();
}

class _PubertyHealthPageState extends State<PubertyHealthPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: _selectedTab == 0
                    ? _buildBasicsTab()
                    : _selectedTab == 1
                    ? _buildHealthTab()
                    : _buildHelpTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Puberty & Health',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE91E8C),
                ),
              ),
              Text(
                'Your wellness guide',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFBB28F5), Color(0xFF7B1FA2)],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAB BAR ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    final tabs = [
      {'icon': Icons.menu_book_outlined, 'label': 'Basics'},
      {'icon': Icons.favorite_border, 'label': 'Health'},
      {'icon': Icons.lightbulb_outline, 'label': 'Help'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFE91E8C), Color(0xFF9C27B0)],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                ),
                child: Column(
                  children: [
                    Icon(
                      tabs[i]['icon'] as IconData,
                      color: isSelected ? Colors.white : Colors.black87,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BASICS TAB
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildBasicsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        // Hero card
        _heroCard(
          gradient: const LinearGradient(
            colors: [Color(0xFFE91E8C), Color(0xFF7B1FA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.auto_awesome,
          title: 'Understanding Your Cycle',
          subtitle:
              'Your menstrual cycle is a natural monthly process. Let\'s learn the basics!',
        ),
        const SizedBox(height: 16),
        // What is a Period card
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                iconBg: const LinearGradient(
                  colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                ),
                icon: Icons.water_drop_outlined,
                title: 'What is a Period?',
              ),
              const SizedBox(height: 12),
              Text(
                'Your menstrual cycle is when your body prepares for potential pregnancy each month. It typically lasts 21-35 days.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.75),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              _keyFactsBox(
                facts: [
                  'Uterine lining sheds (3-7 days)',
                  'Hormones change throughout the month',
                  'Blood loss: 30-80ml total',
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 4 Cycle Phases
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                iconBg: const LinearGradient(
                  colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                ),
                icon: Icons.calendar_month_outlined,
                title: '4 Cycle Phases',
              ),
              const SizedBox(height: 12),
              _phaseCard(
                color: const Color.fromARGB(255, 255, 225, 236), // pastel pink
                borderColor: const Color(0xFFEF9A9A),
                dotColor: const Color(0xFFE53935),
                title: 'Menstrual (Days 1-5)',
                subtitle: 'Period begins. Energy may be lower.',
              ),
              const SizedBox(height: 8),
              _phaseCard(
                color: const Color.fromARGB(255, 222, 255, 225), // pastel green
                borderColor: const Color(0xFF81C784),
                dotColor: const Color(0xFF43A047),
                title: 'Follicular (Days 6-14)',
                subtitle: 'Energy increases. Great for activity!',
              ),
              const SizedBox(height: 8),
              _phaseCard(
                color: const Color.fromARGB(
                  255,
                  255,
                  252,
                  223,
                ), // pastel yellow
                borderColor: const Color(0xFFFFCC02),
                dotColor: const Color(0xFFFFC107),
                title: 'Ovulation (Day 14)',
                subtitle: 'Most fertile. Feel social & energetic.',
              ),
              const SizedBox(height: 8),
              _phaseCard(
                color: const Color.fromARGB(255, 219, 239, 255), // pastel blue
                borderColor: const Color(0xFF90CAF9),
                dotColor: const Color(0xFF1E88E5),
                title: 'Luteal (Days 15-28)',
                subtitle: 'PMS may appear. Focus on self-care.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Common Symptoms
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                iconBg: const LinearGradient(
                  colors: [Color(0xFFFF5722), Color(0xFFFF1744)],
                ),
                icon: Icons.monitor_heart_outlined,
                title: 'Common Symptoms',
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
                children: const [
                  _SymptomCard(
                    emoji: '😔',
                    title: 'Mood Swings',
                    subtitle: 'Hormonal changes',
                    color: Color(0xFFF8BBD0), // pastel pink
                  ),
                  _SymptomCard(
                    emoji: '🤕',
                    title: 'Cramps',
                    subtitle: 'Muscle contractions',
                    color: Color(0xFFBBDEFB), // pastel blue
                  ),
                  _SymptomCard(
                    emoji: '😴',
                    title: 'Fatigue',
                    subtitle: 'Low iron levels',
                    color: Color(0xFFC8E6C9), // pastel green
                  ),
                  _SymptomCard(
                    emoji: '🌸',
                    title: 'Bloating',
                    subtitle: 'Water retention',
                    color: Color(0xFFFFF9C4), // pastel yellow
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HEALTH TAB
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHealthTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _heroCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF00BCD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.favorite_border,
          title: 'Stay Healthy & Happy',
          subtitle: 'Simple habits to support your body throughout your cycle.',
        ),
        const SizedBox(height: 16),
        // Nutrition Tips
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                iconBg: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                ),
                icon: Icons.eco_outlined,
                title: 'Nutrition Tips',
              ),
              const SizedBox(height: 12),
              _nutritionItem(
                emoji: '🥩',
                title: 'Iron-Rich Foods',
                subtitle:
                    'Spinach, red meat, beans, lentils, fortified cereals',
                color: const Color.fromARGB(255, 251, 207, 223),
              ),
              const SizedBox(height: 8),
              _nutritionItem(
                emoji: '🥜',
                title: 'Healthy Fats',
                subtitle: 'Avocados, nuts, salmon - support hormone balance',
                color: const Color.fromARGB(255, 212, 248, 205),
              ),
              const SizedBox(height: 8),
              _nutritionItem(
                emoji: '🍌',
                title: 'Magnesium Foods',
                subtitle: 'Bananas, dark chocolate - reduce cramps & bloating',
                color: const Color.fromARGB(255, 250, 229, 195),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Lifestyle Habits
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                iconBg: const LinearGradient(
                  colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                ),
                icon: Icons.bolt_outlined,
                title: 'Lifestyle Habits',
              ),
              const SizedBox(height: 12),
              _lifestyleCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF1976D2)],
                ),
                icon: Icons.water_drop_outlined,
                title: 'Stay Hydrated',
                subtitle: '8-10 glasses daily',
              ),
              const SizedBox(height: 8),
              _lifestyleCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFFE91E8C)],
                ),
                icon: Icons.monitor_heart_outlined,
                title: 'Gentle Exercise',
                subtitle: 'Yoga, walking, stretching',
              ),
              const SizedBox(height: 8),
              _lifestyleCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3F51B5), Color(0xFF7B1FA2)],
                ),
                icon: Icons.nightlight_outlined,
                title: 'Quality Sleep',
                subtitle: '8-9 hours nightly',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Managing Cramps
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                iconBg: const LinearGradient(
                  colors: [Color(0xFFFFA000), Color(0xFFFF6F00)],
                ),
                icon: Icons.wb_sunny_outlined,
                title: 'Managing Cramps',
              ),
              const SizedBox(height: 12),
              _crampItem(
                'Apply heat pad to lower abdomen',
                const Color(0xFFFFF3E0), // pastel orange
              ),
              const SizedBox(height: 6),
              _crampItem(
                'Take warm baths to relax muscles',
                const Color(0xFFFCE4EC), // pastel pink
              ),
              const SizedBox(height: 6),
              _crampItem(
                'Gentle massage on lower back',
                const Color(0xFFE8F5E9), // pastel green
              ),
              const SizedBox(height: 6),
              _crampItem(
                'Over-the-counter pain relief (ask parent/guardian)',
                const Color(0xFFE3F2FD), // pastel blue
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Self-Care Reminder
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFFE91E8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: const [
              Text('💜', style: TextStyle(fontSize: 32)),
              SizedBox(height: 8),
              Text(
                'Self-Care Reminder',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Listen to your body. Rest when needed. You\'re doing great!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELP TAB
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHelpTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _heroCard(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6F00), Color(0xFFE53935)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.lightbulb_outline,
          title: 'When to Get Help',
          subtitle: 'Know the signs and when to talk to a healthcare provider.',
        ),
        const SizedBox(height: 16),
        // See a Doctor If
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFFFFDE7),
            border: Border.all(color: const Color(0xFFFFCC02), width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFA000),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'See a Doctor If:',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...[
                'Periods last longer than 7 days',
                'Severe pain interfering with daily activities',
                'Cycles shorter than 21 or longer than 35 days',
                'No period by age 15',
                'Very heavy bleeding (changing pad/tampon every hour)',
                'Sudden changes in your normal cycle pattern',
              ].map((e) => _doctorItem(e)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // What's Normal
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's Normal?",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: 12),
              // Usually Normal
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF43A047),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Usually Normal:',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...[
                      'Irregular cycles in first 2 years',
                      'Mild cramps and discomfort',
                      'Mood changes before period',
                      'Light spotting between periods',
                    ].map((e) => _bulletItem(e, const Color(0xFF2E7D32))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Needs Attention
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Needs Attention:',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC62828),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...[
                      'Debilitating pain (can\'t function)',
                      'Soaking through products hourly',
                      'Passing large blood clots',
                      'Severe mood disturbances',
                    ].map((e) => _bulletItem(e, const Color(0xFFC62828))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Who Can Help
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who Can Help?',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: 12),
              _whoCanHelpCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF00BCD4)],
                ),
                emoji: '👨‍⚕️',
                title: 'Healthcare Provider',
                subtitle: 'Doctor, gynecologist, nurse',
              ),
              const SizedBox(height: 8),
              _whoCanHelpCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B1FA2), Color(0xFFE91E8C)],
                ),
                emoji: '👨‍👩‍👧',
                title: 'Trusted Adult',
                subtitle: 'Parent, guardian, school nurse',
              ),
              const SizedBox(height: 8),
              _whoCanHelpCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF00BCD4)],
                ),
                emoji: '🏫',
                title: 'School Counselor',
                subtitle: 'Guidance counselor, health teacher',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Remember card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFE91E8C), Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: const [
              Text('💕', style: TextStyle(fontSize: 32)),
              SizedBox(height: 8),
              Text(
                'Remember',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Your health matters! Never hesitate to ask questions or seek help.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REUSABLE WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _heroCard({
    required LinearGradient gradient,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required LinearGradient iconBg,
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ],
    );
  }

  Widget _keyFactsBox({required List<String> facts}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star_border, color: Color(0xFFE53935), size: 16),
              SizedBox(width: 6),
              Text(
                'Key Facts:',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...facts.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phaseCard({
    required Color color,
    required Color borderColor,
    required Color dotColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: dotColor),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lifestyleCard({
    required LinearGradient gradient,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _crampItem(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: CircleAvatar(radius: 4, backgroundColor: Color(0xFFE91E8C)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFFFA000),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5D4037),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(radius: 3, backgroundColor: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: color, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whoCanHelpCard({
    required LinearGradient gradient,
    required String emoji,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Symptom Card (const-compatible) ────────────────────────────────────────
class _SymptomCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _SymptomCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black87, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
