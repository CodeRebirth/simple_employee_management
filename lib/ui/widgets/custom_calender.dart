import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../const/string_const.dart';

class CustomTableCalender extends StatefulWidget {
  final String? whichDate;
  final TextEditingController joiningDateController;
  final TextEditingController endingDateController;
  const CustomTableCalender({
    Key? key,
    this.whichDate,
    required this.joiningDateController,
    required this.endingDateController,
  }) : super(key: key);

  @override
  State<CustomTableCalender> createState() => _CustomTableCalenderState();
}

class _CustomTableCalenderState extends State<CustomTableCalender> {
  TextStyle color = const TextStyle(color: Colors.blue, fontSize: 13);
  DateTime? selectedDay;
  String? selectedTile;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                if (widget.whichDate == ENDDATE)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedTile = NODATE;
                        selectedDay = null;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: selectedTile == NODATE ? Colors.blue : Colors.blue.shade50,
                      ),
                      height: 35,
                      width: 160,
                      child: Text(NODATE, style: selectedTile == NODATE ? const TextStyle(color: Colors.white) : color),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedDay = DateTime.now();
                      selectedTile = TODAY;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: selectedTile == TODAY ? Colors.blue : Colors.blue.shade50,
                    ),
                    height: 35,
                    width: 160,
                    child: Text(TODAY, style: selectedTile == TODAY ? const TextStyle(color: Colors.white) : color),
                  ),
                ),
                if (widget.whichDate != ENDDATE)
                  InkWell(
                    onTap: () {
                      setState(() {
                        DateTime now = selectedDay ?? DateTime.now();
                        int daysUntilNextMonday = DateTime.monday - now.weekday + 7;
                        DateTime nextMonday = now.add(Duration(days: daysUntilNextMonday));
                        selectedDay = nextMonday;
                        selectedTile = MONDAY;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: selectedTile == MONDAY ? Colors.blue : Colors.blue.shade50,
                      ),
                      height: 35,
                      width: 160,
                      child: Text("Next Monday", style: selectedTile == MONDAY ? const TextStyle(color: Colors.white) : color),
                    ),
                  ),
                if (widget.whichDate != ENDDATE)
                  InkWell(
                    onTap: () {
                      DateTime now = selectedDay ?? DateTime.now();
                      int daysUntilNextTuesday = DateTime.tuesday - now.weekday;
                      if (daysUntilNextTuesday <= 0) {
                        daysUntilNextTuesday += 7;
                      }
                      DateTime nextTuesday = now.add(Duration(days: daysUntilNextTuesday));

                      setState(() {
                        selectedDay = nextTuesday;
                        selectedTile = TUESDAY;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: selectedTile == TUESDAY ? Colors.blue : Colors.blue.shade50,
                      ),
                      height: 35,
                      width: 160,
                      child: Text("Next Tuesday", style: selectedTile == TUESDAY ? const TextStyle(color: Colors.white) : color),
                    ),
                  ),
                if (widget.whichDate != ENDDATE)
                  InkWell(
                    onTap: () {
                      DateTime now = selectedDay ?? DateTime.now();
                      DateTime nextWeek = now.add(const Duration(days: 7));

                      setState(() {
                        selectedDay = nextWeek;
                        selectedTile = ONEWEEK;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: selectedTile == ONEWEEK ? Colors.blue : Colors.blue.shade50,
                      ),
                      height: 35,
                      width: 160,
                      child: Text("Next Week", style: selectedTile == ONEWEEK ? const TextStyle(color: Colors.white) : color),
                    ),
                  )
              ],
            )),
        Container(
          height: 10,
        ),
        TableCalendar(
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.blue)),
            defaultTextStyle: const TextStyle(fontSize: 13),
            selectedTextStyle: const TextStyle(fontSize: 13, color: Colors.white),
            todayTextStyle: const TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
            weekendTextStyle: const TextStyle(color: Colors.black87, fontSize: 13),
            selectedDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            disabledTextStyle: TextStyle(color: Colors.grey.shade200, fontSize: 13),
            outsideDaysVisible: false,
          ),
          enabledDayPredicate: (day) {
            if (widget.whichDate == ENDDATE) {
              if (widget.joiningDateController.text != TODAY) {
                if (day.isBefore(DateFormat(DATEFORMAT).parse(widget.joiningDateController.text))) {
                  return false;
                }
              }
            }

            return true;
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          rowHeight: 40,
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: selectedDay ?? DateTime.now(),
          headerVisible: true,
          headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              rightChevronIcon: Icon(
                Icons.arrow_right,
                color: Colors.grey,
              ),
              leftChevronIcon: Icon(
                Icons.arrow_left,
                color: Colors.grey,
              ),
              titleCentered: true,
              rightChevronMargin: EdgeInsets.zero,
              leftChevronMargin: EdgeInsets.zero,
              formatButtonShowsNext: false),
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDayCl, focusedDay) {
            setState(() {
              selectedTile = "Empty";
              selectedDay = selectedDayCl;
            });
          },
        ),
        const Spacer(),
        const Divider(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10, bottom: 10),
          child: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).primaryColor,
                  ),
                  selectedDay == null && widget.whichDate == ENDDATE
                      ? const Text(NODATE)
                      : selectedDay == null
                          ? Text(DateFormat(DATEFORMAT).format(DateTime.now()))
                          : Text(DateFormat(DATEFORMAT).format(selectedDay!)),
                  const Spacer(),
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
                            if (widget.whichDate == JOINDATE) {
                              if (selectedDay != null) {
                                widget.joiningDateController.text = DateFormat(DATEFORMAT).format(selectedDay!);
                              }
                              Navigator.of(context).pop();
                            } else {
                              if (selectedDay != null) {
                                widget.endingDateController.text = DateFormat(DATEFORMAT).format(selectedDay!);
                              } else {
                                widget.endingDateController.text = NODATE;
                              }

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(SAVE))
                    ],
                  )
                ],
              )),
        ),
      ],
    );
  }
}
