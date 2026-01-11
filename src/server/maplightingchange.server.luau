local CollectionService = game:GetService "CollectionService"

local scoreboardTagged = CollectionService:GetTagged "Scoreboard"
local bulbTagged = CollectionService:GetTagged "Bulb"
local spotlightTagged = CollectionService:GetTagged "Pointlight"

--print(scoreboardTagged, bulbTagged, spotlightTagged) we'll come back to this once we decide how the daytime system works
-- either instant OR day cycle OR Boss
