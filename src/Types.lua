-- Copyright (c) 2024 RAMPAGE Interactive
-- License: MIT
-- GitHub: https://github.com/RAMPAGELLC/bloxsqlv3

export type void = nil

export type SQLQuery = string

export type SQLConnection = {
	config: SQLConnectionConfiguration,
	query: (SQLQuery, UnfilteredSQLParameters) -> SQLResponse?,
	execute: (SQLQuery, UnfilteredSQLParameters) -> SQLResponse?,
    queryPromise: (SQLQuery, UnfilteredSQLParameters) -> any; -- TODO: Promise type.

	Utility: { any },

	Enum: {
		[string]: string,
	},
}

export type SQLConnectionConfiguration = {
	proxy_server: string?,
	proxy_auth: string?,
	proxy: string,

	host: string,
	user: string,
	database: string,
	password: string,
}

export type UnfilteredSQLParameters = {
	[number]: table | string | boolean | number | StringValue | NumberValue | IntValue | CFrame | Vector2 | Vector3,
}

export type SQLParameters = {
	[number]: table | string | boolean | number,
}

export type SQLResponse = {
	success: boolean,
	query: string,

    params: SQLParameters;
    unfiltered_params: UnfilteredSQLParameters;

    results: {
        [number]: {
            any
        }
    }
}

return {}