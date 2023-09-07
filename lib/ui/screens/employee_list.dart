import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_employee_management/bloc/employee_list_bloc.dart';
import 'package:simple_employee_management/const/string_const.dart';

import 'package:simple_employee_management/ui/widgets/common_appbar.dart';
import 'package:simple_employee_management/helpers/db_helper.dart';
import 'package:simple_employee_management/utilities/show_custom_scaffold.dart';

import '../widgets/add_floating_action_button.dart';
import '../widgets/dismissable_employee.dart';
import '../widgets/no_employee.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({
    super.key,
  });
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(title: EMPLIST),
      floatingActionButton: const AddFloatingActionButton(),
      body: Center(
        child: BlocConsumer<EmployeeListBloc, EmployeeListState>(listener: (context, state) {
          if (state.modifyEmployeeList == true) {
            BlocProvider.of<EmployeeListBloc>(context).add(FetchEmployeeListEvent());
            showCustomScaffold(
                context,
                Row(
                  children: [
                    Text(
                      state.actionString!,
                    ),
                    const Spacer(),
                    if (state.actionString!.contains("deleted"))
                      InkWell(
                        onTap: () {
                          BlocProvider.of<EmployeeListBloc>(context, listen: false).add(UndoDeleteEvent(name: state.lastDeleteEmployeeName!));
                          ScaffoldMessenger.of(context).clearSnackBars();
                        },
                        child: const Text(
                          "Undo",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                  ],
                ));
          }
        }, builder: (ctx, state) {
          if (state.loadingState) {
            return const CircularProgressIndicator.adaptive();
          } else {
            if (state.employees.isEmpty && state.prevEmployees.isEmpty) {
              return const NoEmployeeFound();
            } else {
              return Column(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade100,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(12),
                    child: const Text(currentEmployees, style: TextStyle(color: Colors.blue)),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return index < state.employees.length
                              ? Divider(
                                  thickness: 1,
                                  height: 5,
                                  color: Colors.grey.shade100,
                                )
                              : Container();
                        },
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];

                          return DismissableEmployeeTile(
                            dbHelper: dbHelper,
                            index: index,
                            employees: state.employees,
                            employee: employee,
                            prevEmployeeList: false,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade100,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(12),
                    child: const Text(previousEmployees, style: TextStyle(color: Colors.blue)),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: state.prevEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = state.prevEmployees[index];
                          return DismissableEmployeeTile(
                            dbHelper: dbHelper,
                            index: index,
                            employees: state.prevEmployees,
                            employee: employee,
                            prevEmployeeList: true,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade100,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(12),
                    child: const Text(SWIPELFT, style: TextStyle(color: Colors.grey)),
                  )
                ],
              );
            }
          }
        }),
      ),
    );
  }
}
