# GemStore — Flutter (din Figma)

Reproducere fidelă a celor două ecrane din Figma: **Home Page** și **Product Page**.

## 1. Cum rulezi proiectul în Android Studio

1. Deschide Android Studio → **Open** → selectează folderul `gemstore_app`.
2. Lasă Android Studio să indexeze proiectul și să descarce dependențele (sau rulează manual):
   ```
   flutter pub get
   ```
3. Pornește un emulator Android (sau conectează un telefon) și apasă **Run**.

Dacă `google_fonts` (folosit pentru fontul Poppins, cel mai apropiat de fontul geometric din design) nu e deja în `pubspec.yaml`, adaugă-l cu:
```
flutter pub add google_fonts
```
Motiv: Figma folosește un font sans-serif geometric (gen Poppins/Circular); `google_fonts` descarcă fontul potrivit automat, fără să trebuiască să incluzi fișiere `.ttf` manual în `assets/`.

## 2. Pagini identificate în Figma

1. **Home Page** — app bar (meniu, titlu "GemStore", clopoțel cu notificare), rând de categorii
   (Women/Men/Accessories/Beauty), banner hero "Autumn Collection 2021", secțiunea
   "Feature Products" (listă orizontală de carduri), banner "Hang Out & Party", secțiunea
   "Recommended" (listă orizontală de tile-uri), secțiunea "Top Collection" cu bannerele
   "For Slim & Beauty" și "Most sexy & fabulous design", și rândul final cu 2 carduri
   "T-Shirts" / "Dresses".
2. **Product Page** — galerie foto cu buton back + favorite, nume produs + preț + rating,
   selector de culoare, selector de mărime, secțiune "Description" (expandabilă),
   secțiune "Reviews" (rating mediu + grafic de distribuție + listă recenzii, expandabilă),
   "Similar Product" (listă orizontală), bară fixă "Add To Cart".

## 3. Structura proiectului

```
lib/
├── main.dart                     punct de intrare
├── theme/app_theme.dart          culori, fonturi, spacing — un singur loc de adevăr
├── models/                       ProductModel, ReviewModel, CategoryModel
├── services/                     sursa de date mock (echivalentul "UserApi")
├── business_logic/               interfețe + implementări + fațada business-logic
├── widgets/                      14 widget-uri reutilizabile (carduri, bannere, selectoare...)
└── pages/                        HomePage, ProductPage
```

Separarea cerută UI → Business Logic → Data/Service:
```
HomePage / ProductPage
      │ (apelează)
      ▼
ProductBusinessLogic / ReviewBusinessLogic      <- fațada pe care o vede UI-ul
      │ (depinde de interfață, nu de implementare)
      ▼
IProductRepository / IReviewRepository          <- contract
      │
      ▼
ProductRepository / ReviewRepository            <- implementare curentă (mock)
      │
      ▼
ProductDataSource / ReviewDataSource            <- sursa reală de date (azi: mock)
```
Când vei avea backend, schimbi doar `ProductDataSource`/`ReviewDataSource` (sau adaugi o
implementare nouă de `IProductRepository`, ex. `RemoteProductRepository`) — UI-ul rămâne
neschimbat.

## 4. Assets

Toate imaginile folosite în aplicație au fost **decupate direct din screenshot-urile Figma**
pe care mi le-ai trimis (nu sunt imagini random de pe internet):

| Fișier | Provine din |
|---|---|
| `banner_autumn.png` | banner-ul "Autumn Collection 2021" |
| `banner_hangout.png` | banner-ul "Hang Out & Party" |
| `banner_slim_beauty.png` | banner-ul "For Slim & Beauty" |
| `banner_summer.png` | banner-ul "Most sexy & fabulous design" |
| `banner_tshirts.png` / `banner_dresses.png` | decupate din bannerul dublu T-Shirts/Dresses |
| `product_turtleneck.png`, `product_longsleeve_dress.png` | decupate din rândul Feature Products |
| `product_hoodie.png`, `product_cotton_tee.png` | decupate din rândul Recommended |
| `product_sportswear_hero.png` | imaginea principală din Product Page |
| `product_rise_crop_hoodie.png`, `product_gym_crop_top.png` | reutilizate din assets existente (Similar Product nu avea poze separate furnizate) |
| `avatar_jennifer.png`, `avatar_kelly.png` | avatarele din secțiunea Reviews |

**Recomandare pentru varianta finală de producție:** exportă din Figma (clic dreapta pe fiecare
imagine → Export → PNG @2x/@3x) variante de rezoluție mai mare decât screenshot-urile trimise
aici, ca aplicația să arate perfect și pe telefoane cu densitate mare de pixeli. Structura
`assets/images/` și `pubspec.yaml` sunt deja pregătite — e suficient să suprascrii fișierele.

## 5. Date mock / business logic

Produsele vin momentan din `ProductDataSource` (date locale, hardcodate). Modelul
`ProductModel` are exact câmpurile cerute (id, name, image(s), price, description, category)
plus `colors`, `sizes`, `ratingAverage`, `ratingCount`, `ratingBreakdown`, `totalReviewCount` —
necesare pentru Product Page. La apăsarea unui produs din Home Page, navighezi către
`ProductPage(productId: ...)`, care își ia datele prin `ProductBusinessLogic.getProductById`.

## 6. Ce am verificat

- Toate import-urile relative se rezolvă la fișiere existente.
- Acolade/paranteze echilibrate în toate fișierele `.dart`.
- Înălțimile listelor orizontale (Feature Products, Similar Product) au fost recalculate ca să
  încapă imagine + nume + preț fără overflow.
- `const` e folosit consecvent pentru modele (performanță + null-safety).
- Nu există stare mutată direct în `build()` (selecția implicită a mărimii "L" se face printr-un
  `addPostFrameCallback`, nu direct în build).

**Notă:** acest mediu de lucru nu are Flutter SDK instalat, deci nu am putut rula
`flutter analyze` / `flutter run` efectiv. Am făcut verificări statice (import-uri, acolade,
dimensiuni layout) manual. Dacă la compilare în Android Studio apare vreo eroare punctuală,
trimite-mi mesajul de eroare și o rezolv imediat.
