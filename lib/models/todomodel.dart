
import 'package:hive/hive.dart';
part'todomodel.g.dart';



@HiveType(typeId: 1)
class Todo{
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime createdat;

  @HiveField(3)
  late bool completed;

  Todo({
    required this.title,
    required this.description,
    required this.createdat,
    required this.completed
  });
  

}