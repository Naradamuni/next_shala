import 'package:flutter/material.dart';

///A reusable text field class.
///*Reders UI with constant text style
///*Colors,width & height can be customized to generate different buttons
class BaseTextFieldFragment extends StatelessWidget {
  const BaseTextFieldFragment({
    Key? key,
    this.controller,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.cursorColor = const Color(0xFF75cac2),
    this.keyboardType,
    this.hintText,
    this.fillColor = const Color(0xFFeef6ff),
    this.focusColor = const Color(0xFFeef6ff),
    this.borderColor = const Color(0xFFeef6ff),
    this.focusedBorderColor = const Color(0xFF75cac2),
    this.suffix,
    this.obscureText = false,
    this.hintTextColor = const Color(0xFF8c8ca1),
    this.padding = const EdgeInsets.all(5),
    this.textColor = const Color(0xFF2a2a3a),
    this.suffixIconConstraints =
        const BoxConstraints(maxHeight: 22, maxWidth: 22),
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textInputAction,
    this.errorBorderColor = const Color(0xFFFF4040),
    this.errorText,
    this.validator,
  }) : super(key: key);

  /// Controls the text being edited.

  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// flag to enable or disable input
  final bool enabled;

  /// Text that appears below the [InputDecorator.child] and the border.
  ///
  /// If non-null, the border's color animates to red and the [helperText] is
  /// not shown.
  ///
  /// In a [TextFormField], this is overridden by the value returned from
  /// [TextFormField.validator], if that is not null.
  final String? errorText;

  /// Called when the user initiates a change to the TextField's value:
  /// when they have inserted or deleted text.

  /// This callback doesn't run when the TextField's text is changed
  /// programmatically, via the TextField's [controller]. Typically it isn't
  /// necessary to be notified of such changes, since they're initiated by
  /// the app itself.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text
  /// in the field.
  final ValueChanged<String>? onFieldSubmitted;

  /// The cursor color
  final Color cursorColor;

  /// You can specify the keybaord type
  final TextInputType? keyboardType;

  /// The hint text
  final String? hintText;

  /// The fill color for text field
  final Color fillColor;

  /// The focus color
  final Color focusColor;

  /// The border color
  final Color borderColor;

  /// The focused border color
  final Color focusedBorderColor;

  /// An icon that appears after the editable part of the text field and after
  /// the [suffix] , within the decoration's container.
  final Widget? suffix;

  /// Flag to toggle visible state
  final bool obscureText;

  /// The hint text color
  final Color hintTextColor;

  /// the padding for the input field
  final EdgeInsetsGeometry padding;

  /// the text color
  final Color textColor;

  /// The suffix icon Box constraints
  final BoxConstraints? suffixIconConstraints;

  /// The scroll paddding for input filed
  final EdgeInsets scrollPadding;

  /// An action the user has requested the text input control to perform.
  final TextInputAction? textInputAction;

  /// The error border Color
  final Color errorBorderColor;

  /// The validator
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: TextFormField(
          enabled: enabled,
          textInputAction: textInputAction,
          scrollPadding: scrollPadding,
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: cursorColor,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontFamily: "Avenir",
              fontStyle: FontStyle.normal,
              fontSize: 16.0),
          decoration: InputDecoration(
              errorText: errorText,
              filled: true,
              fillColor: fillColor,
              focusColor: focusColor,
              hintText: hintText,
              hintStyle: TextStyle(
                  color: hintTextColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Avenir",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: errorBorderColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: focusedBorderColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              suffixIcon: suffix,
              contentPadding: const EdgeInsets.all(16),
              suffixIconConstraints: suffixIconConstraints),
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        ));
  }
}
