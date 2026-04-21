import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gamified_habit_tracker/widgets/bottom_nav_bar.dart';
import 'package:gamified_habit_tracker/widgets/purple_background.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String _selectedPeriod = 'Week';
  DateTime _displayedMonth = DateTime.now();
  List<QueryDocumentSnapshot>? _cachedHabits;
  Map<int, Color>? _preloadedColors;

  @override
  void initState() {
    super.initState();
    // Preload calendar colors on init
    _preloadCalendarColors(_displayedMonth);
  }

  void _preloadCalendarColors(DateTime month) async {
    final colors = await _getCalendarColors(month);
    if (mounted) {
      setState(() {
        _preloadedColors = colors;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: const Center(child: Text('Not logged in')),
        bottomNavigationBar: BottomNavBar(currentRoute: '/analytics'),
      );
    }

    return Scaffold(
      body: PurpleBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Progress\nAnalytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      final userData = userSnapshot.data?.data() as Map<String, dynamic>?;

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Period Selector
                            _buildPeriodSelector(),
                            const SizedBox(height: 24),

                            // Stats Cards
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFCBF49), Color(0xFFEAA94D)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.flash_on, color: Colors.white, size: 28),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '${userData?['totalXP'] ?? 0}',
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Text(
                                          'Total XP',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.trending_up, color: Colors.white, size: 28),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Level ${userData?['level'] ?? 1}',
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Text(
                                          'Current Level',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Completion Rate Section
                            const Text(
                              'Completion Rate',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 160,
                              child: _buildCompletionRateChart(),
                            ),

                            const SizedBox(height: 20),

                            // XP Progress Section
                            const Text(
                              'XP Progress',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 155,
                              child: _buildXPProgressChart(),
                            ),

                            const SizedBox(height: 20),

                            // Habit Calendar Section
                            const Text(
                              'Habit Calendar',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildCalendar(),

                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentRoute: '/analytics'),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ['Week', 'Month', 'Year'].map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompletionRateChart() {
    return FutureBuilder<Map<String, double>>(
      future: _getCompletionRateData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No data yet',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final entries = data.entries.toList();
        final barGroups = <BarChartGroupData>[];

        for (int i = 0; i < entries.length; i++) {
          final percentage = entries[i].value;
          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: percentage,
                  color: percentage >= 75
                      ? Colors.green
                      : percentage >= 50
                          ? Colors.orange
                          : Colors.red,
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 0.8,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= entries.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          entries[index].key,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 8,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 8,
                        ),
                      );
                    },
                    interval: 25,
                  ),
                ),
              ),
              maxY: 100,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.black87,
                  tooltipMargin: 4,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toStringAsFixed(0)}%',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildXPProgressChart() {
    return FutureBuilder<List<FlSpot>>(
      future: _getXPProgressData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No XP data yet',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ),
          );
        }
        final spots = snapshot.data!;
        return Container(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 2, left: 4),
                child: Text(
                  'Experience Points',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              SizedBox(
                height: 85,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.15),
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 15,
                          interval: spots.length > 7 ? (spots.length / 4).toDouble() : 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= spots.length) return const SizedBox.shrink();
                            return Text('D${index + 1}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 7,),);
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 7,),);
                          },
                          interval: (spots.isNotEmpty ? spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) / 3 : 100).toDouble(),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200, width: 0.5,),),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: const Color(0xFF7C3AED),
                        barWidth: 1,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 2.5, color: const Color(0xFF7C3AED), strokeColor: Colors.white, strokeWidth: 0.8,),),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    lineTouchData: LineTouchData(enabled: true, touchTooltipData: LineTouchTooltipData(getTooltipColor: (_) => Colors.black87, tooltipMargin: 2, getTooltipItems: (touchedSpots) => touchedSpots.map((spot) => LineTooltipItem('XP: ${spot.y.toInt()}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8,),),).toList(),),),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 2, left: 4),
                child: Text('Completion Timeline', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF64748B),),),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Month header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF64748B)),
                onPressed: () {
                  setState(() {
                    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
                    _preloadedColors = null;
                  });
                  _preloadCalendarColors(_displayedMonth);
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(_displayedMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
                onPressed: () {
                  setState(() {
                    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
                    _preloadedColors = null;
                  });
                  _preloadCalendarColors(_displayedMonth);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                 ),
               ),
             );
          }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar days
          if (_preloadedColors != null)
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: _buildCalendarGrid(_preloadedColors!),
            )
          else
            const SizedBox(
              height: 280,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(child: _buildLegendItem('🟢 All Done', Colors.green)),
              Flexible(child: _buildLegendItem('🟠 Partial', Colors.orange)),
              Flexible(child: _buildLegendItem('🔴 Missed', Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildLegendItem(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

  List<Widget> _buildCalendarGrid(Map<int, Color> colorMap) {
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final startingDayOfWeek = firstDay.weekday % 7;

    final calendarDays = <int?>[];
    for (int i = 0; i < startingDayOfWeek; i++) {
      calendarDays.add(null);
    }
    for (int i = 1; i <= daysInMonth; i++) {
      calendarDays.add(i);
    }

    return calendarDays.map((day) {
      if (day == null) {
        return Container();
      }

      final color = colorMap[day] ?? const Color(0xFFF1F5F9);

      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color == const Color(0xFFF1F5F9)
                  ? const Color(0xFF94A3B8)
                  : Colors.white,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<Map<int, Color>> _getCalendarColors(DateTime month) async {
    try {
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final colorMap = <int, Color>{};
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      List<QueryDocumentSnapshot> habits;
      
      if (_cachedHabits != null) {
        habits = _cachedHabits!;
      } else {
        final habitsSnapshot = await FirebaseFirestore.instance
            .collection('habits')
            .where('userId', isEqualTo: user!.uid)
            .where('isActive', isEqualTo: true)
            .get();
        
        habits = habitsSnapshot.docs;
        _cachedHabits = habits;
      }

      if (habits.isEmpty) {
        return colorMap;
      }

      final monthStart = DateTime(month.year, month.month, 1);
      final monthEnd = DateTime(month.year, month.month + 1, 0);
      
      final completionsDocs = await FirebaseFirestore.instance
          .collection('completions')
          .where('userId', isEqualTo: user!.uid)
          .where('date', isGreaterThanOrEqualTo: '${monthStart.year}-${monthStart.month.toString().padLeft(2, '0')}-01')
          .where('date', isLessThanOrEqualTo: '${monthEnd.year}-${monthEnd.month.toString().padLeft(2, '0')}-${monthEnd.day.toString().padLeft(2, '0')}')
          .get();

      final completionsByDate = <String, int>{};
      for (var doc in completionsDocs.docs) {
        final date = doc.data()['date'] as String?;
        if (date != null) {
          completionsByDate[date] = (completionsByDate[date] ?? 0) + 1;
        }
      }

      for (int day = 1; day <= daysInMonth; day++) {
        final dateKey = '${month.year}-${month.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        final completedCount = completionsByDate[dateKey] ?? 0;
        final dayDate = DateTime(month.year, month.month, day);
        final isFuture = dayDate.isAfter(today);
        final isPast = dayDate.isBefore(today);

        if (isFuture) {
          colorMap[day] = const Color(0xFFF1F5F9);
        } else if (completedCount >= habits.length) {
          colorMap[day] = Colors.green;
        } else if (completedCount > 0) {
          colorMap[day] = Colors.orange;
        } else if (isPast) {
          colorMap[day] = Colors.red;
        } else {
          colorMap[day] = const Color(0xFFF1F5F9);
        }
      }

      return colorMap;
    } catch (e) {
      print('Error getting calendar colors: $e');
      return {};
    }
  }

Future<Map<String, double>> _getCompletionRateData() async {
  try {
    final now = DateTime.now();
    final completionData = <String, double>{};

    final habits = await FirebaseFirestore.instance
        .collection('habits')
        .where('userId', isEqualTo: user!.uid)
        .where('isActive', isEqualTo: true)
        .get();

    if (habits.docs.isEmpty) return completionData;

    final completions = await FirebaseFirestore.instance
        .collection('completions')
        .where('userId', isEqualTo: user!.uid)
        .get();

    final completionsByDate = <String, int>{};
    for (var doc in completions.docs) {
      final date = doc.data()['date'] as String?;
      if (date != null) {
        completionsByDate[date] = (completionsByDate[date] ?? 0) + 1;
      }
    }

    if (_selectedPeriod == 'Week') {
      // Show last 7 days with day labels
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final completedCount = completionsByDate[dateKey] ?? 0;
        final cappedCount = completedCount.clamp(0, habits.docs.length);
        final percentage = (cappedCount / habits.docs.length) * 100;
        final label = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][date.weekday % 7];
        completionData[label] = percentage;
      }

    } else if (_selectedPeriod == 'Month') {
      // Week 1, Week 2, Week 3, Week 4
      for (int week = 0; week < 4; week++) {
        double totalPercentage = 0;
        int dayCount = 0;
        for (int day = 0; day < 7; day++) {
          final daysAgo = (3 - week) * 7 + (6 - day);
          final date = now.subtract(Duration(days: daysAgo));
          final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final completedCount = completionsByDate[dateKey] ?? 0;
          final cappedCount = completedCount.clamp(0, habits.docs.length);
          totalPercentage += (cappedCount / habits.docs.length) * 100;
          dayCount++;
        }
        completionData['Wk ${week + 1}'] = totalPercentage / dayCount;
      }

    } else {
      // Show last 12 months
      for (int i = 11; i >= 0; i--) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 0);
        double totalPercentage = 0;
        int dayCount = 0;

        for (int day = 1; day <= monthEnd.day; day++) {
          final date = DateTime(monthDate.year, monthDate.month, day);
          final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final completedCount = completionsByDate[dateKey] ?? 0;
          final cappedCount = completedCount.clamp(0, habits.docs.length);
          totalPercentage += (cappedCount / habits.docs.length) * 100;
          dayCount++;
        }

        final monthLabel = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][monthDate.month - 1];
        completionData[monthLabel] = totalPercentage / dayCount;
      }
    }

    return completionData;
  } catch (e) {
    print('Error getting completion data: $e');
    return {};
  }
}

  Future<List<FlSpot>> _getXPProgressData() async {
    try {
      final completions = await FirebaseFirestore.instance
          .collection('completions')
          .where('userId', isEqualTo: user!.uid)
          .limit(30)
          .get();

      if (completions.docs.isEmpty) return [];

      int cumulativeXP = 0;
      final spots = <FlSpot>[];

      for (int i = 0; i < completions.docs.length; i++) {
        final xp = (completions.docs[i].data()['xpEarned'] as num?)?.toInt() ?? 0;
        cumulativeXP += xp;
        spots.add(FlSpot(i.toDouble(), cumulativeXP.toDouble()));
      }

      return spots;
    } catch (e) {
      print('Error getting XP data: $e');
      return [];
    }
  }
}
