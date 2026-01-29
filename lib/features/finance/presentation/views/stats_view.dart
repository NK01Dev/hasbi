import 'package:flutter/material.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class StatsView extends HookConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: SpacingHelper.pAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             //text
             Text('static')
           ],
          ),
        ),
      ),
    );
  }
}