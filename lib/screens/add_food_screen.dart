import 'package:flutter/material.dart';

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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _servingSizeFocusNode.dispose();
    _servingUnitFocusNode.dispose();
    _servingsFocusNode.dispose();
    super.dispose();
  }

  List<bool> isSelected = [];
  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     final isImageUrlValid = _imageValidator(_imageUrlController.text);
  //     if (isImageUrlValid != null && _imagePreviewURL.isNotEmpty) {
  //       setState(() {
  //         _imagePreviewURL = '';
  //       });
  //     }
  //     if (isImageUrlValid == null &&
  //         _imagePreviewURL != _imageUrlController.text) {
  //       setState(() {
  //         _imagePreviewURL = _imageUrlController.text;
  //       });
  //     }
  //   }
  // }

  List<Step> stepsList() => [
        Step(
            title: const Text('Basic Information'),
            //subtitle: const Text('Enter your name'),
            isActive: true,
            //state: StepState.error,
            state: StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  focusNode: _nameFocusNode,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onSaved: (value) {},
                  maxLines: 1,
                  validator: (value) {},
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Food name',
                  ),
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  onSaved: (value) {},
                  maxLines: 3,
                  //initialValue: 'Aseem Wangoo',
                  validator: (value) {},
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context)
                  //       .requestFocus(_servingSizeFocusNode);
                  // },
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
                        autocorrect: false,
                        onSaved: (value) {},
                        maxLines: 1,
                        validator: (value) {},
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
                        autocorrect: false,
                        onSaved: (value) {},
                        maxLines: 1,
                        validator: (value) {},
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
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  onSaved: (value) {},
                  maxLines: 1,
                  validator: (value) {},
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
                    focusNode: _imageUrlFocusNode,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    onSaved: (value) {},
                    maxLines: 1,
                    validator: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4)),
                  width: double.infinity,
                  child: Center(
                    child: Icon(Icons.camera_alt),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  onSaved: (value) {},
                  maxLines: 1,
                  validator: (value) {},
                  decoration: InputDecoration(
                    labelText: 'more info...',
                  ),
                ),
              ],
            )),
        Step(
            title: const Text('Phone'),
            //subtitle: const Text('Subtitle'),
            isActive: true,
            //state: StepState.editing,
            state: StepState.indexed,
            content: TextFormField(
              keyboardType: TextInputType.phone,
              autocorrect: false,
              validator: (value) {},
              onSaved: (value) {},
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Enter your number',
                  hintText: 'Enter a number',
                  icon: const Icon(Icons.phone),
                  labelStyle:
                      TextStyle(decorationStyle: TextDecorationStyle.solid)),
            )),
        Step(
            title: const Text('Email'),
            // subtitle: const Text('Subtitle'),
            isActive: true,
            state: StepState.indexed,
            // state: StepState.disabled,
            content: TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: (value) {},
              onSaved: (value) {},
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'Enter a email address',
                  icon: const Icon(Icons.email),
                  labelStyle:
                      TextStyle(decorationStyle: TextDecorationStyle.solid)),
            )),
        Step(
            title: const Text('Age'),
            // subtitle: const Text('Subtitle'),
            isActive: true,
            state: StepState.indexed,
            content: TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: false,
              validator: (value) {},
              maxLines: 1,
              onSaved: (value) {},
              decoration: InputDecoration(
                  labelText: 'Enter your age',
                  hintText: 'Enter age',
                  icon: const Icon(Icons.explicit),
                  labelStyle:
                      TextStyle(decorationStyle: TextDecorationStyle.solid)),
            )),
      ];
  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState as FormState;

      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add Food')),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Stepper(
                physics: ClampingScrollPhysics(),
                steps: stepsList(),
                type: StepperType.vertical,
                currentStep: this.currStep,
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
                    if (currStep < stepsList().length - 1) {
                      currStep = currStep + 1;
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
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _submitDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
