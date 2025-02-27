import 'package:hive/hive.dart';

part 'categoryModel.g.dart';

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryName,
  });
}
