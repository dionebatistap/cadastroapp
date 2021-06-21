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
    var tamanho = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 30, 0),
      height: tamanho.size.height * 0.09,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800],
            width: 1.1,
          ),
        ),
        color: Colors.grey[200],
        //border: Border.fromBorderSide(),
      ),
      child: InkWell(
        onTap: onPressed,
        child: InputDecorator(
          
          decoration: InputDecoration(labelText: labelText, border: InputBorder.none),
          baseStyle: valueStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center ,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Data Batismo nas águas:",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              Spacer(
                flex: 6,
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
      ),
    );
  }
}
