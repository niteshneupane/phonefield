import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword;
  final String? hintText;
  final String? labelText;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final TextStyle? hintStyle;
  final bool isFilled;
  final TextAlign? textAlign;
  final double? borderRadius;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool? autoFocus;
  final TextInputAction? textInputAction;
  final Color? titleColor;
  final int? maxLength;
  final AutovalidateMode? autoValidateMode;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final BoxConstraints? prefixIconConstraints;
  final bool isNewStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  final double minPrefixWidth;

  final Color? focusedBorderColor;

  const CustomTextField({
    super.key,
    this.focusNode,
    this.labelStyle,
    this.controller,
    this.maxLength,
    this.labelText,
    this.hintText,
    this.isNewStyle = false,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.maxLines,
    this.contentPadding,
    this.suffixIcon,
    this.isFilled = false,
    this.prefixIcon,
    this.onSubmitted,
    this.onChanged,
    this.initialValue,
    this.prefixIconConstraints,
    this.autoFocus = false,
    this.textInputAction,
    this.textAlign,
    this.prefixText,
    this.borderRadius,
    this.hintStyle,
    this.autoValidateMode,
    this.titleColor,
    this.inputFormatters,
    this.textStyle,
    this.minPrefixWidth = 70,
    this.focusedBorderColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xffCBD5E1)),
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null && !widget.isNewStyle)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              widget.labelText!,
              style: widget.labelStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        TextFormField(
          cursorColor: Colors.black,
          maxLength: widget.maxLength,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign ?? TextAlign.start,
          initialValue: widget.initialValue,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          autovalidateMode: widget.autoValidateMode,
          obscureText: (widget.isPassword) ? _showPassword : false,
          controller: widget.controller,
          autofocus: widget.autoFocus ?? false,
          validator: widget.validator,
          onTap: widget.onTap,
          maxLines: widget.maxLines ?? 1,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          style: widget.textStyle,
          decoration: InputDecoration(
            filled: widget.isFilled,
            fillColor: Colors.white,
            hoverColor: Colors.transparent,
            prefixText: widget.prefixText,
            prefixStyle: const TextStyle(fontSize: 16),
            prefixIconConstraints: widget.prefixIconConstraints,
            errorMaxLines: 2,
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder.copyWith(
              borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? const Color(0xffCBD5E1)),
            ),
            errorBorder: outlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.red),
            ),
            disabledBorder: outlineInputBorder,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                const TextStyle(
                  color: Color(0xff64748B),
                  fontSize: 14,
                ),
            prefixIcon: (widget.isNewStyle && widget.labelText != null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: widget.minPrefixWidth,
                          ),
                          child: Text(
                            widget.labelText!,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          height: 24,
                          width: 1,
                          color: const Color(0xffCBD5E1),
                        ),
                      ],
                    ),
                  )
                : widget.prefixIcon,
            suffixIcon: widget.suffixIcon ??
                (widget.isPassword
                    ? InkWell(
                        onTap: () =>
                            setState(() => _showPassword = !_showPassword),
                        child: _showPassword
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                size: 18.0,
                                // color: AppColors.fontGrey,
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                size: 18.0,
                                // color: AppColors.fontGrey,
                              ),
                      )
                    : null),
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
          ),
          onFieldSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }
}
