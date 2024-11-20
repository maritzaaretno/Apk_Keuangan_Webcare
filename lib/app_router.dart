import 'package:flutter/material.dart';
import 'auth/controller/login_controller.dart';
import 'auth/login_screen.dart';
import 'auth/profile_screen.dart';
import 'auth/register_screen.dart';
import 'report/detail_report.dart';
import 'report/report_screen.dart';
import 'transaction/add_transaction_screen.dart';
import 'splash_screen.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/profile':
        if (args is LoginController) {
          return MaterialPageRoute(builder: (_) => ProfileScreen(loginController: args));
        }
        return _errorRoute();
      case '/add_transaction':
        return MaterialPageRoute(builder: (_) => AddTransScreen());
      case '/report':
        if (args is LoginController) {
          return MaterialPageRoute(builder: (_) => ReportScreen(loginController: args));
        }
        return _errorRoute();
      // case '/detail_report':
      //   if (args is Map<String, dynamic>) {
      //     final loginController = args['loginController'] as LoginController?;
      //     final report = args['report'] as Map<String, dynamic>?;
      //     if (loginController != null && report != null) {
      //       return MaterialPageRoute(builder: (_) => DetailReport(loginController: loginController, report: report));
      //     }
      //   }
      //   return _errorRoute();
      // default:
      //   return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Halaman tidak ditemukan'),
        ),
      );
    });
  }
}
