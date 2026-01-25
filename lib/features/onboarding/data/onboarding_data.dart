import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OnboardingModel {
  final String title;
  final String subtitle;
  final String imageAsset;
  final Color backgroundColor; // New field for the transition effect

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.backgroundColor,
  });
}
final List<OnboardingModel> onboardingList = [
  OnboardingModel(
    title: "Track your expenses easily",
    subtitle: "Manage daily spending in one place",
    imageAsset: "assets/onboarding/img_1.svg",
    backgroundColor: AppColors.primary.withOpacity(0.15),
  ),
  OnboardingModel(
    title: "Understand your money",
    subtitle: "Visual reports for income & expenses",
    imageAsset: "assets/onboarding/img_2.svg",
    backgroundColor: AppColors.secondary.withOpacity(0.15),
  ),
  OnboardingModel(
    title: "Stay in control",
    subtitle: "Set budgets & save smarter",
    imageAsset: "assets/onboarding/img_3.svg",
    backgroundColor: AppColors.background,
  ),
];
