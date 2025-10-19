# Desafio Técnico: Estrutura de E-commerce com Supabase

## Visão Geral do Projeto

Imagine uma loja online como uma loja física. Ela tem a vitrine (o site ou aplicativo que o cliente vê) e os bastidores (o estoque, o caixa, os registros de clientes e o sistema de segurança).

Este projeto construiu todos os **bastidores** dessa loja digital. É o que chamamos de "backend": o motor inteligente e invisível que organiza, protege e gerencia todas as informações e operações do e-commerce. Para construir essa estrutura, utilizamos uma plataforma moderna chamada **Supabase**.

## Funcionalidades Implementadas: O que o Projeto Faz?

O projeto executa cinco tarefas essenciais para o funcionamento de qualquer e-commerce.

1.  **Organiza as Informações (Criação de Tabelas)**
    * **O que faz?** Criamos "fichários" digitais (Tabelas no banco de dados) para guardar de forma organizada todas as informações importantes: um para os `clientes`, um para os `produtos` à venda, um para os `pedidos` realizados e um último para detalhar os itens de cada pedido.
    * **Por que é importante?** Sem essa organização, as informações ficariam perdidas, e seria impossível saber quem comprou o quê.

2.  **Garante a Privacidade dos Clientes (Row-Level Security)**
    * **O que faz?** Implementamos um sistema de segurança avançado que funciona como um "porteiro" em cada linha de dado. Ele garante que um cliente, ao se logar, possa ver **apenas** os seus próprios pedidos e informações. Ninguém consegue espiar os dados de outra pessoa.
    * **Por que é importante?** Isso é fundamental para a segurança e a privacidade, prevenindo o acesso não autorizado a dados sensíveis, como históricos de compra e endereços.

3.  **Automatiza Tarefas (Funções no Banco de Dados)**
    * **O que faz?** Criamos um "assistente automático" que calcula o valor total de uma compra sozinho. Assim que um novo produto é adicionado a um pedido, esse assistente (chamado de `trigger`) entra em ação e atualiza o total instantaneamente, sem chance de erro humano.
    * **Por que é importante?** Garante que os totais dos pedidos sejam sempre precisos e confiáveis, o que é crucial para o faturamento da loja.

4.  **Facilita a Busca de Informações (Criação de Views)**
    * **O que faz?** Criamos um "relatório pronto" (chamado de `view`) que junta as informações mais importantes de vários fichários em um só lugar. Ele mostra de forma clara e rápida quem foi o cliente, o que ele comprou e qual o status do pedido.
    * **Por que é importante?** Isso melhora drasticamente o desempenho. Em vez de o sistema precisar fazer buscas complexas em vários lugares toda vez, ele consulta esse relatório pronto, entregando a informação de forma muito mais rápida para quem administra a loja.

5.  **Cria Ferramentas Sob Demanda (Edge Functions)**
    * **O que faz?** Desenvolvemos uma ferramenta especial que, ao ser acionada, gera um relatório de um pedido específico e o exporta para uma planilha (arquivo no formato CSV).
    * **Por que é importante?** Permite a criação de funcionalidades extras e automações, como enviar e-mails ou gerar relatórios, sem a necessidade de um servidor tradicional, tornando a operação mais eficiente.

## Decisões Técnicas (Para o Avaliador)

A solução foi desenvolvida com foco nos critérios de **funcionamento, código limpo, segurança e desempenho**.

* **Segurança como Prioridade:** A escolha pelo **Row-Level Security (RLS)** é o pilar da segurança deste projeto. Diferente de outras abordagens, o RLS aplica as regras de permissão diretamente no banco de dados. Isso significa que a proteção está na camada mais fundamental do sistema, garantindo que, mesmo em caso de falha em outra parte do software, os dados permaneçam seguros.

* **Desempenho Otimizado:** A `view` chamada `detalhes_pedidos` foi criada para evitar consultas lentas e repetitivas. Em um e-commerce, a consulta de detalhes de um pedido é uma das operações mais frequentes. Ao pré-unir os dados, a aplicação final executa uma única leitura simples, resultando em respostas mais rápidas para o usuário e menor carga no banco de dados.

* **Integridade dos Dados:** A automação do cálculo do total do pedido via `trigger` é uma decisão crucial. Ela move essa lógica de negócio para o backend, eliminando o risco de manipulação ou erros de cálculo que poderiam ocorrer se a responsabilidade fosse do aplicativo do cliente. Isso garante que o valor faturado seja sempre a "fonte da verdade".

## Como Executar o Projeto (Guia Passo a Passo)

Qualquer pessoa pode replicar toda a estrutura seguindo estes três passos.

#### Pré-requisitos:
* Uma conta gratuita na plataforma [Supabase](https://supabase.com).
* A ferramenta de linha de comando **Supabase CLI** instalada no seu computador.

---

**Passo 1: Crie o Projeto na Supabase**
* Acesse sua conta no Supabase e clique em "New Project". Dê um nome a ele e guarde bem a senha do banco de dados.

**Passo 2: Construa o Banco de Dados**
* Dentro do seu projeto no Supabase, vá até a seção **"SQL Editor"**.
* Abra a pasta `/sql` deste projeto. Copie o conteúdo do arquivo `tabelas.sql` e cole no editor. Clique em **"RUN"**.
* Repita o processo para os outros arquivos, seguindo a ordem numérica correta: `rls.sql`, `funcoes_e_triggers.sql` e `views.sql`.

**Passo 3: Publique a Ferramenta de Exportação**
* Abra o terminal do seu computador e navegue até a pasta principal onde você salvou este projeto.
* Execute o comando abaixo para se conectar à sua conta Supabase:
    ```bash
    supabase login
    ```
* Vincule seu projeto local com o da nuvem usando o comando a seguir. Lembre-se de substituir `SEU_ID_DO_PROJETO` pelo ID real do seu projeto (que pode ser encontrado nas configurações dele no site do Supabase).
    ```bash
    supabase link --project-ref SEU_ID_DO_PROJETO
    ```
* Finalmente, publique a ferramenta com o comando:
    ```bash
    supabase functions deploy exportar-pedido-csv
    ```

**Pronto!** Com esses três passos, toda a estrutura de backend do e-commerce está configurada e funcionando na nuvem.