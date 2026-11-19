# Laborator nr. 3 – GemStore (Flutter, BLoC/Cubit, programare asincronă)

## Rulare în Android Studio
1. Dezarhivează proiectul și deschide folderul în Android Studio (plugin-urile Flutter + Dart instalate).
2. În terminal, din folderul proiectului, rulează **o singură dată** pentru a genera folderele de platformă
   (`android/` etc.). Comanda nu suprascrie `lib/` și `pubspec.yaml`:
   ```
   flutter create . --project-name gemstore_lab3 --platforms android
   flutter pub get
   ```
3. Imaginile se încarcă de pe internet. În modul *release* adaugă în
   `android/app/src/main/AndroidManifest.xml`, deasupra tagului `<application>`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
   (în debug permisiunea există deja).
4. Alege emulatorul / telefonul și apasă **Run**. Teste: `flutter test`.

## Structura
```
assets/data/store.json            datele aplicatiei (JSON)
lib/
  main.dart, app.dart             punct de intrare, providere
  core/theme.dart                 tema
  data/models/                    Product, Review, ColorOption, StoreData (fromJson)
  data/repositories/              StoreRepository (incarcare asincrona + compute)
  logic/products/                 ProductsCubit + ProductsState (cautare/filtrare/sortare)
  logic/favorites/                FavoritesCubit
  ui/screens/                     Home, Detalii produs, Favorite
  ui/widgets/                     ProductCard, SearchField, FilterBar, State views...
```

## Cerinte -> implementare
| Cerinta | Unde |
|---|---|
| State management (BLoC/Cubit) | `ProductsCubit`, `FavoritesCubit` (`flutter_bloc`) |
| JSON in proiect, incarcat asincron | `store.json` + `StoreRepository.loadStore` (`rootBundle`, `Future`, `compute`) |
| Stari Loading / Success / Empty / Error | `ProductsStatus` + `state_views.dart`; din meniul ⋮ se pot simula Eroare si Lista goala |
| Cautare (debounce) | `SearchField` -> `ProductsCubit.setQuery` |
| Filtrare | chip-uri colectie + slider pret (`FilterBar`) |
| Sortare | nume A-Z, pret crescator/descrescator |
| Favorite | `FavoritesCubit`, `FavoriteButton`, `FavoritesScreen` |
| Navigare la detalii | `ProductCard` -> `ProductDetailsScreen` |
| Componente reutilizabile | `ProductCard`, `ProductImage`, `FavoriteButton`, `RatingStars`, `EmptyView`/`ErrorView`/`LoadingView` |
