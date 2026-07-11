local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "koKR")
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
L["CHAT_LOADED"] = "버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 옵션 > 애드온 > Magic Eraser에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

-- Eraser
L["COMBAT_LOCKOUT"] = "전투 중에는 아이템을 삭제할 수 없습니다."
L["CURSOR_TOO_FAST"] = "천천히! 게임이 아이템을 삭제하는 것보다 빠르게 클릭하고 있습니다."
L["ERASED_ITEM"] = "%s%s%s 삭제됨."
L["ERASED_VALUE_SUFFIX"] = ", 가치 %s"
L["ERASED_QUEST_SUFFIX"] = ", 이 아이템은 완료된 퀘스트와 관련되어 있었습니다"
L["QUEST_ITEM_READY"] = "%s 이제 안전하게 삭제할 수 있습니다!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s 판매됨, 가치 %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "전투가 끝나면 자동 판매가 진행됩니다."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "최저가 아이템"
L["NO_VALUE"] = "가치 없음"
L["LEFT_CLICK"] = "좌클릭"
L["RIGHT_CLICK"] = "우클릭"
L["MIDDLE_CLICK"] = "휠클릭"
L["SHIFT_RIGHT_CLICK"] = "Shift + 우클릭"
L["ACTION_ERASE"] = "삭제"
L["ACTION_IGNORE"] = "무시"
L["ACTION_TOGGLE"] = "전환"
L["ACTION_CLEAR_IGNORE"] = "무시 목록 초기화"
L["BAGS_CLEAN_SHORT"] = "축하합니다, 가방이 좋은 것들로 가득 차 있습니다!"
L["BAGS_CLEAN_HINT"] = "더 많은 공간을 확보하려면 직접 무언가를 삭제해야 합니다."
L["LOADING_ITEM"] = "불러오는 중 ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser 옵션"
L["MINIMAP_OPTIONS_KEYBIND"] = "Shift + 휠클릭"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "자동 판매"
L["AUTO_VEND_DESCRIPTION"] = "Magic Eraser가 잡동사니로 표시한 아이템을 자동으로 판매합니다."
L["IGNORE_LIST"] = "무시 목록"
L["ON"] = "활성화"
L["OFF"] = "비활성화"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "가방을 즉시 정리하세요. 완료된 퀘스트 아이템, 저레벨 소모품, 상인 품질의 흰색 아이템, 회색 잡동사니가 미니맵 버튼을 클릭할 때마다 삭제됩니다. 상인을 방문하면 판매 가능한 것은 모두 자동으로 판매됩니다."
L["OPTIONS_WELCOME"] = "환영 메시지 활성화"
L["OPTIONS_MINIMAP"] = "미니맵 버튼 활성화"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "상인 창을 열 때 Magic Eraser가 잡동사니로 표시한 아이템을 자동으로 판매합니다."
L["OPTIONS_ENABLE_AUTO_VEND"] = "자동 판매 활성화"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "자동 판매 메시지 활성화"
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Magic Eraser 설정 인터페이스를 엽니다."
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
