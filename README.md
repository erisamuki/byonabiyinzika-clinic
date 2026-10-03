# Byonabiyinzika Clinic: Patient Management System

Stack: Flutter (frontend), Node.js + TypeScript, Prisma, PostgreSQL (backend).
Target load: about 300 patients per day.

## Layout

- `frontend/` Flutter app with working screens. It runs today on mock data.
- `backend/` Empty scaffold. Every folder and file exists so you can fill them in module by module.
- `docker-compose.yml` Empty. Will hold PostgreSQL, PgBouncer and the backend.

## Run the frontend

1. Install Flutter (stable channel).
2. From the `frontend` folder, generate the platform folders once:

   ```
   flutter create . --platforms=windows,web,android
   ```

   If this replaces `lib/main.dart` or `test/widget_test.dart`, copy the versions from this project back.
3. Install packages and run:

   ```
   flutter pub get
   flutter run -d windows
   ```

   Use `-d chrome` for web or an Android device id for a tablet.
4. Demo sign-in: the username is the role (`reception`, `nurse`, `doctor`, `cashier`, `lab`, `pharmacy`, `owner`) and the password is `clinic123`.

## Frontend structure

- `core/theme` colours and shared look. Red is reserved for allergy alerts and failed payments.
- `core/widgets` shared pieces: patient header, status chip, money field, search bar, queue list, confirm dialog.
- `core/data` the repository interface, mock data and providers. Replace `MockClinicRepository` with an API version when the backend is ready.
- `core/router` routes, role-based menu and the app shell.
- `features/` one folder per role: reception, nurse, doctor, cashier, lab and pharmacy, owner.

## Connecting the backend later

1. Fill in `backend/` and expose the API under `/api`.
2. Write `ApiClinicRepository` in `frontend/lib/core/data` using `dioProvider`.
3. Return it from `clinicRepositoryProvider` in `providers.dart`.
4. Replace the demo login in `features/auth/auth_controller.dart` with `POST /auth/login` and store the token in `tokenProvider`.
5. Set the server address at build time: `flutter run --dart-define=API_URL=https://your-server/api`.

## Suggested build order for the backend

1. `prisma/schema.prisma`, then `config`, `common`, `auth` and `users`.
2. `patients`, `visits`, `billing`, `payments` (Phase 1).
3. `consultations`, `lab`, `pharmacy`, `insurance`, `followups` (Phase 2).
4. `reports`, `dashboard`, `audit` hardening (Phase 3).
