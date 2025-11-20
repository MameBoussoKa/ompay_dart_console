import 'dart:io';
import '../service/compte_service.dart';

class CompteView {
  final CompteService compteService;

  CompteView(this.compteService);

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

  void displayMenu() {
    print('=== Compte Menu ===');
    print('1. Profil');
    print('2. Voir Solde');
    print('3. Payer');
    print('4. Transferer');
    print('5. Liste des Transactions');
    print('6. Retour');
    print('Choisir une option: ');
  }

  Future<void> handleCompte() async {
    while (true) {
      displayMenu();
      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          await getMe();
          break;
        case '2':
          await getSolde();
          break;
        case '3':
          await pay();
          break;
        case '4':
          await transfer();
          break;
        case '5':
          await getTransactions();
          break;
        case '6':
          return;
        default:
          print('Invalid option. Try again.');
      }
    }
  }

  Future<void> getMe() async {
    try {
      var result = await compteService.me();
      if (result['success'] == true) {
        var data = result['data'];
        _displayDashboard(data);
      } else {
        print('Erreur: ${result['message']}');
      }
    } catch (e) {
      print('Failed to get my info: $e');
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }

  Future<void> getSolde() async {
    try {
      // First get user info to retrieve account ID
      var meResult = await compteService.me();
      if (meResult['success'] == true) {
        var compte = meResult['data']['compte'];
        if (compte != null) {
          String compteId = compte['id'].toString();
          var result = await compteService.getSolde(compteId);
          if (result['success'] == true) {
            var data = result['data'];
            print('=== SOLDE DU COMPTE ===');
            print('Numéro de compte: ${data['numeroCompte']}');
            print('Solde: ${data['solde']} ${data['devise']}');
            print('========================');
          } else {
            print('Erreur: ${result['message']}');
          }
        } else {
          print('Aucun compte associé à cet utilisateur.');
        }
      } else {
        print('Erreur lors de la récupération des informations utilisateur: ${meResult['message']}');
      }
    } catch (e) {
      print('Failed to get solde: $e');
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }

  Future<void> pay() async {
    try {
      // First get user info to retrieve account ID
      var meResult = await compteService.me();
      if (meResult['success'] == true) {
        var compte = meResult['data']['compte'];
        if (compte != null) {
          String compteId = compte['id'].toString();

          print('Enter montant: ');
          String? montantStr = stdin.readLineSync();
          print('Enter recipient telephone (or leave empty): ');
          String? recipientTelephone = stdin.readLineSync();
          print('Enter marchand code (or leave empty): ');
          String? marchandCode = stdin.readLineSync();

          if (montantStr != null) {
            double? montant = double.tryParse(montantStr);
            if (montant != null) {
              Map<String, dynamic> data = {'montant': montant};
              if (recipientTelephone != null && recipientTelephone.isNotEmpty) {
                data['recipient_telephone'] = recipientTelephone;
              }
              if (marchandCode != null && marchandCode.isNotEmpty) {
                data['marchand_code'] = marchandCode;
              }
              var result = await compteService.pay(compteId, data);
              if (result['success'] == true) {
                print('Paiement effectué avec succès!');
                print('Nouveau solde: ${result['data']['nouveau_solde']} ${compte['devise']}');
              } else {
                print('Erreur: ${result['message']}');
              }
            } else {
              print('Montant invalide.');
            }
          }
        } else {
          print('Aucun compte associé à cet utilisateur.');
        }
      } else {
        print('Erreur lors de la récupération des informations utilisateur: ${meResult['message']}');
      }
    } catch (e) {
      print('Payment failed: $e');
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }

  Future<void> transfer() async {
    try {
      // First get user info to retrieve account ID
      var meResult = await compteService.me();
      if (meResult['success'] == true) {
        var compte = meResult['data']['compte'];
        if (compte != null) {
          String compteId = compte['id'].toString();

          print('Enter destinataire telephone: ');
          String? destinataireTelephone = stdin.readLineSync();
          print('Enter montant: ');
          String? montantStr = stdin.readLineSync();

          if (destinataireTelephone != null && montantStr != null) {
            double? montant = double.tryParse(montantStr);
            if (montant != null) {
              var result = await compteService.transfer(compteId, {
                'destinataire_telephone': destinataireTelephone,
                'montant': montant
              });
              if (result['success'] == true) {
                print('Transfert effectué avec succès!');
                print('Nouveau solde: ${result['data']['nouveau_solde']} ${compte['devise']}');
              } else {
                print('Erreur: ${result['message']}');
              }
            } else {
              print('Montant invalide.');
            }
          }
        } else {
          print('Aucun compte associé à cet utilisateur.');
        }
      } else {
        print('Erreur lors de la récupération des informations utilisateur: ${meResult['message']}');
      }
    } catch (e) {
      print('Transfer failed: $e');
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }

  Future<void> getTransactions() async {
    try {
      // First get user info to retrieve account ID
      var meResult = await compteService.me();
      if (meResult['success'] == true) {
        var compte = meResult['data']['compte'];
        if (compte != null) {
          String compteId = compte['id'].toString();

          print('Enter page (optional): ');
          String? pageStr = stdin.readLineSync();
          print('Enter per_page (optional): ');
          String? perPageStr = stdin.readLineSync();

          int? page = pageStr != null && pageStr.isNotEmpty ? int.tryParse(pageStr) : null;
          int? perPage = perPageStr != null && perPageStr.isNotEmpty ? int.tryParse(perPageStr) : null;

          var result = await compteService.getTransactions(compteId, page: page, perPage: perPage);
          if (result['success'] == true) {
            var data = result['data'];
            print('=== HISTORIQUE DES TRANSACTIONS ===');
            var transactions = data['transactions'] as List<dynamic>;
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
                print('${typeDisplay}: ${tx['montant']} ${tx['devise']} - ${tx['date']} (${tx['statut']})');
              }
            } else {
              print('Aucune transaction trouvée.');
            }
            var pagination = data['pagination'];
            print('Page ${pagination['current_page']} sur ${pagination['total']} transactions');
          } else {
            print('Erreur: ${result['message']}');
          }
        } else {
          print('Aucun compte associé à cet utilisateur.');
        }
      } else {
        print('Erreur lors de la récupération des informations utilisateur: ${meResult['message']}');
      }
    } catch (e) {
      print('Failed to get transactions: $e');
    }
    print('Press Enter to continue...');
    stdin.readLineSync();
  }
}