import 'package:realm/realm.dart';

part 'models.realm.dart';

@RealmModel()
class _Category {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late String color;
  late DateTime? updatedAt;
  late DateTime? createdAt;
}

@RealmModel()
class _Note {
  @PrimaryKey()
  late ObjectId id;

  late String title;
  late String? content;
  late String? password;
  late DateTime? updatedAt;
  late DateTime? createdAt;
  late _Category? category;
}
