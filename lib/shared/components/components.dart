// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/cubit.dart';

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({required this.model, required this.disKey});

  final Map model;
  final String disKey;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(disKey),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            )),
            const SizedBox(
              width: 12.0,
            ),
            IconButton(
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'done', id: model['id']);
                }),
            const SizedBox(
              width: 12.0,
            ),
            IconButton(
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black45,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'Archived', id: model['id']);
                }),
          ],
        ),
      ),
      onDismissed: (dir) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );
  }
}

class CustomListView extends StatelessWidget {
  const CustomListView({required this.map});
  final List<Map> map;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return BuildTaskItem(
              model: map[index], disKey: map[index]['id'].toString());
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          );
        },
        itemCount: map.length);
  }
}
