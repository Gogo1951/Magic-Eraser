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
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "안전을 위해 전투 중에는 단축키 목록을 열 수 없습니다."
L["KEY_BINDINGS_LOCATION"] = "게임 메뉴를 열고 %s, %s 순서로 들어가 Magic Eraser 항목을 찾으세요."

-- Eraser
L["COMBAT_LOCKOUT"] = "전투 중에는 아이템을 삭제할 수 없습니다."
L["CONFIRM_ERASE"] = "%s%s 삭제하시겠습니까?"
L["BAGS_FULL"] = "가방이 가득 찼습니다!"
L["BAGS_FULL_NUDGE"] = "가방이 거의 찼습니다. %d칸 남았습니다."
L["BAGS_FULL_NUDGE_ONE"] = "가방이 거의 찼습니다. 1칸 남았습니다."
L["CURSOR_TOO_FAST"] =
	"천천히 하세요! 게임이 아이템을 삭제하는 속도보다 빠르게 클릭하고 있습니다."
L["ERASE_CANDIDATE_CHANGED"] =
	"삭제하기 전에 아이템이 바뀌어 아무것도 삭제하지 않았습니다. 미니맵 버튼을 확인하고 다시 시도하세요."
L["ERASED_ITEM"] = "%s%s 삭제됨."
L["QUEST_ITEM_READY"] =
	"%s%s: 이제 안전하게 삭제할 수 있습니다. 완료한 퀘스트에서 남은 아이템입니다."
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s: 이제 안전하게 삭제할 수 있습니다. 캐릭터가 수락할 수 없는 퀘스트를 시작하는 아이템입니다."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s 판매됨, 가치 %s."
L["SOLD_SUMMARY"] = "%s개 아이템 (가방 %s칸) 판매됨, 가치 %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s개 아이템 (가방 1칸) 판매됨, 가치 %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1개 아이템 (가방 1칸) 판매됨, 가치 %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "전투가 끝나면 자동 판매가 진행됩니다."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "은행에서 %s개 아이템 (가방 %s칸) 꺼냄, 가치 %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "은행에서 %s개 아이템 (가방 1칸) 꺼냄, 가치 %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "은행에서 1개 아이템 (가방 1칸) 꺼냄, 가치 %s."

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "보호 목록에 추가했습니다: %s"
L["IGNORE_LIST_MOVED"] = "삭제 목록에서 보호 목록으로 옮겼습니다: %s"
L["IGNORE_LIST_ALREADY"] = "이미 보호 목록에 있습니다: %s"
L["ERASE_LIST_ADDED"] = "삭제 목록에 추가했습니다: %s"
L["ERASE_LIST_ALREADY"] = "이미 삭제 목록에 있습니다: %s"
L["ERASE_LIST_PROTECTED"] =
	"%s: 보호 목록에 있으며, 보호 목록이 항상 우선합니다. 먼저 보호 목록에서 제거하세요."
