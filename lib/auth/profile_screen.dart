import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../transaction/add_transaction_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_navbar.dart';
import 'controller/login_controller.dart';
import 'controller/profile_controller.dart';
import 'package:Webcare/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  final LoginController loginController;

  const ProfileScreen({Key? key, required this.loginController}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = ProfileController();
  User? _user;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? user = await _profileController.getUserProfile();
    setState(() {
      _user = user;
      _usernameController.text = user?.name ?? '';
      _emailController.text = user?.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 1.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          suffixIcon: Icon(Icons.person),
                        ),
                        readOnly: true,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          suffixIcon: Icon(Icons.mail),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 80),
                      CustomButton(
                        buttonText: 'KELUAR',
                        onPressed: () {
                          widget.loginController.logout(context);
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavbar(loginController: widget.loginController), // Sediakan loginController dari widget ini
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_transaction');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
