import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoginTextfield extends StatefulWidget {
  final String? hint;
  final String? errorMessage;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  const CustomLoginTextfield({
    super.key,
    this.hint,
    this.prefixIcon,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<CustomLoginTextfield> createState() => _CustomLoginTextfieldState();
}

class _CustomLoginTextfieldState extends State<CustomLoginTextfield> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    );
    return TextFormField(
      onChanged: widget.onChanged,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      obscuringCharacter: '●',
      decoration: InputDecoration(
        filled: true,
        // isDense: true,
        hintText: widget.hint,
        errorText: widget.errorMessage,
        hintStyle: textStyles.bodySmall?.copyWith(
          color: colors.onBackground.withOpacity(0.5),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () => _toggle(),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(
                  _obscureText
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill,
                  color: colors.primary,
                ),
              )
            : null,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        contentPadding: EdgeInsets.all(18.w),
        fillColor: colors.surface,
        focusedBorder: border,
        enabledBorder: border,
      ),
    );
  }
}
