resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"
lua54 'yes'
client_scripts {
    "config/shared.lua",
    "client/VehicleManager_CL.lua",
    "client/client.lua"
}

server_scripts {
    "config/shared.lua",
    "server/chatCommand.lua",
    "server/server.lua"
}
