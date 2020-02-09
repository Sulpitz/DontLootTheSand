local DontLootTheSand = {}


SLASH_DONTLOOTTHESAND1 = "/sand"
SLASH_DONTLOOTTHESAND2 = "/dontlootthesand"
SlashCmdList["DONTLOOTTHESAND"] = function(msg)
  DontLootTheSand_SlashCommand(msg)
end 

--setup
if not DontLootTheSand.Message then DontLootTheSand.Message = "Der Sand wird von der Raidleitung gelootet, bitte trade den Sand!" end
if not DontLootTheSand.IgnoreList then DontLootTheSand.IgnoreList = {} end

function DontLootTheSand_SlashCommand(msg)
  if msg == "" then
    print("DontLootTheSand usage:\n /sand message [Message] - message that should be wispered to some one looting sand")
  else
    print(msg)
  end


  
end

function DontLootTheSand_OnLoad()
  DontLootTheSand_Frame:RegisterEvent("CHAT_MSG_LOOT")
end

function DontLootTheSand_OnEvent(self, event, ...)
  print("------------------------")
  local messageString = select(1, ...)
  local itemName = string.match(messageString, "%[.+%]")
  local player = string.match(messageString, "%S+")
  
  print(player)
  print(itemName)

  if itemName == "[Chunk of Boar Meat]" then
    SendChatMessage(DontLootTheSand.Message ,"WHISPER" ,nil ,"Tarawera")
  end

end







