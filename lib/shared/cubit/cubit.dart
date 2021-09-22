// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/modules/archived_screen/archived_screen.dart';
import 'package:to_do/modules/done_screen/done_screen.dart';
import 'package:to_do/modules/new_task_screen/new_task_screen.dart';
import 'package:to_do/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTaskScreen(),
    const DoneScreen(),
    const ArchivedScreen(),
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late bool isBottomSheetShown = false;
  late IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  late Database database;

  void createDatabase() async {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("database Created");
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
          .then((value) => print("Table Created"));
    }, onOpen: (database) {
      print("database Opended");
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time , status) VALUES("$title" , "$date" , "$time" , "new")')
            .then((value) {
          print("$value inserted Successfully");
          emit(AppInsertDatabaseState());
          getDataFromDatabase(database);
        }));
// await database.rawInsert('INSERT INTO tasks(title,data,time , status) VALUES("first title" , "237" , "12" , "new")').then((value) => [print("$value inserted Successfully")]);
  }

  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('Select * From tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetDataFromDatabaseState());
    });
  }

  void updateDatabase({required String status, required int id}) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({required int id}) async {
    await database
        .rawUpdate('Delete From tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }
}






















//   void createDatabase() {
//     openDatabase('todo.db', version: 1, onCreate: (database, version) {
//       print("database Created");
//       database
//           .execute(
//               'CREATE TABLE tasks(id INTEGER PRIMARY KEY , time TEXT , title TEXT , date TEXT , status TEXT)')
//           .then((value) => print("Table Created"));
//     }, onOpen: (database) {
//       getDataFromDatabase(database);
//       print('database opend');
//     }).then((value) {
//       database = value;
//       emit(AppCreateDatabaseState());
//     });
//   }

// ///////////////////      insert to database    //////////////////////

//   insertToDatabase({
//     required String time,
//     required String title,
//     required String date,
//   }) async {
//     await database.transaction((txn) => txn
//             .rawInsert(
//                 'INSERT INTO tasks(time,title,date , status) VALUES("$time" , "$title" , "$date" , "new")')
//             .then((value) {
//           emit(AppInsertDatabaseState());
//           print("$value inserted Successfully");
//           getDataFromDatabase(database);
//         }));
//   }

// ///////////////////      Get Data from  Database    //////////////////////////
//   void getDataFromDatabase(database) {
//     newtasks = [];
//     donetasks = [];
//     archivedtasks = [];

//     emit(AppGetDatabaseLoadingState());
//     database.rawQuery('SELECT * FROM tasks').then((value) {
//       value.forEach((element) {
//         if (element['status'] == 'new')
//           newtasks.add(element);
//         else if (element['status'] == 'done')
//           donetasks.add(element);
//         else
//           archivedtasks.add(element);
//       });

//       emit(AppGetDataFromDatabaseState());
//     });
//   }

//   void upDateDatabse({required int id, required String status}) async {
//     database.rawUpdate(
//         'UPDATE tasks SET status = ? WHERE id =?', [id, status]).then((value) {
//       emit(AppUpdateDataBaseState());
//     });
//   }
// }