L["NO_HOVERED_ITEM"] = "아이템 위에 마우스를 올린 다음 키를 다시 누르세요."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "삭제될 수 있습니다."
L["TOOLTIP_IGNORED"] = "보호 목록에 있습니다."
L["TOOLTIP_ON_ERASE_LIST"] = "삭제 목록에 있으며, 삭제될 수 있습니다."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "최저가 아이템"
L["CLUTTER_REPORT"] = "잡동사니 보고서"
L["CLUTTER_ITEMS"] = "(%s개)"
L["CLUTTER_ITEMS_ONE"] = "(1개)"
L["CLUTTER_SLOTS"] = "가방 %s칸"
L["CLUTTER_SLOTS_ONE"] = "가방 1칸"
L["NO_VALUE"] = "가치 없음"
L["LEFT_CLICK"] = "좌클릭"
L["RIGHT_CLICK"] = "우클릭"
L["MIDDLE_CLICK"] = "휠클릭"
L["SHIFT_RIGHT_CLICK"] = "Shift + 우클릭"
L["SHIFT_MIDDLE_CLICK"] = "Shift + 휠클릭"
L["ACTION_ERASE"] = "삭제"
L["ACTION_IGNORE"] = "보호"
L["ACTION_TOGGLE"] = "전환"
L["ACTION_CLEAR_IGNORE"] = "보호 목록 초기화"
L["BAGS_CLEAN_CONGRATS"] = "축하합니다, 가방이 좋은 것들로 가득 차 있습니다!"
L["BAGS_CLEAN_HINT"] = "더 많은 공간을 확보하려면 직접 무언가를 삭제해야 합니다."
L["LOADING_ITEM"] = "불러오는 중 ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser 옵션"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "최저가 아이템 삭제"
L["BINDING_ADD_TO_IGNORE_LIST"] = "마우스를 올린 아이템을 보호 목록에 추가"
L["BINDING_ADD_TO_ERASE_LIST"] = "마우스를 올린 아이템을 삭제 목록에 추가"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "자동 판매"
L["AUTO_VEND_DESCRIPTION"] = "상인 창을 여는 즉시 잡동사니를 가장 싼 것부터 판매합니다."
L["TAB_YOUR_CURRENT_BAGS"] = "현재 가방"
L["TAB_ERASING"] = "삭제"
L["TAB_MERCHANT_BANK"] = "상인 및 은행"
L["TAB_ALERTS"] = "알림 및 툴팁"
L["TAB_IGNORE_LIST"] = "보호 목록"
L["TAB_ERASE_LIST"] = "삭제 목록"
L["ENABLED"] = "활성화"
L["DISABLED"] = "비활성화"

-- Example lines under features that print to chat or add a tooltip line. %s is that whole line.
L["OPTIONS_EXAMPLE"] = "예시: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "예시 아이템"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"잡동사니를 삭제하고 가방 공간을 즉시 확보하세요. 완료된 퀘스트 아이템, 이제는 필요 없는 소모품, 상인에게 팔 물건, 회색 아이템을 미니맵 버튼 클릭 한 번으로 정리하세요. 엄선된 잡동사니 목록이 필요한 아이템을 안전하게 지켜 주고, 자동 판매가 나머지를 다음 상인에게 판매합니다."
L["OPTIONS_ENABLE_WELCOME"] = "환영 메시지 활성화"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"접속할 때마다 버전이 담긴 한 줄짜리 환영 메시지를 대화창에 표시합니다."
L["OPTIONS_ENABLE_MINIMAP"] = "미니맵 버튼 활성화"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] =
	"미니맵에 Magic Eraser 버튼을 표시합니다. 버튼 아이콘은 다음에 삭제할 아이템이며, 마우스를 올리면 잡동사니 보고서가 표시됩니다."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "기능"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 창을 엽니다."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "단축키 설정"
L["OPTIONS_KEY_SET"] = "키 지정"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"게임의 단축키 목록을 엽니다. Magic Eraser 전용 항목이 있습니다."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"미니맵 버튼을 좌클릭하는 것과 똑같이 다음 아이템을 삭제합니다. 키를 누르기 전에는 미리 보기가 없으니, 실수로 누르지 않을 키에 지정하세요."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"마우스를 올린 아이템을 이 캐릭터에서 보호합니다. 가방, 은행, 상인, 전리품 창 어디서든 사용할 수 있습니다. 이 캐릭터의 삭제 목록에 있었다면 거기서 빠집니다."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"마우스를 올린 아이템을 가치와 상관없이 이 캐릭터의 삭제 목록에 추가합니다. 보호 목록이 여전히 우선합니다."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "버전 %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"미니맵 버튼이 다음에 삭제할 아이템과 그 뒤에 대기 중인 잡동사니, 그리고 가지고 있는 나머지 모든 아이템을 보여 줍니다. 여기서 바로 삭제하거나 보호할 수 있습니다."
L["OPTIONS_UP_NEXT"] = "다음 차례"
L["OPTIONS_CLUTTER_TOTAL"] = "합계"
L["OPTIONS_STACKS"] = "(%d묶음)"
L["OPTIONS_ERASE_BUTTON"] = "삭제"
L["OPTIONS_ERASE_BUTTON_DESCRIPTION"] =
	"미니맵 버튼을 좌클릭하는 것과 똑같이 다음 아이템을 삭제합니다."
