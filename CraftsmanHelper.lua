local Conf = {
    width = 68,
    height = 18,
    x = 68,
    y = -14
}

local auctionatorRealmName = GetRealmName() .. "_" .. UnitFactionGroup("player")

local addonNameForChat = "|cffffff00CraftsmanHelper:|r"
local reagentForChat = "|c000affa0Reagent name:|r"
local noPriceForChat = "|c00ffa0a0No price for:|r"

local realmName = GetRealmName()

local CMH_TradeSkillButton = CreateFrame("Frame")

CMH_TradeSkillButton:SetScript(
    "OnEvent",
    function(self, event, ...)
        return self[event](self, ...)
    end
)

CMH_TradeSkillButton:RegisterEvent("PLAYER_LOGIN")

function CMH_TradeSkillButton:PLAYER_LOGIN()
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
            if (ReagentsPrices[realmName][reagentName]) then
                local reagentSum = reagentCount * ReagentsPrices[realmName][reagentName]
                print(reagentForChat, reagentName,  "[x"..reagentCount.."]", GetCoinTextureString(reagentSum))
                sum = sum + reagentSum
            else
                print(addonNameForChat, "No price for:", reagentName)
            end
        else
            local reagentSum = reagentCount * AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagentName]
            print(reagentForChat, reagentName, "[x"..reagentCount.."]", GetCoinTextureString(reagentSum))
            sum = sum + reagentSum
        end
    end

    print(addonNameForChat, GetCoinTextureString(sum))
end
