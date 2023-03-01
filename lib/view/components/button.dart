import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final IconData icon;
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 0, vertical: 10 //SizeConfig.screenHeight * 0.02,
          ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        icon: Icon(icon),
        style: buttonStyle(),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
        // backgroundColor: MaterialStateProperty.all(primaryClr),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        minimumSize: MaterialStateProperty.all(Size(100, 45)));
  }
}