L["OPTIONS_PROTECT_BUTTON"] = "보호"

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "가방 속 모든 아이템"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"잡동사니든 아니든 가지고 있는 모든 아이템입니다. 삭제 또는 보호에 체크하면 이 캐릭터의 목록에 추가됩니다."
L["OPTIONS_COLUMN_ITEM"] = "아이템"
L["OPTIONS_COLUMN_TYPE"] = "종류"
L["OPTIONS_COLUMN_ERASE"] = "삭제"
L["OPTIONS_COLUMN_PROTECT"] = "보호"
L["OPTIONS_CHECK_ERASE_DESCRIPTION"] =
	"이 아이템을 이 캐릭터의 삭제 목록에 넣어 가치와 상관없이 항상 잡동사니로 취급합니다. 이 캐릭터의 보호 목록에서는 빠집니다."
L["OPTIONS_CHECK_ERASE_GLOBAL_DESCRIPTION"] =
	"이 아이템은 모든 캐릭터 목록에 있습니다. 그 목록은 모든 캐릭터에 적용되므로 삭제 목록 또는 보호 목록 페이지에서 변경하세요."
L["OPTIONS_CHECK_PROTECT_DESCRIPTION"] =
	"이 아이템을 이 캐릭터의 보호 목록에 넣어 절대 삭제하거나 판매하지 않습니다. 이 캐릭터의 삭제 목록에서는 빠집니다."
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESCRIPTION"] =
	"이 아이템은 모든 캐릭터 보호 목록에 있습니다. 그 목록은 모든 캐릭터에 적용되므로 보호 목록 페이지에서 변경하세요."

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "퀘스트 완료"
L["REASON_QUEST_INELIGIBLE"] = "수락 불가"
L["REASON_OUTGROWN"] = "저레벨"
L["REASON_EQUIPMENT"] = "흰색 장비"
L["REASON_GRAY"] = "회색"
L["REASON_MANUAL"] = "삭제 목록"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] =
	"클릭할 때마다 가방에서 가장 싼 잡동사니를 한 묶음씩 삭제합니다."
L["TAB_ERASING_RESTORE_NOTE"] =
	"참고: 실수로 삭제한 아이템은 대부분 블리자드의 아이템 복구 서비스로 되찾을 수 있습니다."

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "잡동사니 기준"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"어떤 종류의 아이템을 삭제할지 선택하세요. 큰 틀의 규칙이므로, 더 세밀하게 조정하려면 항상 남겨 둘 아이템은 보호 목록에, 항상 삭제할 아이템은 삭제 목록에 추가하세요."
L["OPTIONS_KIND_QUEST"] = "완료된 퀘스트 아이템"
L["OPTIONS_KIND_QUEST_DESCRIPTION"] =
	"해당 아이템이 필요한 마지막 퀘스트를 완료한 뒤 남은 아이템입니다."
L["OPTIONS_KIND_STARTER"] = "수락 불가 퀘스트 시작 아이템"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESCRIPTION"] =
	"내 종족이나 직업으로는 절대 수락할 수 없는 퀘스트를 시작하는 아이템입니다."
L["OPTIONS_KIND_FOOD"] = "저레벨 음식 및 음료"
L["OPTIONS_KIND_FOOD_DESCRIPTION"] =
	"처음 사용할 수 있던 레벨보다 10레벨 이상 높아진 음식과 음료입니다. 초보자용 빵과 물은 5레벨에 삭제됩니다."
L["OPTIONS_KIND_AMMO"] = "저레벨 화살 및 탄환"
L["OPTIONS_KIND_AMMO_DESCRIPTION"] =
	"상인이 파는 더 좋은 종류를 사용할 수 있게 된 화살과 탄환입니다. 현재 레벨에 맞는 최고의 상인 판매 탄약은 절대 삭제하지 않습니다."
L["OPTIONS_KIND_WHITE"] = "흰색 무기 및 방어구"
L["OPTIONS_KIND_WHITE_DESCRIPTION"] =
	"상인이 구매하는 흰색 무기와 방어구입니다. 전문 기술 도구, 셔츠, 정장, 퀘스트에 아직 필요한 흰색 아이템은 남겨 둡니다."
