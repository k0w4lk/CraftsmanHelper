local Conf = {
    width = 68,
    height = 18,
    x = 68,
    y = -14
}

local auctionatorRealmName = GetRealmName() .. "_" .. UnitFactionGroup("player")

local addonNameForChat = "|cffffff00CraftsmanHelper:|r"

local CMH = CreateFrame("Frame")

CMH:SetScript(
    "OnEvent",
    function(self, event, ...)
        return self[event](self, ...)
    end
)

CMH:RegisterEvent("PLAYER_LOGIN")

function CMH:PLAYER_LOGIN()
    print("CraftsmanHelper loaded")
end

local GetPriceButton = CreateFrame("Button", "GetPriceButton", TradeSkillFrame, "UIPanelButtonTemplate")

GetPriceButton:SetSize(Conf.width, Conf.height)
GetPriceButton:SetText("Узнать цену")
GetPriceButton:RegisterForClicks("AnyUp")
GetPriceButton:SetScript(
    "OnClick",
    function(self, button, down)
        CalcPrice()
    end
)
GetPriceButton:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", Conf.x, Conf.y)

function CalcPrice()
    id = GetTradeSkillSelectionIndex()
    skillName = GetTradeSkillInfo(id)
    numReagents = GetTradeSkillNumReagents(id)
    local sum = 0

    print(addonNameForChat, skillName)

    for i = 1, numReagents, 1 do
        local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
        if (not AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagentName]) then
            print(addonNameForChat, "No price for:", reagentName)
        else
            sum = sum + reagentCount * AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagentName]
        end
    end

    print(addonNameForChat, GetCoinTextureString(sum))
end
