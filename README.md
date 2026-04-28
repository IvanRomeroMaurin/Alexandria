# 🛒 Alexandria

[![ASP.NET Core](https://img.shields.io/badge/ASP.NET%20Core-10.0-purple?style=flat-square&logo=.net)](https://dotnet.microsoft.com/)
[![Next.js](https://img.shields.io/badge/Next.js-16-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-blue?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-3.4-38bdf8?style=flat-square&logo=tailwind-css)](https://tailwindcss.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?style=flat-square&logo=postgresql)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

> ⚡ Plataforma SaaS de e-commerce multi-tenant para el mercado argentino

Alexandria es una plataforma de e-commerce moderna que permite a comerciantes crear y gestionar su propia tienda online con pagos integrados via MercadoPago. Similar a Tienda Nube, pero con arquitectura moderna y escalable.

---

## 📋 Tabla de Contenidos

- [✨ Características](#-características)
- [🏗️ Arquitectura](#-arquitectura)
- [🛠️ Tech Stack](#-tech-stack)
- [🚀 Getting Started](#-getting-started)
- [🌐 Multi-Tenant & Subdominios](#-multi-tenant--subdominios)
- [📦 Estructura del Proyecto](#-estructura-del-proyecto)
- [🗺️ Roadmap](#-🗺️-roadmap)
- [🤝 Contribución](#-contribución)
- [📄 Licencia](#-licencia)

---

## ✨ Características

| Característica | Descripción |
|----------------|-------------|
| 🏪 **Multi-Tenant** | Cada comerciante tiene su propia tienda con subdominio personalizado |
| 💳 **Pagos** | Integración completa con MercadoPago |
| 📱 **Responsive** | Interfaces adaptadas a todos los dispositivos |
| 🔐 **Autenticación** | Sistema de usuarios y roles |
| 📦 **Gestión de Productos** | Catálogo completo con categorías e inventario |
| 🛒 **Carrito de Compras** | Carrito persistente con sesión |
| 📊 **Dashboard** | Panel de estadísticas y gestión de pedidos |
| ⚙️ **Configuración** | Personalización de tienda (logo, colores, banner) |

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                        Alexandria Platform                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐       │
│  │     Store    │    │   Dashboard  │    │    Admin     │       │
│  │  (Frontend)  │    │  (Frontend)  │    │  (Frontend)  │       │
│  │  Next.js 16  │    │  Next.js 16  │    │  Next.js 16  │       │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘       │
│         │                   │                   │               │
│         └───────────────────┼───────────────────┘               │
│                             │                                    │
│                      ┌──────▼──────┐                           │
│                      │  ASP.NET    │                           │
│                      │  Core API   │                           │
│                      │  (Backend)  │                           │
│                      └──────┬──────┘                           │
│                             │                                    │
│         ┌───────────────────┼───────────────────┐               │
│         │                   │                   │               │
│  ┌──────▼──────┐    ┌───────▼──────┐    ┌───────▼──────┐        │
│  │ Application │    │   Domain    │    │Infrastructure│        │
│  │   (CQRS)   │    │  (Entities) │    │ (EF Core)    │        │
│  └─────────────┘    └─────────────┘    └──────────────┘        │
│                                                                  │
│                             │                                    │
│                      ┌──────▼──────┐                           │
│                      │ PostgreSQL  │                           │
│                      │  Database   │                           │
│                      └─────────────┘                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 🏛️ Patrones y Principios

- **Clean Architecture** — Separación clara en capas
- **CQRS** — Command Query Responsibility Segregation con MediatR
- **Repository Pattern** — Abstracción de acceso a datos
- **Unit of Work** — Transacciones atómicas
- **Multi-Tenant** — Aislamiento por subdominio

---

## 🛠️ Tech Stack

### Backend

| Tecnología | Propósito |
|------------|-----------|
| ![](https://img.shields.io/badge/.NET-10.0-512BD4?style=flat-square) | Framework |
| ![](https://img.shields.io/badge/ASP.NET%20Core-10.0-512BD4?style=flat-square) | Web API |
| ![](https://img.shields.io/badge/EF%20Core-9.0-512BD4?style=flat-square) | ORM |
| ![](https://img.shields.io/badge/MediatR-12.4-512BD4?style=flat-square) | CQRS |
| ![](https://img.shields.io/badge/FluentValidation-11.0-512BD4?style=flat-square) | Validación |

### Frontend

| Tecnología | Propósito |
|------------|-----------|
| ![](https://img.shields.io/badge/Next.js-16.0-black?style=flat-square) | Framework |
| ![](https://img.shields.io/badge/TypeScript-5.7-3178C6?style=flat-square) | Tipado |
| ![](https://img.shields.io/badge/Tailwind%20CSS-3.4-38BDF8?style=flat-square) | Estilos |
| ![](https://img.shields.io/badge/React%20Query-5.0-FF4154?style=flat-square) | Estado |

### Infraestructura

| Tecnología | Propósito |
|------------|-----------|
| ![](https://img.shields.io/badge/PostgreSQL-16-336791?style=flat-square) | Base de datos |
| ![](https://img.shields.io/badge/MercadoPago-2.0-00BFFF?style=flat-square) | Pagos |

---

## 🚀 Getting Started

### 📌 Requisitos Previos

- **.NET 10 SDK** — [Descargar](https://dotnet.microsoft.com/download)
- **Node.js 20+** — [Descargar](https://nodejs.org/)
- **PostgreSQL 16+** — [Descargar](https://www.postgresql.org/download/)
- **npm 10+** — Incluido con Node.js

### 🔧 Configuración Inicial

1. **Clonar el repositorio**

```bash
git clone https://github.com/tu-usuario/alexandria.git
cd alexandria
```

2. **Instalar dependencias del frontend**

```bash
# Dependencias raíz
npm install

# Dependencias de cada app
npm run install:all
```

3. **Configurar variables de entorno**

```bash
# Backend
cp apps/backend/src/Web/appsettings.Development.json apps/backend/src/Web/appsettings.json

# Frontends - crear .env.local en cada app
touch apps/store/.env.local
touch apps/dashboard/.env.local
touch apps/admin/.env.local
```

4. **Configurar puertos de desarrollo**

Los scripts `dev` de dashboard y admin necesitan el flag `--port` para evitar conflictos con el store:

```bash
# apps/dashboard/package.json
"dev": "next dev --port 3001"

# apps/admin/package.json
"dev": "next dev --port 3002"
```

> ✅ El store usa el puerto 3000 por defecto, no necesita configuración extra.

### ⚙️ Variables de Entorno

#### Backend (`apps/backend/src/Web/appsettings.json`)

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=alexandria;Username=postgres;Password=tu_password"
  },
  "MercadoPago": {
    "AccessToken": "TU_ACCESS_TOKEN",
    "PublicKey": "TU_PUBLIC_KEY",
    "WebhookUrl": "https://tu-dominio.com/api/webhooks/mercadopago"
  },
  "App": {
    "BaseUrl": "http://localhost:5000",
    "StoreBaseUrl": "http://localhost:3000"
  }
}
```

> 🔐 **Nota:** Para obtener tokens de MercadoPago, crea una cuenta en [MercadoPago Developers](https://www.mercadopago.com.ar/developers).

### 📄 Archivos `.env.example`

Para facilitar la configuración inicial, creá estos archivos en cada app:

**`apps/store/.env.example`**
```bash
NEXT_PUBLIC_API_URL=http://localhost:5186
```

**`apps/dashboard/.env.example`**
```bash
NEXT_PUBLIC_API_URL=http://localhost:5186
```

**`apps/admin/.env.example`**
```bash
NEXT_PUBLIC_API_URL=http://localhost:5186
```

Luego copiá cada `.env.example` a `.env.local` y ajustá los valores según tu entorno.

#### Frontend (`.env.local`)

Cada aplicación Next.js necesita su propio archivo `.env.local` en su directorio:

```bash
# apps/store/.env.local
NEXT_PUBLIC_API_URL=http://localhost:5186

# apps/dashboard/.env.local
NEXT_PUBLIC_API_URL=http://localhost:5186

# apps/admin/.env.local
NEXT_PUBLIC_API_URL=http://localhost:5186
```

> ⚠️ **Importante:** Crear el archivo `.env.local` en cada carpeta de app (no en la raíz del proyecto).

### 🏃 Ejecutar el Proyecto

#### Modo Desarrollo

```bash
# Terminal 1: Backend
cd apps/backend/src/Web
dotnet run

# Terminal 2: Store (Tienda pública)
npm run dev --workspace=apps/store

# Terminal 3: Dashboard (Panel comerciante)
npm run dev --workspace=apps/dashboard

# Terminal 4: Admin (Panel administrativo)
npm run dev --workspace=apps/admin
```

#### Puertos

| Aplicación | Puerto | URL |
|------------|--------|-----|
| 🏪 Store | 3000 | http://localhost:3000 |
| 📊 Dashboard | 3001 | http://localhost:3001 |
| ⚙️ Admin | 3002 | http://localhost:3002 |
| 🔌 API | 5186 | http://localhost:5186 |

> 🔍 **¿Qué puerto usa el backend?** Al ejecutar `dotnet run`, el output muestra el puerto en que está escuchando (por defecto `http://localhost:5186`). Si ves otro puerto en la consola, usá ese en lugar del 5186.

---

## 🌐 Multi-Tenant & Subdominios

Alexandria implementa una arquitectura multi-tenant donde cada comerciante tiene su propia tienda aislada mediante subdominios.

### 🏠 Estructura de Subdominios

```
┌─────────────────────────────────────────────────────────────┐
│                    Flujo de Multi-Tenant                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  usuario1.alexandria.local  ──►  Tienda de Usuario 1        │
│       │                                                            │
│       ▼                                                            │
│  usuario2.alexandria.local  ──►  Tienda de Usuario 2        │
│       │                                                            │
│       ▼                                                            │
│  admin.alexandria.local     ──►  Panel Administrativo        │
│       │                                                            │
│       ▼                                                            │
│  dashboard.alexandria.local ──►  Panel del Comerciante       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 🔑 Conceptos Clave

| Concepto | Descripción |
|----------|-------------|
| **Tenant** | Cada tienda/comerciante está aislada |
| **Subdominio** | Identifica al tenant (ej: `mitienda.alexandria.com`) |
| **Host Header** | El backend extrae el subdominio para filtrar datos |
| **Schema por Tenant** | (Opcional) Schema separado en PostgreSQL |

### 🛠️ Configuración de Hosts

En `apps/backend/src/Web/Program.cs`:

```csharp
// El middleware de multi-tenant extrae el subdominio del Host
app.UseMiddleware<TenantMiddleware>();
```

---

## 📦 Estructura del Proyecto

```
alexandria/
├── 📁 apps/
│   ├── 🏪 store/           # Tienda pública (Next.js)
│   │   ├── app/
│   │   ├── components/
│   │   └── public/
│   ├── 📊 dashboard/       # Panel del comerciante (Next.js)
│   │   ├── app/
│   │   ├── components/
│   │   └── public/
│   └── ⚙️ admin/           # Panel administrativo (Next.js)
│       ├── app/
│       ├── components/
│       └── public/
│
├── 📁 packages/
│   ├── 🎨 ui/              # Componentes compartidos
│   │   └── src/
│   ├── 📝 types/           # Tipos TypeScript
│   │   └── src/
│   └── 🔧 utils/          # Utilidades
│       └── src/
│
└── 📁 apps/backend/
    └── src/
        ├── 🏛️ Application/    # CQRS Handlers
        ├── 🏭 Domain/         # Entidades
        ├── 🗄️ Infrastructure/ # EF Core, Servicios
        ├── 🌐 Web/            # API REST
        └── 🏠 AppHost/       # Configuración
```

---

## 🗺️ Roadmap

### ✅ Completado

- [x] Estructura base del proyecto
- [x] Configuración de Clean Architecture
- [x] Integración con MercadoPago (básica)
- [x] Catálogo de productos
- [x] Carrito de compras

### 🚧 En Progreso

- [ ] Sistema de autenticación
- [ ] Gestión de pedidos
- [ ] Dashboard de estadísticas

### 📋 Por Desarrollar

| Feature | Prioridad | Descripción |
|---------|-----------|-------------|
| 🔐 **Auth con JWT** | Alta | Sistema de login y registro |
| 📦 **Gestión de Órdenes** | Alta | Carrito, checkout, historial |
| 📊 **Métricas** | Media | Ventas, visitas, productos |
| 📧 **Notificaciones** | Media | Email, SMS, WebPush |
| 📦 **Inventario** | Media | Stock, alertas |
| 🏷️ **Descuentos** | Baja | Cupones, promociones |
| 📱 **PWA** | Baja | App instalable |
| 📈 **Reportes** | Baja | Exportación PDF/Excel |

---

## 🤝 Contribución

¡Contribuciones son bienvenidas! 🎉

### 📌 Pasos para Contribuir

1. **Fork** el repositorio
2. Crear una rama (`git checkout -b feature/mi-feature`)
3. **Commit** tus cambios (`git commit -m 'Add: nueva feature'`)
4. **Push** a la rama (`git push origin feature/mi-feature`)
5. Abrir un **Pull Request**

### 📖 Guías de Estilo

- Usar **Conventional Commits** para mensajes de commit
- Mantener el código siguiendo las convenciones del proyecto
- Agregar tests para nuevas funcionalidades
- Actualizar la documentación

### 🐛 Reportar Bugs

Usar [GitHub Issues](https://github.com/tu-usuario/alexandria/issues) para reportar bugs o solicitar features.

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT** — ver el archivo [LICENSE](LICENSE) para detalles.

---

## 📨 Contacto

- **GitHub**: [github.com/tu-usuario/alexandria](https://github.com/tu-usuario/alexandria)
- **Discord**: [Únete a nuestra comunidad](https://discord.gg/alexandria)

---

<div align="center">

⭐️ Si te gusta este proyecto, no olvides dar una estrella!

</div>