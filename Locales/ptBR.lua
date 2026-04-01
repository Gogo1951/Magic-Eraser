local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "ptBR")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["COMBAT_LOCKOUT"] = "Não é possível excluir itens durante o combate."
L["ERASED_ITEM"] = "%s%s%s excluído."
L["ERASED_QUEST_SUFFIX"] = ", este item estava associado a uma missão concluída"
L["ERASED_VALUE_SUFFIX"] = ", valor %s"
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["CURSOR_TOO_FAST"] = "Devagar! Você está clicando mais rápido do que o jogo consegue excluir itens."
L["BAGS_CLEAN"] = "Parabéns, suas bolsas estão cheias de coisas boas! Você precisará excluir algo manualmente para liberar espaço."
L["QUEST_ITEM_READY"] = "%s agora pode ser excluído com segurança!"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Item de menor valor"
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
L["TOOLTIP_HINT"] = "Configurações adicionais em Opções > AddOns > Magic Eraser"

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Venda automática"
L["AUTO_VEND_DESC"] = "Vende automaticamente itens marcados como lixo pelo Magic Eraser."
L["ENABLED"] = "Ativado"
L["DISABLED"] = "Desativado"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "Lista de ignorados"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Exclui o item de menor valor nas suas bolsas ao clicar no botão do minimapa."
L["OPTIONS_AUTO_VEND_DESC"] = "Vende automaticamente itens marcados como lixo pelo Magic Eraser ao abrir uma janela de mercador."
L["OPTIONS_RESET"] = "Redefinir"
L["OPTIONS_RESET_IGNORE"] = "Redefinir lista de ignorados"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Remover todos os itens da lista de ignorados deste personagem?"
L["OPTIONS_RESET_ALL"] = "Redefinir todas as configurações do Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Redefinir todas as configurações do Magic Eraser para os padrões? Isso limpa a lista de ignorados e desativa a venda automática."
L["OPTIONS_FEEDBACK"] = "Feedback e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
