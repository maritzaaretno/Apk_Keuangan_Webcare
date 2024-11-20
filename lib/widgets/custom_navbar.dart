import 'package:flutter/material.dart';
import 'package:Webcare/theme/colors.dart';
import '../auth/profile_screen.dart';
import '../report/report_screen.dart';
import '../auth/controller/login_controller.dart';

class CustomNavbar extends StatelessWidget {
  final LoginController loginController;

  const CustomNavbar({Key? key, required this.loginController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: tertiaryColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 25.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBottomNavigationItem(Icons.list_alt, 'Laporan', 0, context),
          const SizedBox(width: 48.0),
          _buildBottomNavigationItem(Icons.person, 'Profil', 1, context),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, String label, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportScreen(loginController: loginController)),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(loginController: loginController)), // tambahkan loginController di sini
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: primaryColor,
          ),
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
