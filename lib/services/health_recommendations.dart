/// Health Recommendation Engine
/// Rule-based system for symptom recommendations
/// No API calls - works offline

class SymptomRecommendation {
  final String symptom;
  final String recommendation;
  final String severity; // mild, moderate, severe
  final bool needsDoctor;

  const SymptomRecommendation({
    required this.symptom,
    required this.recommendation,
    this.severity = 'moderate',
    this.needsDoctor = false,
  });
}

class HealthRecommendationEngine {
  /// Single symptom recommendations
  static const Map<String, String> symptomRecommendations = {
    'Cramps': 'Heat therapy, light stretching, magnesium supplements. '
        'Use a heating pad for 15-20 mins. Stay hydrated. '
        'Ibuprofen can help. If severe, see a doctor.',
    'Headache': 'Stay hydrated (drink 8 glasses water daily), take ibuprofen, '
        'rest in dark room, avoid screens. Caffeine might help or worsen it. '
        'If persistent > 3 days, consult doctor.',
    'Mood Swings': 'Practice deep breathing, reduce caffeine & sugar, exercise 20 mins, '
        'get adequate sleep. Journal your feelings. It\'s hormonal - totally normal. '
        'Talk to someone you trust.',
    'Fatigue': 'Rest 7-8 hours, eat iron-rich foods (red meat, spinach, beans), '
        'avoid heavy workouts, stay hydrated. Light walks ok. '
        'If persists > 1 week, check iron levels with doctor.',
    'Bloating': 'Reduce salt & sugar, eat magnesium-rich foods (bananas, almonds), '
        'light exercise/yoga, stay hydrated. Avoid carbonated drinks. '
        'Bloating usually subsides in 2-3 days.',
    'Acne': 'Wash face gently 2x daily, use oil-free products, avoid touching face, '
        'hormonal acne is normal mid-cycle. Avoid heavy makeup. '
        'Dermatologist if severe.',
    'Back Pain': 'Strengthen core with gentle exercises, use heating pad, '
        'maintain good posture, avoid heavy lifting. Try yoga poses. '
        'See doctor if pain is severe or worsens.',
    'Nausea': 'Eat small frequent meals, ginger tea helps, fresh air, '
        'avoid heavy/greasy foods. Stay hydrated. Usually passes in 1-2 days. '
        'See doctor if vomiting occurs.',
    'Anxiety': 'Practice mindfulness meditation, deep breathing exercises, '
        'reduce caffeine, exercise helps. Talk to someone. Anxiety peaks around ovulation. '
        'Seek professional help if overwhelming.',
    'Insomnia': 'Sleep 7-9 hours, no screens 1 hour before bed, warm bath/shower, '
        'avoid caffeine after 2pm. Magnesium supplement helps. '
        'Sleep issues are hormonal - track patterns.',
  };

  /// Get recommendation for single symptom
  static String getRecommendation(String symptom) {
    return symptomRecommendations[symptom] ??
        'Monitor this symptom. If it worsens or persists > 3 days, consult a healthcare provider.';
  }

  /// Get combined recommendation for multiple symptoms
  static String getCombinedRecommendation(
    List<String> symptoms,
    int cycleDay,
    String currentPhase,
  ) {
    if (symptoms.isEmpty) {
      return 'No symptoms logged. You\'re doing great! 💚';
    }

    if (symptoms.length == 1) {
      return getRecommendation(symptoms.first);
    }

    // Multiple symptoms - generate combined advice
    final recommendations = symptoms
        .map((s) => '• ${_getShortRecommendation(s)}')
        .join('\n\n');

    final phaseAdvice = _getPhaseSpecificAdvice(cycleDay, currentPhase);

    final warningSign = _checkWarningSignsCombined(symptoms);

    return '''
$recommendations

$phaseAdvice

$warningSign
''';
  }

