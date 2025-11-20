# Console Dart - Application de Gestion Financière

Une application console Dart qui communique avec un backend Laravel pour gérer les comptes, transactions, clients et authentification. Idéale pour les débutants en Dart et en architecture d'application.

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

Cette application console permet d'interagir avec une API Laravel pour effectuer des opérations CRUD (Créer, Lire, Mettre à Jour, Supprimer) sur les comptes bancaires, transactions, clients et gérer l'authentification. Elle utilise Dio pour les requêtes HTTP asynchrones et suit une architecture modulaire avec séparation des responsabilités.

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

L'application commence par afficher la **page de compte** avec les options suivantes :
- Register : Inscription d'un nouvel utilisateur
- Login : Connexion à un compte existant
- Logout : Déconnexion
- Exit : Quitter l'application

Après une connexion réussie, l'application affiche le **menu principal** avec accès aux fonctionnalités :
- Comptes : Gestion des comptes bancaires
- Transactions : Gestion des transactions
- Clients : Gestion des clients
- Déconnexion : Retour à la page de compte
- Exit : Quitter l'application

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
│   ├── compte_service.dart      # Service de gestion des comptes
│   ├── transaction_service.dart # Service de gestion des transactions
│   └── client_service.dart      # Service de gestion des clients
├── model/
│   ├── user.dart                # Modèle Utilisateur
│   ├── compte.dart              # Modèle Compte
│   ├── transaction.dart         # Modèle Transaction
│   └── client.dart              # Modèle Client
├── view/
│   ├── auth_view.dart           # Interface d'authentification
│   ├── compte_view.dart         # Interface de gestion des comptes
│   ├── transaction_view.dart    # Interface de gestion des transactions
│   └── client_view.dart         # Interface de gestion des clients
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
- Connexion
- Déconnexion

### Gestion des Comptes
- Lister tous les comptes
- Voir un compte spécifique
- Créer un nouveau compte
- Modifier un compte existant
- Supprimer un compte

### Gestion des Transactions
- Lister toutes les transactions
- Voir une transaction spécifique
- Créer une nouvelle transaction
- Modifier une transaction
- Supprimer une transaction

### Gestion des Clients
- Lister tous les clients
- Voir un client spécifique
- Créer un nouveau client
- Modifier un client
- Supprimer un client

## API Backend

L'application communique avec un backend Laravel via les endpoints suivants :

### Authentification
- `POST /api/login` - Connexion (avec téléphone)
- `POST /api/register` - Inscription (avec téléphone)
- `POST /api/logout` - Déconnexion

### Comptes
- `GET /api/comptes` - Lister les comptes
- `GET /api/comptes/{id}` - Voir un compte
- `POST /api/comptes` - Créer un compte
- `PUT /api/comptes/{id}` - Modifier un compte
- `DELETE /api/comptes/{id}` - Supprimer un compte

### Transactions
- `GET /api/transactions` - Lister les transactions
- `GET /api/transactions/{id}` - Voir une transaction
- `POST /api/transactions` - Créer une transaction
- `PUT /api/transactions/{id}` - Modifier une transaction
- `DELETE /api/transactions/{id}` - Supprimer une transaction

### Clients
- `GET /api/clients` - Lister les clients
- `GET /api/clients/{id}` - Voir un client
- `POST /api/clients` - Créer un client
- `PUT /api/clients/{id}` - Modifier un client
- `DELETE /api/clients/{id}` - Supprimer un client

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
- Vérifiez que le backend Laravel est démarré
- Vérifiez l'URL dans `bin/console.dart` (const baseUrl)
- Vérifiez la connectivité réseau

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

## Ressources pour Débutants

- [Documentation Dart Officielle](https://dart.dev/guides)
- [Tutoriels Flutter/Dart](https://flutter.dev/docs)
- [Guide des APIs REST](https://restfulapi.net/)
- [Documentation Dio](https://pub.dev/packages/dio)

## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

---

**Note** : Cette documentation est automatiquement mise à jour avec chaque modification du projet. Pour les contributions, veuillez suivre les bonnes pratiques décrites ci-dessus.
