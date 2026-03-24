import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class WeeklyBarChart extends StatelessWidget {
  /// 7 values (Mon~Sun), each 0.0~1.0 completion rate
  final List<double> rates;
  final int todayIndex; // 0=Mon, 6=Sun

  const WeeklyBarChart({
    super.key,
    required this.rates,
    required this.todayIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.0,
          minY: 0,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${(rod.toY * 100).round()}%',
                  GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 0.5,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value == 0.5 || value == 1.0) {
                    return Text(
                      '${(value * 100).round()}%',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  final i = value.toInt();
                  if (i < 0 || i > 6) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      days[i],
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: i == todayIndex
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: i == todayIndex
                            ? AppColors.primary
                            : isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 0.5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark
                  ? AppColors.darkDivider
                  : AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            final isFuture = i > todayIndex;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: isFuture ? 0 : rates[i],
                  width: 20,
                  color: isFuture
                      ? (isDark ? AppColors.darkDivider : AppColors.divider)
                      : (rates[i] >= 1.0
                          ? AppColors.green
                          : rates[i] > 0
                              ? AppColors.primary
                              : (isDark ? AppColors.darkDivider : AppColors.divider)),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
