import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from "../_shared/cors.ts";

serve(async (req) => {
  // Trata requisições OPTIONS (pré-voo CORS)
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { pedido_id } = await req.json();
    if (!pedido_id) throw new Error("ID do pedido é obrigatório.");

    // Crie o cliente Supabase com as permissões de administrador
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Usa a view que criamos para buscar os detalhes do pedido
    const { data, error } = await supabaseAdmin
      .from("detalhes_pedidos")
      .select("*")
      .eq("pedido_id", pedido_id);

    if (error) throw error;
    if (!data || data.length === 0) {
      return new Response(JSON.stringify({ error: "Pedido não encontrado." }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 404,
      });
    }

    // Monta o cabeçalho do CSV
    const csvHeader = "produto_nome,quantidade,preco_unitario\n";
    // Monta as linhas do CSV
    const csvRows = data
      .map(
        (item) =>
          `${item.produto_nome},${item.quantidade},${item.preco_unitario}`
      )
      .join("\n");
    const csvContent = csvHeader + csvRows;

    // Retorna o conteúdo como um arquivo CSV
    return new Response(csvContent, {
      headers: {
        ...corsHeaders,
        "Content-Type": "text/csv",
        "Content-Disposition": `attachment; filename="pedido_${pedido_id}.csv"`,
      },
      status: 200,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
