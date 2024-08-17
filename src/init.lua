-- Copyright (c) 2024 RAMPAGE Interactive
-- License: MIT
-- GitHub: https://github.com/RAMPAGELLC/bloxsqlv3

-- @author vq9o
-- @purpose bloxSQL module
-- @version 3.0

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LibraryUtility = require(script:WaitForChild("Utility"))
local LibraryEnum = require(script:WaitForChild("Enum"))
local Promise = require(script:WaitForChild("Promise"))
local Types = require(script:WaitForChild("Types"))

local Class = {}
Class.__index = Class

function Class.new(config: Types.SQLConnectionConfiguration): Types.SQLConnection
	local self = setmetatable({}, Class)

	assert(
		RunService:IsServer(),
		"bloxSQL must be ran on the server! Utilize RemoteFunctions/RemoteEvents if the client requires data!"
	)

	self.Utility = LibraryUtility
	self.Enum = LibraryEnum
	self.config = config

	assert(self.config.host ~= nil and typeof(self.config.host) == "string")
	assert(self.config.user ~= nil and typeof(self.config.user) == "string")
	assert(self.config.database ~= nil and typeof(self.config.database) == "string")
	assert(self.config.password ~= nil and typeof(self.config.password) == "string")
	assert(self.config.proxy ~= nil and typeof(self.config.proxy) == "string")

	assert(
		self.Enum.ProxyOptions[self.config.proxy] ~= nil,
		"Invalid Proxy Options; Valid options are: " .. self.Utility:CSVWithKeys(self.Enum.ProxyOptions)
	)

	if self.config.proxy == self.Enum.ProxyOptions.Default then
		self.config.proxy = self.Enum.ProxyOptions.Public
		self.config.proxy_server = "https://bloxsql.rampagestudios.org/v1/proxy"
		self.config.proxy_auth = "public"
	end

	assert(self.config.proxy_server ~= nil and typeof(self.config.proxy_server) == "string")
	assert(self.config.proxy_auth ~= nil and typeof(self.config.proxy_auth) == "string")

	assert(
		self.config.proxy == self.Enum.ProxyOptions.Private and self.config.proxy_auth ~= "public",
		"You need to set a secure proxy authentication token."
	)

	assert(
		self.config.proxy == self.Enum.ProxyOptions.Private and self.config.proxy_server == nil,
		"Missing configuration option 'proxy_server'."
	)

	assert(
		self.config.proxy == self.Enum.ProxyOptions.Private and self.config.proxy_auth == nil,
		"Missing configuration option 'proxy_auth'."
	)

	return self
end

function Class:query(
	query: Types.SQLQuery,
	params: Types.UnfilteredSQLParameters | Types.SQLParameters
): Types.SQLResponse
	params = self.Utility:FixUnfilteredParameters(params)

	HttpService:RequestAsync(self.config.proxy_server)
	-- todo.
end

function Class:queryPromise(query: Types.SQLQuery, params: Types.UnfilteredSQLParameters | Types.SQLParameters)
	return Promise.new(function(resolve, reject, onCall)
		local SQLResponse = self:query(query, params)
        
        if SQLResponse.success then
            resolve(SQLResponse)
        else
            reject("An error occured while fetching!")
        end
	end)
end

function Class:execute(...): any
	return self:query(...)
end

return Class