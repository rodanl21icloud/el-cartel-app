# El Cartel App - Backup Manifest

## Proyecto Completado: Sistema ERP Multi-Empresa

**Fecha del Backup:** 2 de Diciembre, 2024
**Repositorio:** github.com/rodanl21icloud/el-cartel-app
**Proyecto Lovable:** ec0597db-c955-440c-94b1-064413936930
**Usuario:** rodanl21

---

## DESCRIPCIÓN DEL PROYECTO

**El Cartel App** es un sistema ERP integrado para gestionar un ecosistema de tres empresas chilenas relacionadas:

1. **RJ Inversiones** - Restaurante "El Cartel de los Pollos" (pollos a las brasas y papas fritas)
2. **NR SPA** - Empresa de inversiones (activos fijos y arriendos)
3. **After Fresh Delivery (AFD)** - E-commerce de huevos y lácteos premium

---

## ESTRUCTURA DEL PROYECTO LOVABLE

### RAÍZ
```
├── public/
│   ├── favicon.ico
│   ├── manifest.json
│   ├── placeholder.svg
│   └── robots.txt
├── src/
│   ├── pages/
│   ├── components/
│   ├── hooks/
│   ├── integrations/
│   ├── lib/
│   ├── scripts/
│   ├── App.tsx
│   ├── App.css
│   ├── index.css
│   ├── main.tsx
│   └── vite-env.d.ts
├── supabase/
│   ├── migrations/
│   └── config.toml
├── .env
├── .gitignore
├── components.json
├── eslint.config.js
├── index.html
├── package.json
├── postcss.config.js
├── README.md
├── tailwind.config.ts
├── tsconfig.json
├── tsconfig.app.json
├── tsconfig.node.json
└── vite.config.ts
```

### PÁGINAS (src/pages/)
- **Auth.tsx** - Login con email/password
- **CreateAdmin.tsx** - Creación de primer usuario administrador
- **Dashboard.tsx** - Dashboard RJ Inversiones
- **DashboardNR.tsx** - Dashboard NR SPA
- **DashboardAFD.tsx** - Dashboard After Fresh Delivery
- **DashboardConsolidado.tsx** - Vista consolidada (Admin Global)
- **POS.tsx** - Punto de venta + Historial de transacciones
- **Inventario.tsx** - Gestión de productos, ingredientes y recetas
- **Clientes.tsx** - Base de datos de clientes
- **Finanzas.tsx** - Movimientos financieros y reportes
- **Activos.tsx** - Activos fijos y contratos de arriendo
- **Reportes.tsx** - Reportes multiempresa
- **AsesorIA.tsx** - Asesor IA (placeholder)
- **Configuracion.tsx** - Configuración de categorías, empresa y usuarios

