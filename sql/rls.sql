-- ARQUIVO: 02_rls.sql
-- DESCRIÇÃO: Ativa o RLS e cria as políticas de segurança para garantir que os usuários só acessem seus próprios dados.

-- Ativar RLS em todas as tabelas
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE itens_pedido ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos ENABLE ROW LEVEL SECURITY;

-- --- POLÍTICAS DE SEGURANÇA ---

-- Tabela Clientes: O usuário só pode ver e editar seus próprios dados.
CREATE POLICY "Clientes podem ver e atualizar seu próprio perfil" ON clientes
FOR ALL
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Tabela Pedidos: O usuário só pode ver seus próprios pedidos e criar novos para si mesmo.
CREATE POLICY "Clientes podem ver seus próprios pedidos" ON pedidos
FOR SELECT
USING (auth.uid() = cliente_id);

CREATE POLICY "Clientes podem criar pedidos para si mesmos" ON pedidos
FOR INSERT
WITH CHECK (auth.uid() = cliente_id);

-- Tabela Itens_Pedido: O usuário só pode ver e inserir itens de pedidos que ele mesmo fez.
CREATE POLICY "Clientes podem ver os itens dos seus pedidos" ON itens_pedido
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM pedidos
    WHERE pedidos.id = itens_pedido.pedido_id AND pedidos.cliente_id = auth.uid()
  )
);
CREATE POLICY "Clientes podem inserir itens em seus pedidos" ON itens_pedido
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM pedidos
    WHERE pedidos.id = itens_pedido.pedido_id AND pedidos.cliente_id = auth.uid()
  )
);

-- Tabela Produtos: Qualquer pessoa (mesmo não logada) pode ver os produtos.
CREATE POLICY "Qualquer pessoa pode visualizar os produtos" ON produtos
FOR SELECT
USING (true);