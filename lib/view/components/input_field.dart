import 'package:flutter/material.dart';

import '../style/const_color.dart';

class Field extends StatelessWidget {
  final String? label;
  final bool? enabled;
  final String? hint;
  final TextEditingController? controller;
  final Widget? widget;

  const Field({
    Key? key,
    this.label,
    this.controller,
    this.widget,
    this.hint,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20, //SizeConfig.screenWidth * 0.03,
        vertical: 20,
      ), //SizeConfig().heightOfCurrentScreen(context, appBar) * 0.04),
      child: TextFormField(
        readOnly: enabled ?? false,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          icon: widget,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: primaryClr),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final Function(String? value) fun;
  final IconData icon;
  final TextEditingController? controller;

  const InputField({
    Key? key,
    required this.label,
    required this.fun,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20, //SizeConfig.screenWidth * 0.03,
        vertical: 20,
      ),
      child: TextFormField(
        autofocus: true,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return '$label is empty';
          }
          return null;
        },
        onSaved: fun,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: primaryClr),
          ),
        ),
      ),
    );
  }
}
