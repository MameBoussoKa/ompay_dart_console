import 'dart:io';
import '../service/auth_service.dart';
import '../service/compte_service.dart';
import '../view/auth_view.dart';
import '../view/compte_view.dart';

void _displayDashboard(Map<String, dynamic> data) {
  print('\n=== DASHBOARD ===\n');

  // User Info
  var user = data['user'];
  print(' Informations Utilisateur:');
  print('   Nom: ${user['prenom']} ${user['nom']}');
  print('   Téléphone: ${user['telephone']}');
  print('   Email: ${user['email'] ?? 'Non fourni'}');
  print('   Type: ${user['type']}');
  print('   Statut: ${user['statut']}');
  print('   Vérifié: ${user['is_verified'] ? 'Oui' : 'Non'}');
  print('');

  // Account Info
  var compte = data['compte'];
  if (compte != null) {
    print(' Informations Compte:');
    print('   Numéro de compte: ${compte['numero_compte']}');
    print('   Solde: ${compte['solde']} ${compte['devise']}');
    print('');
  } else {
    print(' Aucun compte associé.');
    print('');
  }

  // Recent Transactions
  var transactions = data['transactions'] as List<dynamic>;
  print(' Transactions Récentes:');
  if (transactions.isNotEmpty) {
    for (var tx in transactions) {
      String type = tx['type'];
      String typeDisplay = '';
      switch (type) {
        case 'payment':
          typeDisplay = 'Paiement';
          break;
        case 'transfer':
          typeDisplay = 'Transfert';
          break;
        case 'incoming_payment':
          typeDisplay = 'Paiement Reçu';
          break;
        case 'incoming_transfer':
          typeDisplay = 'Transfert Reçu';
          break;
        default:
          typeDisplay = type;
      }
      print('   ${typeDisplay}: ${tx['montant']} ${tx['devise']} - ${tx['date']} (${tx['statut']})');
    }
  } else {
    print('   Aucune transaction récente.');
  }
  print('\n=================\n');
}

Future<void> main() async {
  const baseUrl = 'http://127.0.0.1:8000/api';

  // Instantiate services
  final authService = AuthService(baseUrl);
  final compteService = CompteService(baseUrl);

  // Instantiate views with services
  final authView = AuthView(authService);
  final compteView = CompteView(compteService);

  String? token;

  while (true) {
    if (token == null) {
      // Show auth menu and get token
      token = await authView.handleAuth();
      if (token != null) {
        authService.setAuthToken(token);
        compteService.setAuthToken(token);
      }
    } else {
      // Show main menu after login
      print('\n=== Menu Principal ===');
      print('1. Mon Profil');
      print('2. Comptes');
      print('3. Déconnexion');
      print('4. Exit');
      print('Choisissez une option: ');

      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          try {
            var result = await compteService.me();
            if (result['success'] == true) {
              var data = result['data'];
              _displayDashboard(data);
            } else {
              print('Erreur: ${result['message']}');
            }
          } catch (e) {
            print('Erreur: $e');
          }
          print('Appuyez sur Entrée pour continuer...');
          stdin.readLineSync();
          break;
        case '2':
          await compteView.handleCompte();
          break;
        case '3':
          try {
            await authService.logout();
            token = null;
            print('Déconnexion réussie!');
          } catch (e) {
            print('Erreur de déconnexion: $e');
          }
          break;
        case '4':
          return;
        default:
          print('Option invalide. Réessayez.');
      }
    }
  }
}
