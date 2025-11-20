import 'dart:io';
import '../service/auth_service.dart';

class AuthView {
  final AuthService authService;

  AuthView(this.authService);

  void displayMenu() {
    print('=== Auth Menu ===');
    print('1. S inscrire');
    print('2. Valider l inscription');
    print('3. Se connecter');
    print('4. Se deconnecter');
    print('5. Quitter');
    print('Choisir une option: ');
  }

  Future<String?> handleAuth() async {
    while (true) {
      displayMenu();
      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          await register();
          break;
        case '2':
          await confirmSms();
          break;
        case '3':
          String? token = await login();
          if (token != null) return token;
          break;
        case '4':
          await logout();
          break;
        case '5':
          return null;
        default:
          print('Invalid option. Try again.');
      }
    }
  }

  Future<void> register() async {
    print('Enter username: ');
    String? username = stdin.readLineSync();
    print('Enter password: ');
    String? password = stdin.readLineSync();
    print('Enter nom: ');
    String? nom = stdin.readLineSync();
    print('Enter prenom: ');
    String? prenom = stdin.readLineSync();
    print('Enter telephone: ');
    String? telephone = stdin.readLineSync();

    if (username != null && password != null && nom != null && prenom != null && telephone != null) {
      try {
        var result = await authService.register(username, password, nom, prenom, telephone);
        print(result['message']);
      } catch (e) {
        print('Registration failed: $e');
      }
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }

  Future<void> confirmSms() async {
    print('Enter telephone: ');
    String? telephone = stdin.readLineSync();
    print('Enter confirmation code: ');
    String? code = stdin.readLineSync();

    if (telephone != null && code != null) {
      try {
        var result = await authService.confirmSms(telephone, code);
        print(result['message']);
      } catch (e) {
        print('SMS confirmation failed: $e');
      }
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }

  Future<String?> login() async {
    print('Enter phone number: ');
    String? phoneNumber = stdin.readLineSync();
    print('Enter password: ');
    String? password = stdin.readLineSync();

    if (phoneNumber != null && password != null) {
      try {
        var result = await authService.login(phoneNumber, password);
        if (result['success'] == true) {
          print(result['message']);
          return result['data']['token'];
        } else {
          print('Login failed: ${result['message']}');
        }
      } catch (e) {
        print('Login failed: $e');
      }
    }
    return null;
  }

  Future<void> logout() async {
    try {
      var result = await authService.logout();
      print(result['message']);
    } catch (e) {
      print('Logout failed: $e');
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }
}