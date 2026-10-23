local _, addon = ...
addon.Layout = {}

-- Keep every bearing marker at its true X. When labels collide, prefer the
-- member nearest straight ahead; full identities remain in the hover details.
function addon.Layout.SelectLabels(items)
    local order = {}
    for index, item in ipairs(items) do
        item.showLabel = false
        order[index] = item
    end
    table.sort(order, function(a, b)
        if math.abs(a.x) ~= math.abs(b.x) then return math.abs(a.x) < math.abs(b.x) end
        if a.member.distance ~= b.member.distance then return a.member.distance < b.member.distance end
        return a.member.slot < b.member.slot
    end)
    local occupied = {}
    for _, item in ipairs(order) do
        local left, right = item.x - item.width / 2, item.x + item.width / 2
        local fits = true
        for _, interval in ipairs(occupied) do
            if left < interval[2] + 8 and right > interval[1] - 8 then fits = false; break end
        end
        if fits then
            item.showLabel = true
            occupied[#occupied + 1] = {left, right}
        end
    end
end
