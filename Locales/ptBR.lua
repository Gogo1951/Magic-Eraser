local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "ptBR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Magic Eraser. Gostando do add-on? Conte a um amigo! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por segurança, o painel de opções não pode ser aberto durante o combate."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "Por segurança, a lista de teclas de atalho não pode ser aberta durante o combate."

-- Eraser
L["COMBAT_LOCKOUT"] = "Não é possível excluir itens durante o combate."
L["CONFIRM_ERASE"] = "Excluir %s%s?"
L["BAGS_FULL"] = "Suas bolsas estão cheias!"
L["BAGS_FULL_NUDGE"] = "Suas bolsas estão quase cheias. Você tem %d espaços restantes."
L["BAGS_FULL_NUDGE_ONE"] = "Suas bolsas estão quase cheias. Você tem 1 espaço restante."
L["CURSOR_TOO_FAST"] = "Devagar! Você está clicando mais rápido do que o jogo consegue excluir itens."
L["ERASE_CANDIDATE_CHANGED"] =
	"Esse item mudou antes de poder ser excluído, então nada foi excluído. Confira o botão do minimapa e tente de novo."
L["ERASED_ITEM"] = "%s%s excluído."
L["QUEST_ITEM_READY"] = "%s%s agora pode ser excluído com segurança. É sobra de uma missão que você concluiu."
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s agora pode ser excluído com segurança. Ele inicia uma missão que seu personagem não pode aceitar."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, no valor de %s."
L["SOLD_SUMMARY"] = "%s itens vendidos (%s espaços de bolsa), no valor de %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s itens vendidos (1 espaço de bolsa), no valor de %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1 item vendido (1 espaço de bolsa), no valor de %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "A Venda automática vai vender assim que o combate terminar."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s itens (%s espaços de bolsa) retirados do seu banco, no valor de %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "%s itens (1 espaço de bolsa) retirados do seu banco, no valor de %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "1 item (1 espaço de bolsa) retirado do seu banco, no valor de %s."

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "%s adicionado à sua Lista de proteção."
L["IGNORE_LIST_MOVED"] = "%s movido da sua Lista de exclusão para a sua Lista de proteção."
L["IGNORE_LIST_ALREADY"] = "%s já está na sua Lista de proteção."
L["ERASE_LIST_ADDED"] = "%s adicionado à sua Lista de exclusão."
L["ERASE_LIST_ALREADY"] = "%s já está na sua Lista de exclusão."
L["ERASE_LIST_PROTECTED"] = "%s está na sua Lista de proteção, que sempre tem prioridade. Remova-o de lá primeiro."
L["NO_HOVERED_ITEM"] = "Passe o mouse sobre um item e pressione a tecla de novo."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Pode ser excluído."
L["TOOLTIP_IGNORED"] = "Está na sua Lista de proteção."
L["TOOLTIP_ON_ERASE_LIST"] = "Está na sua Lista de exclusão e pode ser excluído."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Item de menor valor"
L["CLUTTER_REPORT"] = "Relatório de lixo"
L["CLUTTER_ITEMS"] = "(%s itens)"
L["CLUTTER_ITEMS_ONE"] = "(1 item)"
L["CLUTTER_SLOTS"] = "%s espaços de bolsa"
L["CLUTTER_SLOTS_ONE"] = "1 espaço de bolsa"
L["NO_VALUE"] = "Sem valor"
L["LEFT_CLICK"] = "Clique esquerdo"
L["RIGHT_CLICK"] = "Clique direito"
L["MIDDLE_CLICK"] = "Clique do meio"
L["SHIFT_RIGHT_CLICK"] = "Shift + Clique direito"
L["SHIFT_MIDDLE_CLICK"] = "Shift + Clique do meio"
L["ACTION_ERASE"] = "Excluir"
L["ACTION_IGNORE"] = "Proteger"
L["ACTION_TOGGLE"] = "Alternar"
L["ACTION_CLEAR_IGNORE"] = "Limpar Lista de proteção"
L["BAGS_CLEAN_CONGRATS"] = "Parabéns, suas bolsas estão cheias de coisas boas!"
L["BAGS_CLEAN_HINT"] = "Você precisará excluir algo manualmente para liberar mais espaço."
L["LOADING_ITEM"] = "Carregando ID: %d"
L["MINIMAP_OPTIONS"] = "Opções do Magic Eraser"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Excluir item de menor valor"
L["BINDING_ADD_TO_IGNORE_LIST"] = "Adicionar item sob o mouse à Lista de proteção"
L["BINDING_ADD_TO_ERASE_LIST"] = "Adicionar item sob o mouse à Lista de exclusão"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Venda automática"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende seu lixo assim que você abre a janela de um comerciante, do mais barato para o mais caro."
L["TAB_YOUR_CURRENT_BAGS"] = "Suas bolsas atuais"
L["TAB_ERASING"] = "Exclusão"
L["TAB_MERCHANT_BANK"] = "Comerciante e banco"
L["TAB_ALERTS"] = "Alertas e dicas"
L["TAB_IGNORE_LIST"] = "Lista de proteção"
L["TAB_ERASE_LIST"] = "Lista de exclusão"
L["ENABLED"] = "Ativado"
L["DISABLED"] = "Desativado"

