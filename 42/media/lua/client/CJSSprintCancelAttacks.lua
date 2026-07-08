local MOD_ID = "cjsSprintCancelAttacks"

local sprintWasDown = setmetatable({}, { __mode = "k" })
local warnedMissingAttackState = false

local function warnMissingAttackState()
    if warnedMissingAttackState then return end

    warnedMissingAttackState = true
    print("[" .. MOD_ID .. "] SwipeStatePlayer.ATTACKED is not available; sprint cancel is disabled")
end

local function getAttackCompletedParam()
    if not SwipeStatePlayer or not SwipeStatePlayer.ATTACKED then
        warnMissingAttackState()
        return nil
    end

    return SwipeStatePlayer.ATTACKED
end

local function isLocalPlayer(player)
    return player and player:isLocalPlayer() == true
end

local function isSprintPressedThisFrame(player)
    local sprintDown = player:isSprintButtonDown() == true
    local wasDown = sprintWasDown[player] == true
    sprintWasDown[player] = sprintDown

    return sprintDown and not wasDown
end

local function isCancelableWeaponAttack(player)
    if player:IsInMeleeAttack() ~= true then return false end
    if player:isDoHandToHandAttack() == true then return false end

    local attackedParam = getAttackCompletedParam()
    if not attackedParam then return false end

    return player:get(attackedParam) == false
end

local function cancelAttack(player)
    player:setDefaultState()
    player:setForceSprint(true)
end

local function onPlayerUpdate(player)
    if not isLocalPlayer(player) then return end
    if not isSprintPressedThisFrame(player) then return end
    if not isCancelableWeaponAttack(player) then return end

    cancelAttack(player)
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
