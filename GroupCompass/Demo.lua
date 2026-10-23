local _, addon = ...
addon.Demo = {}
local anchors, map
local samples = {
    { name = "Demo A", relative = -math.pi / 3, distance = 25 },
    { name = "Demo B", relative = 0, distance = 40 },
    { name = "Demo C", relative = math.pi / 3, distance = 60 },
}

function addon.Demo.Reset()
    anchors, map = nil, nil
end

function addon.Demo.Sample()
    local player, reason = addon.Tracking.PlayerState()
    if not player then return {}, "DEMO paused - " .. reason end
    if not anchors or map ~= player.map then
        anchors, map = {}, player.map
        for slot, sample in ipairs(samples) do
            local bearing = player.facing - sample.relative
            anchors[slot] = {
                x = player.x + math.cos(bearing) * sample.distance,
                y = player.y + math.sin(bearing) * sample.distance,
            }
        end
    end
    local members = {}
    for slot, anchor in ipairs(anchors) do
        local angle, distance = addon.Direction.Calculate(player.x, player.y, anchor.x, anchor.y, player.facing)
        members[slot] = { slot = slot, color = addon.Tracking.Color(slot),
            name = samples[slot].name, angle = angle, distance = distance }
    end
    return members, "DEMO - fixed simulated locations; turn your character or walk"
end
