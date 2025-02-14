# Personal Power Cloud

Personal Power Cloud é um aplicativo Flutter que permite gerenciar e sincronizar arquivos em diferentes serviços de armazenamento em nuvem, como Google Drive, Dropbox, OneDrive, e também em dispositivos locais e remotos.

## Estrutura do Projeto

```plaintext
.
├── .dart_tool/
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── .gitignore
├── .idea/
├── .metadata
├── .vscode/
│   ├── launch.json
├── analysis_options.yaml
├── android/
├── assets/
├── build/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── crawler_dropbox_screen.dart
│   │   ├── crawler_google_drive_screen.dart
│   │   ├── crawler_internal_storage_screen.dart
│   │   ├── crawler_onedrive_screen.dart
│   │   ├── crawler_ppc_screen.dart
│   │   ├── crawler_sd_card_screen.dart
│   │   ├── logout_screen.dart
│   │   ├── remote_access_screen.dart
│   │   ├── register_screen.dart
│   │   ├── splash_screen.dart
│   │   ├── trash_screen.dart
│   ├── services/
│   │   ├── google_drive_integration.dart
│   ├── utils/
│   │   ├── file_system_service.dart
│   ├── widgets/
│   │   ├── custom_popup.dart
│   │   ├── file_item.dart
│   │   ├── icon_button.dart
│   │   ├── navigation_buttons.dart
│   │   ├── navigation_buttons_more.dart
├── linux/
│   ├── flutter/
│   │   ├── CMakeLists.txt
├── macos/
├── pubspec.lock
├── pubspec.yaml
├── README.md
├── test/
├── web/
├── windows/
