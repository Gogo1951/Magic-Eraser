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

-- Eraser
L["COMBAT_LOCKOUT"] = "Não é possível excluir itens durante o combate."
L["CONFIRM_ERASE"] = "Excluir %s%s?"
L["BAGS_FULL"] = "Suas bolsas estão cheias!"
L["BAGS_FULL_NUDGE"] = "Suas bolsas estão quase cheias. Você tem %d espaços restantes."
L["BAGS_FULL_NUDGE_ONE"] = "Suas bolsas estão quase cheias. Você tem 1 espaço restante."
L["CURSOR_TOO_FAST"] = "Devagar! Você está clicando mais rápido do que o jogo consegue excluir itens."
L["ERASED_ITEM"] = "%s%s excluído."
L["ERASED_ITEM_WITH_VALUE"] = "%s%s excluído, valor %s."
L["ERASED_ITEM_FROM_QUEST"] = "%s%s excluído, de uma missão que você concluiu."
L["QUEST_ITEM_READY"] = "%s agora pode ser excluído com segurança!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["SOLD_SUMMARY"] = "%s itens (%s espaços) vendidos, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "A venda automática ocorrerá assim que o combate terminar."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s itens (%s espaços) retirados do seu banco, valor %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "O Magic Eraser vai excluir isto."
L["TOOLTIP_IGNORED"] = "Protegido pela sua lista de ignorados."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Item de menor valor"
L["CLUTTER_REPORT"] = "Relatório de lixo"
L["CLUTTER_ITEMS"] = "(%s itens)"
L["CLUTTER_SLOTS"] = "%s espaços"
L["NO_VALUE"] = "Sem valor"
L["LEFT_CLICK"] = "Clique esquerdo"
L["RIGHT_CLICK"] = "Clique direito"
L["MIDDLE_CLICK"] = "Clique do meio"
L["SHIFT_RIGHT_CLICK"] = "Shift + Clique direito"
L["SHIFT_MIDDLE_CLICK"] = "Shift + Clique do meio"
L["ACTION_ERASE"] = "Excluir"
L["ACTION_IGNORE"] = "Ignorar"
L["ACTION_TOGGLE"] = "Alternar"
L["ACTION_CLEAR_IGNORE"] = "Limpar lista de ignorados"
L["BAGS_CLEAN_CONGRATS"] = "Parabéns, suas bolsas estão cheias de coisas boas!"
L["BAGS_CLEAN_HINT"] = "Você precisará excluir algo manualmente para liberar mais espaço."
L["LOADING_ITEM"] = "Carregando ID: %d"
L["MINIMAP_OPTIONS"] = "Opções do Magic Eraser"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Venda automática"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende automaticamente itens marcados como lixo pelo Magic Eraser ao abrir uma janela de mercador."
L["IGNORE_LIST"] = "Lista de ignorados"
L["TAB_IGNORE_LIST"] = "Lista de ignorados"
L["ENABLED"] = "Ativado"
L["DISABLED"] = "Desativado"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Limpe suas bolsas instantaneamente. Itens de missões concluídas, consumíveis de baixo nível, itens brancos de qualidade de vendedor e lixo cinza são excluídos a cada clique no botão do minimapa. Quando você visita um mercante, tudo o que pode ser vendido é vendido automaticamente."
L["OPTIONS_ENABLE_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_ENABLE_MINIMAP"] = "Ativar botão do minimapa"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre o painel de opções deste addon."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Ativar Venda automática"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Ativar mensagens de Venda automática"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Por item"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Somente resumo"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Retirada do banco"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Ativar retirada do banco"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Retira automaticamente do seu banco os itens marcados como lixo pelo Magic Eraser ao abri-lo, para que você possa excluí-los."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Dicas de itens"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Adiciona uma linha à dica de um item nas suas bolsas quando o Magic Eraser for excluí-lo, ou quando sua lista de ignorados estiver protegendo-o."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Ativar dicas para itens na bolsa"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espaço na bolsa"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Faz a contagem regressiva no chat conforme seus espaços livres caem até o limite definido abaixo."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Ativar avisos de espaço na bolsa"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Limite de espaços livres"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "Confirmações de exclusão"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Perguntar antes de excluir os tipos de item marcados abaixo."
L["OPTIONS_ENABLE_SAFETY"] = "Ativar confirmações de exclusão"
L["OPTIONS_SAFETY_QUEST"] = "Para itens de missões concluídas"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Para consumíveis de baixo nível"
L["OPTIONS_SAFETY_WHITE"] = "Para itens brancos de qualidade de vendedor"
L["OPTIONS_SAFETY_GRAY"] = "Para itens cinzas de qualidade de vendedor"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Comentários e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Itens em uma Lista de ignorados nunca são excluídos nem vendidos. A lista Global protege um item em todos os personagens, e a lista do próprio personagem o protege apenas nele."
L["OPTIONS_IGNORE_GLOBAL"] = "Global"
L["OPTIONS_IGNORE_ADD_ID"] = "Adicionar por ID do item"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Digite um ID de item e pressione Enter. Você também pode dar Shift+clique em um link de item no chat para inseri-lo aqui."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "Digite um ID de item, ou dê Shift+clique em um link de item no chat."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Move este item para a lista Global, para que ele fique protegido em todos os personagens."
L["OPTIONS_IGNORE_REMOVE"] = "Remover"
L["OPTIONS_IGNORE_EMPTY"] = "Esta lista está vazia."
