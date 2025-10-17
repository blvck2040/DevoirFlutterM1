# Gestion d'emploi du temps universitaire

Projet Flutter multi-écrans utilisant SQLite pour la gestion locale des utilisateurs, cours et créneaux d'emploi du temps.

## Fonctionnalités
- Authentification locale (inscription/connexion) persistée en SQLite
- Navigation entre écrans (connexion, inscription, accueil, cours, détail d'un cours, emploi du temps)
- Affichage des cours et des enseignants associés
- Visualisation des créneaux d'emploi du temps groupés par date

## Démarrage
1. Installer Flutter (version 3.22 ou supérieure recommandée).
2. Récupérer les dépendances :
   ```bash
   flutter pub get
   ```
3. Lancer l'application :
   ```bash
   flutter run
   ```

Un utilisateur de démonstration est prérempli : `demo` / `demo123`.

## Structure principale
```
lib/
├── db/
│   └── database_helper.dart
├── main.dart
├── models/
│   ├── course.dart
│   ├── schedule.dart
│   ├── teacher.dart
│   └── user.dart
└── screens/
    ├── course_detail_screen.dart
    ├── course_list_screen.dart
    ├── home_screen.dart
    ├── login_screen.dart
    ├── register_screen.dart
    └── schedule_screen.dart
```
