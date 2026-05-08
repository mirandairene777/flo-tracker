import 'package:flutter/material.dart';
import '../models/cycle_data.dart';
import '../services/health_recommendations.dart';

class HealthAdvisorPage extends StatefulWidget {
  final CycleService cycleService;

  const HealthAdvisorPage({required this.cycleService, super.key});

  @override
  State<HealthAdvisorPage> createState() => _HealthAdvisorPageState();
}

class _HealthAdvisorPageState extends State<HealthAdvisorPage> {
  @override
  Widget build(BuildContext context) {
    final cycleData = widget.cycleService.cycleData;
    final today = DateTime.now();
    final cycleDay = cycleData.getCurrentCycleDay(today);
    final phase = cycleData.getCurrentPhase(today);
    final todaySymptoms = cycleData.getSymptoms(today);
    final lifestyleRecommendations =
        HealthRecommendationEngine.getLifestyleRecommendations(cycleDay);

    final recommendation = HealthRecommendationEngine.getCombinedRecommendation(
      todaySymptoms,
      cycleDay,
      phase.name,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0008),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Health Advisor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Text(
                'Personalized recommendations based on your cycle',
                style: TextStyle(color: Color(0xFFC8A0B8), fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Cycle Phase Card
              _buildPhaseCard(phase, cycleDay),

              const SizedBox(height: 16),

              // Current Symptoms Section
              if (todaySymptoms.isNotEmpty) ...[
                const Text(
                  'Your Symptoms Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: todaySymptoms.map((symptom) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0427A).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0427A)),
                      ),
                      child: Text(
                        symptom,
                        style: const TextStyle(
                          color: Color(0xFFF8BBD0),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Main Recommendation Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E0018),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE0427A).withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE0427A).withValues(alpha: 0.1),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE0427A), Color(0xFFF472A8)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.lightbulb,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Recommendation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      recommendation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Lifestyle Recommendations
              const Text(
                'Lifestyle Tips This Week',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: lifestyleRecommendations.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0427A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(
                              color: Color(0xFFC8A0B8),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Disclaimer Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF280020),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFFC8A0B8),
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This is general wellness information. If symptoms are severe or persist, please consult a healthcare provider.',
                        style: TextStyle(
                          color: Color(0xFFC8A0B8),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseCard(CyclePhase phase, int cycleDay) {
    final phaseColors = {
      'Menstrual': (Color(0xFFFCE4EC), Color(0xFFF8BBD0)),
      'Follicular': (Color(0xFFE8F5E9), Color(0xFFC8E6C9)),
      'Ovulation': (Color(0xFFFFFDE7), Color(0xFFFFF9C4)),
      'Luteal': (Color(0xFFE3F2FD), Color(0xFFBBDEFB)),
    };

    final (bgColor, accentColor) =
        phaseColors[phase.name] ??
        (const Color(0xFFFCE4EC), const Color(0xFFF8BBD0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase.name,
                    style: const TextStyle(
                      color: Color(0xFF1a1a1a),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Day $cycleDay of your cycle',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(phase.emoji, style: const TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            phase.description,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.8),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
