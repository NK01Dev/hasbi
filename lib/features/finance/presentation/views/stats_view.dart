import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Statistics Coming Soon",
        style: TextStyleHelper.textStyle18(),
      ),
    );
  }
}
