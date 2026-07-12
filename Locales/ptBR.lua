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

-- Eraser
L["COMBAT_LOCKOUT"] = "Não é possível excluir itens durante o combate."
L["CONFIRM_ERASE"] = "Excluir %s%s?"
L["BAGS_FULL"] = "Suas bolsas estão cheias!"
L["BAGS_FULL_NUDGE"] = "Suas bolsas estão quase cheias. Você tem %d espaços restantes."
L["BAGS_FULL_NUDGE_ONE"] = "Suas bolsas estão quase cheias. Você tem 1 espaço restante."
L["CURSOR_TOO_FAST"] = "Devagar! Você está clicando mais rápido do que o jogo consegue excluir itens."
L["ERASED_ITEM"] = "%s%s%s excluído."
L["ERASED_VALUE_SUFFIX"] = ", valor %s"
L["ERASED_QUEST_SUFFIX"] = ", este item estava associado a uma missão concluída"
L["QUEST_ITEM_READY"] = "%s agora pode ser excluído com segurança!"

-- Item Tooltip
L["TOOLTIP_WILL_ERASE"] = "O Magic Eraser vai excluir isto."
L["TOOLTIP_IGNORED"] = "Protegido pela sua lista de ignorados."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["SOLD_SUMMARY"] = "%s itens vendidos, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "A venda automática ocorrerá assim que o combate terminar."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Item de menor valor"
L["CLUTTER_REPORT"] = "Relatório de lixo"
L["CLUTTER_SLOTS"] = "%s espaços"
L["CLUTTER_ITEMS"] = "(%s itens)"
L["CLUTTER_VALUE"] = "Valor %s"
L["NO_VALUE"] = "Sem valor"
L["LEFT_CLICK"] = "Clique esquerdo"
L["RIGHT_CLICK"] = "Clique direito"
L["MIDDLE_CLICK"] = "Clique do meio"
L["SHIFT_RIGHT_CLICK"] = "Shift + Clique direito"
L["ACTION_ERASE"] = "Excluir"
L["ACTION_IGNORE"] = "Ignorar"
L["ACTION_TOGGLE"] = "Alternar"
L["ACTION_CLEAR_IGNORE"] = "Limpar lista de ignorados"
L["BAGS_CLEAN_SHORT"] = "Parabéns, suas bolsas estão cheias de coisas boas!"
L["BAGS_CLEAN_HINT"] = "Você precisará excluir algo manualmente para liberar espaço."
L["LOADING_ITEM"] = "Carregando ID: %d"
L["MINIMAP_OPTIONS"] = "Opções do Magic Eraser"
L["MINIMAP_OPTIONS_KEYBIND"] = "Shift + Clique do meio"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Venda automática"
L["AUTO_VEND_DESCRIPTION"] = "Vende automaticamente itens marcados como lixo pelo Magic Eraser."
L["IGNORE_LIST"] = "Lista de ignorados"
L["ON"] = "Ativado"
L["OFF"] = "Desativado"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Limpe suas bolsas instantaneamente. Itens de missões concluídas, consumíveis de baixo nível, itens brancos de qualidade de vendedor e lixo cinza são excluídos a cada clique no botão do minimapa. Quando você visita um mercante, tudo o que pode ser vendido é vendido automaticamente."
L["OPTIONS_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_MINIMAP"] = "Ativar botão do minimapa"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "Abre a interface de opções do Magic Eraser."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Dicas de itens"
L["OPTIONS_TOOLTIP_WARNING"] = "Ativar dicas para itens na bolsa"

-- Auto-Vend
L["OPTIONS_AUTO_VEND_DESCRIPTION"] =
	"Vende automaticamente itens marcados como lixo pelo Magic Eraser ao abrir uma janela de mercador."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Ativar Venda automática"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Ativar mensagens de Venda automática"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "Por item"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Resumo"
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espaço na bolsa"
L["OPTIONS_BAGS_FULL_NUDGE"] = "Ativar avisos de espaço na bolsa"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Limite de espaços livres"

-- Eraser Confirmation
L["OPTIONS_SAFETY_HEADER"] = "Confirmações de exclusão"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Perguntar antes de excluir os tipos de item marcados abaixo."
L["OPTIONS_ENABLE_SAFETY"] = "Ativar confirmações de exclusão"
L["OPTIONS_SAFETY_QUEST"] = "Para itens de missões concluídas"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Para consumíveis de baixo nível"
L["OPTIONS_SAFETY_WHITE"] = "Para itens brancos de qualidade de vendedor"
L["OPTIONS_SAFETY_GRAY"] = "Para itens cinzas de qualidade de vendedor"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
