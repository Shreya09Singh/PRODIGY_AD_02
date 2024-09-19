import 'package:hive/hive.dart';

part 'NotesModel.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  NotesModel({required this.title, required this.content});
}
