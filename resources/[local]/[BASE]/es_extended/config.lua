Config = {}
Config.Locale = 'pl'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney = {bank = 500000000, money = 25000}

Config.MaxWeight            = 20000   -- the max inventory weight without backpack

Config.PaycheckInterval     = 11 * 60000 -- how often to recieve pay checks in milliseconds

Config.EnableDebug          = false

Config.IncompatibleResourcesToStop = {
	['spawnmanager'] = 'Default resource that takes care of spawning players, ESX does this already',
	['mapmanager'] = 'Default resource that was required by spawnmanager, but neither are used',
	['basic-gamemode'] = 'Resource that is solely for choosing the default game type',
	['fivem'] = 'Resource that is solely for choosing the default game type',
	['fivem-map-hipster'] = 'Default spawn locations for mapmanager',
	['fivem-map-skater'] = 'Default spawn locations for mapmanager',
}
