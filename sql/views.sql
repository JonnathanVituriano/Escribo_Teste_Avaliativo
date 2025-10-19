-- ARQUIVO: 04_views.sql
-- DESCRIÇÃO: Cria a view "detalhes_pedidos" para facilitar a consulta de dados combinados.

CREATE OR REPLACE VIEW public.detalhes_pedidos AS
SELECT
  p.id AS pedido_id,
  p.status,
  p.total,
  p.criado_em AS data_pedido,
  c.id AS cliente_id,
  c.nome_completo AS cliente_nome,
  c.email AS cliente_email,
  pr.nome AS produto_nome,
  ip.quantidade,
  ip.preco_unitario
FROM
  pedidos p
  JOIN clientes c ON p.cliente_id = c.id
  JOIN itens_pedido ip ON p.id = ip.pedido_id
  JOIN produtos pr ON ip.produto_id = pr.id;