L["OPTIONS_KIND_GRAY"] = "회색 잡동사니"
L["OPTIONS_KIND_GRAY_DESCRIPTION"] = "상인이 구매하는 모든 회색 아이템입니다."
L["OPTIONS_KIND_UNCHECKED_DESCRIPTION"] =
	"체크하지 않으면 잡동사니가 아니므로, 삭제하거나 판매하거나 은행에서 꺼내지 않습니다."
L["OPTIONS_KINDS_NONE_CHECKED"] =
	"체크한 종류가 없어 삭제 목록에 있는 아이템만 삭제하거나 판매합니다."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "삭제할 최대 가치"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"아래에서 설정한 한도보다 가치가 높은 아이템이나 묶음은 삭제하지 않습니다."
L["OPTIONS_ENABLE_VALUE_CAP"] = "삭제할 최대 가치 활성화"
L["OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION"] =
	"가치 한도를 켜거나 끕니다. 한도 때문에 삭제하지 않은 아이템도 자동 판매는 판매하며, 삭제 목록에는 이 한도가 적용되지 않습니다."
L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"] =
	"묶음 전체의 판매 가치로 따져 이 금액보다 비싼 묶음은 삭제하지 않습니다."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d 골드"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "수동 삭제 도우미"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'기본적으로 게임에서는 "%s"를 입력해야 %s 등급 이상의 아이템을 삭제할 수 있습니다. 이 기능은 그 입력 창을 간단한 예/아니오 확인으로 바꿉니다.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "수동 삭제 도우미 활성화"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION"] =
	"수동 삭제 도우미를 켜거나 끕니다. 게임은 여전히 예/아니오를 묻고, 입력하는 과정만 사라집니다."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESCRIPTION"] =
	"판매 가치 없는 아이템은 상인이 구매하지 않는 아이템만 간단하게 바꿉니다. 모든 아이템은 입력이 필요한 모든 확인 창을 간단하게 바꿉니다."
L["OPTIONS_MANUAL_DELETE_ALL"] = "모든 아이템"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "판매 가치 없는 아이템"

-- Erase Confirmation
L["OPTIONS_ERASE_CONFIRM_HEADER"] = "삭제 확인"
L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"] = "무엇이든 삭제하기 전에 예/아니오를 묻습니다."
L["OPTIONS_ENABLE_ERASE_CONFIRM"] = "삭제 확인 활성화"
L["OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION"] =
	"미니맵 버튼, 단축키, 현재 가방 중 어디서 삭제하든 매번 삭제하기 전에 예/아니오를 표시하며, 삭제 목록에 있는 아이템도 마찬가지입니다."

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"상인 창을 여는 즉시 잡동사니를 판매하고, 은행에 있는 잡동사니도 가방으로 가져와 함께 처리합니다. 보호 목록에 있는 아이템은 건드리지 않습니다."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "자동 판매 활성화"
L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"] =
	"상인에게 판매하는 기능을 켜거나 끕니다. 보호 목록에 있는 아이템은 절대 판매하지 않습니다."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "대화창에 요약"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "대화창에 모든 판매"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "대화창 보고 없음"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESCRIPTION"] =
	"자동 판매가 대화창에 표시할 내용입니다. 대화창에 요약은 방문할 때마다 합계를 한 번 표시합니다. 대화창에 모든 판매는 판매 내역을 하나씩 표시한 뒤 합계를 표시합니다. 대화창 보고 없음은 아무것도 표시하지 않습니다."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "은행에서 가져오기"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"은행을 열면 잡동사니를 꺼내 나머지와 함께 판매하거나 삭제할 수 있게 합니다. 오직 내 은행에서만 가져오며, 길드 은행이나 계정 공용 은행에서는 가져오지 않습니다."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "은행에서 가져오기 활성화"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION"] =
	"은행에서 가져오기를 켜거나 끕니다. 빈 가방 칸에 들어갈 만큼만 가져옵니다."
