import 'package:flutter/material.dart';

import '../auth/controller/login_controller.dart';
import '../model/user_model.dart';
import '../theme/colors.dart';
import '../theme/text_theme.dart';
import '../transaction/add_transaction_screen.dart';
import '../widgets/custom_navbar.dart';
import 'daily_report_screen.dart';
import 'monthly_report_screen.dart';

class ReportScreen extends StatefulWidget {
  final LoginController loginController;

  const ReportScreen({super.key, required this.loginController});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 0;
  User? user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    setState(() {
      user = null;
    });

    User? currentUser = await widget.loginController.getCurrentUser();
    print('Current User: $currentUser');
    setState(() {
      user = currentUser;
    });
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LAPORAN', style: appBarText),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(160, 60),
                      backgroundColor: _selectedIndex == 0 ? tertiaryColor : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _onButtonPressed(0),
                    child: Text(
                      'Harian',
                      style: primaryText.copyWith(
                        color: _selectedIndex == 0 ? primaryColor : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(160, 60),
                      backgroundColor: _selectedIndex == 1 ? tertiaryColor : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _onButtonPressed(1),
                    child: Text(
                      'Bulanan',
                      style: primaryText.copyWith(
                        color: _selectedIndex == 1 ? primaryColor : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                //child: DailyReportScreen(userId: user!.userId.toString()),
                child: _selectedIndex == 0
                    ? DailyReportScreen(userId: user!.userId.toString())
                    : MonthlyReportScreen(userId: user!.userId.toString()), // Pass the user object here
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(loginController: widget.loginController),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransScreen(),
              settings: RouteSettings(
                arguments: widget.loginController,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
