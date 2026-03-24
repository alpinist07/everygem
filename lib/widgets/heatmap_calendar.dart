import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class HeatmapCalendar extends StatelessWidget {
  /// date key 'yyyy-MM-dd' → completion rate 0.0~1.0
  final Map<String, double> data;
  final int weeksToShow;

  const HeatmapCalendar({
    super.key,
    required this.data,
    this.weeksToShow = 15,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final totalDays = weeksToShow * 7;
    final startDate = now.subtract(Duration(days: totalDays - 1));
    // align to start of week (Monday)
    final alignedStart = startDate.subtract(Duration(days: startDate.weekday - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month labels
        SizedBox(
          height: 16,
          child: Row(
            children: _buildMonthLabels(context, alignedStart, weeksToShow),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day labels
            Column(
              children: ['', 'M', '', 'W', '', 'F', '']
                  .map((d) => SizedBox(
                        height: 14,
                        width: 16,
                        child: Text(d,
                            style: GoogleFonts.inter(
                                fontSize: 8,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary)),
                      ))
                  .toList(),
            ),
            // Grid
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  children: List.generate(weeksToShow, (weekIndex) {
                    return Column(
                      children: List.generate(7, (dayIndex) {
                        final date = alignedStart.add(
                            Duration(days: weekIndex * 7 + dayIndex));
                        if (date.isAfter(now)) {
                          return _Cell(rate: -1); // future
                        }
                        final key = _dateKey(date);
                        final rate = data[key] ?? 0.0;
                        return _Cell(rate: rate);
                      }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Less ',
                style: GoogleFonts.inter(
                    fontSize: 9,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary)),
            ...[0.0, 0.25, 0.5, 0.75, 1.0].map((r) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: _rateColor(r),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
            Text(' More',
                style: GoogleFonts.inter(
                    fontSize: 9,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildMonthLabels(BuildContext context, DateTime start, int weeks) {
    final labels = <Widget>[];
    String? lastMonth;
    for (int w = 0; w < weeks; w++) {
      final date = start.add(Duration(days: w * 7));
      final month = _monthName(date.month);
      if (month != lastMonth) {
        labels.add(Padding(
          padding: EdgeInsets.only(left: w == 0 ? 16 : 0),
          child: Text(month,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary)),
        ));
        lastMonth = month;
      }
      labels.add(const Spacer());
    }
    return labels;
  }

  static Color _rateColor(double rate) {
    if (rate <= 0) return const Color(0xFFEBEDF0);
    if (rate <= 0.25) return const Color(0xFF9BE9A8);
    if (rate <= 0.5) return const Color(0xFF40C463);
    if (rate <= 0.75) return const Color(0xFF30A14E);
    return const Color(0xFF216E39);
  }

  static String _monthName(int m) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m];
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _Cell extends StatelessWidget {
  final double rate;
  const _Cell({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: rate < 0
            ? Colors.transparent
            : HeatmapCalendar._rateColor(rate),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
