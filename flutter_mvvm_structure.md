# Flutter MVVM Project Structure

```txt
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   ├── bindings/
│   │   └── initial_binding.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       └── app_dimensions.dart
│
├── core/
│   ├── constants/
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_client.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── refresh_token_interceptor.dart
│   │       └── logger_interceptor.dart
│   │
│   ├── services/
│   ├── utils/
│   ├── widgets/
│   └── exceptions/
│
├── features/
│   ├── auth/
│   │   ├── bindings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │
│   │   └── presentation/
│   │       ├── views/
│   │       ├── viewmodels/
│   │       └── widgets/
│   │
│   ├── home/
│   ├── profile/
│   ├── search/
│   ├── events/
│   └── settings/
│
├── shared/
│   ├── enums/
│   ├── widgets/
│   ├── mixins/
│   └── models/
│
└── l10n/
    ├── app_en.arb
    └── app_km.arb
```

---

# MVVM Flow

```txt
View
 ↓
ViewModel
 ↓
UseCase
 ↓
Repository
 ↓
Datasource/API
```

---

# Recommended Packages

```yaml
dependencies:
  get:
  dio:
  flutter_secure_storage:
  shared_preferences:
  flutter_dotenv:
  internet_connection_checker_plus:
  freezed_annotation:
  json_annotation:
  pretty_dio_logger:
```

```yaml
dev_dependencies:
  build_runner:
  freezed:
  json_serializable:
```

---

# Naming Convention

| Type | Example |
|---|---|
| View | login_page.dart |
| ViewModel | auth_viewmodel.dart |
| UseCase | login_usecase.dart |
| Repository | auth_repository.dart |
| Datasource | auth_remote_datasource.dart |
| Model | login_response_model.dart |
