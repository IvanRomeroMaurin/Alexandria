# Ecommerce - Clean Architecture (ASP.NET)

## Estructura de la solution

```
src/
├── Domain          # Entidades, Value Objects, Interfaces, Domain Events
├── Application     # Casos de uso CQRS (MediatR), Validaciones, DTOs
├── Infrastructure  # EF Core, Repositorios, Servicios externos
└── API             # Controllers, Middleware, Program.cs

tests/
├── Domain.Tests
├── Application.Tests
└── Integration.Tests
```

## Reglas de dependencia
- **Domain** → sin dependencias externas
- **Application** → solo Domain
- **Infrastructure** → Application + Domain
- **API** → Application + Infrastructure (solo Program.cs para DI)

## Primeros pasos

```bash
# Restaurar paquetes
dotnet restore

# Crear migración inicial
dotnet ef migrations add Initial --project src/SOLUTION.Infrastructure --startup-project src/SOLUTION.API

# Aplicar migración
dotnet ef database update --project src/SOLUTION.Infrastructure --startup-project src/SOLUTION.API

# Ejecutar
dotnet run --project src/SOLUTION.API
```
