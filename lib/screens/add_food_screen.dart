import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firestore_search/firestore_search.dart';

import '../models/food.dart';
import '../providers/foods.dart';
import '../widgets/cloud_firestore_search.dart';

class AddFoodScreen extends StatefulWidget {
  static const routeName = '/add-food';

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  int currStep = 0;

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _servingSizeFocusNode = FocusNode();
  final _servingUnitFocusNode = FocusNode();
  final _servingsFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _caloriesFocusNode = FocusNode();
  final _carbohydratesFocusNode = FocusNode();
  final _fatsFocusNode = FocusNode();
  final _proteinFocusNode = FocusNode();

  var _imagePreviewURL = '';
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _servingUnitController = TextEditingController();
  final _servingsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _fatsController = TextEditingController();
  final _proteinController = TextEditingController();
  var mealType = '';
  var date;
  Map<String, dynamic> formValues = {};
  Foods? foodItems;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  List<bool> isSelected = [];

  String name = '';
  FirebaseFirestore db = FirebaseFirestore.instance;

  void initialize() async {
    foodItems = await Provider.of<Foods>(context, listen: false);
    foodItems?.fetchAndSetFoods(date);
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _servingSizeFocusNode.dispose();
    _servingUnitFocusNode.dispose();
    _servingsFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _caloriesFocusNode.dispose();
    _carbohydratesFocusNode.dispose();
    _fatsFocusNode.dispose();
    _proteinFocusNode.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _servingSizeController.dispose();
    _servingUnitController.dispose();
    _servingsController.dispose();
    _imageUrlController.dispose();
    _caloriesController.dispose();
    _carbohydratesController.dispose();
    _fatsController.dispose();
    _proteinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    isSelected = [true, false];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    mealType = (ModalRoute.of(context)!.settings.arguments as List)[0];
    date = (ModalRoute.of(context)!.settings.arguments as List)[1];
    // print(mealType);
    initialize();
    super.didChangeDependencies();
  }

