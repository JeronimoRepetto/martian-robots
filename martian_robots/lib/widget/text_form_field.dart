import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    this.key,
    this.focusNode,
    this.nextFocus,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.decoration,
    this.onFieldSubmitted,
    this.keyboardType,
    this.controller,
    this.autocorrect = false,
    this.obscureText = false,
    this.enabled,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.noErrorsCallback,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.style,
    this.textCapitalization = TextCapitalization.none,
  });

  final Key? key;
  final focusNode;
  final nextFocus;
  final onSaved;
  final onChanged;
  final validator;
  final InputDecoration? decoration;
  final onFieldSubmitted;
  final keyboardType;
  final controller;
  final autocorrect;
  final obscureText;
  final enabled;
  final inputFormatters;
  final maxLines;
  final maxLength;
  final noErrorsCallback;
  final textInputAction;
  final textAlign;
  final style;
  final textCapitalization;

  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool showError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          key: widget.key,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: (val)=>widget.onChanged(val),
          onSaved: (val) => widget.onSaved(val),
          onFieldSubmitted: (val) => widget.onFieldSubmitted(val),
          decoration: widget.decoration,
          validator: (val) => _checkValidation(val),
          autocorrect: widget.autocorrect,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          textAlign: widget.textAlign,
          style: widget.style,
          textCapitalization: widget.textCapitalization,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Opacity(
            opacity: showError ? 1.0 : 0.0,
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }

  String? _checkValidation(String? val) {
    var result = widget.validator(val);
    if (result != null) {
      setState(() {
        showError = true;
        errorMessage = result;
      });
      widget.noErrorsCallback(false);
    } else {
      setState(() {
        showError = false;
        errorMessage = '';
      });
      widget.noErrorsCallback(true);
    }
    return null;
  }
}