# Migraine Tracker & Analysis App

Une application mobile complète de suivi et d'analyse des migraines pour iOS et Android.

## Architecture

```
Migraine/
├── mobile/                 # Application Flutter (iOS + Android)
│   ├── lib/
│   │   ├── models/         # Modèles de données
│   │   ├── services/       # Services (API, storage, etc.)
│   │   ├── screens/        # Écrans de l'application
│   │   ├── widgets/        # Composants UI réutilisables
│   │   ├── utils/          # Fonctions utilitaires
│   │   └── providers/      # State management (Riverpod)
│   └── assets/
│       ├── images/        # Images et icônes
│       └── fonts/          # Polices personnalisées
│
├── backend/                # Backend Node.js/TypeScript
│   ├── src/
│   │   ├── models/        # Schémas de base de données
│   │   ├── services/      # Logique métier
│   │   ├── controllers/   # Contrôleurs API
│   │   ├── routes/        # Routes Express
│   │   ├── middleware/    # Middleware (auth, etc.)
│   │   └── utils/         # Fonctions utilitaires
│   └── config/            # Configuration
│
└── shared/                # Code partagé (Dart + TypeScript)
    └── src/               # Modèles et types communs
```

## Fonctionnalités

### Core Features
- [ ] Onboarding progressif
- [ ] Dashboard avec indicateurs clés
- [ ] Saisie rapide de migraine (<30s)
- [ ] Journal quotidien rapide (<60s)
- [ ] Calendrier des migraines
- [ ] Analyse et corrélations automatiques
- [ ] Graphiques et heatmaps
- [ ] Rapports hebdomadaires/mensuels
- [ ] Export PDF/CSV/JSON

### Advanced Features
- [ ] Mode migraine (UI adaptée)
- [ ] Assistant IA conversationnel
- [ ] Intégration APIs météo
- [ ] Synchronisation santé (Apple Health/Health Connect)
- [ ] Notifications intelligentes
- [ ] Système freemium

## Technologies

### Mobile (Flutter)
- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Database**: Hive (local) + Firestore (cloud)
- **Auth**: Firebase Auth
- **Charts**: fl_chart, syncfusion_flutter_charts
- **PDF**: pdf, printing
- **Localization**: flutter_localizations
- **Notifications**: firebase_messaging, local_notifications

### Backend (Node.js/TypeScript)
- **Framework**: Express.js + NestJS
- **Database**: PostgreSQL (Supabase) ou Firestore
- **Auth**: Firebase Auth / JWT
- **API**: RESTful + GraphQL optionnel
- **Weather**: OpenWeatherMap API, WeatherAPI
- **AI**: LangChain.js + LLM API

### DevOps
- **CI/CD**: GitHub Actions
- **Testing**: Jest (backend), flutter_test (mobile)
- **Monitoring**: Sentry, Firebase Crashlytics

## Configuration

### Environment Variables

#### Mobile
```env
# Firebase
FIREBASE_API_KEY=your_api_key
FIREBASE_APP_ID=your_app_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_PROJECT_ID=your_project_id

# Weather API
WEATHER_API_KEY=your_weather_api_key

# Deep Links
DEEP_LINK_SCHEME=migraine
DEEP_LINK_HOST=app.example.com
```

#### Backend
```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/migraine

# Firebase
FIREBASE_SERVICE_ACCOUNT_KEY=path/to/serviceAccountKey.json

# Weather
WEATHER_API_KEY=your_weather_api_key

# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d

# Port
PORT=3000
```

## Installation

### Mobile
```bash
cd mobile
flutter pub get
flutter run
```

### Backend
```bash
cd backend
npm install
npm run dev
```

## Scripts

### Mobile
- `flutter run` - Lancer l'application
- `flutter build apk` - Build APK Android
- `flutter build ios` - Build iOS
- `flutter test` - Lancer les tests

### Backend
- `npm run dev` - Lancer en développement
- `npm run build` - Build production
- `npm run test` - Lancer les tests
- `npm run lint` - Linter le code

## Contribution

1. Fork le repository
2. Crée une branche (`git checkout -b feature/nouvelle-fonctionnalité`)
3. Commit tes changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalité`)
5. Ouvre une Pull Request

## Licence

MIT License - Voir [LICENSE](LICENSE) pour plus de détails.

## Confidentialité

Cette application suit une approche **privacy-first** :
- Pas de collecte de données sans consentement explicite
- Chiffrement des données sensibles
- Conformité RGPD
- Pas de vente de données de santé
- Export et suppression complète des données possibles

Voir [PRIVACY.md](PRIVACY.md) pour plus de détails.

---

**Note**: Cette application ne fournit pas de diagnostic médical. Consultez toujours un professionnel de santé pour toute question médicale.
