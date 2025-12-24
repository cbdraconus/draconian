# Responder Schedule

This repo now includes a secure, reliable scaffold for a police department scheduling system.

## Backend (ASP.NET Core)
Location: `scheduler-backend/`

### Development
1. Ensure PostgreSQL is running.
2. Update `scheduler-backend/appsettings.json` with connection settings.
3. Run the API:
   ```bash
   dotnet run --project scheduler-backend/Scheduler.Api.csproj
   ```

The API exposes:
- `GET /api/health`
- `GET /api/schedules/my` (authorized)
- `GET /api/schedules/department` (authorized)

## Frontend (React + Vite)
Location: `scheduler-frontend/`

### Development
```bash
npm install
npm run dev
```

## Seed Admin User
Set the initial admin credentials in `scheduler-backend/appsettings.json` (or environment variables) under `SeedAdmin`.

```json
\"SeedAdmin\": {
  \"UserName\": \"admin\",
  \"Email\": \"admin@agency.gov\",
  \"Password\": \"use-a-secure-password\"
}
```

> Leave these values blank to skip seeding an admin. Always set a secure JWT signing key in production.
