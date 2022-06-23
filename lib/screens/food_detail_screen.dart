import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/food.dart';

class FoodDetailScreen extends StatelessWidget {
  static const routeName = '/food-detail';

  @override
  Widget build(BuildContext context) {
    var food = ModalRoute.of(context)!.settings.arguments as Food;
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //color: Colors.amber,
              width: double.infinity,
              height: 200,
              child: Image.network(
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                food.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Name: ${food.name}'),
            Text('Description: ${food.description}'),
            Text('Servings: ${food.servings}'),
            Text('Serving Size: ${food.servingSize} ${food.servingUnit}'),
            Text('Calories: ${food.nutritions?.calories}'),
            Text('Carbohydrates: ${food.nutritions?.carbohydrates}'),
            Text('Fats: ${food.nutritions?.fat}'),
            Text('Protein: ${food.nutritions?.protein}'),
          ],
        ),
      ),
    );
  }
}
