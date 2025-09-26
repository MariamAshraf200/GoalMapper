import 'package:hive/hive.dart';
import '../../domain/entities/taskPlan.dart';

class TaskPlanAdapter extends TypeAdapter<TaskPlan> {
  @override
  final int typeId = 4; // Make sure this is unique in your project

  @override
  TaskPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskPlan(
      id: fields[0] as String,
      text: fields[1] as String,
      status: TaskPlanStatus.values[fields[2] as int],
    );
  }

  @override
  void write(BinaryWriter writer, TaskPlan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.status.index);
  }
}

