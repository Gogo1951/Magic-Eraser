local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "ptBR")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Magic Eraser. Gostando do add-on? Conte a um amigo! (="
L["MESSAGE_RESET"] = "Todas as configurações foram redefinidas para os padrões."

-- Eraser
L["COMBAT_LOCKOUT"] = "Não é possível excluir itens durante o combate."
L["CURSOR_TOO_FAST"] = "Devagar! Você está clicando mais rápido do que o jogo consegue excluir itens."
L["ERASED_ITEM"] = "%s%s%s excluído."
L["ERASED_VALUE_SUFFIX"] = ", valor %s"
L["ERASED_QUEST_SUFFIX"] = ", este item estava associado a uma missão concluída"
L["BAGS_CLEAN"] = "Parabéns, suas bolsas estão cheias de coisas boas! Você precisará excluir algo manualmente para liberar espaço."
L["QUEST_ITEM_READY"] = "%s agora pode ser excluído com segurança!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "A venda automática ocorrerá assim que o combate terminar."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
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
L["TOOLTIP_HINT"] = "Configurações adicionais em Opções > AddOns > Magic Eraser."

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

L["OPTIONS_DESCRIPTION"] = "O Magic Eraser identifica o lixo de menor valor em seu inventário e o exclui com um único clique no botão do minimapa. Itens de missões concluídas, consumíveis de baixo nível, itens brancos de qualidade de vendedor e lixo cinza — sumiram. Quando você visita um mercante, a Venda automática vende o resto para você."
L["OPTIONS_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Vende automaticamente itens marcados como lixo pelo Magic Eraser ao abrir uma janela de mercador."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Ativar Venda automática"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Ativar mensagens de Venda automática"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Abre a interface de opções do Magic Eraser."
L["OPTIONS_RESET"] = "Redefinir"
L["OPTIONS_RESET_DESCRIPTION"] = "Restaura todas as opções para o valor padrão."
L["OPTIONS_RESET_IGNORE"] = "Redefinir lista de ignorados"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Remover todos os itens da lista de ignorados deste personagem?"
L["OPTIONS_RESET_ALL"] = "Redefinir todas as configurações do Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Redefinir todas as configurações do Magic Eraser para os padrões? Isso limpa a lista de ignorados e desativa a venda automática."
L["OPTIONS_FEEDBACK"] = "Feedback e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
