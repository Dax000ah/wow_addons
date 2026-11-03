local addon = {}
assert(loadfile("GroupCompass/Layout.lua"))("GroupCompass", addon)
local function item(x, slot, distance, width)
    return {x = x, width = width or 100, member = {slot = slot, distance = distance or 20}}
end
local items = {item(-160, 1), item(0, 2), item(160, 3)}
addon.Layout.SelectLabels(items)
assert(items[1].showLabel and items[2].showLabel and items[3].showLabel)
items = {item(-30, 1), item(0, 2), item(25, 3)}
addon.Layout.SelectLabels(items)
assert(not items[1].showLabel and items[2].showLabel and not items[3].showLabel)
assert(#items == 3 and items[1].x == -30 and items[3].x == 25, "never move or discard bearing markers")
items = {item(0, 1, 40), item(0, 2, 10), item(0, 3, 30)}
addon.Layout.SelectLabels(items)
assert(items[2].showLabel and not items[1].showLabel and not items[3].showLabel)
items = {item(0, 3), item(0, 1), item(0, 2)}
addon.Layout.SelectLabels(items); assert(items[2].showLabel)
items = {}
for slot = 1, 40 do items[slot] = item(-240 + (slot - 1) * 12, slot, 20, 120) end
addon.Layout.SelectLabels(items)
for a = 1, #items do
    if items[a].showLabel then
        for b = a + 1, #items do
            if items[b].showLabel then assert(math.abs(items[a].x - items[b].x) >= 128) end
        end
    end
end
addon.Layout.SelectLabels({})
print("PASS: single-row label spacing, center priority, stable ties, crowded raids and unmodified bearings")

for _,width in ipairs({320,620,1200}) do
    for font=8,20 do
        local minimum=3*font+16
        for _,height in ipairs({minimum,160}) do
            local g=addon.Layout.Compass({compassWidth=width,compassHeight=height,textSize=font})
            assert(g.span>0 and g.span+g.labelWidth/2<=width/2-9)
            assert(g.nameY-font>=g.headingY+1)
            assert(g.headingY-font>=g.tickY)
            assert(g.tickY-7>=g.distanceY-1e-6)
            assert(-g.distanceY+font<=height-2)
        end
    end
end
print('PASS: compass row fit and edge padding at minimum/maximum widths, heights and every supported font size')
