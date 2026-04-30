# 🛒 Alexara

> ⚡ Plataforma SaaS de e-commerce multi-tenant para el mercado argentino

Alexara es una plataforma moderna que permite a comerciantes crear y gestionar su propia tienda online, con pagos integrados vía MercadoPago.

---

## 🛠️ Tech Stack

- **Backend:** ASP.NET Core 10, Entity Framework Core, PostgreSQL, Clean Architecture, CQRS (MediatR).
- **Frontend:** Next.js 16 (Store, Dashboard, Admin), TypeScript, Tailwind CSS.
- **Pagos:** MercadoPago.

---

## 🚀 Getting Started

### 1. Clonar e Instalar Dependencias

```bash
git clone https://github.com/tu-usuario/alexara.git
cd alexara
npm install
npm run install:all
```

### 2. Configurar Variables de Entorno

**Backend:**
Renombra o copia `apps/api/src/Web/appsettings.Development.json` a `appsettings.json` y configura tu conexión a PostgreSQL.

**Frontend:**
Crea un archivo `.env.local` dentro de `apps/store`, `apps/dashboard` y `apps/admin` indicando la URL de la API:
```bash
NEXT_PUBLIC_API_URL=http://localhost:5203
```

### 3. Ejecutar el Proyecto

Levanta el backend y los frontends en terminales separadas:

```bash
# Backend (API)
cd apps/api/src/Web
dotnet run

# Frontends (desde la raíz del proyecto)
npm run dev --workspace=apps/store
npm run dev --workspace=apps/dashboard
npm run dev --workspace=apps/admin
```

---

## 📦 Estructura del Monorepo

- `apps/api/`: Backend en ASP.NET Core.
- `apps/store/`: Tienda pública (Next.js).
- `apps/dashboard/`: Panel de administración del comerciante (Next.js).
- `apps/admin/`: Panel de control general de Alexara (Next.js).
- `packages/`: Componentes UI compartidos, tipos y utilidades.

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**.