-- Example lines under chat-printing features. %s is the whole chat line.
L["OPTIONS_EXAMPLE"] = "Exemplo: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Item de exemplo"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Exclua o lixo e libere espaço nas bolsas instantaneamente. Limpe itens de missões concluídas, consumíveis que você já superou, lixo de comerciante e itens cinza com um clique no botão do minimapa. Uma lista de lixo revisada à mão protege o que você precisa, enquanto a Venda automática vende o resto no próximo comerciante que você visitar."
L["OPTIONS_ENABLE_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_ENABLE_WELCOME_DESC"] =
	"Mostra no chat uma mensagem de boas-vindas de uma linha, com a versão, sempre que você entra no jogo."
L["OPTIONS_ENABLE_MINIMAP"] = "Ativar botão do minimapa"
L["OPTIONS_ENABLE_MINIMAP_DESC"] =
	"Mostra o botão do Magic Eraser no seu minimapa. O ícone dele é o próximo item da fila, e passar o mouse sobre ele mostra o Relatório de lixo."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Recursos"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre o painel de opções deste add-on."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Teclas de atalho"
L["OPTIONS_KEY_NOT_BOUND"] = "Não atribuída"
L["OPTIONS_KEY_SET"] = "Definir tecla"
L["OPTIONS_KEY_SET_DESC"] = "Abre a lista de teclas de atalho do jogo, onde o Magic Eraser tem sua própria seção."
L["KEY_BINDINGS_LOCATION"] = "Abra o menu do jogo, depois %s, depois %s, e procure a seção Magic Eraser."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Exclui o próximo item da fila, igual a um clique esquerdo no botão do minimapa. Não há prévia antes de apertar a tecla, então escolha uma tecla que você não vá apertar sem querer."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Protege o item sob o mouse neste personagem, onde quer que você o veja: bolsas, banco, comerciante ou janela de saque. Se ele estava na Lista de exclusão deste personagem, sai dela."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Adiciona o item sob o mouse à Lista de exclusão deste personagem, seja qual for o valor. Sua Lista de proteção continua tendo prioridade."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Comentários e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versão %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"O que o botão do minimapa exclui a seguir e o lixo que vem depois, e então tudo o mais que você carrega, pronto para excluir ou proteger."
L["OPTIONS_UP_NEXT"] = "A seguir"
L["OPTIONS_CLUTTER_TOTAL"] = "Total"
L["OPTIONS_STACKS"] = "(%d pilhas)"
L["OPTIONS_ERASE_BUTTON"] = "Excluir"
L["OPTIONS_ERASE_BUTTON_DESC"] =
	"Exclui o próximo item da fila, exatamente como um clique esquerdo no botão do minimapa."
L["OPTIONS_PROTECT_BUTTON"] = "Proteger"
L["OPTIONS_PROTECT_BUTTON_DESC"] =
	"Adiciona este item à Lista de proteção deste personagem, para que ele nunca seja excluído nem vendido."

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "Tudo nas suas bolsas"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"Todos os itens que você carrega, lixo ou não. Marque Excluir ou Proteger para colocar o item na lista deste personagem."
L["OPTIONS_COLUMN_ITEM"] = "Item"
L["OPTIONS_COLUMN_TYPE"] = "Tipo"
L["OPTIONS_COLUMN_ERASE"] = "Excluir"
L["OPTIONS_COLUMN_PROTECT"] = "Proteger"
L["OPTIONS_CHECK_ERASE_DESC"] =
	"Coloca este item na Lista de exclusão deste personagem, para que ele seja sempre lixo, seja qual for o valor. Tira o item da Lista de proteção deste personagem."
L["OPTIONS_CHECK_ERASE_GLOBAL_DESC"] =
	"Este item está em uma lista de Todos os personagens. Altere-o na página Lista de exclusão ou Lista de proteção, já que essa lista vale para todos os personagens."
