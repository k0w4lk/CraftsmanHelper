local Conf = {
    width = 68,
    height = 18,
    x = 68,
    y = -14
}

local auctionatorRealmName = GetRealmName() .. "_" .. UnitFactionGroup("player")

local addonNameForChat = "|cffffff00CraftsmanHelper:|r"

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

function GetPriceButton:PLAYER_LOGIN()
    print("CraftsmanHelper loaded")
end

function CalcPrice()
    id = GetTradeSkillSelectionIndex()
    skillName = GetTradeSkillInfo(id)
    numReagents = GetTradeSkillNumReagents(id)
    local sum = 0
    for i = 1, numReagents, 1 do
        local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
        if (not AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagentName]) then
            print(addonNameForChat, "No price for:", reagentName)
            do
                return
            end
        end
        sum = sum + reagentCount * AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagentName]
    end

    print(addonNameForChat, skillName)
    print(addonNameForChat, GetCoinTextureString(sum))
end
