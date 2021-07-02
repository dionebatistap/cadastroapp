import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';

Widget gsAppButton(BuildContext context, String title, Function onTap) {
  return AppButton(
    width: context.width(),
    child: Text(title, style: boldTextStyle(color: Colors.white)),
    color: Colors.grey[800],
    shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    onTap: onTap,
  );
}

Widget passoAPasso(String image, String title, String subTitle) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 220, width: 180, fit: BoxFit.cover),
        60.height,
        Column(
          children: [
            Text(title.validate(),
                style: boldTextStyle(size: 20), textAlign: TextAlign.center),
            16.height,
            Text(subTitle.validate(),
                style: secondaryTextStyle(size: 16),
                textAlign: TextAlign.center),
          ],
        ),
      ],
    ),
  );
}
