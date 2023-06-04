import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String? initialValue;
  final String? errorMessage;
  final String? hint;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.errorMessage,
    this.hint,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none);
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType ?? TextInputType.name,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        hintText: hint,
        hintStyle: textStyles.bodyMedium?.copyWith(
          color: colors.onBackground.withOpacity(0.5),
          fontSize: 18.sp,
        ),
        border: border,
        errorBorder: border,
        errorText: errorMessage,
        contentPadding: const EdgeInsets.all(20),
        fillColor: colors.surface,
        focusedBorder: border,
        enabledBorder: border,
      ),
    );
  }
}
