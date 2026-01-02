opt server_output = "src/server/zap.luau"
opt client_output = "src/shared/zap.luau"

event PlayerSync = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
        wins: u16,
    },
}

event InIntermission = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data : (InIntermission: boolean),
}