  /* function for updating imagePreview on url input */
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      final isImageUrlValid = _imageValidator(_imageUrlController.text);
      if (isImageUrlValid != null && _imagePreviewURL.isNotEmpty) {
        setState(() {
          _imagePreviewURL = '';
        });
      }
      if (isImageUrlValid == null &&
          _imagePreviewURL != _imageUrlController.text) {
        setState(() {
          _imagePreviewURL = _imageUrlController.text;
        });
      }
    }
  }

  Widget createTextWidget(String text, String value) {
    return Row(
      children: [
        Text(
          '$text: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Container(
            child: Text(
              value,
              overflow: value.length > 10 ? TextOverflow.ellipsis : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget createImagePreview() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(4)),
          width: double.infinity,
          child: _imagePreviewURL.isEmpty
              ? Center(
                  child: Icon(Icons.camera_alt),
                )
              : FittedBox(
                  child: Image.network(
                    _imagePreviewURL,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ],
    );
  }

  String? _imageValidator(String imgUrl) {
    if (imgUrl.isEmpty) {
      return 'Please enter an image URL.';
    }
    if (!(Uri.tryParse(imgUrl)?.hasAbsolutePath ?? false)) {
      return 'Please enter a valid URL.';
    }
    if (!imgUrl.endsWith('.png') &&
        !imgUrl.endsWith('.jpg') &&
        !imgUrl.endsWith('.jpeg')) {
      return 'Please enter a valid image URL.';
    }
    return null;
  }

  String? _stringValidator(String text) {
    if (text.isEmpty) {
      return 'can\'t be empty';
    }
    if (double.tryParse(text) != null) {
      return 'can\'t be a number';
    }
    return null;
  }

  String? _numberValidator(String text) {
    if (text.isEmpty) {
      return 'can\'t be empty';
    }
    if (double.tryParse(text) == null) {
      return 'must be a number';
    }
    return null;
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitDetails() {
    bool flag = false;
    _formKeys.forEach((formKey) {
      final FormState formState = formKey.currentState as FormState;
      if (!formState.validate()) {
        flag = false;
        showSnackBarMessage('Please enter correct data');
      } else {
        flag = true;
        formState.save();
      }
    });
    if (flag) {
      formValues.addAll({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'mealType': mealType,
        'servingSize': _servingSizeController.text,
        'servingUnit': _servingUnitController.text,
        'servings': _servingsController.text,
        'imageUrl': _imageUrlController.text,
        'nutritions': {
          'calories': _caloriesController.text,
          'carbohydrates': _carbohydratesController.text,
          'fats': _fatsController.text,
          'protein': _proteinController.text,
        },
        'categories': [mealType],
      });
      Food food = Food.fromJson(formValues);
      foodItems?.addFood(food, date);
    }
  }

  List<Step> stepsList() => [
        Step(
          title: const Text('Basic Information'),
          isActive: true,
          state: StepState.indexed,
          content: Form(
            key: _formKeys[0],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  focusNode: _nameFocusNode,
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  onSaved: (value) {},
                  validator: (value) {
                    return _stringValidator(value as String);
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Food name',
                  ),
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {},
                  maxLines: 3,
                  validator: (value) {
                    return _stringValidator(value as String);
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        focusNode: _servingSizeFocusNode,
                        controller: _servingSizeController,
                        onSaved: (value) {},
                        validator: (value) {
                          return _numberValidator(value as String);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_servingUnitFocusNode);
                        },
                        decoration: InputDecoration(
                          labelText: 'Serving Size',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        focusNode: _servingUnitFocusNode,
                        controller: _servingUnitController,
                        onSaved: (value) {},
                        validator: (value) {
                          return _stringValidator(value as String);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_servingsFocusNode);
                        },
                        decoration: InputDecoration(
                          labelText: 'Serving Unit',
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  focusNode: _servingsFocusNode,
                  controller: _servingsController,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {},
                  maxLines: 1,
                  validator: (value) {
                    return _numberValidator(value as String);
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Servings',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Image Upload:'),
                SizedBox(
                  height: 20,
                ),
                ToggleButtons(
                  children: [
                    Text('URL'),
                    Text('Local'),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        isSelected[buttonIndex] = buttonIndex == index;
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
                if (isSelected[0])
                  TextFormField(
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    keyboardType: TextInputType.url,
                    //autovalidateMode: AutovalidateMode.always,
                    onSaved: (value) {},
                    validator: (value) {
                      return _imageValidator(value as String);
                    },
                    onFieldSubmitted: (_) {
                      setState(() {
                        if (currStep < stepsList().length - 1) {
                          currStep++;
                        } else {
                          currStep = 0;
                        }
                      });
                      FocusScope.of(context).requestFocus(_caloriesFocusNode);
                    },
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                    ),
                  ),
                createImagePreview(),
              ],
            ),
          ),
        ),
        Step(
            title: const Text('Nutritions'),
            isActive: true,
            state: StepState.indexed,
            content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _caloriesFocusNode,
                    keyboardType: TextInputType.number,
                    controller: _caloriesController,
                    validator: (value) {
                      return _numberValidator(value as String);
                    },
                    onSaved: (value) {},
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_carbohydratesFocusNode);
                    },
                    decoration: InputDecoration(
                      labelText: 'Calories',
                    ),
                  ),
                  TextFormField(
                    focusNode: _carbohydratesFocusNode,
                    keyboardType: TextInputType.number,
                    controller: _carbohydratesController,
                    validator: (value) {
                      return _numberValidator(value as String);
                    },
                    onSaved: (value) {},
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_fatsFocusNode);
                    },
                    decoration: InputDecoration(
                      labelText: 'Carbohydrates value',
                    ),
                  ),
                  TextFormField(
                    focusNode: _fatsFocusNode,
                    keyboardType: TextInputType.number,
                    controller: _fatsController,
                    validator: (value) {
                      return _numberValidator(value as String);
                    },
                    onSaved: (value) {},
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_proteinFocusNode);
                    },
                    decoration: InputDecoration(
                      labelText: 'Fats value',
                    ),
                  ),
                  TextFormField(
                    focusNode: _proteinFocusNode,
                    keyboardType: TextInputType.number,
                    controller: _proteinController,
                    validator: (value) {
                      return _numberValidator(value as String);
                    },
                    onSaved: (value) {},
                    onFieldSubmitted: (_) {
                      setState(() {
                        if (currStep < stepsList().length - 1) {
                          currStep++;
                        } else {
                          currStep = 0;
                        }
                      });
                      FocusScope.of(context).requestFocus(_proteinFocusNode);
                    },
                    decoration: InputDecoration(
                      labelText: 'Protein value',
                    ),
                  ),
                ],
              ),
            )),
        Step(
          title: const Text('Review'),
          isActive: true,
          state: StepState.indexed,
          content: Column(children: [
            createTextWidget('Name', _nameController.text),
            createTextWidget('Description', _descriptionController.text),
            createTextWidget('Serving Size', _servingSizeController.text),
            createTextWidget('Serving Unit', _servingUnitController.text),
            createTextWidget('Servings', _servingsController.text),
            createTextWidget('Image Url', _imageUrlController.text),
            createTextWidget('Calories', _caloriesController.text),
            createTextWidget(
                'Carbohydrates (gram)', _carbohydratesController.text),
            createTextWidget('Fats (gram)', _fatsController.text),
            createTextWidget('Protein (gram)', _proteinController.text),
            createImagePreview(),
          ]),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Food'),
          bottom: TabBar(tabs: [
            Tab(
              text: 'Add Existing Food',
            ),
            Tab(
              text: 'Create new Food',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            CloudFirestoreSearch(mealType: mealType, date: date),
            Container(
              child: ListView(
                children: <Widget>[
                  Stepper(
                    physics: ClampingScrollPhysics(),
                    steps: stepsList(),
                    type: StepperType.vertical,
                    currentStep: currStep,
                    controlsBuilder: (ctx, ControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('BACK'),
                          ),
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: const Text('NEXT'),
                          ),
                        ],
                      );
                    },
                    onStepContinue: () {
                      setState(() {
                        if (currStep == stepsList().length - 1) {
                          _submitDetails();
                        } else if (currStep < stepsList().length - 1) {
                          currStep++;
                        } else {
                          currStep = 0;
                        }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (currStep > 0) {
                          currStep = currStep - 1;
                        } else {
                          currStep = 0;
                        }
                      });
                    },
                    onStepTapped: (step) {
                      setState(() {
                        currStep = step;
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Save details',
                    ),
                    onPressed: _submitDetails,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
