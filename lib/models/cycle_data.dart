import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Represents a single cycle phase
class CyclePhase {
  final String name;
  final int startDay;
  final int endDay;
  final String emoji;
  final String description;

  const CyclePhase({
    required this.name,
    required this.startDay,
    required this.endDay,
    required this.emoji,
    required this.description,
  });
}

/// Represents user's cycle data and status
class CycleData {
  final DateTime lastPeriodStart;
  final int cycleLength;
  final int periodLength;
  DateTime? nextPeriodStart;
  DateTime? nextOvulation;

  // User symptoms and mood tracking
  final Map<String, List<String>> symptomHistory;
  final Map<DateTime, String> moodHistory;

  CycleData({
    required this.lastPeriodStart,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.nextPeriodStart,
    this.nextOvulation,
    Map<String, List<String>>? symptomHistory,
    Map<DateTime, String>? moodHistory,
  }) : symptomHistory = symptomHistory ?? {},
       moodHistory = moodHistory ?? {} {
    _calculateCycleDates();
  }

  /// Convert DateTime to string key (YYYY-MM-DD)
  String _dateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Calculate next period and ovulation dates
  void _calculateCycleDates() {
    nextPeriodStart = lastPeriodStart.add(Duration(days: cycleLength));
    // Ovulation typically happens around day 14 of cycle
    nextOvulation = lastPeriodStart.add(const Duration(days: 14));
  }

  /// Get current cycle day (1-28)
  int getCurrentCycleDay(DateTime date) {
    final daysDifference = date.difference(lastPeriodStart).inDays;
    return (daysDifference % cycleLength) + 1;
  }

  /// Get days until next period
  int getDaysUntilNextPeriod(DateTime date) {
    if (nextPeriodStart == null) return 0;
    final difference = nextPeriodStart!.difference(date).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Check if given date is a period day
  bool isPeriodDay(DateTime date) {
    final cycleDay = getCurrentCycleDay(date);
    return cycleDay >= 1 && cycleDay <= periodLength;
  }

  /// Check if given date is ovulation day
  bool isOvulationDay(DateTime date) {
    return nextOvulation != null &&
        date.year == nextOvulation!.year &&
        date.month == nextOvulation!.month &&
        date.day == nextOvulation!.day;
  }

  /// Get probability of pregnancy (0-100%)
  int getPregnancyChance(DateTime date) {
    final cycleDay = getCurrentCycleDay(date);

    // High chance: days 10-16 (around ovulation)
    if (cycleDay >= 10 && cycleDay <= 16) return 85;
    // Medium chance: days 8-18
    if (cycleDay >= 8 && cycleDay <= 18) return 50;
    // Low chance: other days
    return 15;
  }

  /// Get current phase
  CyclePhase getCurrentPhase(DateTime date) {
    final cycleDay = getCurrentCycleDay(date);

    if (cycleDay >= 1 && cycleDay <= 5) {
      return const CyclePhase(
        name: 'Menstrual',
        startDay: 1,
        endDay: 5,
        emoji: '🩸',
        description: 'Period begins. Energy may be lower.',
      );
    } else if (cycleDay >= 6 && cycleDay <= 13) {
      return const CyclePhase(
        name: 'Follicular',
        startDay: 6,
        endDay: 13,
        emoji: '🌱',
        description: 'Energy increases. Great for activity!',
      );
    } else if (cycleDay >= 14 && cycleDay <= 14) {
      return const CyclePhase(
        name: 'Ovulation',
        startDay: 14,
        endDay: 14,
        emoji: '✨',
        description: 'Most fertile. Feel social & energetic.',
      );
    } else {
      return const CyclePhase(
        name: 'Luteal',
        startDay: 15,
        endDay: 28,
        emoji: '🌙',
        description: 'PMS may appear. Focus on self-care.',
      );
    }
  }

  /// Add symptom for specific date (avoids duplicates)
  void addSymptom(DateTime date, String symptom) {
    final key = _dateKey(date);

    if (!symptomHistory.containsKey(key)) {
      symptomHistory[key] = [];
    }

    // Avoid adding duplicate symptoms
    if (!symptomHistory[key]!.contains(symptom)) {
      symptomHistory[key]!.add(symptom);

      // Save to Hive if box is initialized
      try {
        if (Hive.isBoxOpen('cycleBox')) {
          Hive.box('cycleBox').put('symptomHistory', symptomHistory);
        }
      } catch (e) {
        print('Hive error saving symptoms: $e');
      }
    }
  }

  /// Remove symptom for specific date
  void removeSymptom(DateTime date, String symptom) {
    final key = _dateKey(date);
    symptomHistory[key]?.remove(symptom);
  }

  /// Get symptoms for specific date
  List<String> getSymptoms(DateTime date) {
    final key = _dateKey(date);
    return symptomHistory[key] ?? [];
  }

  /// Update mood for specific date
  void setMood(DateTime date, String mood) {
    final dateKey = DateTime(date.year, date.month, date.day);
    moodHistory[dateKey] = mood;
  }

  /// Get mood for specific date
  String? getMood(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return moodHistory[dateKey];
  }
}

/// Service class to manage cycle data
class CycleService {
  static final CycleService _instance = CycleService._internal();

  factory CycleService() {
    return _instance;
  }

  CycleService._internal();

  late final Box box;

  // Initialize with default data
  late CycleData _cycleData;

  /// Initialize CycleService with Hive box
  Future<void> init() async {
    if (!Hive.isBoxOpen('cycleBox')) {
      box = await Hive.openBox('cycleBox');
    } else {
      box = Hive.box('cycleBox');
    }

    final lastPeriodStr = box.get(
      'lastPeriodStart',
      defaultValue: DateTime.now()
          .subtract(const Duration(days: 11))
          .toIso8601String(),
    );

    final symptomHistoryMap = box.get('symptomHistory', defaultValue: {});
    final Map<String, List<String>> symptomHistory =
        Map<String, List<String>>.from(symptomHistoryMap as Map);

    _cycleData = CycleData(
      lastPeriodStart: DateTime.parse(lastPeriodStr),
      cycleLength: box.get('cycleLength', defaultValue: 28),
      periodLength: box.get('periodLength', defaultValue: 5),
      symptomHistory: symptomHistory,
    );
  }

  CycleData get cycleData => _cycleData;

  /// Update cycle data
  void updateCycleData(CycleData newData) {
    _cycleData = newData;

    box.put('lastPeriodStart', newData.lastPeriodStart.toIso8601String());
    box.put('cycleLength', newData.cycleLength);
    box.put('periodLength', newData.periodLength);
    box.put('symptomHistory', newData.symptomHistory);
  }

  /// Get current cycle day
  int getCurrentCycleDay() {
    return _cycleData.getCurrentCycleDay(DateTime.now());
  }

  /// Get days until next period
  int getDaysUntilNextPeriod() {
    return _cycleData.getDaysUntilNextPeriod(DateTime.now());
  }

  /// Get current phase
  CyclePhase getCurrentPhase() {
    return _cycleData.getCurrentPhase(DateTime.now());
  }

  /// Get pregnancy chance for today
  int getTodayPregnancyChance() {
    return _cycleData.getPregnancyChance(DateTime.now());
  }
}
