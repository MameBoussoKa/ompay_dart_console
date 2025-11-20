import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // URL de ton API Laravel
  final url = Uri.parse('http://127.0.0.1:8000/api/register');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Réponse API :");
      print(data);
    } else {
      print("Erreur serveur : ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur de connexion : $e");
  }
}
