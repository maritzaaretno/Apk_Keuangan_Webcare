import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ButtonCard extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final dynamic loginController; // Deklarasikan loginController di sini

  const ButtonCard({
    required this.buttonText,
    required this.onPressed,
    required this.loginController, // Tambahkan loginController ke constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Gunakan onPressed dari constructor
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 50),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonText, // Gunakan buttonText dari constructor
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            )
          ],
        ),
      ),
    );
  }
}
