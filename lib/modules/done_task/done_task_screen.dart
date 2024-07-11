import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        if (AppCubit.get(context).doneTasks.isNotEmpty) {
          var task = AppCubit.get(context).doneTasks;
          return buildItems(context, task);
        } else {
          return noTasks();
        }
      },
      listener: (context, state) {},
    );
  }
}
