import 'package:flutter/material.dart';

import 'package:simple_employee_management/common_appbar.dart';

class AddEmployeeDetails extends StatefulWidget {
  const AddEmployeeDetails({super.key});

  @override
  State<AddEmployeeDetails> createState() => _AddEmployeeDetailsState();
}

class _AddEmployeeDetailsState extends State<AddEmployeeDetails> {
  List roles = ["Product Designer", "Flutter Developer", "QA Tester", "Product Owner"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Add Employee Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedIconTextField(
              hintText: 'Employee name',
              icon: Icons.person_outline,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                itemCount: roles.length,
                                itemBuilder: ((context, index) => Container(
                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: .15))),
                                    height: 60,
                                    alignment: Alignment.center,
                                    child: Text(roles[index])))),
                          ),
                        ));
              },
              child: IgnorePointer(
                ignoring: true,
                child: RoundedIconTextField(
                  hintText: 'Select role',
                  icon: Icons.badge,
                  suffixIcon: Icons.arrow_drop_down,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const RoundedIconTextField(
                  hintText: 'Today',
                  icon: Icons.calendar_month,
                  width: 150,
                ),
                SizedBox(
                    width: 55,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    )),
                const RoundedIconTextField(
                  hintText: 'No date',
                  icon: Icons.calendar_month,
                  width: 150,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.blue),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(onPressed: () {}, child: const Text("Save"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoundedIconTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final double width;
  final IconData? suffixIcon;

  const RoundedIconTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.width,
    this.suffixIcon,
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
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 13),
            suffixIcon: Icon(
              suffixIcon,
              color: Theme.of(context).primaryColor,
            ),
            enabled: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade200)),
            prefixIcon: Icon(
              icon,
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