### COMPONENTES (src/components/)
- **Layout/MainLayout.tsx** - Layout principal con autenticación y selector de empresa
- **EmpresaSelector.tsx** - Selector de empresa post-login
- **Dashboard/** - Gráficos y cards de KPIs
- **POS/** - Componentes para punto de venta
- **Inventario/** - CRUD para productos, ingredientes, recetas
- **Clientes/** - Gestión de clientes
- **Finanzas/** - Movimientos, reportes, exportación
- **Activos/** - Gestión de activos y contratos
- **Reportes/** - Componentes de reportes
- **Configuracion/** - Gestión de configuración

### UTILIDADES (src/lib/ y src/hooks/)
- **integrations/supabase/** - Cliente de Supabase y tipos TypeScript
- **lib/utils.ts** - Funciones de utilidad
- **hooks/use-toast.ts** - Hook para notificaciones
- **hooks/use-mobile.tsx** - Detector de dispositivos móviles

---

## STACK TECNOLÓGICO

**Frontend:**
- React 18 + TypeScript
- Vite
- React Router DOM v6
- TanStack React Query
- Tailwind CSS + shadcn/ui
- Lucide React
- Recharts
- React Hook Form + Zod
- date-fns (locale: es)
- jspdf + jspdf-autotable
- @hookform/resolvers
- radix-ui components

**Backend:**
- Supabase (PostgreSQL)
- Supabase Auth
- Supabase Storage
- Row Level Security (RLS)

---

## CONFIGURACIÓN CRÍTICA

### Supabase Auth Settings
- ✅ Auto-confirm email: HABILITADO
- ✅ Email confirmations: DESHABILITADO
- ✅ Signup: DESHABILITADO (solo Admin crea usuarios)

### Storage
- Bucket **"productos"** - Público (imágenes de productos)

### Variables de Entorno (.env)
```
VITE_SUPABASE_URL=<URL>
VITE_SUPABASE_ANON_KEY=<KEY>
```

---

## AUTENTICACIÓN Y ROLES

### Roles (5 roles definidos)
1. **admin_global** - Acceso a todas las empresas + Vista Consolidada
2. **admin_rj** - Solo RJ Inversiones
3. **cajero_rj** - POS y gestión de caja RJ
4. **cocina_rj** - Tickets de cocina RJ
5. **admin_nr** - Solo NR SPA

### Seguridad
- Roles almacenados en tabla separada `user_roles`
- RLS habilitado en todas las tablas
- Función `has_role()` con SECURITY DEFINER para verificación
- Filtrado por `empresa_id` en todas las queries

---

## FUNCIONALIDADES IMPLEMENTADAS

✅ **Autenticación** - Login/Logout, Selector de empresa
✅ **POS** - Carrito, métodos de pago, historial de transacciones
✅ **Inventario** - Productos, Ingredientes, Recetas
✅ **Clientes** - CRUD con datos sensibles restringidos
✅ **Finanzas** - Movimientos, filtros, paginación, exportación PDF/Excel
✅ **Activos** - Activos fijos y contratos de arriendo
✅ **Dashboards** - RJ, NR, AFD, Consolidado (con gráficos)
✅ **Reportes** - Ventas, Finanzas, Inventario
✅ **Configuración** - Categorías, Empresa, Usuarios
✅ **Accesibilidad** - WCAG 2.1 (contraste 4.5:1, aria-labels)
✅ **Localización** - Español chileno, CLP, formato fechas

---

## BASES DE DATOS - TABLAS PRINCIPALES

1. **empresas** - Datos de las 3 empresas
2. **profiles** - Perfiles de usuario (vinculado a auth.users)
3. **user_roles** - Asignación de roles por usuario
4. **categorias** - Categorías de productos
5. **productos** - Catálogo de productos
6. **ingredientes** - Materias primas
7. **recetas** - Relación producto-ingrediente
8. **clientes** - Base de clientes
9. **ventas** - Transacciones de venta
10. **venta_items** - Items detallados de ventas
11. **activos_fijos** - Equipos y activos
12. **contratos** - Contratos de arriendo entre empresas
13. **movimientos_financieros** - Registro financiero
14. **conversaciones_ia** - Conversaciones del asesor IA
15. **mensajes_ia** - Mensajes del asesor IA

---

## NOTAS DE IMPLEMENTACIÓN CRÍTICAS

1. **Tabla de Roles Separada** - NO guardar roles en profiles, usar tabla user_roles
2. **RLS Obligatorio** - Todas las tablas deben tener Row Level Security
3. **Función has_role()** - Usar SECURITY DEFINER para evitar recursión
4. **Filtrado por empresa_id** - TODAS las queries deben filtrar por empresa_id del usuario
5. **localStorage selected_empresa_id** - Persistir empresa seleccionada entre sesiones
6. **Trigger handle_new_user()** - Auto-crear profile cuando se registra nuevo usuario
7. **Auto-confirm Email** - Habilitado en Supabase Auth settings
8. **Registro Público Deshabilitado** - Solo Admin Global puede crear usuarios

---

## INFORMACIÓN DEL PROYECTO LOVABLE

**Identificador del Proyecto:** ec0597db-c955-440c-94b1-064413936930
**Nombre:** Brasa Hub / El Cartel App
**Descripción:** Sistema de gestión integrado para 3 empresas chilenas relacionadas
**Estado:** ✅ COMPLETADO Y FUNCIONAL

### Acceso al Código Original
Todos los archivos fuente están disponibles en Lovable:
- URL: https://lovable.dev/projects/ec0597db-c955-440c-94b1-064413936930?view=codeEditor
- Usuario: rodanl21

---

## INSTRUCCIONES PARA RECUPERACIÓN

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/rodanl21icloud/el-cartel-app.git
   cd el-cartel-app
   ```

2. **Instalar dependencias:**
   ```bash
   npm install
   ```

3. **Configurar variables de entorno (.env):**
   ```
   VITE_SUPABASE_URL=<tu_url>
   VITE_SUPABASE_ANON_KEY=<tu_key>
   ```

4. **Ejecutar servidor de desarrollo:**
   ```bash
   npm run dev
   ```

5. **Build para producción:**
   ```bash
   npm run build
   ```

---

**Backup completado exitosamente.** Este archivo sirve como índice completo de la aplicación.
