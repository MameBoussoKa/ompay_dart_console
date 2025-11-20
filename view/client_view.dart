import 'dart:io';
import '../service/client_service.dart';

class ClientView {
  final ClientService clientService;

  ClientView(this.clientService);

  void displayMenu() {
    print('=== Client Menu ===');
    print('1. Lister les Clients');
    print('2. Rechercher un  Client par son ID');
    print('3. Creer un Client');
    print('4. Modifier un Client');
    print('5. Supprimer un Client');
    print('6. Retour');
    print('Choisir une option: ');
  }

  void handleClient() {
    while (true) {
      displayMenu();
      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          listClients();
          break;
        case '2':
          getClient();
          break;
        case '3':
          createClient();
          break;
        case '4':
          updateClient();
          break;
        case '5':
          deleteClient();
          break;
        case '6':
          return;
        default:
          print('Invalid option. Try again.');
      }
    }
  }

  void listClients() {
    try {
      var result = clientService.getClients();
      print('Clients: $result');
    } catch (e) {
      print('Failed to list clients: $e');
    }
  }

  void getClient() {
    print('Enter client ID: ');
    String? idStr = stdin.readLineSync();
    if (idStr != null) {
      int? id = int.tryParse(idStr);
      if (id != null) {
        try {
          var result = clientService.getClient(id);
          print('Client: $result');
        } catch (e) {
          print('Failed to get client: $e');
        }
      }
    }
  }

  void createClient() {
    print('Enter name: ');
    String? name = stdin.readLineSync();
    print('Enter phone: ');
    String? phone = stdin.readLineSync();
    print('Enter address: ');
    String? address = stdin.readLineSync();
    if (name != null && phone != null && address != null) {
      try {
        var result = clientService.createClient({
          'name': name,
          'phone': phone,
          'address': address,
        });
        print('Client created: $result');
      } catch (e) {
        print('Failed to create client: $e');
      }
    }
  }

  void updateClient() {
    print('Enter client ID: ');
    String? idStr = stdin.readLineSync();
    print('Enter new name: ');
    String? name = stdin.readLineSync();
    if (idStr != null && name != null) {
      int? id = int.tryParse(idStr);
      if (id != null) {
        try {
          var result = clientService.updateClient(id, {'name': name});
          print('Client updated: $result');
        } catch (e) {
          print('Failed to update client: $e');
        }
      }
    }
  }

  void deleteClient() {
    print('Enter client ID: ');
    String? idStr = stdin.readLineSync();
    if (idStr != null) {
      int? id = int.tryParse(idStr);
      if (id != null) {
        try {
          var result = clientService.deleteClient(id);
          print('Client deleted: $result');
        } catch (e) {
          print('Failed to delete client: $e');
        }
      }
    }
  }
}