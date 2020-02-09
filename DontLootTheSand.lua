

SLASH_DONTLOOTTHESAND1 = "/sand"
SLASH_DONTLOOTTHESAND2 = "/dontlootthesand"
SlashCmdList["DONTLOOTTHESAND"] = function(msg)
  DontLootTheSand_SlashCommand(msg)
end 

function DontLootTheSand_SlashCommand(msg)
  local keyWord = string.match(msg, "%w+")
  local slashString
  if keyWord ~= nil then
    slashString = string.gsub(msg, keyWord .. "%s", "")
  end
 
  if msg == "" then
    print("DontLootTheSand usage:/sand on - turn Addon on\n/sand off - trun Addon off\n/sand message [Message] - message that should be wispered to some one looting sand\n/sand item [itemname] - item name to warn about (without [])\n/sand sound - to enable SoundWarning\n/sand wh [playerName] - add player to Whitelist to not be messaged when looting")
  elseif keyWord == "message" then
    DontLootTheSand.Message = slashString

  elseif keyWord == "item" then
    if slashString == nil then
      print("DontLootTheSand warning for item: " .. DontLootTheSand.WarnItem)
    else
      DontLootTheSand.WarnItem = "[" .. slashString .. "]"
      print("DontLootTheSand now warning for item: " .. DontLootTheSand.WarnItem)
    end

  elseif keyWord == "sound" then
    DontLootTheSand.PlaySound = not DontLootTheSand.PlaySound
    if DontLootTheSand.PlaySound then print("DontLootTheSand play sound [on]") else print("DontLootTheSand play sound [off]") end

  elseif keyWord == "wh" or keyWord == "whitelist" then
    if slashString then
      if DontLootTheSand.WhiteList[slashString] then
        DontLootTheSand.WhiteList[slashString] = nil
      else
        DontLootTheSand.WhiteList[slashString] = true
      end
    end
    print("DontLootTheSand Whitelist:")
    for whitelistEntry, _ in pairs(DontLootTheSand.WhiteList) do
      print("   " .. whitelistEntry)
    end
  
  elseif keyWord == "on" then
    DontLootTheSand.Enabled = true
    DontLootTheSand_ToggleAddon()
    print("DontLootTheSand enabled")

  elseif keyWord == "off" then
    DontLootTheSand.Enabled = false
    DontLootTheSand_ToggleAddon()
    print("DontLootTheSand dissabled")
    
  else
    print(msg .. " is not a valid DontLootTheSand command")
  end  
end

local function DontLootTheSand_SetupSavedVariables()
  --setup
  if not DontLootTheSand then DontLootTheSand = {} end
  if not DontLootTheSand.Message then DontLootTheSand.Message = "Der Sand wird von der Raidleitung gelootet, bitte trade den Sand!" end
  if not DontLootTheSand.WhiteList then DontLootTheSand.WhiteList = {} end
  if not DontLootTheSand.WarnItem then DontLootTheSand.WarnItem = "[Hourglass Sand]" end
  if not DontLootTheSand.Sound then DontLootTheSand.Sound = ture end
  if not DontLootTheSand.Enabled then DontLootTheSand.Enabled = ture end
end
function DontLootTheSand_ToggleAddon()
  if DontLootTheSand.Enabled == true then
    DontLootTheSand_Frame:RegisterEvent("CHAT_MSG_LOOT")
  else 
    DontLootTheSand_Frame:UnregisterEvent("CHAT_MSG_LOOT")
  end
end


function DontLootTheSand_OnLoad()
  DontLootTheSand_Frame:RegisterEvent("CHAT_MSG_LOOT")
  DontLootTheSand_Frame:RegisterEvent("ADDON_LOADED")
end

function DontLootTheSand_OnEvent(self, event, ...)
  if event == "CHAT_MSG_LOOT" then
    local messageString = select(1, ...)
    local itemName = string.match(messageString, "%[.+%]")
    local player = string.match(messageString, "%S+")
    
    if player == "You" then player = UnitName("player") end
    
    if DontLootTheSand.WhiteList[player] == true then return end

    if DontLootTheSand.WarnItem == "[test]" or itemName == DontLootTheSand.WarnItem then
      SendChatMessage(DontLootTheSand.Message ,"WHISPER" ,nil ,player)
      if DontLootTheSand.PlaySound then
        PlaySoundFile("sound/interface/bnet_voicechat_chatinitiated.ogg")
      end
    end

  elseif event == "ADDON_LOADED" and select(1, ...) == "DontLootTheSand" then
    DontLootTheSand_Frame:UnregisterEvent("ADDON_LOADED")
    DontLootTheSand_SetupSavedVariables()
  end
end






