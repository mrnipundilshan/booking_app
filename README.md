# booking_app

A Flutter app for booking home service providers (plumbing, electrical, carpentry, painting, AC repair, cleaning).

## What the app does

**Customer side**

- Browse service categories and search providers by name or skill.
- See all providers, then filter (category, rating, hourly rate, available only) and sort them.
- Open a provider's details and book a time slot.
- See your bookings and cancel them.

**Provider side**

- Turn on **Provider mode** in the Profile tab. You then act as the sample provider Kamal Perera (`p001`).
- See jobs booked with you and accept, reject, start or complete them.

**Booking rules**

- Time slots: 8–10 AM, 10–12 PM, 1–3 PM, 3–5 PM.
- Dates from tomorrow up to 30 days ahead. No bookings on Sundays.
- 1 to 8 hours, and the work must end by 5 PM.
- Cost = hourly rate × hours + LKR 500 visiting charge. Saturdays add 15% to the labour cost.

**Other**

- English and Sinhala languages.
- No server needed. Categories and providers come from `assets/data/data.json`. Bookings are saved on the device with SQLite (`sqflite`).

## Flutter version

Built and tested with:

- Flutter **3.41.9** (stable channel)
- Dart **3.11.5**

## Setup

1. Install Flutter 3.41.9 ([install guide](https://docs.flutter.dev/get-started/install)).
2. Set up an Android emulator or iOS simulator, or connect a real device.
3. Check your setup:

   ```bash
   flutter doctor
   ```

4. Get the packages:

   ```bash
   flutter pub get
   ```

## Run the app

```bash
flutter run
```

The project has Android and iOS folders, so run it on an Android or iOS device/emulator.

## Run the tests

```bash
flutter test
```

The tests are in `test/` and cover booking cost calculation and booking form validation.
