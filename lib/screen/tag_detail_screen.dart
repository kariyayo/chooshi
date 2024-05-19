import 'package:chooshi/model/tag_detail.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagDetailScreen extends ConsumerWidget {
  const TagDetailScreen({super.key, required this.tag});

  static Route route(String tag) {
    return MaterialPageRoute<void>(builder: (_) => TagDetailScreen(tag: tag));
  }

  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagDetail = ref.read(tagDetailStoreProvider).fetch(tag);
    return Scaffold(
      appBar: AppBar(
        title: Text(tag),
      ),
      body: tagDetail == null
          ? const Center(child: Text('No data'))
          : Center(
              child: _Content(tagDetail: tagDetail),
            ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.tagDetail});
  final TagDetail tagDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Mean: ${tagDetail.mean}'),
            Text('Count: ${tagDetail.count}'),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _Chart(tagDetail),
          ),
        ),
      ],
    );
  }
}

class _Chart extends ConsumerWidget {
  const _Chart(this.tagDetail);

  final TagDetail tagDetail;

  final _titlesData = const FlTitlesData(
    leftTitles: AxisTitles(
      axisNameWidget: Text('Count'),
      axisNameSize: 28,
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: AxisTitles(
      axisNameWidget: Text(''),
      axisNameSize: 24,
      sideTitles: SideTitles(showTitles: false),
    ),
    bottomTitles: AxisTitles(
      axisNameWidget: Text('Rating'),
      axisNameSize: 24,
      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxCount = tagDetail.ratings.values.reduce((max, value) => max > value ? max : value);
    final barGroup = tagDetail.ratings.entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                    toY: entry.value.toDouble(),
                    width: 16,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)))
              ],
              showingTooltipIndicators: [0],
            ))
        .toList();
    return BarChart(
      BarChartData(
        maxY: maxCount * 1.4,
        backgroundColor: Colors.blueGrey.withOpacity(0.25),
        borderData: FlBorderData(border: const Border(bottom: BorderSide(color: Colors.black))),
        gridData: const FlGridData(show: false),
        barGroups: barGroup,
        titlesData: _titlesData,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 12,
            fitInsideVertically: true,
            direction: TooltipDirection.top,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final color = rod.gradient?.colors.first ?? rod.color;
              final textStyle = TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14);
              final value = rod.toY.toInt();
              return BarTooltipItem(value == 0 ? '' : value.toString(), textStyle);
            },
            getTooltipColor: (BarChartGroupData group) => Colors.transparent,
          ),
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.linear,
    );
  }
}
