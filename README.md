# Alexandria

Plataforma de e-commerce SaaS multi-tenant. Permite a comerciantes crear y gestionar su propia tienda online.

## Estructura
Alexandria/
├── apps/
│   ├── backend/     # API REST - ASP.NET Clean Architecture
│   ├── store/       # Tienda pública - Next.js
│   ├── dashboard/   # Panel del comerciante - Next.js
│   └── admin/       # Panel administrativo - Next.js
└── packages/
├── ui/          # Componentes compartidos
├── types/       # Tipos TypeScript compartidos
└── utils/       # Utilidades compartidas

## Tech Stack

- **Backend:** ASP.NET Core 10, Clean Architecture, EF Core, MediatR
- **Frontend:** Next.js 16, TypeScript, Tailwind CSS
- **Pagos:** MercadoPago
- **Base de datos:** PostgreSQL

## Levantar el proyecto

### Backend
```bash
cd apps/backend/src/Web
dotnet run
```

### Frontends
```bash
npm run store       # http://localhost:3000
npm run dashboard   # http://localhost:3000
npm run admin       # http://localhost:3000
```