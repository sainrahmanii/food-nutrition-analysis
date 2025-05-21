import 'package:flutter/material.dart';
import 'package:food_nutrition_analysis/global_variables.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class FoodNutritionComposition extends StatefulWidget {
  const FoodNutritionComposition({super.key});

  @override
  State<FoodNutritionComposition> createState() =>
      _FoodNutritionCompositionState();
}

class _FoodNutritionCompositionState extends State<FoodNutritionComposition> {
  XFile? imageFile;

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Nutrition\n Composition Analysis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: <Widget>[
            const Text(
              'unggah gambar makanan atau minuman\n yang ingin kamu ketahui komposisi nutrisinya\n dan kehalalannya',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            Container(
              width: 300,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepOrangeAccent,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        setState(() {
                          imageFile = value;
                        });
                      });
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      size: 100,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  const Text(
                    'unggah atau ambil foto',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                GenerativeModel model = GenerativeModel(
                    model: 'gemini-1.5-flash-latest', apiKey: apiKey);
                model.generateContent([]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                fixedSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Analisis Gambar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.rocket_launch_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
