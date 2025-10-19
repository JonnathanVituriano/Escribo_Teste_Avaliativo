-- ARQUIVO: 03_funcoes_e_triggers.sql
-- DESCRIÇÃO: Cria a função para calcular o total de um pedido e o trigger que a aciona.

-- 1. A Função que calcula o total
CREATE OR REPLACE FUNCTION public.calcular_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE pedidos
  SET total = (
    SELECT SUM(ip.preco_unitario * ip.quantidade)
    FROM itens_pedido ip
    WHERE ip.pedido_id = NEW.pedido_id
  )
  WHERE id = NEW.pedido_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. O Trigger que dispara a função após a inserção de um item
CREATE TRIGGER on_item_pedido_insert
AFTER INSERT ON public.itens_pedido
FOR EACH ROW
EXECUTE FUNCTION public.calcular_total_pedido();