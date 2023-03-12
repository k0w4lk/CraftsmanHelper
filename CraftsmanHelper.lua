CMH = {};

CMH["Кристалл пропасти"] = AbyssCrystal or 520000
CMH["Осколок грез"] = DreamShard or 690000
CMH["Великая космическая субстанция"] = GreaterCosmicEssence or 70000
CMH["Абсолютная пыль"] = InfiniteDust or 40000

local Conf = {
    width = 68,
    height = 18,
    x = 68,
    y = -14
}

local addonNameForChat = "|cffffff00CraftsmanHelper:|r";

local Core = CreateFrame("Frame", "CoreFrame", TradeSkillFrame)
local GetPriceButton = CreateFrame("Button", "GetPriceButton", TradeSkillFrame, "UIPanelButtonTemplate")

GetPriceButton:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", Conf.x, Conf.y)
GetPriceButton:SetSize(Conf.width, Conf.height)
GetPriceButton:SetText("Calc price")
GetPriceButton:RegisterForClicks("AnyUp")
GetPriceButton:SetScript(
    "OnClick",
    function(self, button, down)
        CalcPrice()
    end
)

GetPriceButton:SetScript(
    "OnEvent",
    function(self, event, ...)
        return self[event](self, ...)
    end
)

GetPriceButton:RegisterEvent("PLAYER_LOGIN")

SLASH_CRAFT1 = "/ch"

SlashCmdList["CRAFT"] = function()
    print("Price is ...")
end

function GetPriceButton:PLAYER_LOGIN()
    print("Craftsman loaded")
end

function CalcPrice()
    id = GetTradeSkillSelectionIndex()
    skillName = GetTradeSkillInfo(id)
    numReagents = GetTradeSkillNumReagents(id)
    local sum = 0
    for i = 1, numReagents, 1 do
        local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
        if(not CMH[reagentName]) then
        print(addonNameForChat, 'No price for:', reagentName)
        do return end
        end
        sum = sum + reagentCount * CMH[reagentName];
    end
    
    print(addonNameForChat, skillName)
    print(addonNameForChat, GetCoinTextureString(math.floor(sum * 1.05)))
   
end
