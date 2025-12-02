# 🔥 El Cartel App

**Sistema ERP integrado para gestión de empresas relacionadas**

> Una solución completa para gestionar un ecosistema de tres empresas chilenas: restaurante, inversiones y e-commerce de delivery.

---

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Arquitectura](#arquitectura)
- [Características](#características)
- [Tech Stack](#tech-stack)
- [Instalación](#instalación)
- [Documentación](#documentación)
- [Licencia](#licencia)

---

## Descripción

**El Cartel App** es un sistema ERP (Enterprise Resource Planning) diseñado para gestionar tres empresas relacionadas en un modelo de negocio integrado:

### Las Tres Empresas

1. **RJ Inversiones** (Restaurante)
   - Negocio: Restaurante "El Cartel de los Pollos" (pollos a la brasa y papas fritas)
   - Módulos: POS, Inventario, Finanzas, Clientes, Reportes
   - Arrenda equipos de NR SPA ($8,000/mes)

2. **NR SPA** (Inversiones)
   - Negocio: Empresa de inversiones que posee y arrienda activos fijos
   - Módulos: Gestión de Activos, Contratos, Finanzas
   - Ingresos: $13,000/mes (arriendo a RJ y AFD)
   - Reinvierte en instrumentos financieros

3. **After Fresh Delivery (AFD)** (E-Commerce)
   - Negocio: Delivery de huevos y lácteos premium a domicilio
   - Zonas: Providencia y Las Condes (Santiago, Chile)
   - Módulos: Dashboard E-commerce, Pedidos, Clientes, Finanzas
   - Arrenda equipos de NR SPA ($5,000/mes)

---

## Arquitectura

### Componentes Principales

```
┌─────────────────────────────────────┐
│     El Cartel App (Frontend)        │
│   React 18 + TypeScript + Vite      │
└──────────────┬──────────────────────┘
               │
               ├─── Dashboard RJ (Restaurante)
               ├─── Dashboard NR (Inversiones)
               ├─── Dashboard AFD (E-commerce)
               └─── Dashboard Consolidado (Admin Global)
               │
┌──────────────▼──────────────────────┐
│      Backend: Supabase              │
│  PostgreSQL + Auth + Storage + RLS  │
└──────────────┬──────────────────────┘
               │
               ├─── Authentication (Supabase Auth)
               ├─── Database (PostgreSQL)
               ├─── Storage (Imágenes, archivos)
               └─── Row Level Security (RLS)
```

### Sistema de Roles

- **admin_global**: Acceso a todas las empresas + Vista Consolidada
- **admin_rj**: Administrador de RJ Inversiones
- **cajero_rj**: Operario de POS
- **cocina_rj**: Personal de cocina (tickets)
- **admin_nr**: Administrador de NR SPA

---

## Características

### 🏪 Módulo POS/Ventas (RJ)
- Grid de productos con categorías
- Carrito de compra lateral
- Métodos de pago: Efectivo, Tarjeta Débito/Crédito, Transferencia
- Generación automática de número de venta
- Historial de transacciones con reimpresión

### 📦 Módulo Inventario (RJ)
- CRUD de productos con imágenes
- Gestión de ingredientes y recetas
- Control de stock con alertas
- Categorías customizables

### 👥 Módulo Clientes
- CRUD de clientes con RUT, email, teléfono
- Información sensible restringida por rol
- KPI: Total clientes y compras acumuladas

### 💰 Módulo Finanzas
- Resumen de ingresos/egresos
- Tabla de movimientos financieros con filtros
- Exportación: PDF, Excel, CSV
- Categorización por tipo (ingreso, egreso, arriendo, etc)

### 🏢 Módulo Activos & Contratos
- Gestión de activos fijos (NR SPA)
- Contratos de arriendo entre empresas
- Seguimiento de vida útil y depreciación

### 📊 Dashboards
- **RJ**: Ventas hoy/mes, Clientes, Productos activos, Gráficos de ventas
- **NR**: Activos totales, Valor activos, Contratos activos, Ingresos renta
- **AFD**: Ventas, Pedidos, Clientes, Ticket promedio
- **Consolidado**: KPIs combinados de las 3 empresas

### 📈 Módulo Reportes
- Reportes de ventas, finanzas e inventario
- Gráficos y estadísticas
- Exportación a PDF

---

## Tech Stack

### Frontend
- **React 18** con TypeScript
- **Vite** para build
- **React Router DOM v6** para routing
- **TanStack React Query** para data fetching
- **Tailwind CSS** + **shadcn/ui** para UI
- **Recharts** para gráficos
- **React Hook Form** + **Zod** para validación de formularios
- **date-fns** para manejo de fechas (locale es-CL)
- **jsPDF** + **jspdf-autotable** para exportación PDF
- **Lucide React** para iconos

### Backend
- **Supabase** (PostgreSQL, Auth, Storage, RLS)
- PostgreSQL 14+
- Row Level Security (RLS) para control de acceso
- Auto-confirm email habilitado
- Registro público deshabilitado

### Base de Datos
12 tablas principales:
- empresas, profiles, user_roles
- productos, categorias, ingredientes, recetas
- clientes, ventas, venta_items
- activos_fijos, contratos
- movimientos_financieros

---

## Instalación

### Prerrequisitos
- Node.js 16+
- npm o yarn
- Cuenta Supabase

### Pasos

1. **Clonar el repositorio**
```bash
git clone https://github.com/rodanl21icloud/el-cartel-app.git
cd el-cartel-app
```

2. **Instalar dependencias**
```bash
npm install
```

3. **Configurar variables de entorno**
Crea un archivo `.env.local`:
```
VITE_SUPABASE_URL=tu_supabase_url
VITE_SUPABASE_ANON_KEY=tu_supabase_key
```

4. **Iniciar desarrollo**
```bash
npm run dev
```

5. **Build para producción**
```bash
npm run build
```

---

## Documentación

- [Setup Completo del Proyecto](./docs/setup.md)
- [Schema de Base de Datos](./docs/database.md)
- [Políticas RLS](./docs/rls-policies.md)
- [Guía de Roles](./docs/roles.md)
- [API Reference](./docs/api.md)

---

## Roadmap

- [ ] Módulo de Asesor IA (Consultas tributarias)
- [ ] Integración con WhatsApp Business API
- [ ] Sistema de notificaciones en tiempo real
- [ ] Mobile app (React Native)
- [ ] Integración con proveedores (pedidos automáticos)

---

## Licencia

MIT License - Ver [LICENSE](./LICENSE) para más detalles.

---

## Contacto

**Creado por**: Rodrigo López (@rodanl21icloud)
**Proyecto**: After Fresh Delivery + Ecosystem Management
**Ubicación**: Santiago, Chile

---

**🔥 Built with Lovable | React | Supabase**
