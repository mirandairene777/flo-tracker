import 'package:flutter/material.dart';
import 'health/puberty_page.dart';
import 'models/cycle_data.dart';
import 'screens/health_advisor_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('cycleBox');

  runApp(const CycleTrackerApp());
}

class CycleTrackerApp extends StatelessWidget {
  const CycleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cycle Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xFF0D0008),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE0427A),
          surface: const Color(0xFF1E0018),
        ),
      ),
      home: const _PhoneFrameWrapper(child: SplashScreen()),
    );
  }
}

// ─────────────────────────────────────────
// PHONE FRAME WRAPPER
// ─────────────────────────────────────────
class _PhoneFrameWrapper extends StatelessWidget {
  final Widget child;

  const _PhoneFrameWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Center(
        child: Container(
          width: 390,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SPLASH SCREEN
// ─────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(
      begin: 0,
      end: -16,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const _PhoneFrameWrapper(child: MainScreen()),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7A8C8), Color(0xFFE86FA0), Color(0xFFC94080)],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Dots top-left
                Positioned(
                  top: 20,
                  left: 24,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Logo top-right
                Positioned(
                  top: 12,
                  right: 24,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB40050).withValues(alpha: 0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🌸', style: TextStyle(fontSize: 26)),
                    ),
                  ),
                ),

                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "Let's Track Your\nCycle Together",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                          shadows: [
                            Shadow(color: Color(0x4D780032), blurRadius: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: child,
                          );
                        },
                        child: Center(
                          child: Image.asset(
                            'assets/images/girl.png',
                            height: 530,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Tap to continue
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.6, end: 1.0),
                      duration: const Duration(seconds: 2),
                      builder: (context, val, child) =>
                          Opacity(opacity: val, child: child),
                      child: const Text(
                        'TAP TO CONTINUE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// MAIN SCREEN (with bottom nav)
// ─────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final CycleService _cycleService = CycleService();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeCycleService();
    _screens = [
      const HomeScreen(),
      const CalendarScreen(),
      const SizedBox(), // placeholder for center +
      const PubertyHealthPage(), // wellness
      HealthAdvisorPage(cycleService: _cycleService), // health advisor
    ];
  }

  Future<void> _initializeCycleService() async {
    await _cycleService.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0008),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF140010).withValues(alpha: 0.98),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 0),
              _navItem(Icons.calendar_month_rounded, 1),
              // Center FAB
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE0427A), Color(0xFFF472A8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE0427A).withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
              _navItem(Icons.favorite_border_rounded, 3),
              _navItem(Icons.lightbulb_outline, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive
              ? const Color(0xFFE0427A).withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFE0427A) : const Color(0xFFC8A0B8),
          size: 24,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CycleService _cycleService = CycleService();

  @override
  void initState() {
    super.initState();
    _cycleService = CycleService();
  }

  void _showSettingsDialog() {
    final cycleData = _cycleService.cycleData;
    int cycleLength = cycleData.cycleLength;
    int periodLength = cycleData.periodLength;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E0018),
          title: const Text(
            'Cycle Settings',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingSlider(
                'Cycle Length: $cycleLength days',
                cycleLength.toDouble(),
                20,
                40,
                (val) => setState(() => cycleLength = val.toInt()),
              ),
              const SizedBox(height: 20),
              _buildSettingSlider(
                'Period Length: $periodLength days',
                periodLength.toDouble(),
                2,
                10,
                (val) => setState(() => periodLength = val.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _cycleService.updateCycleData(
                  CycleData(
                    lastPeriodStart: cycleData.lastPeriodStart,
                    cycleLength: cycleLength,
                    periodLength: periodLength,
                  ),
                );
                setState(() {});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0427A),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFE0427A),
            thumbColor: const Color(0xFFE0427A),
            overlayColor: const Color(0xFFE0427A).withValues(alpha: 0.3),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.toInt().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E0018),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Enable notifications for period and ovulation reminders',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showEditPeriodDialog() {
    final cycleData = _cycleService.cycleData;
    int selectedDay = cycleData.lastPeriodStart.day;
    int selectedMonth = cycleData.lastPeriodStart.month;
    int selectedYear = cycleData.lastPeriodStart.year;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E0018),
        title: const Text(
          'Edit Last Period Start',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDatePicker(
                  'Month',
                  selectedMonth,
                  1,
                  12,
                  (val) => selectedMonth = val,
                ),
                _buildDatePicker(
                  'Day',
                  selectedDay,
                  1,
                  31,
                  (val) => selectedDay = val,
                ),
                _buildDatePicker(
                  'Year',
                  selectedYear,
                  2020,
                  2030,
                  (val) => selectedYear = val,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newDate = DateTime(
                selectedYear,
                selectedMonth,
                selectedDay,
              );
              _cycleService.updateCycleData(
                CycleData(
                  lastPeriodStart: newDate,
                  cycleLength: cycleData.cycleLength,
                  periodLength: cycleData.periodLength,
                ),
              );
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0427A),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    int value,
    int min,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: TextField(
            onChanged: (val) {
              if (val.isNotEmpty) {
                int? newVal = int.tryParse(val);
                if (newVal != null && newVal >= min && newVal <= max) {
                  onChanged(newVal);
                }
              }
            },
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '$value',
              hintStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSymptomDialog() {
    final symptoms = [
      'Cramps',
      'Headache',
      'Mood Swings',
      'Fatigue',
      'Bloating',
      'Acne',
      'Back Pain',
      'Nausea',
    ];
    final selectedSymptoms = <String>[];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E0018),
          title: const Text(
            'Add Today\'s Symptoms',
            style: TextStyle(color: Colors.white),
          ),
          content: Wrap(
            spacing: 8,
            children: symptoms.map((symptom) {
              final isSelected = selectedSymptoms.contains(symptom);
              return FilterChip(
                label: Text(symptom),
                selected: isSelected,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                backgroundColor: Colors.transparent,
                selectedColor: const Color(0xFFE0427A),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFE0427A)
                      : Colors.white.withValues(alpha: 0.3),
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedSymptoms.add(symptom);
                    } else {
                      selectedSymptoms.remove(symptom);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                for (var symptom in selectedSymptoms) {
                  _cycleService.cycleData.addSymptom(DateTime.now(), symptom);
                }
                setState(() {});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0427A),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycleData = _cycleService.cycleData;
    final today = DateTime.now();
    final daysUntilNextPeriod = cycleData.getDaysUntilNextPeriod(today);
    final daysUntilOvulation =
        cycleData.nextOvulation?.difference(today).inDays ?? 0;
    final pregnancyChance = cycleData.getPregnancyChance(today);
    final todaySymptoms = cycleData.getSymptoms(today);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconBtn(
                    Icons.settings_outlined,
                    onPressed: _showSettingsDialog,
                  ),
                  Text(
                    _formatDate(today),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  _iconBtn(
                    Icons.notifications_none_rounded,
                    onPressed: _showNotificationsDialog,
                  ),
                ],
              ),
            ),

            // Period Banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: const Color(0xFF280020),
              child: Text(
                daysUntilNextPeriod == 0
                    ? 'Period starts today!'
                    : 'Next period: $daysUntilNextPeriod days left',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFC8A0B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Ovulation info
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
              child: Column(
                children: [
                  const Text(
                    'NEXT OVULATION',
                    style: TextStyle(
                      color: Color(0xFFC8A0B8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF8CC8), Color(0xFFE0427A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      '$daysUntilOvulation Days Left',
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showEditPeriodDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0427A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: const Color(
                        0xFFE0427A,
                      ).withValues(alpha: 0.5),
                    ),
                    child: const Text(
                      'Edit Period',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Feeling card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E0018),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How are you feeling today?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'TELL US MORE ABOUT YOUR\nBODY TO GET ANALYSIS',
                          style: TextStyle(
                            color: Color(0xFFC8A0B8),
                            fontSize: 11,
                            letterSpacing: 0.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: _showAddSymptomDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0427A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 9,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Add Symptom',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        center: Alignment(-0.3, -0.3),
                        colors: [Color(0xFFC94080), Color(0xFF5A0030)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC80064).withValues(alpha: 0.4),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🌙', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Today's Symptoms
            if (todaySymptoms.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E0018),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE0427A).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Symptoms",
                        style: TextStyle(
                          color: Color(0xFFE0427A),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: todaySymptoms.map((symptom) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE0427A,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              symptom,
                              style: const TextStyle(
                                color: Color(0xFFC8A0B8),
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Info cards
            SizedBox(
              height: 155,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _infoCardCycleDay(_cycleService.getCurrentCycleDay()),
                  const SizedBox(width: 12),
                  _infoCardText(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD86B), Color(0xFFFF9F4A)],
                    ),
                    label: 'Weights Ups and Downs? Here\'s Why',
                    icon: '⚖️',
                  ),
                  const SizedBox(width: 12),
                  _infoCardText(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4F5C0), Color(0xFF6DB88A)],
                    ),
                    label: 'Heavy Period? Quick Ways To Ease',
                    icon: '🍵',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _iconBtn(IconData icon, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF1E0018),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }

  Widget _infoCardCycleDay(int cycleDay) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9EC4), Color(0xFFE84D8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CYCLE\nDAY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xB3000000),
              letterSpacing: 0.5,
              height: 1.3,
            ),
          ),
          const Spacer(),
          Text(
            '$cycleDay',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0x99000000),
              fontStyle: FontStyle.italic,
            ),
          ),
          const Text('🔄', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _infoCardText({
    required LinearGradient gradient,
    required String label,
    required String icon,
  }) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xB3000000),
              height: 1.4,
            ),
          ),
          const Spacer(),
          Text(icon, style: const TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// CALENDAR SCREEN
// ─────────────────────────────────────────
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedDay = 13;

  final List<int> periodDays = [5, 6, 7, 8];
  final int today = 13;
  final List<int> ovulationDays = [19];

  String get _chanceText {
    final cycleDay = _selectedDay - 2;
    if (cycleDay >= 10 && cycleDay <= 16) return 'High';
    if (cycleDay >= 8 && cycleDay <= 18) return 'Medium';
    return 'Low';
  }

  int get _cycleDay => (_selectedDay - 2).clamp(1, 28);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconBtn(Icons.settings_outlined),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF280020),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _toggleBtn('April', true),
                        _toggleBtn('Year', false),
                      ],
                    ),
                  ),
                  _iconBtn(Icons.menu_rounded),
                ],
              ),
            ),

            // Weekday headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                    .map(
                      (d) => SizedBox(
                        width: 44,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFC8A0B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Calendar grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCalendarGrid(),
            ),

            const SizedBox(height: 16),

            // Info bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E0018),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'April $_selectedDay',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Cycle day $_cycleDay',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_chanceText · chance of getting pregnant',
                    style: const TextStyle(
                      color: Color(0xFFC8A0B8),
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE0427A),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Edit Period',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF280020),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Add Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // April 2026 starts on Wednesday (index 3)
    const startDay = 3;
    const totalDays = 30;

    final cells = <Widget>[];

    // Empty cells before start
    for (int i = 0; i < startDay; i++) {
      cells.add(const SizedBox());
    }

    for (int d = 1; d <= totalDays; d++) {
      final isPeriod = periodDays.contains(d);
      final isToday = d == today;
      final isSelected = d == _selectedDay && !isPeriod && !isToday;
      final isOvulation = ovulationDays.contains(d);

      cells.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDay = d),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isPeriod
                      ? const Color(0xFFE0427A)
                      : isToday
                      ? const Color(0xFF280020)
                      : isSelected
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isToday
                      ? Border.all(color: const Color(0xFFE0427A), width: 2)
                      : null,
                  boxShadow: isPeriod
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFE0427A,
                            ).withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$d',
                    style: TextStyle(
                      color: isPeriod
                          ? Colors.white
                          : isToday
                          ? const Color(0xFFF472A8)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: isPeriod || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if (isOvulation)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF472A8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      children: cells,
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF1E0018),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _toggleBtn(String label, bool isActive) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE0427A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFFC8A0B8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
