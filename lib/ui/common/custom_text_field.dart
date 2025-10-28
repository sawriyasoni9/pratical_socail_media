import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool obscureText;
  final bool isMultiline;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsetsGeometry contentPadding;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.isMultiline = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.fillColor,
    this.borderColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: isMultiline ? null : 1,
      minLines: isMultiline ? 3 : 1,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      textInputAction:  TextInputAction.done,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade400),
        ),
        suffixIcon: suffixIcon != null
            ? InkWell(
          onTap: onSuffixTap,
          borderRadius: BorderRadius.circular(30),
          child: Icon(suffixIcon, color: Colors.grey.shade700),
        )
            : null,
      ),
    );
  }
}
