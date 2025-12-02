-- El Cartel App - Supabase Database Schema
-- Complete schema for multi-tenant ERP system

-- ENUMS
CREATE TYPE app_role AS ENUM ('admin_global', 'admin_rj', 'cajero_rj', 'cocina_rj', 'admin_nr');
CREATE TYPE empresa_tipo AS ENUM ('OPERADOR_RESTAURANTE', 'DUENA_ACTIVOS', 'OPERADOR_ECOMMERCE');
CREATE TYPE estado_venta AS ENUM ('pendiente', 'en_preparacion', 'completada', 'cancelada');
CREATE TYPE metodo_pago AS ENUM ('efectivo', 'tarjeta_debito', 'tarjeta_credito', 'transferencia');
CREATE TYPE tipo_movimiento AS ENUM ('ingreso', 'egreso', 'arriendo', 'compra_activo', 'depreciacion');

-- MAIN TABLES
CREATE TABLE IF NOT EXISTS empresas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nombre TEXT NOT NULL,
  rut TEXT NOT NULL UNIQUE,
  tipo empresa_tipo NOT NULL,
  email TEXT,
  telefono TEXT,
  direccion TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  nombre_completo TEXT,
  telefono TEXT,
  empresa_id UUID REFERENCES empresas(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role app_role NOT NULL,
  UNIQUE(user_id, role)
);

CREATE TABLE IF NOT EXISTS categorias (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nombre TEXT NOT NULL,
  descripcion TEXT,
  color TEXT DEFAULT '#ef4444',
  icono TEXT,
  orden INTEGER DEFAULT 0,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS productos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  nombre TEXT NOT NULL,
  descripcion TEXT,
  precio_venta INTEGER NOT NULL,
  costo_produccion INTEGER DEFAULT 0,
  categoria_id UUID REFERENCES categorias(id),
  sku TEXT,
  imagen_url TEXT,
  tiempo_preparacion INTEGER DEFAULT 15,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ingredientes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  nombre TEXT NOT NULL,
  unidad TEXT NOT NULL,
  stock_actual NUMERIC DEFAULT 0,
  stock_minimo NUMERIC DEFAULT 0,
  costo_unitario INTEGER DEFAULT 0,
  proveedor TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS recetas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  producto_id UUID REFERENCES productos(id),
  ingrediente_id UUID REFERENCES ingredientes(id),
  cantidad NUMERIC NOT NULL,
  notas TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS clientes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  nombre TEXT,
  rut TEXT,
  email TEXT,
  telefono TEXT,
  direccion TEXT,
  notas TEXT,
  total_compras INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ventas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  numero_venta TEXT NOT NULL,
  usuario_id UUID,
  cliente_id UUID REFERENCES clientes(id),
  subtotal INTEGER NOT NULL,
  iva INTEGER DEFAULT 0,
  propina INTEGER DEFAULT 0,
  total INTEGER NOT NULL,
  metodo_pago metodo_pago NOT NULL,
  estado estado_venta DEFAULT 'pendiente',
  notas TEXT,
  completada_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS venta_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venta_id UUID REFERENCES ventas(id) ON DELETE CASCADE,
  producto_id UUID REFERENCES productos(id),
  cantidad INTEGER NOT NULL,
  precio_unitario INTEGER NOT NULL,
  subtotal INTEGER NOT NULL,
  notas TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS activos_fijos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  nombre TEXT NOT NULL,
  descripcion TEXT,
  categoria TEXT,
  valor_compra INTEGER NOT NULL,
  valor_actual INTEGER NOT NULL,
  fecha_compra DATE NOT NULL,
  vida_util_anos INTEGER DEFAULT 5,
  ubicacion TEXT,
  numero_serie TEXT,
  proveedor TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS contratos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_propietaria_id UUID NOT NULL REFERENCES empresas(id),
  empresa_arrendataria_id UUID NOT NULL REFERENCES empresas(id),
  activo_id UUID REFERENCES activos_fijos(id),
  fecha_inicio DATE NOT NULL,
  fecha_termino DATE,
  monto_mensual INTEGER NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  notas TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS movimientos_financieros (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  empresa_id UUID NOT NULL REFERENCES empresas(id),
  tipo tipo_movimiento NOT NULL,
  monto INTEGER NOT NULL,
  fecha DATE DEFAULT CURRENT_DATE,
  descripcion TEXT NOT NULL,
  categoria TEXT,
  venta_id UUID REFERENCES ventas(id),
  contrato_id UUID REFERENCES contratos(id),
  activo_id UUID REFERENCES activos_fijos(id),
  usuario_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS Enable
ALTER TABLE empresas ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE ingredientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE recetas ENABLE ROW LEVEL SECURITY;
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
ALTER TABLE venta_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE activos_fijos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos_financieros ENABLE ROW LEVEL SECURITY;

-- HELPER FUNCTION
CREATE OR REPLACE FUNCTION has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN AS $$
SELECT EXISTS(
  SELECT 1 FROM user_roles WHERE user_id = _user_id AND role = _role
)
$$ LANGUAGE SQL STABLE SECURITY DEFINER SET search_path = public;

-- Indexes for Performance
CREATE INDEX idx_productos_empresa_id ON productos(empresa_id);
CREATE INDEX idx_ingredientes_empresa_id ON ingredientes(empresa_id);
CREATE INDEX idx_clientes_empresa_id ON clientes(empresa_id);
CREATE INDEX idx_ventas_empresa_id ON ventas(empresa_id);
CREATE INDEX idx_venta_items_venta_id ON venta_items(venta_id);
CREATE INDEX idx_activos_empresa_id ON activos_fijos(empresa_id);
CREATE INDEX idx_movimientos_empresa_id ON movimientos_financieros(empresa_id);

COMMENT ON TABLE empresas IS 'Las 3 empresas del ecosistema';
COMMENT ON TABLE user_roles IS 'Tabla separada para almacenar roles de usuarios';
COMMENT ON TABLE movimientos_financieros IS 'Registro de todos los movimientos financieros';