L["OPTIONS_CHECK_PROTECT_DESC"] =
	"Coloca este item na Lista de proteção deste personagem, para que ele nunca seja excluído nem vendido. Tira o item da Lista de exclusão deste personagem."
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESC"] =
	"Este item está na Lista de proteção de Todos os personagens. Altere-o na página Lista de proteção, já que essa lista vale para todos os personagens."

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "Missão concluída"
L["REASON_QUEST_INELIGIBLE"] = "Indisponível"
L["REASON_OUTGROWN"] = "Superado"
L["REASON_EQUIPMENT"] = "Item branco"
L["REASON_GRAY"] = "Cinza"
L["REASON_MANUAL"] = "Lista de exclusão"
L["REASON_ASKS_FIRST"] = "Pergunta antes"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "Cada clique exclui o lixo mais barato das suas bolsas, uma pilha por vez."
L["TAB_ERASING_RESTORE_NOTE"] =
	"Bom saber: quase tudo que for excluído por engano ainda pode ser recuperado pelo serviço de restauração de itens da Blizzard."

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "O que conta como lixo"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"Escolha quais tipos de item são excluídos. Para ajustar, adicione qualquer item à sua Lista de proteção para sempre mantê-lo, ou à sua Lista de exclusão para sempre excluí-lo."
L["OPTIONS_KIND_QUEST"] = "Itens de missões concluídas"
L["OPTIONS_KIND_QUEST_DESC"] = "Itens que sobram depois que você entrega a última missão que precisa deles."
L["OPTIONS_KIND_STARTER"] = "Iniciadores de missão bloqueados"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESC"] = "Itens que iniciam uma missão que sua raça ou classe nunca pode aceitar."
L["OPTIONS_KIND_FOOD"] = "Comida e bebida superadas"
L["OPTIONS_KIND_FOOD_DESC"] =
	"Comida e bebida quando você está dez níveis acima do nível em que pôde usá-las pela primeira vez. O pão e a água iniciais saem no nível 5."
L["OPTIONS_KIND_AMMO"] = "Flechas e balas superadas"
L["OPTIONS_KIND_AMMO_DESC"] =
	"Flechas e balas assim que você puder usar um tipo melhor vendido por comerciantes. A melhor munição de comerciante para o seu nível nunca é excluída."
L["OPTIONS_KIND_WHITE"] = "Armas e armaduras brancas"
L["OPTIONS_KIND_WHITE_DESC"] =
	"Armas e armaduras brancas que um comerciante compra. Ferramentas de profissão, camisas, trajes formais e itens brancos de que uma missão ainda precisa são mantidos."
L["OPTIONS_KIND_GRAY"] = "Lixo cinza"
L["OPTIONS_KIND_GRAY_DESC"] = "Qualquer item cinza que um comerciante compre."
L["OPTIONS_KIND_ERASE"] = "Excluir"
L["OPTIONS_KIND_ASK"] = "Excluir, perguntar antes"
L["OPTIONS_KIND_KEEP"] = "Manter"
L["OPTIONS_KIND_ACTION_DESC"] =
	"Excluir remove sem perguntar. Excluir, perguntar antes mostra um Sim ou Não antes de excluir. Manter significa que não é lixo: nunca é excluído, vendido nem retirado do banco. Itens na sua Lista de exclusão sempre saem sem perguntar, seja qual for o valor."
L["OPTIONS_KINDS_ALL_KEPT"] =
	"Todos os tipos estão em Manter, então só os itens da sua Lista de exclusão são excluídos ou vendidos."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valor máximo para excluir"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "Nunca exclui um item ou pilha que valha mais que o limite definido abaixo."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Ativar valor máximo para excluir"
L["OPTIONS_ENABLE_VALUE_CAP_DESC"] =
	"Liga ou desliga o limite de valor. A Venda automática ainda vende tudo o que ele poupa, e sua Lista de exclusão não é limitada por ele."
L["OPTIONS_VALUE_CAP_LIMIT_DESC"] =
	"Pilhas que valem mais que isto, contando o valor de venda da pilha inteira, nunca são excluídas."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d de ouro"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Ajuda na exclusão manual"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'Por padrão, o jogo faz você digitar "%s" ao excluir um item %s ou melhor. Isto transforma esse aviso em um simples Sim ou Não.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Ativar ajuda na exclusão manual"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESC"] =
	"Liga ou desliga a Ajuda na exclusão manual. O jogo ainda pergunta Sim ou Não; só a digitação some."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESC"] =
	"Itens sem valor de venda simplifica só os itens que nenhum comerciante compra. Todos os itens simplifica todo aviso que pede digitação."
