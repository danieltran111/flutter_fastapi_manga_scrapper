import 'package:flutter/material.dart';
import 'package:manga_flutter/consts/constants.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      color: Constants.darkgray,
    );
  }
}
