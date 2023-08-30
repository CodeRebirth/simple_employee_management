import 'package:flutter/material.dart';

import '../screens/add_employee.dart';

class AddFloatingActionButton extends StatelessWidget {
  const AddFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AddOrEditEmployeeDetails(),
      )),
      tooltip: 'Add Employee',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Icon(Icons.add),
    );
  }
}
