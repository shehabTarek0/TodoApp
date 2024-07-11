import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'states.dart';
import '../../modules/archived_task/archived_screen.dart';
import '../../modules/done_task/done_task_screen.dart';
import '../../modules/new_task/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStatse());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedScreen(),
  ];
  List<String> titlesScreen = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  late Database db;
  bool isOpened = false;

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavStatse());
  }

  void toggleOpen() {
    isOpened = !isOpened;
    emit(AppChangeBottomSheetStatse());
  }

  void createdDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then(
          (value) {
            print('Table Created');
          },
        ).catchError((e) {
          print('Error is ${e.toString()}');
        });
      },
      onOpen: (db) {
        getData(db);
        print('database Opened');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatbase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await db.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","New")')
            .then((value) {
          print('$value inserted successfully');
          emit(AppInsertDatabaseState());
          getData(db);
        }).catchError((e) {
          print('Error is ${e.toString()}');
        }));
  }

  void getData(Database db) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      for (var e in value) {
        if (e['status'] == 'New') {
          newTasks.add(e);
        } else if (e['status'] == 'Done') {
          doneTasks.add(e);
        } else {
          archiveTasks.add(e);
        }
      }
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) {
    db.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      emit(AppUpdateDatabaseState());
      getData(db);
    });
  }

  void deleteData({
    required int id,
  }) {
    db.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      getData(db);
    });
  }
}
