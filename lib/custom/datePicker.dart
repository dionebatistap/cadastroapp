import 'package:flutter/material.dart';

class DateDropDown extends StatelessWidget {
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  const DateDropDown(
      {Key key,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var tamanho = MediaQuery.of(context);
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration:
            InputDecoration(labelText: labelText, border: InputBorder.none),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Data batismo nas águas:",
                style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            Spacer(
              flex: 3,
            ),
            Text(
              valueText ?? '',
              style: valueStyle,
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
