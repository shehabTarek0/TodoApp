import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (context, state) {
        if (AppCubit.get(context).archiveTasks.isNotEmpty) {
          var task = AppCubit.get(context).archiveTasks;
          return buildItems(context, task);
        } else {
          return noTasks();
        }
      },
      listener: (context, state) {},
    );
  }
}
