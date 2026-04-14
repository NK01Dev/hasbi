class AppRoutePaths {
  // Root
  static const String root = '/';

  // Auth Flow
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';

  // Main App
  static const String dashboard = '/dashboard';

  // Transaction Routes
  static const String addIncome = '/add-income';
  static const String addExpense = '/add-expense';
  static const String editIncome = '/edit-income/:id';
  static const String editExpense = '/edit-expense/:id';
  // Debt Routes
  static const String addDebt = '/add-debt';
  static const String editDebt = '/edit-debt/:id';

  // Goal Routes
  static const String addGoal = '/add-goal';
  static const String editGoal = '/edit-goal/:id';
}
