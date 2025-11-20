# Console Dart - Application Mobile Money

Une application console Dart pour la gestion de comptes mobile money. Permet de consulter le solde, effectuer des paiements et transferts, et voir l'historique des transactions via une API Laravel.

## Table des Matières

- [Description](#description)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Exécution](#exécution)
- [Architecture](#architecture)
- [Structure du Projet](#structure-du-projet)
- [Fonctionnalités](#fonctionnalités)
- [API Backend](#api-backend)
- [Comment Contribuer](#comment-contribuer)
- [Dépannage](#dépannage)

## Description

Cette application console permet à un utilisateur de gérer son compte mobile money via une interface en ligne de commande. Elle communique avec un backend Laravel pour :

- Consulter les informations du profil
- Voir le solde du compte
- Effectuer des paiements (vers un numéro de téléphone ou un marchand)
- Faire des transferts d'argent
- Consulter l'historique des transactions

L'application utilise Dio pour les requêtes HTTP et suit une architecture MVC adaptée à une console.

## Prérequis

- **Dart SDK** : Version 3.10.0 ou supérieure
- **Backend Laravel** : Un serveur Laravel fonctionnel avec les endpoints API
- **Connexion Internet** : Pour communiquer avec le backend

### Installation de Dart

1. Téléchargez Dart depuis [dart.dev](https://dart.dev/get-dart)
2. Suivez les instructions d'installation pour votre système d'exploitation
3. Vérifiez l'installation :
   ```bash
   dart --version
   ```

## Installation

1. **Clonez ou téléchargez le projet** :
   ```bash
   git clone <url-du-repo>
   cd ompay_dart_console
   ```

2. **Installez les dépendances** :
   ```bash
   dart pub get
   ```

3. **Vérifiez que tout est correct** :
   ```bash
   dart analyze
   ```

## Exécution

Pour lancer l'application console :

```bash
dart run bin/console.dart
```

L'application commence par afficher la **page d'authentification** avec les options suivantes :
- Register : Inscription d'un nouvel utilisateur
- Login : Connexion à un compte existant
- Logout : Déconnexion
- Exit : Quitter l'application

Après une connexion réussie, l'application affiche le **menu principal** avec accès aux fonctionnalités :
- Mon Profil : Voir les informations utilisateur et compte
- Comptes : Menu de gestion du compte (solde, paiements, transferts, transactions)
- Déconnexion : Retour à la page d'authentification
- Exit : Quitter l'application

### Menu Comptes

- Profil : Informations détaillées du compte
- Voir Solde : Consulter le solde actuel
- Payer : Effectuer un paiement (choix entre téléphone ou marchand)
- Transferer : Transférer de l'argent à un autre client
- Liste des Transactions : Historique des transactions

## Architecture

L'application suit une architecture **MVC (Modèle-Vue-Contrôleur)** adaptée à une console :

### Couches de l'Application

1. **API Layer** (`api/`) : Gestion des requêtes HTTP
2. **Service Layer** (`service/`) : Logique métier et appels API
3. **Model Layer** (`model/`) : Structures de données
4. **View Layer** (`view/`) : Interface utilisateur console

### Flux de Données

```
Utilisateur → View → Service → API → Backend Laravel
                      ↓
                   Model (parsing JSON)
```

## Structure du Projet

```
ompay_dart_console/
├── api/
│   └── apiService.dart          # Classe de base pour les requêtes HTTP
├── service/
│   ├── auth_service.dart        # Service d'authentification
│   └── compte_service.dart      # Service de gestion des comptes et transactions
├── model/
│   ├── user.dart                # Modèle Utilisateur
│   ├── compte.dart              # Modèle Compte
│   ├── transaction.dart         # Modèle Transaction
│   └── client.dart              # Modèle Client
├── view/
│   ├── auth_view.dart           # Interface d'authentification
│   └── compte_view.dart         # Interface de gestion des comptes et transactions
├── bin/
│   └── console.dart             # Point d'entrée principal
├── test/
│   └── console_test.dart        # Tests unitaires
├── pubspec.yaml                 # Configuration du projet
├── README.md                    # Cette documentation
└── analysis_options.yaml        # Configuration d'analyse
```

## Fonctionnalités

### Authentification
- Inscription d'un nouvel utilisateur
- Connexion avec numéro de téléphone
- Déconnexion

### Gestion du Compte Utilisateur
- Consulter les informations du profil
- Voir le solde du compte
- Effectuer des paiements :
  - Vers un numéro de téléphone
  - Vers un marchand (avec code marchand)
- Transférer de l'argent à un autre client
- Consulter l'historique des transactions

## API Backend

L'application communique avec un backend Laravel via les endpoints suivants :

### Authentification
- `POST /api/login` - Connexion (avec téléphone)
- `POST /api/register` - Inscription (avec téléphone)
- `POST /api/logout` - Déconnexion

### Gestion du Compte
- `GET /api/me` - Informations du profil utilisateur et compte
- `GET /api/compte/{numeroCompte}/solde` - Consulter le solde
- `POST /api/compte/{numeroCompte}/pay` - Effectuer un paiement
- `POST /api/compte/{numeroCompte}/transfer` - Effectuer un transfert
- `GET /api/compte/{numeroCompte}/transactions` - Historique des transactions

**Note** : `{numeroCompte}` est le numéro du compte (ex: "CMPT-123456")

## Comment Contribuer

### Ajouter une Nouvelle Fonctionnalité

1. **Créer un nouveau modèle** dans `model/` si nécessaire
2. **Ajouter un service** dans `service/` qui hérite de `ApiService`
3. **Créer une vue** dans `view/` pour l'interface utilisateur
4. **Mettre à jour le menu principal** dans `bin/console.dart`

### Exemple : Ajouter une Gestion des Catégories

1. Créer `model/categorie.dart`
2. Créer `service/categorie_service.dart`
3. Créer `view/categorie_view.dart`
4. Ajouter l'option dans le menu principal

### Bonnes Pratiques

- Utilisez des noms descriptifs pour les variables et fonctions
- Ajoutez des commentaires pour expliquer la logique complexe
- Gérez les erreurs avec des try-catch
- Respectez la séparation des responsabilités

## Dépannage

### Erreur de Connexion
- Vérifiez que le backend Laravel est démarré (`php artisan serve`)
- Vérifiez l'URL dans `bin/console.dart` (const baseUrl = 'http://localhost:8000/api')
- Vérifiez la connectivité réseau

### Erreur 302 Redirection
- Le serveur Laravel peut rediriger si l'host est mal configuré
- Assurez-vous que le serveur est lancé avec `--host=127.0.0.1`

### Erreur de Compilation
```bash
dart analyze
```
Résout les problèmes de syntaxe et d'imports.

### Dépendances Manquantes
```bash
dart pub get
```
Réinstalle les dépendances.

### Application qui ne Répond Pas
- L'application attend une entrée utilisateur
- Appuyez sur Entrée ou tapez une option valide

### Erreur "Montant insuffisant"
- Vérifiez le solde avec l'option "Voir Solde"
- Le solde est calculé à partir des transactions

### Erreur "Destinataire invalide"
- Le destinataire doit avoir un compte vérifié
- Utilisez le numéro de téléphone correct (ex: "775942400")
- Pour les marchands, utilisez le code correct (ex: "MARCHAND-123")

## Ressources pour Débutants

- [Documentation Dart Officielle](https://dart.dev/guides)
- [Tutoriels Flutter/Dart](https://flutter.dev/docs)
- [Guide des APIs REST](https://restfulapi.net/)
- [Documentation Dio](https://pub.dev/packages/dio)

## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## Données de Test

Pour tester l'application, des données de test ont été ajoutées :

- Client destinataire : téléphone `775942400`
- Marchand : code `MARCHAND-123`

Utilisez ces valeurs pour tester les paiements et transferts.

---

**Note** : Cette documentation reflète les fonctionnalités actuelles de l'application mobile money.