  /// Short version of recommendation for combined view
  static String _getShortRecommendation(String symptom) {
    switch (symptom) {
      case 'Cramps':
        return 'Cramps: Use heat pad, stretch, take magnesium';
      case 'Headache':
        return 'Headache: Stay hydrated, rest, use ibuprofen';
      case 'Mood Swings':
        return 'Mood Swings: Deep breathing, exercise, reduce caffeine';
      case 'Fatigue':
        return 'Fatigue: Rest well, eat iron-rich foods';
      case 'Bloating':
        return 'Bloating: Reduce salt, light exercise, stay hydrated';
      case 'Acne':
        return 'Acne: Keep face clean, use oil-free products';
      case 'Back Pain':
        return 'Back Pain: Core exercises, heating pad, good posture';
      case 'Nausea':
        return 'Nausea: Eat small meals, ginger tea, fresh air';
      case 'Anxiety':
        return 'Anxiety: Meditation, deep breathing, reduce caffeine';
      case 'Insomnia':
        return 'Insomnia: No screens before bed, magnesium supplement';
      default:
        return symptom;
    }
  }

  /// Phase-specific contextual advice
  static String _getPhaseSpecificAdvice(int cycleDay, String phase) {
    if (cycleDay >= 1 && cycleDay <= 5) {
      return '🩸 **Menstrual Phase (Days 1-5):**\n'
          'Your body is shedding the uterine lining. Rest is important. '
          'Eat iron-rich foods to replenish blood. Light activities ok.';
    } else if (cycleDay >= 6 && cycleDay <= 13) {
      return '🌱 **Follicular Phase (Days 6-13):**\n'
          'Energy is rising! This is a great time for workouts & activities. '
          'Eat colorful veggies. Symptoms should improve this week.';
    } else if (cycleDay == 14) {
      return '✨ **Ovulation Day (Day 14):**\n'
          'Peak fertility day. Energy & mood are usually high. '
          'Some get ovulation pain - that\'s normal. Stay active!';
    } else {
      return '🌙 **Luteal Phase (Days 15-28):**\n'
          'Progesterone rises. You might feel more introspective. '
          'Self-care is important. PMS symptoms peak around day 21-28.';
    }
  }

  /// Check for warning signs that need doctor visit
  static String _checkWarningSignsCombined(List<String> symptoms) {
    final severeSymptoms = ['Nausea', 'Back Pain'];
    final hasSevere = symptoms.any((s) => severeSymptoms.contains(s));

    if (symptoms.length >= 3 && hasSevere) {
      return '⚠️ **Consult a doctor** if symptoms are severe or persist > 3 days.';
    }

    if (symptoms.contains('Nausea') && symptoms.contains('Fatigue')) {
      return '⚠️ Consider seeing a doctor if vomiting occurs or fatigue is extreme.';
    }

    return '💡 If symptoms worsen or don\'t improve in 3 days, consult healthcare provider.';
  }

  /// Get lifestyle recommendations based on cycle phase
  static List<String> getLifestyleRecommendations(int cycleDay) {
    if (cycleDay >= 1 && cycleDay <= 5) {
      return [
        'Rest: Aim for 8-9 hours sleep',
        'Nutrition: Eat iron, red meat, spinach, lentils',
        'Exercise: Light walks or yoga only',
        'Hydration: Drink extra water',
      ];
    } else if (cycleDay >= 6 && cycleDay <= 13) {
      return [
        'Exercise: High-intensity workouts are great now',
        'Nutrition: High protein, whole grains',
        'Social: Great time for social activities',
        'Productivity: Peak energy - tackle important projects',
      ];
    } else if (cycleDay == 14) {
      return [
        'Exercise: Peak performance - push yourself',
        'Nutrition: Maintain balanced diet',
        'Confidence: You\'re most confident - take advantage',
        'Health: Best time for health screenings',
      ];
    } else {
      return [
        'Rest: Prioritize sleep (8-9 hours)',
        'Nutrition: Magnesium, complex carbs, healthy fats',
        'Exercise: Moderate cardio, strength training',
        'Self-care: Meditation, yoga, bubble bath',
        'Work: Focus on detail-oriented tasks',
      ];
    }
  }

  /// Emergency warning signs
  static bool hasEmergencyWarningSign(List<String> symptoms) {
    final emergencySymptoms = {
      'Severe back pain',
      'Severe nausea with vomiting',
      'Chest pain',
      'Fainting',
    };

    return symptoms.any((s) => emergencySymptoms.contains(s));
  }
}
