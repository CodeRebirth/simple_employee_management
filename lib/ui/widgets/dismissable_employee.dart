import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_employee_management/bloc/employee_list_bloc.dart';
import 'package:simple_employee_management/model/employee_model.dart';
import 'package:simple_employee_management/ui/screens/add_employee.dart';

import '../../helpers/db_helper.dart';

class DismissableEmployeeTile extends StatelessWidget {
  const DismissableEmployeeTile({
    Key? key,
    required this.dbHelper,
    required this.employees,
    required this.employee,
    required this.index,
  }) : super(key: key);

  final DatabaseHelper dbHelper;
  final List<EmployeeModel> employees;
  final EmployeeModel employee;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        BlocProvider.of<EmployeeListBloc>(context, listen: false).add(DeleteEmployeeEvent(id: employee.id!.toInt(), name: employee.empName));
      },
      key: Key(employees[index].id.toString()),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddOrEditEmployeeDetails(
                  existingData: {
                    "empName": employees[index].empName,
                    "role": employees[index].role,
                    "joining_date": employees[index].joining_date,
                    "ending_date": employees[index].ending_date,
                    "id": employees[index].id
                  },
                ))),
        child: ListTile(
          dense: true,
          title: Text(employee.empName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                employee.role,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              Text("From ${employee.joining_date}", style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
