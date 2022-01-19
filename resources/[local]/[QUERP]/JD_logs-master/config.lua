Config = {}

Config.AllLogs = true											-- Enable/Disable All Logs Channel
Config.postal = true  											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "qqxLogs" 							-- Bot Username
Config.avatar = "https://via.placeholder.com/30x30"				-- Bot Avatar
Config.communtiyName = "qqxBot"					-- Icon top of the embed
Config.communtiyLogo = "https://via.placeholder.com/30x30"		-- Icon top of the embed
Config.FooterText = "qqxLogs"						-- Footer text for the embed
Config.FooterIcon = "https://via.placeholder.com/30x30"			-- Footer icon for the embed


Config.weaponLog = true  			-- set to false to disable the shooting weapon logs
Config.InlineFields = true			-- set to false if you don't want the player details next to each other

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs
Config.license = true				-- set to false to disable license in the logs
Config.IP = false					-- set to false to disable IP in the logs

-- Change color of the default embeds here
-- It used Decimal or Hex color codes. They will both work.
Config.BaseColors ={		-- For more info have a look at the docs: https://docs.prefech.com
	chat = "#A1A1A1",				-- Chat Message
	joins = "#3AF241",				-- Player Connecting
	leaving = "#F23A3A",			-- Player Disconnected
	deaths = "#000000",				-- Shooting a weapon
	shooting = "#2E66F2",			-- Player Died
	resources = "#EBEE3F",			-- Resource Stopped/Started	
}


Config.webhooks = {		-- For more info have a look at the docs: https://docs.prefech.com
	all = "https://discord.com/api/webhooks/915615760309690408/-BeYZGYf_C1EGL07ecSfi7TUqUIGtPHrTsFikRDUapjL1lblJvbkNfe2kSSP9hFhzU0c",		-- All logs will be send to this channel
	chat = "https://discord.com/api/webhooks/915615667456192513/BtTdBRAXH_WJqzD_StOX-KxN_eap0By3IypEMrrnpkOUPfxW9NGFWH97OhbArkoJrzx1",		-- Chat Message
	joins = "https://discord.com/api/webhooks/915615557297004544/2nMDcp-m7Sl7Buzl7Dw9zEB9t6mpKbHIrLpjYZUPvKN24LZvEBGQRVftBZgtMfk5QeQx",		-- Player Connecting
	leaving = "https://discord.com/api/webhooks/915615493879136296/Kmv6GLBfJTe2EXpuac7rQZz_ksexS_pW6XYuQcELPw7o4kN4jrRMcICtj6QgyylKBjBU",	-- Player Disconnected
	deaths = "https://discord.com/api/webhooks/915615294117011487/oZV1L2usp4K1HtNu3ol_mc8tIdZ4-uccAPMfzOv9v7oXRAWijmACcSVuLbAIWvmX8DvE",		-- Shooting a weapon
	shooting = "https://discord.com/api/webhooks/915615152357904456/T0J4azrdwFDVn973S9v4yTls9FH_VY-eE8D55zNPa4If8Lg8no0D3-NGSggocFIv-jjS",	-- Player Died
	resources = "https://discord.com/api/webhooks/915622105285033984/GpD5WIxYqDHpbIMH7kCq8j9cw9mxuVvt1kowQySqL1OEDC62plMHGI05HQKztOXfKtpr",	-- Resource Stopped/Started	
}

Config.TitleIcon = {		-- For more info have a look at the docs: https://docs.prefech.com
	chat = "💬",				-- Chat Message
	joins = "📥",				-- Player Connecting
	leaving = "📤",			-- Player Disconnected
	deaths = "💀",				-- Shooting a weapon
	shooting = "🔫",			-- Player Died
	resources = "🔧",			-- Resource Stopped/Started	
}

Config.Plugins = {
	--["PluginName"] = {color = "#FFFFFF", icon = "🔗", webhook = "DISCORD_WEBHOOK"},
	["NameChange"] = {color = "#03fc98", icon = "🔗", webhook = "DISCORD_WEBHOOK"},
}


 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.3.0"
