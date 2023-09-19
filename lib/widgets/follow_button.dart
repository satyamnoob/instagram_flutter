import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.buttonText,
    required this.textColor,
  });

  final Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String buttonText;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: () {
          onPressed!();
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: 230,
          height: 27,
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
