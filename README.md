<div align="center">

# App Motorista

### Digital proof of delivery for freight drivers

**A Flutter app that replaces paper delivery receipts — drivers scan the invoice barcode, photograph the signed receipt, and the record is stored on the device.**

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org/)

</div>

---

## The problem

A freight driver delivers goods and needs proof: the invoice (NF-e) data and a photo of the signed receipt. Done on paper, that proof gets lost, damaged or never reaches the office.

This app puts the whole flow in the driver's pocket, offline-first, so it works on the road where there is no signal.

## How it works

```
1. Driver scans the NF-e barcode with the phone camera
2. App reads the invoice key and shows the data
3. Driver photographs the signed receipt (canhoto)
4. Record is saved locally on the device
5. Office retrieves the stored records
```

Each record keeps the invoice code **and** the receipt image together, so the proof is never separated from the delivery it belongs to.

## Features

- **Barcode scanning** with the device camera (`simple_barcode_scanner`)
- **Receipt photography** with the camera or gallery (`image_picker`)
- **Local persistence** with SQLite (`sqflite`) — works with no connection
- **Brazilian document formatting** for invoice keys (`brasil_fields`)
- **Record list** with the ability to review and delete entries
- **Custom splash screen** and branding

## Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK ≥ 3.1) |
| Local database | SQLite via `sqflite` |
| Scanning | `simple_barcode_scanner` |
| Camera / gallery | `image_picker` |
| Formatting | `brasil_fields`, `intl` |

## Architecture

The data layer is a **singleton database connection** with a table per record type, exposing async methods for insert, query and delete. Screens are `StatefulWidget`s that load their data in `initState` and re-render on change.

```
lib/
├── main.dart            # app entry and routing
├── db_conexao.dart      # SQLite connection + CRUD (singleton)
├── salvaCodigo.dart     # capture screen: scan + photograph
├── listaCodigo.dart     # saved records list
└── clipboard.dart       # clipboard helpers
```

## Getting started

```bash
flutter pub get
flutter run
```

To build for Android:

```bash
flutter build apk --release
```

## Status

Working prototype, in use to validate the driver workflow. The data layer is device-local by design — the next step is syncing records to the company backend when a connection is available.

---

<div align="center">
<sub>Built by <a href="https://github.com/devgui01">Guilherme Kauan Marques</a></sub>
</div>
