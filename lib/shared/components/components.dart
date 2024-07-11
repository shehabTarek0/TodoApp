import 'package:flutter/material.dart';

import '../../layout/cubit/cubit.dart';

Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType inputType,
        required FormFieldValidator validator,
        String? text,
        String? labelText,
        GestureTapCallback? tap,
        int? numOfLines,
        InputBorder? border,
        Icon? prefix,
        Icon? suffix,
        VoidCallback? onPressedSuffix,
        bool enabel = true,
        ValueChanged? submit,
        bool isPassword = false}) =>
    TextFormField(
      onFieldSubmitted: submit,
      onTap: tap,
      enabled: enabel,
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      obscureText: isPassword,
      maxLines: numOfLines,
      decoration: InputDecoration(
          hintText: text,
          labelText: labelText,
          suffixIcon: suffix != null
              ? IconButton(onPressed: onPressedSuffix, icon: suffix)
              : null,
          prefixIcon: prefix,
          border: border),
    );

Widget space() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 1,
        color: const Color.fromARGB(137, 164, 161, 161),
      ),
    );

Widget taskItem(Map task, context) => Dismissible(
      direction: DismissDirection.horizontal,
      background: Container(
          alignment: Alignment.centerLeft,
          color: const Color.fromARGB(255, 223, 58, 58),
          child: const Icon(
            Icons.delete,
            size: 40,
            color: Color.fromARGB(255, 232, 231, 231),
          )),
      key: Key(task['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: task['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color.fromARGB(255, 183, 192, 193),
              child: Text(
                '${task['time']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${task['title']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${task['date']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'Done', id: task['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Color.fromARGB(255, 90, 211, 94),
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'Archive', id: task['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );

Widget buildItems(context, List<Map> task) => ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: task.length,
      separatorBuilder: (BuildContext context, int index) {
        return space();
      },
      itemBuilder: (BuildContext context, int index) {
        return taskItem(task[index], context);
      },
    );

Widget noTasks() => const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_outlined,
            color: Colors.black45,
            size: 70,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
