local MOD_ID = "cjsSprintCancelAttacks"

local sprintAttackBan = setmetatable({}, { __mode = "k" })

local function isLocalPlayer(player)
    return player and player:isLocalPlayer() == true
end

local function isSprintDown(player)
    return player:isSprintButtonDown() == true
end

local function applySprintAttackBan(player)
    if not sprintAttackBan[player] then
        sprintAttackBan[player] = {
            wasBanned = player:isBannedAttacking() == true,
        }
    end

    player:setBannedAttacking(true)
end

local function releaseSprintAttackBan(player)
    local state = sprintAttackBan[player]
    if not state then return end

    player:setBannedAttacking(state.wasBanned == true)
    sprintAttackBan[player] = nil
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

    if isSprintDown(player) then
        applySprintAttackBan(player)

        if player:IsInMeleeAttack() == true then
            cancelAttack(player)
        end
    else
        releaseSprintAttackBan(player)
    end
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
