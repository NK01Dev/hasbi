import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import '../../data/models/category_model.dart';
import '../../providers/stats_provider.dart';

class FinancePieChart extends ConsumerStatefulWidget {
  final Map<String, double> data;
  final bool isIncome;

  const FinancePieChart({
    super.key,
    required this.data,
    required this.isIncome,
  });

  @override
  ConsumerState<FinancePieChart> createState() => _FinancePieChartState();
}

class _FinancePieChartState extends ConsumerState<FinancePieChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousTouchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final touchedIndex = ref.watch(pieChartTouchedIndexProvider);

    // Handle animation trigger when touchedIndex changes
    ref.listen(pieChartTouchedIndexProvider, (previous, next) {
      if (previous != next) {
        _previousTouchedIndex = previous ?? -1;
        _animationController.forward(from: 0.0);
      }
    });

    if (widget.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 48.sp, color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Text('No data available', style: TextStyleHelper.textStyle14(color: Colors.grey)),
          ],
        ),
      );
    }

    final entries = widget.data.entries.toList();
    final allCategories = widget.isIncome
        ? AppCategories.getIncomeCategories()
        : AppCategories.getExpenseCategories();

    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SfCircularChart(
          margin: EdgeInsets.all(SpacingHelper.xs),
          selectionGesture: ActivationMode.singleTap,
          onSelectionChanged: (SelectionArgs args) {
            ref.read(pieChartTouchedIndexProvider.notifier).setIndex(args.pointIndex ?? -1);
          },
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Container(
                padding: EdgeInsets.all(SpacingHelper.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: TextStyleHelper.textStyle11(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: TextStyleHelper.textStyle20(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          series: <DoughnutSeries<MapEntry<String, double>, String>>[
            DoughnutSeries<MapEntry<String, double>, String>(
              dataSource: entries,
              xValueMapper: (e, _) => allCategories
                  .firstWhere((cat) => cat.id == e.key,
                  orElse: () => allCategories.last)
                  .name,
              yValueMapper: (e, _) => e.value,
              pointColorMapper: (e, _) => allCategories
                  .firstWhere((cat) => cat.id == e.key,
                  orElse: () => allCategories.last)
                  .color,
              dataLabelMapper: (e, _) {
                final categoryName = allCategories
                    .firstWhere((cat) => cat.id == e.key,
                        orElse: () => allCategories.last)
                    .name;
                final percent = total > 0
                    ? (e.value / total * 100).toStringAsFixed(1)
                    : '0.0';
                return '$categoryName \n $percent%';
              },
              innerRadius: '83%',
              radius: '80%', // Increased radius slightly

              explode: true,
              explodeIndex: touchedIndex,
              explodeOffset: Tween<double>(
                begin: _previousTouchedIndex == -1 ? 0 : 0.03,
                end: touchedIndex == -1 ? 0 : 0.05,
              ).animate(_animation).value.toString(),
              // Animated offset for smooth transition
              animationDuration: 300,
              // enableAnimation: true,
              strokeColor: Colors.white, // Changed to white for clean separation
              strokeWidth: 1.5, // Slightly thicker stroke for better separation
              cornerStyle: CornerStyle.bothCurve,
              enableTooltip: true,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                labelAlignment: ChartDataLabelAlignment.bottom,
                labelIntersectAction: LabelIntersectAction.shift,
                textStyle: TextStyleHelper.textStyle12(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                connectorLineSettings: const ConnectorLineSettings(
                  length: '10%',
                  width: 1,
                ),
              ),

              startAngle: 4,
              endAngle: 360,
            ),
          ],
        );
      },
    );
  }
}