L["OPTIONS_MANUAL_DELETE_ALL"] = "Todos os itens"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Itens sem valor de venda"

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Vende seu lixo assim que você abre a janela de um comerciante, e traz o lixo do seu banco de volta para as bolsas para ir junto. Nada na sua Lista de proteção é tocado."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Ativar Venda automática"
L["OPTIONS_ENABLE_AUTO_VEND_DESC"] =
	"Liga ou desliga a venda em comerciantes. Itens na sua Lista de proteção nunca são vendidos."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Resumo no chat"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Cada venda no chat"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "Sem relatório no chat"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESC"] =
	"O que a Venda automática mostra no chat. Resumo no chat mostra um total por visita. Cada venda no chat mostra cada venda e depois o total. Sem relatório no chat não mostra nada."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Retirada do banco"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Retira o lixo do seu banco quando você o abre, para que possa ser vendido ou excluído com o resto. Só retira do seu próprio banco, nunca de um banco de guilda nem de um banco compartilhado da conta."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Ativar retirada do banco"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESC"] =
	"Liga ou desliga a retirada do banco. Nunca retira mais do que seus espaços de bolsa livres comportam."
L["OPTIONS_BANK_CUSHION_NOTE"] =
	"Deixa %d espaços de bolsa livres, porque os Avisos de espaço na bolsa estão ativados."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] =
	"Deixa 1 espaço de bolsa livre, porque os Avisos de espaço na bolsa estão ativados."

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "O que o Magic Eraser avisa por conta própria, no chat e nas dicas."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Avisos nas dicas"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Adiciona uma linha à dica de qualquer item nas suas bolsas que o Magic Eraser possa excluir, ou que sua Lista de proteção proteja."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Ativar avisos nas dicas"
L["OPTIONS_ENABLE_TOOLTIPS_DESC"] = "Liga ou desliga a linha do Magic Eraser nas dicas das bolsas."

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Alertas de itens de missão"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Avisa você assim que um dos seus Itens de missões concluídas ou Iniciadores de missão bloqueados puder ser excluído com segurança."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Ativar alertas de itens de missão"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESC"] =
	"Liga ou desliga estas mensagens. Itens de missões concluídas e Iniciadores de missão bloqueados continuam sendo excluídos de qualquer forma."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espaço na bolsa"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Avisa você conforme seus últimos espaços de bolsa livres vão se enchendo. Fica em silêncio enquanto a janela de um comerciante, da caixa de correio ou do banco estiver aberta."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Ativar avisos de espaço na bolsa"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESC"] = "Liga ou desliga a contagem regressiva no chat."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Limite de espaços livres"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESC"] =
	"Quantos espaços livres iniciam a contagem regressiva. Com os avisos ativados, a Retirada do banco também deixa essa quantidade de espaços livres."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Todos os personagens"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Adicionar das bolsas"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESC"] =
	"Escolha qualquer coisa que você carrega. As bolsas se fecham quando o painel de opções abre, então isto substitui arrastar um item para cá."
L["OPTIONS_LIST_ADD_ID"] = "Adicionar por ID do item"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Digite um ID de item e pressione Enter. Você também pode dar Shift+clique em um link de item no chat para inseri-lo aqui."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Digite um ID de item, ou dê Shift+clique em um link de item no chat."
L["OPTIONS_LIST_REMOVE"] = "Remover"
L["OPTIONS_LIST_EMPTY"] = "Esta lista está vazia."
L["OPTIONS_LIST_PROTECTED_TAG"] = "Protegido"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Itens em uma Lista de proteção nunca são excluídos nem vendidos. A lista de Todos os personagens protege um item em todos os personagens, e a lista própria de um personagem o protege só nele."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Move este item para a lista de Todos os personagens, para que ele fique protegido em todos os personagens."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Itens em uma Lista de exclusão são sempre lixo, seja qual for o valor: excluídos pelo botão do minimapa e vendidos em comerciantes. Sua Lista de proteção continua tendo prioridade, e uma linha anulada por ela mostra Protegido."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Move este item para a lista de Todos os personagens, para que ele seja excluído em todos os personagens, inclusive naqueles em que nunca foi adicionado."
L["OPTIONS_ERASE_RESTORE"] = "Restaurar padrões"
L["OPTIONS_ERASE_RESTORE_DESC"] =
	"Volta a Lista de exclusão deste personagem aos itens com que o Magic Eraser a inicia."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Esvaziar a Lista de exclusão deste personagem e devolver apenas os itens com que o Magic Eraser começa? Tudo o que você mesmo adicionou é removido."
