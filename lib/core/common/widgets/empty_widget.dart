import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hasbi/generated/assets.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  final String lottieAsset;

  const EmptyWidget({
    super.key,
     this.message ,
    this.lottieAsset = Assets.animationsEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(lottieAsset),
           SizedBox(height: 16.h),
          Text(
            message??'Things look empty here. Tap + to start',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
