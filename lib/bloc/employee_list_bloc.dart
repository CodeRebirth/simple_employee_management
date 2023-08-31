import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:simple_employee_management/model/employee_model.dart';

import '../helpers/db_helper.dart';

abstract class EmployeeListEvent {}

class EmployeeListState extends Equatable {
  final bool loadingState;
  final List<EmployeeModel> prevEmployees;
  final List<EmployeeModel> employees;
  final bool? modifyEmployeeList;
  final String? actionString;
  final String? lastDeleteEmployeeName;

  const EmployeeListState({
    required this.loadingState,
    required this.prevEmployees,
    required this.employees,
    this.modifyEmployeeList,
    this.actionString,
    this.lastDeleteEmployeeName,
  });

  @override
  List<Object?> get props {
    return [
      loadingState,
      prevEmployees,
      employees,
      modifyEmployeeList,
      actionString,
      lastDeleteEmployeeName,
    ];
  }

  EmployeeListState copyWith({
    bool? loadingState,
    List<EmployeeModel>? prevEmployees,
    List<EmployeeModel>? employees,
    bool? modifyEmployeeList,
    String? actionString,
    String? lastDeleteEmployeeName,
  }) {
    return EmployeeListState(
      loadingState: loadingState ?? this.loadingState,
      prevEmployees: prevEmployees ?? this.prevEmployees,
      employees: employees ?? this.employees,
      modifyEmployeeList: modifyEmployeeList ?? this.modifyEmployeeList,
      actionString: actionString ?? this.actionString,
      lastDeleteEmployeeName: lastDeleteEmployeeName ?? this.lastDeleteEmployeeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loadingState': loadingState,
      'prevEmployees': prevEmployees.map((x) => x.toMap()).toList(),
      'employees': employees.map((x) => x.toMap()).toList(),
      'modifyEmployeeList': modifyEmployeeList,
      'actionString': actionString,
      'lastDeleteEmployeeName': lastDeleteEmployeeName,
    };
  }

  factory EmployeeListState.fromMap(Map<String, dynamic> map) {
    return EmployeeListState(
      loadingState: map['loadingState'] ?? false,
      prevEmployees: List<EmployeeModel>.from(map['prevEmployees']?.map((x) => EmployeeModel.fromMap(x))),
      employees: List<EmployeeModel>.from(map['employees']?.map((x) => EmployeeModel.fromMap(x))),
      modifyEmployeeList: map['modifyEmployeeList'],
      actionString: map['actionString'],
      lastDeleteEmployeeName: map['lastDeleteEmployeeName']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeListState.fromJson(String source) => EmployeeListState.fromMap(json.decode(source));
}

class FetchEmployeeListEvent extends EmployeeListEvent {}

class AddEmployeeEvent extends EmployeeListEvent {
  final EmployeeModel empData;
  AddEmployeeEvent({
    required this.empData,
  });
}

class UpdateEmployeeEvent extends EmployeeListEvent {
  final EmployeeModel updatedData;
  final int id;
  UpdateEmployeeEvent({
    required this.updatedData,
    required this.id,
  });
}

class DeleteEmployeeEvent extends EmployeeListEvent {
  final int id;
  final String name;
  DeleteEmployeeEvent({
    required this.id,
    required this.name,
  });
}

class UndoDeleteEvent extends EmployeeListEvent {
  final String name;
  UndoDeleteEvent({required this.name});
}

class ClearAllData extends EmployeeListEvent {}

class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  final DatabaseHelper databaseHelper;
  EmployeeListBloc(this.databaseHelper) : super(const EmployeeListState(loadingState: true, modifyEmployeeList: false, employees: [], prevEmployees: [])) {
    on<FetchEmployeeListEvent>((event, emit) async {
      final List<EmployeeModel> employeeData = [];
      final List<EmployeeModel> prevEmployeeData = [];
      final data = await databaseHelper.getAllEmployees();
      if (data.isNotEmpty) {
        for (Map<String, dynamic> e in data) {
          final employee = EmployeeModel(id: e["id"], empName: e["empName"], role: e["role"], ending_date: e["ending_date"], joining_date: e["joining_date"]);

          if (employee.ending_date == "") {
            employeeData.add(employee);
          } else {
            prevEmployeeData.add(employee);
          }

          // final DateTime dateTime = DateFormat('dd MMM yyyy').parse(employee.ending_date);

          // if (dateTime.isBefore(DateTime.now())) {
          // } else {
          //   employeeData.add(employee);
          // }
        }

        emit(state.copyWith(employees: employeeData, loadingState: false, prevEmployees: prevEmployeeData, modifyEmployeeList: false));
      } else {
        emit(state.copyWith(employees: [], loadingState: false, prevEmployees: [], modifyEmployeeList: false));
      }
    });
    on<AddEmployeeEvent>((event, emit) async {
      emit(state.copyWith(modifyEmployeeList: false));
      await databaseHelper.insertEmployee(event.empData.toMap());
      emit(state.copyWith(modifyEmployeeList: true, actionString: "Employee added to list"));
    });
    on<DeleteEmployeeEvent>((event, emit) async {
      emit(state.copyWith(modifyEmployeeList: false));
      await databaseHelper.moveEmployeeToDeletedTable(event.id);
      emit(state.copyWith(modifyEmployeeList: true, actionString: "Employee data deleted from list", lastDeleteEmployeeName: event.name));
    });
    on<UndoDeleteEvent>((event, emit) async {
      emit(state.copyWith(modifyEmployeeList: false));
      await databaseHelper.undoDelete(event.name);
      emit(state.copyWith(modifyEmployeeList: true, actionString: "Undo done"));
    });
    on<UpdateEmployeeEvent>((event, emit) async {
      emit(state.copyWith(modifyEmployeeList: false));
      await databaseHelper.updateEmployee(event.updatedData.toMap(), event.id);
      emit(state.copyWith(modifyEmployeeList: true, actionString: "Update Employee data"));
    });
    // on<ClearAllData>((event, emit) async {
    //   databaseHelper.clearAllData();
    // });
  }
}
