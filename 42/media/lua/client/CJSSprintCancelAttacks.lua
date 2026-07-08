local MOD_ID = "cjsSprintCancelAttacks"

local runAttackBan = setmetatable({}, { __mode = "k" })

local function isLocalPlayer(player)
    return player and player:isLocalPlayer() == true
end

local function isRunDown(player)
    return player:isRunButtonDown() == true
end

local function applyRunAttackBan(player)
    if not runAttackBan[player] then
        runAttackBan[player] = {
            wasBanned = player:isBannedAttacking() == true,
        }
    end

    player:setBannedAttacking(true)
end

local function releaseRunAttackBan(player)
    local state = runAttackBan[player]
    if not state then return end

    player:setBannedAttacking(state.wasBanned == true)
    runAttackBan[player] = nil
end

local function resetActionContext(player)
    local actionContext = player:getActionContext()
    if not actionContext then return end

    local group = actionContext:getGroup()
    if not group then return end

    local initialState = group:getInitialState()
    if not initialState then
        initialState = group:getDefaultState()
    end

    if initialState then
        actionContext:setCurrentState(initialState)
    end
end

local function cancelAttack(player)
    player:clearHandToHandAttack()
    resetActionContext(player)
    player:setDefaultState()
    player:setIgnoreMovement(false)
    player:setBlockMovement(false)
    player:setPerformingAttackAnimation(false)
    player:setPerformingShoveAnimation(false)
    player:setPerformingStompAnimation(false)
    player:setShoveStompAnim(false)
end

local function onPlayerUpdate(player)
    if not isLocalPlayer(player) then return end

    if isRunDown(player) then
        applyRunAttackBan(player)

        if player:IsInMeleeAttack() == true then
            cancelAttack(player)
        end
    else
        releaseRunAttackBan(player)
    end
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
