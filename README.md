# Sistema SQLite

## Overview

Sistema SQLite is a Flutter application that utilizes SQLite for local data storage. The application manages various models, including products, and provides a user-friendly interface for performing CRUD operations.

## Project Structure

```
sistema_sqlite
├── lib
│   ├── data
│   │   └── db_helper.dart
│   ├── models
│   │   ├── modeloProducto.dart
│   │   ├── modeloRegistroProducto.dart
│   │   └── modeloTipoProducto.dart
│   │   └── modeloUsuario.dart
│   ├── presentation
│   │   ├── menu.dart
│   │   ├── producto.dart
│   │   ├── usuario.dart
│   ├── providers
│   │   ├── producto_provider.dart
│   │   ├── usuario_provider.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

## Features

- **Database Management**: The application uses SQLite for efficient data management.
- **CRUD Operations**: Users can create, read, update, and delete products and other entities.
- **User Interface**: A simple and intuitive UI for interacting with the database.

## Setup Instructions

1. Clone the repository:
   ```
   git clone https://github.com/joseluisdaza/MFS_MOBILE_Expenses.git
   ```
2. Navigate to the project directory:
   ```
   cd sistema_sqlite
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run
   ```

## Usage

- Launch the application to view the product list.
- Use the provided UI to add, update, or delete products.
- Navigate through different pages to manage other models as defined in the application.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
