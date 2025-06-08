---comment Test the action ID with a nonce value.
---@param nonce string
---@return string
local function TestActionId(nonce)
    local testNonce = nonce
    if not testNonce or testNonce == "" then
        error("Missing required parameter: testNonce")
    end

    local result = "Test action ID received: " .. testNonce
    return result
end

return TestActionId
