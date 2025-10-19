-- ARQUIVO: 01_tabelas.sql
-- DESCRIÇÃO: Cria as tabelas para gerenciar produtos, clientes, pedidos e itens de pedido.

-- Tabela para os Produtos
CREATE TABLE produtos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome TEXT NOT NULL,
  descricao TEXT,
  preco NUMERIC(10, 2) NOT NULL,
  estoque INT NOT NULL DEFAULT 0,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tabela para os Clientes (vinculada à autenticação do Supabase)
CREATE TABLE clientes (
  id UUID PRIMARY KEY REFERENCES auth.users(id), -- Chave estrangeira para a tabela de usuários do Supabase
  nome_completo TEXT,
  email TEXT UNIQUE,
  endereco TEXT,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tabela para os Pedidos
CREATE TABLE pedidos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES clientes(id),
  status TEXT NOT NULL DEFAULT 'pendente', -- Ex: pendente, pago, enviado, cancelado
  total NUMERIC(10, 2) DEFAULT 0.00,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tabela de Itens do Pedido (tabela de junção)
CREATE TABLE itens_pedido (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pedido_id UUID NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
  produto_id UUID NOT NULL REFERENCES produtos(id),
  quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario NUMERIC(10, 2) NOT NULL -- Preço no momento da compra
);