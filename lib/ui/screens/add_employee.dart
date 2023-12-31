import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:simple_employee_management/bloc/employee_list_bloc.dart';
import 'package:simple_employee_management/const/string_const.dart';
import 'package:simple_employee_management/helpers/db_helper.dart';
import 'package:simple_employee_management/model/employee_model.dart';
import 'package:simple_employee_management/ui/widgets/common_appbar.dart';
import 'package:simple_employee_management/utilities/show_custom_scaffold.dart';

import '../widgets/custom_calender.dart';

class AddOrEditEmployeeDetails extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  const AddOrEditEmployeeDetails({
    Key? key,
    this.existingData,
  }) : super(key: key);

  @override
  State<AddOrEditEmployeeDetails> createState() => _AddEmployeeDetailsState();
}

class _AddEmployeeDetailsState extends State<AddOrEditEmployeeDetails> {
  final dbHelper = DatabaseHelper();
  List roles = ["Product Designer", "Flutter Developer", "QA Tester", "Product Owner"];

  TextEditingController empTextController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController(text: "Today");
  TextEditingController endingDateController = TextEditingController(text: "No date");

  DateTime? joinDate;
  DateTime? endDate;

  @override
  void initState() {
    if (widget.existingData != null) {
      fillFormWithExistingData(widget.existingData);
    }
    super.initState();
  }

  void fillFormWithExistingData(Map<String, dynamic>? existingData) {
    //filling in the form with existing data
    empTextController.text = existingData!["empName"];
    roleController.text = existingData["role"];
    joiningDateController.text = existingData["joining_date"];
    endingDateController.text = existingData["ending_date"];
  }

  void showAndSetDate(TextEditingController controller, String whichDate) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height <= 700 ? MediaQuery.of(context).size.height * .84 : MediaQuery.of(context).size.height * .60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                      child: CustomTableCalender(
                    endingDateController: endingDateController,
                    joiningDateController: joiningDateController,
                    whichDate: whichDate,
                  )),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showRoleBottomDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: roles.length,
            itemBuilder: ((context, index) => InkWell(
                  onTap: () {
                    setState(() {
                      roleController.text = roles[index];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: .15))), height: 60, alignment: Alignment.center, child: Text(roles[index])),
                ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(title: ADDEMPDETAILS),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedIconTextField(
              hintText: 'Employee name',
              icon: Icons.person_outline,
              width: MediaQuery.of(context).size.width,
              controller: empTextController,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: showRoleBottomDialog,
              child: IgnorePointer(
                ignoring: true,
                child: RoundedIconTextField(
                  hintText: 'Select role',
                  icon: Icons.badge,
                  suffixIcon: Icons.arrow_drop_down,
                  width: MediaQuery.of(context).size.width,
                  controller: roleController,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      showAndSetDate(joiningDateController, JOINDATE);
                    },
                    child: IgnorePointer(
                      ignoring: true,
                      child: RoundedIconTextField(
                        textSize: 11,
                        hintText: TODAY,
                        icon: Icons.calendar_month,
                        width: MediaQuery.of(context).size.width * .389,
                        controller: joiningDateController,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: 55,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 17,
                      color: Theme.of(context).primaryColor,
                    )),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showAndSetDate(endingDateController, ENDDATE);
                    },
                    child: IgnorePointer(
                      ignoring: true,
                      child: RoundedIconTextField(
                        hintText: NODATE,
                        icon: Icons.calendar_month,
                        width: MediaQuery.of(context).size.width * .389,
                        controller: endingDateController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[50], elevation: 0),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      CANCEL,
                      style: TextStyle(color: Colors.blue),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      if (empTextController.text.isEmpty || roleController.text.isEmpty || joiningDateController.text.isEmpty || endingDateController.text.isEmpty) {
                        showCustomScaffold(context, const Text(PLSFILLRQDINFO));
                      } else {
                        EmployeeModel newEmployee = EmployeeModel(
                            id: widget.existingData == null ? null : widget.existingData!["id"],
                            empName: empTextController.text,
                            role: roleController.text,
                            joining_date: joiningDateController.text == TODAY ? DateFormat(DATEFORMAT).format(DateTime.now()) : joiningDateController.text,
                            ending_date: endingDateController.text == NODATE ? " " : endingDateController.text);
                        if (widget.existingData != null) {
                          //updating employee record

                          BlocProvider.of<EmployeeListBloc>(context, listen: false).add(UpdateEmployeeEvent(updatedData: newEmployee, id: widget.existingData!["id"]));
                          Navigator.pop(context);
                          return;
                        }
                        BlocProvider.of<EmployeeListBloc>(context, listen: false).add(AddEmployeeEvent(empData: newEmployee));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(SAVE))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    empTextController.dispose();
    roleController.dispose();
    joiningDateController.dispose();
    endingDateController.dispose();
    super.dispose();
  }
}

class RoundedIconTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final double width;
  final IconData? suffixIcon;
  final double? textSize;
  final TextEditingController controller;

  const RoundedIconTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.width,
    this.suffixIcon,
    this.textSize,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 35,
        width: width,
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 13),
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
            enabled: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade300)),
            prefixIcon: Icon(
              icon,
              size: 19,
              color: Theme.of(context).primaryColor,
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