L["OPTIONS_BANK_CUSHION_NOTE"] = "가방 공간 경고가 켜져 있으므로 가방 %d칸을 비워 둡니다."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "가방 공간 경고가 켜져 있으므로 가방 1칸을 비워 둡니다."

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Magic Eraser가 대화창과 툴팁으로 알아서 알려 주는 내용입니다."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "툴팁 경고"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"가방 속 아이템 중 Magic Eraser가 삭제할 수 있는 아이템이나 보호 목록이 보호하는 아이템의 툴팁에 한 줄을 추가합니다."
L["OPTIONS_ENABLE_TOOLTIPS"] = "툴팁 경고 활성화"
L["OPTIONS_ENABLE_TOOLTIPS_DESCRIPTION"] = "가방 툴팁의 Magic Eraser 줄을 켜거나 끕니다."

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "퀘스트 아이템 알림"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"가방 속 완료된 퀘스트 아이템이나 수락 불가 퀘스트 시작 아이템을 안전하게 삭제할 수 있게 되는 즉시 알려 줍니다."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "퀘스트 아이템 알림 활성화"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION"] =
	"대화창 알림을 켜거나 끕니다. 어느 쪽이든 완료된 퀘스트 아이템과 수락 불가 퀘스트 시작 아이템은 그대로 삭제됩니다."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "가방 공간 경고"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"마지막 남은 빈 가방 칸이 채워질 때 경고합니다. 상인, 우편함, 은행 창이 열려 있는 동안에는 알리지 않습니다."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "가방 공간 경고 활성화"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION"] = "대화창 카운트다운을 켜거나 끕니다."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "빈 칸 기준값"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"] =
	"카운트다운을 시작할 빈 칸 수입니다. 경고가 켜져 있는 동안 은행에서 가져오기도 이만큼의 칸을 비워 둡니다."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "모든 캐릭터"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "가방에서 추가"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"] =
	"가지고 있는 아이템 중 하나를 고르세요. 설정 창이 열리면 가방이 닫히므로, 아이템을 여기로 끌어다 놓는 대신 사용합니다."
L["OPTIONS_LIST_ADD_ID"] = "아이템 ID로 추가"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"아이템 ID를 입력하고 Enter 키를 누르세요. 대화창의 아이템 링크를 Shift+클릭해 여기에 넣을 수도 있습니다."
L["OPTIONS_LIST_ADD_ID_INVALID"] =
	"아이템 ID를 입력하거나, 대화창의 아이템 링크를 Shift+클릭하세요."
L["OPTIONS_LIST_REMOVE"] = "제거"
L["OPTIONS_LIST_EMPTY"] = "이 목록은 비어 있습니다."

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"보호 목록에 있는 아이템은 절대 삭제되거나 판매되지 않습니다. 모든 캐릭터 목록은 모든 캐릭터에서 아이템을 보호하고, 캐릭터별 목록은 해당 캐릭터에서만 보호합니다."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"이 아이템을 모든 캐릭터 목록으로 옮겨 모든 캐릭터에서 보호합니다."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"삭제 목록에 있는 아이템은 가치와 상관없이 항상 잡동사니로 취급되어, 미니맵 버튼으로 삭제되고 상인에게 판매됩니다. 보호 목록이 여전히 우선하며, 보호 목록에 밀린 줄에는 보호됨이라고 표시됩니다."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"이 아이템을 모든 캐릭터 목록으로 옮겨, 추가한 적 없는 캐릭터를 포함해 모든 캐릭터에서 삭제합니다."
L["OPTIONS_LIST_PROTECTED_TAG"] = "보호됨"
L["OPTIONS_ERASE_RESTORE"] = "기본값 복원"
L["OPTIONS_ERASE_RESTORE_DESCRIPTION"] =
	"이 캐릭터의 삭제 목록을 Magic Eraser가 처음 넣어 주는 아이템으로 되돌립니다."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"이 캐릭터의 삭제 목록을 비우고 Magic Eraser가 처음 넣어 주는 아이템만 다시 넣을까요? 직접 추가한 항목은 모두 제거됩니다."
