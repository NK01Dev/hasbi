import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Fix: Changed 'golas' to 'goals'
enum TransactionType { income, expense, goals }

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final String colorHex; // Hex code for background pastel color

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
  });

  Color get color {
    final hex = colorHex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Color(int.parse(hex, radix: 16));
  }
}

class AppCategories {
  static List<CategoryModel> getIncomeCategories() => [
    CategoryModel(
      id: 'salary',
      name: 'Salary',
      icon: FontAwesomeIcons.wallet,
      colorHex: '#2196F3',
    ),
    CategoryModel(
      id: 'business',
      name: 'Business',
      icon: FontAwesomeIcons.briefcase,
      colorHex: '#4CAF50',
    ),
    CategoryModel(
      id: 'investment',
      name: 'Investment',
      icon: FontAwesomeIcons.arrowTrendUp,
      colorHex: '#FF9800',
    ),
    CategoryModel(
      id: 'grant',
      name: 'Grant',
      icon: FontAwesomeIcons.gift,
      colorHex: '#E91E63',
    ),
    CategoryModel(
      id: 'rent',
      name: 'Rent',
      icon: FontAwesomeIcons.key,
      colorHex: '#3F51B5',
    ),
    CategoryModel(
      id: 'other',
      name: 'Other',
      icon: FontAwesomeIcons.ellipsis,
      colorHex: '#9C27B0',
    ),
  ];

  static List<CategoryModel> getExpenseCategories() => [
    // Housing
    CategoryModel(
      id: 'rent',
      name: 'Rent',
      icon: FontAwesomeIcons.house,
      colorHex: '#607D8B', // Blue Grey
    ),

    // Food & Drink
    CategoryModel(
      id: 'food',
      name: 'Food',
      icon: FontAwesomeIcons.utensils,
      colorHex: '#F44336',
    ),
    CategoryModel(
      id: 'groceries',
      name: 'Groceries',
      icon: FontAwesomeIcons.cartShopping,
      colorHex: '#4CAF50',
    ),

    // Transportation
    CategoryModel(
      id: 'transport',
      name: 'Transport',
      icon: FontAwesomeIcons.car,
      colorHex: '#2196F3',
    ),

    // Lifestyle & Shopping
    CategoryModel(
      id: 'shopping',
      name: 'Shopping',
      icon: FontAwesomeIcons.bagShopping,
      colorHex: '#FF9800',
    ),
    CategoryModel(
      id: 'clothing',
      name: 'Clothing',
      icon: FontAwesomeIcons.shirt,
      colorHex: '#E91E63',
    ),
    CategoryModel(
      id: 'personal_care',
      name: 'Personal Care',
      icon: FontAwesomeIcons.spa,
      colorHex: '#9C27B0',
    ),

    // Entertainment & Health
    CategoryModel(
      id: 'entertainment',
      name: 'Fun',
      icon: FontAwesomeIcons.gamepad,
      colorHex: '#FF5722',
    ),
    CategoryModel(
      id: 'health',
      name: 'Health',
      icon: FontAwesomeIcons.notesMedical,
      colorHex: '#00BCD4',
    ),
    CategoryModel(
      id: 'fitness',
      name: 'Fitness',
      icon: FontAwesomeIcons.dumbbell,
      colorHex: '#009688',
    ),

    // Travel
    CategoryModel(
      id: 'travel',
      name: 'Travel',
      icon: FontAwesomeIcons.plane,
      colorHex: '#3F51B5',
    ),

    // Financial & Family
    CategoryModel(
      id: 'bills',
      name: 'Bills',
      icon: FontAwesomeIcons.fileInvoiceDollar,
      colorHex: '#795548',
    ),
    CategoryModel(
      id: 'education',
      name: 'Education',
      icon: FontAwesomeIcons.graduationCap,
      colorHex: '#673AB7',
    ),
    CategoryModel(
      id: 'family',
      name: 'Family',
      icon: FontAwesomeIcons.users,
      colorHex: '#FF7043',
    ),
    CategoryModel(
      id: 'gifts',
      name: 'Gifts',
      icon: FontAwesomeIcons.gift,
      colorHex: '#EC407A',
    ),

    // Pets
    CategoryModel(
      id: 'pets',
      name: 'Pets',
      icon: FontAwesomeIcons.paw,
      colorHex: '#8D6E63',
    ),

    // Other
    CategoryModel(
      id: 'other_exp',
      name: 'Other',
      icon: FontAwesomeIcons.ellipsis,
      colorHex: '#9E9E9E',
    ),
  ];
  // NEW: Add Goal Categories here
  static List<CategoryModel> getGoalCategories() => [
    // Existing
    CategoryModel(
      id: 'travel',
      name: 'Travel',
      icon: FontAwesomeIcons.plane,
      colorHex: '#2196F3',
    ),
    CategoryModel(
      id: 'housing',
      name: 'Housing',
      icon: FontAwesomeIcons.houseChimney,
      colorHex: '#4CAF50',
    ),
    CategoryModel(
      id: 'vehicle',
      name: 'Vehicle',
      icon: FontAwesomeIcons.car,
      colorHex: '#FF9800',
    ),
    CategoryModel(
      id: 'health',
      name: 'Health',
      icon: FontAwesomeIcons.notesMedical,
      colorHex: '#F44336',
    ),

    // New – Financial
    CategoryModel(
      id: 'emergency',
      name: 'Emergency Fund',
      icon: FontAwesomeIcons.shieldHeart,
      colorHex: '#607D8B',
    ),
    CategoryModel(
      id: 'investment',
      name: 'Investment',
      icon: FontAwesomeIcons.chartLine,
      colorHex: '#3F51B5',
    ),
    CategoryModel(
      id: 'debt',
      name: 'Debt Payoff',
      icon: FontAwesomeIcons.handHoldingDollar,
      colorHex: '#795548',
    ),

    // New – Personal Growth
    CategoryModel(
      id: 'education',
      name: 'Education',
      icon: FontAwesomeIcons.graduationCap,
      colorHex: '#9C27B0',
    ),
    CategoryModel(
      id: 'skills',
      name: 'Skill Building',
      icon: FontAwesomeIcons.laptopCode,
      colorHex: '#673AB7',
    ),

    // New – Lifestyle
    CategoryModel(
      id: 'shopping',
      name: 'Shopping',
      icon: FontAwesomeIcons.bagShopping,
      colorHex: '#E91E63',
    ),
    CategoryModel(
      id: 'entertainment',
      name: 'Entertainment',
      icon: FontAwesomeIcons.film,
      colorHex: '#FF5722',
    ),
    CategoryModel(
      id: 'fitness',
      name: 'Fitness',
      icon: FontAwesomeIcons.dumbbell,
      colorHex: '#009688',
    ),

    // New – Family & Tech
    CategoryModel(
      id: 'family',
      name: 'Family',
      icon: FontAwesomeIcons.peopleRoof,
      colorHex: '#8BC34A',
    ),
    CategoryModel(
      id: 'gadgets',
      name: 'Gadgets',
      icon: FontAwesomeIcons.mobileScreenButton,
      colorHex: '#03A9F4',
    ),
  ];
}
