import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_employee_management/const/svg_const.dart';

class NoEmployeeFound extends StatelessWidget {
  const NoEmployeeFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.string(
          NO_EMP_FOUND,
          width: 200,
          height: 200,
        ),
        const Text(
          "No Employee records found",
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
