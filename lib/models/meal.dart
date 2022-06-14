// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'food.dart';
import 'recipe.dart';

class Meal {
  String id;
  String name;
  List<dynamic> items;
  List<String> directions;
  Meal({
    required this.id,
    required this.name,
    required this.items,
    required this.directions,
  });

  Meal copyWith({
    String? id,
    String? name,
    List<dynamic>? items,
    List<String>? directions,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      directions: directions ?? this.directions,
    );
  }
}
