import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_employee_management/ui/screens/employee_list.dart';
import 'bloc/employee_list_bloc.dart';
import 'helpers/db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();
  databaseHelper.initDatabase().then((value) {
    runApp(MultiBlocProvider(providers: [
      BlocProvider<EmployeeListBloc>(
        create: (context) => EmployeeListBloc(databaseHelper)..add(FetchEmployeeListEvent()),
      )
    ], child: const MyApp()));
  }); // Create an instance of db helper class
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Manager',
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(elevation: 0),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EmployeeList(),
    );
  }
}
