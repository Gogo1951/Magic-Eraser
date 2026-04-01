local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "koKR")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["COMBAT_LOCKOUT"] = "전투 중에는 아이템을 삭제할 수 없습니다."
L["ERASED_ITEM"] = "%s%s%s 삭제됨."
L["ERASED_QUEST_SUFFIX"] = ", 이 아이템은 완료된 퀘스트와 관련되어 있었습니다"
L["ERASED_VALUE_SUFFIX"] = ", 가치 %s"
L["SOLD_ITEM"] = "%s%s 판매됨, 가치 %s."
L["CURSOR_TOO_FAST"] = "천천히! 게임이 아이템을 삭제하는 것보다 빠르게 클릭하고 있습니다."
L["BAGS_CLEAN"] = "축하합니다, 가방이 좋은 것들로 가득 차 있습니다! 더 많은 공간을 확보하려면 직접 무언가를 삭제해야 합니다."
L["QUEST_ITEM_READY"] = "%s 이제 안전하게 삭제할 수 있습니다!"

--------------------------------------------------------------------------------
-- Tooltip
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
L["TOOLTIP_HINT"] = "추가 설정은 옵션 > 애드온 > Magic Eraser에서 확인하세요"

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "자동 판매"
L["AUTO_VEND_DESC"] = "Magic Eraser가 잡동사니로 표시한 아이템을 자동으로 판매합니다."
L["ENABLED"] = "활성화"
L["DISABLED"] = "비활성화"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "무시 목록"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "미니맵 버튼을 클릭하면 가방에서 가장 낮은 가치의 아이템을 삭제합니다."
L["OPTIONS_AUTO_VEND_DESC"] = "상인 창을 열 때 Magic Eraser가 잡동사니로 표시한 아이템을 자동으로 판매합니다."
L["OPTIONS_RESET"] = "초기화"
L["OPTIONS_RESET_IGNORE"] = "무시 목록 초기화"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "이 캐릭터의 무시 목록에서 모든 아이템을 제거하시겠습니까?"
L["OPTIONS_RESET_ALL"] = "모든 Magic Eraser 설정 초기화"
L["OPTIONS_RESET_ALL_CONFIRM"] = "모든 Magic Eraser 설정을 기본값으로 초기화하시겠습니까? 무시 목록이 비워지고 자동 판매가 비활성화됩니다."
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
