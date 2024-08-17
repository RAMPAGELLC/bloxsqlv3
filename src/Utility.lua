-- Copyright (c) 2024 RAMPAGE Interactive
-- License: MIT
-- GitHub: https://github.com/RAMPAGELLC/bloxsqlv3

local Utility = {}
local Types = require(script.Parent:WaitForChild("Types"))

function Utility:CSVWithKeys(options)
    local values = {}

    for _, value in pairs(options) do
        table.insert(values, value)
    end

    return Utility:CSV(values)
end

function Utility:CSV(options)
    return table.concat(options, ", ")
end

-- Utility functions to convert an "CFrame" for example into a Table and convert back as by default SQL does not support that.
function Utility:FilteredParametersToUnfiltered(params: Types.SQLParameters): Types.UnfilteredSQLParameters
    for i,v in pairs(params) do
        if typeof(v) == "table" then
            if v.BS_V3_ODT ~= nil then
                if v.BS_V3_ODT == "CFrame" then
                    params[i] = CFrame.new(table.unpack(v.Value))
                    continue;
                end

                local Instance = Instance.new(v.BS_V3_ODT);

                for property, value in pairs(v.Props) do
                    if Instance[property] == nil then
                        continue;
                    end

                    Instance[property] = value;
                end
            end
        end
    end

	return params
end

function Utility:FixUnfilteredParameters(params: Types.UnfilteredSQLParameters): Types.SQLParameters
	for i, v in pairs(params) do
		if typeof(v) == "Instance" and (v:IsA("StringValue") or v:IsA("NumberValue") or v:IsA("IntValue")) then
			params[i] = v.Value
		end

		if typeof(v) == "CFrame" then
			params[i] = {
				BS_V3_ODT = "CFrame",
                Value = { v:GetGetComponents() }
			}
		end
	end

	return params
end

return Utility
