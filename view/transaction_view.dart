import 'dart:io';
import '../service/transaction_service.dart';

class TransactionView {
  final TransactionService transactionService;

  TransactionView(this.transactionService);

  void displayMenu() {
    print('=== Transaction Menu ===');
    print('1. Liste des Transactions');
    print('2. Recherche une Transaction par ID');
    print('3. Creer un Transaction');
    print('4. Modifier une Transaction');
    print('5. Supprimer une  Transaction');
    print('6. Retour');
    print('Choisir une option: ');
  }

  void handleTransaction() {
    while (true) {
      displayMenu();
      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          listTransactions();
          break;
        case '2':
          getTransaction();
          break;
        case '3':
          createTransaction();
          break;
        case '4':
          updateTransaction();
          break;
        case '5':
          deleteTransaction();
          break;
        case '6':
          return;
        default:
          print('Invalid option. Try again.');
      }
    }
  }

  void listTransactions() {
    try {
      var result = transactionService.getTransactions();
      print('Transactions: $result');
    } catch (e) {
      print('Failed to list transactions: $e');
    }
  }

  void getTransaction() {
    print('Enter transaction ID: ');
    String? idStr = stdin.readLineSync();
    if (idStr != null) {
      int? id = int.tryParse(idStr);
      if (id != null) {
        try {
          var result = transactionService.getTransaction(id);
          print('Transaction: $result');
        } catch (e) {
          print('Failed to get transaction: $e');
        }
      }
    }
  }

  void createTransaction() {
    print('Enter compte ID: ');
    String? compteIdStr = stdin.readLineSync();
    print('Enter type: ');
    String? type = stdin.readLineSync();
    print('Enter amount: ');
    String? amountStr = stdin.readLineSync();
    print('Enter description: ');
    String? description = stdin.readLineSync();
    if (compteIdStr != null && type != null && amountStr != null && description != null) {
      int? compteId = int.tryParse(compteIdStr);
      double? amount = double.tryParse(amountStr);
      if (compteId != null && amount != null) {
        try {
          var result = transactionService.createTransaction({
            'compte_id': compteId,
            'type': type,
            'amount': amount,
            'description': description,
          });
          print('Transaction created: $result');
        } catch (e) {
          print('Failed to create transaction: $e');
        }
      }
    }
  }

  void updateTransaction() {
    print('Enter transaction ID: ');
    String? idStr = stdin.readLineSync();
    print('Enter new amount: ');
    String? amountStr = stdin.readLineSync();
    if (idStr != null && amountStr != null) {
      int? id = int.tryParse(idStr);
      double? amount = double.tryParse(amountStr);
      if (id != null && amount != null) {
        try {
          var result = transactionService.updateTransaction(id, {'amount': amount});
          print('Transaction updated: $result');
        } catch (e) {
          print('Failed to update transaction: $e');
        }
      }
    }
  }

  void deleteTransaction() {
    print('Enter transaction ID: ');
    String? idStr = stdin.readLineSync();
    if (idStr != null) {
      int? id = int.tryParse(idStr);
      if (id != null) {
        try {
          var result = transactionService.deleteTransaction(id);
          print('Transaction deleted: $result');
        } catch (e) {
          print('Failed to delete transaction: $e');
        }
      }
    }
  }
}