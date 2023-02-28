import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputFormText extends StatelessWidget {
  final Function setInput;
  final Function validate;
  final String label;
  final bool? obscure;
  final Function? setObscure;
  final Icon icon;
  final Function validator;
  final String? initialValue;
  const InputFormText({
    super.key,
    required this.setInput,
    required this.validate,
    required this.label,
    required this.icon,
    required this.validator,
    this.setObscure,
    this.obscure,
    this.initialValue,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        padding: const EdgeInsets.only(left: 20.0),
        child: TextFormField(
          initialValue: initialValue,
          obscureText: obscure ?? false,
          onChanged: (value) {
            setInput(value);
            validate();
          },
          validator: ((value) => validator(value)),
          decoration: InputDecoration(
            icon: icon,
            suffixIcon: obscure == null
                ? null
                : IconButton(
                    icon: Icon(
                        obscure! ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setObscure!(!obscure!);
                    },
                  ),
            border: InputBorder.none,
            labelText: label,
            labelStyle: GoogleFonts.rubik(
              textStyle: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
