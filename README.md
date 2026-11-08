# ev_lookup

This is a small Flutter app for looking up an electric car by its registration plate and listing the chargers that fit it. You type a plate, confirm the car it finds, and then see the chargers with the same connector, with the time and total cost for a 40% to 80% charge. There is no real backend: all the data comes from a mock HTTP transport that runs inside the app.

Here is a short recording of the app on an Android emulator:

https://github.com/user-attachments/assets/06590a50-0fd1-4e8d-b95d-7777381682a6

## Running it

I built it with Flutter 3.29.3 and Dart 3.7.2 and tested it on a Pixel 7 Pro API 34 emulator. To run it and the tests:

    flutter pub get
    flutter run
    flutter test

The registration that returns a car is `TF24LPO`. Spaces and case do not matter, so `tf24 lpo` works. Any other plate shows "Vehicle not found".

`flutter test` runs 70 tests. They cover the use cases, the repositories, both Cubits, the screens and the localized strings. The connector filter test is in `test/features/chargers/filter_by_connector_test.dart`.

## Demo flags

Three `--dart-define` flags let me show the error and empty states without touching the code. The two failure flags make only the first matching request fail, so Retry recovers.

    flutter run --dart-define=FAIL_LOOKUP_ONCE=true
    flutter run --dart-define=FAIL_CHARGERS_ONCE=true
    flutter run --dart-define=EMPTY_CHARGERS=true

## Architecture

The code is split by feature, and each feature has data, domain and presentation folders. The domain layer has the entities, the repository contracts and the use cases, and it imports neither Flutter nor http. The data layer has the remote data sources, the models and the repository implementations. The presentation layer has the screens, widgets and Cubits.

State is handled with flutter_bloc Cubits, and get_it wires everything together in one place. Cubits are registered as factories, so each screen gets a fresh one. Use cases return an `Either<Failure, T>` from dartz, and the repositories turn exceptions into failures: a 404 becomes a not-found failure, `http.ClientException` and `SocketException` become a network failure, and anything else becomes an unknown failure.

The data sources talk to a plain `http.Client`. In the app, `MockTransport` is injected as that client. It is a `MockClient` with a short delay, and it serves `/vehicles/lookup` and `/chargers`. Swapping in a real client would not touch anything outside the service locator.

## Decisions

- The mock data wins over the screenshots. The charger shows 150 kW, not the 350 in the design, and the heading says "2 chargers near you" because that is what the data returns.
- Chargers are matched to the car by exact connector, for example `CCS` only, and they keep the order of the response.
- Retry repeats the last registration that was submitted, even if I have edited the field since. "Not my car" clears it, so Retry does nothing after that.
- I skipped the Hero animation. The car illustration appears on only one screen, so there is no pair to animate between.
- Rubik is bundled in `google_fonts/` with its OFL license, and runtime font fetching is turned off, so the app never downloads fonts. Widget tests use a plain `MaterialApp` and fetch nothing.
- All user-facing text is in `lib/l10n/app_en.arb` and generated with gen-l10n, so a new language is a new ARB file.
