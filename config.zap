opt server_output = "src/server/zap.luau"
opt client_output = "src/shared/zap.luau"

event PlayerSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
        wins: u16?,
		current_stats: struct {
			strength: u8,
			energy: u8,
			endurance: u8,
		}?
    },
}

event InIntermission = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data : (InIntermission: boolean),
}

event PlayerRoll = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event PlayerParry = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event UpdateStats = {
	from : Client,
	type : Reliable,
	call: SingleAsync,
	data : (NewStats : struct {
		strength : u8,
		energy : u8,
		endurance : u8,
	})
}

event DisplayProjectile = {
	from : Server,
	type : Reliable,
	call : SingleAsync,
	data : (sentTime : f64,spawn : Vector3, velocity : Vector3)
}

event LobbedProjectile = {
	from : Server,
	type : Reliable,
	call : SingleAsync,
	data : (sentTime : f64,spawn : Vector3,velocity : Vector3,dtCoefficient : f64,target : Instance.Model)
}