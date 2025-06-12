import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_nutrition_analysis/loading_page.dart';
import 'package:food_nutrition_analysis/result_page.dart';
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

  final apiKey = dotenv.env["API_KEY"] ?? "";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      imageFile = null;
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
                  if (imageFile != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(imageFile!.path),
                            width: 300,
                            height: 175,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _showPickerOptions,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 100,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (imageFile == null) {
                  // Pop-up jika gambar belum ditambahkan
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 32,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Gambar Belum Ada!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        'Silakan tambahkan gambar terlebih dahulu sebelum melakukan analisis.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepOrangeAccent,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'OK',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoadingPage();
                    },
                  ),
                );

                try {
                  final model = GenerativeModel(
                    model: 'gemini-1.5-flash-latest',
                    apiKey: apiKey,
                    systemInstruction: Content.system(
                      '''
                        Kamu adalah seorang nutrisionis yang ahli dalam menganalisis komposisi nutrisi makanan.
                        Tugas kamu adalah memberikan analisis yang akurat dan komprehensif tentang komposisi nutrisi, kandungan gizi, dan kehalalan dari gambar makanan yang diberikan.
                        Kamu harus memberikan informasi yang jelas dan mudah dipahami estimasi gramasi pada komposisi nutrisinya, sebutkan vitamin yang terkandung tanpa penjelasan, serta menyertakan rekomendasi jika diperlukan.
                        Pastikan untuk selalu memberikan informasi yang sesuai dengan gambar yang diberikan.
                        Jika gambar tidak jelas atau tidak dapat dianalisis, berikan penjelasan yang sesuai.
                        berikan saya dalam json saja, tanpa penjelasan tambahan dengan format berikut:
                        {
                          "nama_makanan": "nama makanan",
                          "komposisi_nutrisi": {
                            "karbohidrat": "jumlah karbohidrat",
                            "protein": "jumlah protein",
                            "lemak": "jumlah lemak",
                            "serat": "jumlah serat",
                            "vitamin": "jenis vitamin"
                          },
                          "kehalalan": "status kehalalan (halal atau tidak halal)",
                          infromasi tambahan: "informasi tambahan jika ada"
                        }
                      ''',
                    ),
                  );

                  final imageBytes = await imageFile!.readAsBytes();
                  final imagePart = DataPart('image/jpeg', imageBytes);

                  final response = await model.generateContent([
                    Content.multi([
                      imagePart,
                      TextPart(
                        'Analisis gambar ini sesuai dengan instruksi',
                      ),
                    ])
                  ]);

                  try {
                    final cleanJsonString = response.text!
                        .replaceAll("```json", "")
                        .replaceAll("```", "")
                        .trim();

                    final jsonData = jsonDecode(cleanJsonString);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultPage(data: jsonData),
                      ),
                    );
                  } catch (e) {
                    print("Parsing Error: ${response.text}");
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Format Tidak Valid"),
                        content: Text(
                            "Respons dari AI bukan JSON.\n\n${response.text}"),
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // Tutup halaman loading
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Terjadi Kesalahan"),
                      content: Text(e.toString()),
                    ),
                  );
                }
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
