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
L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 옵션 > 애드온 > Magic Eraser에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 창을 열 수 없습니다."

-- Eraser
L["COMBAT_LOCKOUT"] = "전투 중에는 아이템을 삭제할 수 없습니다."
L["CONFIRM_ERASE"] = "%s%s 삭제하시겠습니까?"
L["BAGS_FULL"] = "가방이 가득 찼습니다!"
L["BAGS_FULL_NUDGE"] = "가방이 거의 찼습니다. %d칸 남았습니다."
L["BAGS_FULL_NUDGE_ONE"] = "가방이 거의 찼습니다. 1칸 남았습니다."
L["CURSOR_TOO_FAST"] = "천천히! 게임이 아이템을 삭제하는 것보다 빠르게 클릭하고 있습니다."
L["ERASED_ITEM"] = "%s%s 삭제됨."
L["ERASED_ITEM_WITH_VALUE"] = "%s%s 삭제됨, 가치 %s."
L["ERASED_ITEM_FROM_QUEST"] = "%s%s 삭제됨, 완료한 퀘스트의 아이템입니다."
L["QUEST_ITEM_READY"] = "%s 이제 안전하게 삭제할 수 있습니다!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s 판매됨, 가치 %s."
L["SOLD_SUMMARY"] = "%s개 아이템 (%s칸) 판매됨, 가치 %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "전투가 끝나면 자동 판매가 진행됩니다."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "은행에서 %s개 아이템 (%s칸) 꺼냄, 가치 %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser가 이 아이템을 삭제합니다."
L["TOOLTIP_IGNORED"] = "무시 목록으로 보호됨."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "최저가 아이템"
L["CLUTTER_REPORT"] = "잡동사니 보고서"
L["CLUTTER_ITEMS"] = "(%s개)"
L["CLUTTER_SLOTS"] = "%s칸"
L["NO_VALUE"] = "가치 없음"
L["LEFT_CLICK"] = "좌클릭"
L["RIGHT_CLICK"] = "우클릭"
L["MIDDLE_CLICK"] = "휠클릭"
L["SHIFT_RIGHT_CLICK"] = "Shift + 우클릭"
L["SHIFT_MIDDLE_CLICK"] = "Shift + 휠클릭"
L["ACTION_ERASE"] = "삭제"
L["ACTION_IGNORE"] = "무시"
L["ACTION_TOGGLE"] = "전환"
L["ACTION_CLEAR_IGNORE"] = "무시 목록 초기화"
L["BAGS_CLEAN_CONGRATS"] = "축하합니다, 가방이 좋은 것들로 가득 차 있습니다!"
L["BAGS_CLEAN_HINT"] = "더 많은 공간을 확보하려면 직접 무언가를 삭제해야 합니다."
L["LOADING_ITEM"] = "불러오는 중 ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser 옵션"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "자동 판매"
L["AUTO_VEND_DESCRIPTION"] =
	"상인 창을 열 때 Magic Eraser가 잡동사니로 표시한 아이템을 자동으로 판매합니다."
L["IGNORE_LIST"] = "무시 목록"
L["TAB_IGNORE_LIST"] = "무시 목록"
L["ENABLED"] = "활성화"
L["DISABLED"] = "비활성화"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"가방을 즉시 정리하세요. 완료된 퀘스트 아이템, 저레벨 소모품, 상인 품질의 흰색 아이템, 회색 잡동사니가 미니맵 버튼을 클릭할 때마다 삭제됩니다. 상인을 방문하면 판매 가능한 것은 모두 자동으로 판매됩니다."
L["OPTIONS_ENABLE_WELCOME"] = "환영 메시지 활성화"
L["OPTIONS_ENABLE_MINIMAP"] = "미니맵 버튼 활성화"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 창을 엽니다."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "자동 판매 활성화"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "자동 판매 메시지 활성화"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "항목별"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "요약만"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "은행에서 가져오기"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "은행에서 가져오기 활성화"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"은행을 열면 Magic Eraser가 잡동사니로 표시한 아이템을 자동으로 꺼내 삭제할 수 있게 합니다."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "아이템 툴팁"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Magic Eraser가 삭제할 아이템이거나 무시 목록이 보호 중인 아이템일 때, 가방 속 아이템 툴팁에 한 줄을 추가합니다."
L["OPTIONS_ENABLE_TOOLTIPS"] = "가방 속 아이템 툴팁 활성화"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "가방 공간 경고"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"남은 가방 칸이 아래에서 설정한 기준값까지 줄어드는 동안 대화창에 카운트다운합니다."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "가방 공간 경고 활성화"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "빈 칸 기준값"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "삭제 확인"
L["OPTIONS_SAFETY_DESCRIPTION"] = "아래에서 선택한 아이템 유형을 삭제하기 전에 확인합니다."
L["OPTIONS_ENABLE_SAFETY"] = "삭제 확인 활성화"
L["OPTIONS_SAFETY_QUEST"] = "완료된 퀘스트 아이템"
L["OPTIONS_SAFETY_CONSUMABLE"] = "저레벨 소모품"
L["OPTIONS_SAFETY_WHITE"] = "상인 품질의 흰색 아이템"
L["OPTIONS_SAFETY_GRAY"] = "상인 품질의 회색 아이템"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"무시 목록에 있는 아이템은 삭제되지도 판매되지도 않습니다. 전체 목록은 모든 캐릭터에서 아이템을 보호하고, 캐릭터별 목록은 해당 캐릭터에서만 보호합니다."
L["OPTIONS_IGNORE_GLOBAL"] = "전체"
L["OPTIONS_IGNORE_ADD_ID"] = "아이템 ID로 추가"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"아이템 ID를 입력하고 Enter 키를 누르세요. 대화창의 아이템 링크를 Shift+클릭해 여기에 넣을 수도 있습니다."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"아이템 ID를 입력하거나, 대화창의 아이템 링크를 Shift+클릭하세요."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"이 아이템을 전체 목록으로 옮겨 모든 캐릭터에서 보호합니다."
L["OPTIONS_IGNORE_REMOVE"] = "제거"
L["OPTIONS_IGNORE_EMPTY"] = "이 목록은 비어 있습니다."
