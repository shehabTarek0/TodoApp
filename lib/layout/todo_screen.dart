import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import '../shared/components/components.dart';
import '../shared/constants/constants.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createdDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppCubit.get(context)
                    .titlesScreen[AppCubit.get(context).currentIndex],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                if (AppCubit.get(context).isOpened) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context)
                        .insertToDatbase(
                            title: titleTaskController.text,
                            time: timeTaskController.text,
                            date: dateTaskController.text)
                        .then((value) {
                      titleTaskController.text = '';
                      timeTaskController.text = '';
                      dateTaskController.text = '';
                    });
                  }
                } else {
                  AppCubit.get(context).toggleOpen();
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => textItems(context),
                      )
                      .closed
                      .then((value) {
                    AppCubit.get(context).toggleOpen();
                    titleTaskController.text = '';
                    timeTaskController.text = '';
                    dateTaskController.text = '';
                  });
                }
              },
              child: AppCubit.get(context).isOpened
                  ? const Icon(Icons.add)
                  : const Icon(Icons.mode_edit_outline_outlined),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_rounded,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (value) {
                AppCubit.get(context).changeBottomNav(value);
              },
            ),
            body: AppCubit.get(context)
                .screens[AppCubit.get(context).currentIndex],
          );
        },
      ),
    );
  }

  Widget textItems(context) => Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[200],
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              defaultTextFormField(
                controller: titleTaskController,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title must be not empty';
                  } else {
                    return null;
                  }
                },
                border: const OutlineInputBorder(),
                labelText: 'Title Task',
                prefix: const Icon(
                  Icons.title,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              defaultTextFormField(
                tap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    timeTaskController.text = value!.format(context).toString();
                  });
                },
                controller: timeTaskController,
                inputType: TextInputType.datetime,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'time  must be not empty';
                  } else {
                    return null;
                  }
                },
                border: const OutlineInputBorder(),
                labelText: 'Time Task',
                prefix: const Icon(
                  Icons.watch_later_outlined,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              defaultTextFormField(
                controller: dateTaskController,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'date must be not empty';
                  } else {
                    return null;
                  }
                },
                tap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse('2100-12-31'),
                  ).then((value) {
                    dateTaskController.text = DateFormat.yMMMd().format(value!);
                  });
                },
                border: const OutlineInputBorder(),
                labelText: 'Date Task',
                prefix: const Icon(
                  Icons.date_range_outlined,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      );
}
