local file = io.open("input.txt", "r")
local input = file:read("*all")
file:close()

local prioritiesTable = {}

--lowercase
for i = 97, 122 do
	local char = utf8.char(i)
	prioritiesTable[char] = i - 96
end

--uppercase
for i = 65, 90 do
	local char = utf8.char(i)
	prioritiesTable[char] = i - 64 + 26
end

local function getRucksacks(input)
	local rucksacks = {}

	local i = 1
	for rucksack in input:gmatch("[^\r\n]+") do
		rucksacks[i] = rucksack
		i = i + 1
	end

	return rucksacks
end

local function getRucksackCompartments(rucksack)
	local compartments = {}

	local left = ""
	local right = ""

	local i = 1
	for item in rucksack:gmatch(".") do
		if i <= (#rucksack / 2) then
			left = left .. item
		else
			right = right .. item
		end

		i = i + 1
	end

	compartments[1] = left
	compartments[2] = right

	return compartments
end

local function getCompartmentItems(compartment)
	local items = {}

	for item in compartment:gmatch(".") do
		table.insert(items, item)
	end

	return items
end



--part 1
local function getItemsExistingInBothCompartments(compartments)
	local leftItems = getCompartmentItems(compartments[1])
	local rightItems = getCompartmentItems(compartments[2])

	local itemsExistingInBothCompartments = {}

	for i = 1, #leftItems do
		local leftItem = leftItems[i]

		for j = 1, #rightItems do
			local rightItem = rightItems[j]

			if leftItem == rightItem then
				itemsExistingInBothCompartments[#itemsExistingInBothCompartments + 1] = leftItem
			end
		end
	end

	return itemsExistingInBothCompartments
end

local function removeDuplicates(items)
	local uniqueSelfMap = {}
	local uniqueArray = {}

	for i = 1, #items do
		local item = items[i]
		if (not uniqueSelfMap[item]) then
			uniqueSelfMap[item] = item
			uniqueArray[#uniqueArray + 1] = item
		end
	end

	return uniqueArray
end

local rucksacks = getRucksacks(input)

local totalPrioritySum = 0
for i = 1, #rucksacks do
	local rucksack = rucksacks[i]
	local compartments = getRucksackCompartments(rucksack)

	local rucksackPrioritySum = 0

	local existingInBoth = getItemsExistingInBothCompartments(compartments)
	existingInBoth = removeDuplicates(existingInBoth)
	for j = 1, #existingInBoth do
		local itemType = existingInBoth[j]
		local priority = prioritiesTable[itemType]

		rucksackPrioritySum = rucksackPrioritySum + priority
	end

	totalPrioritySum = totalPrioritySum + rucksackPrioritySum
end

print(totalPrioritySum)



--part 2
local function getGroupRucksacks()
	local groupsRucksacks = {}
	for i = 1, #rucksacks, 3 do
		local groupRucksacks = {}
		groupRucksacks[1] = rucksacks[i]
		groupRucksacks[2] = rucksacks[i + 1]
		groupRucksacks[3] = rucksacks[i + 2]

		groupsRucksacks[#groupsRucksacks + 1] = groupRucksacks
	end
	return groupsRucksacks
end

local function getItemExistingInGroupRucksacks(groupRucksacks)
	local firstItems = getCompartmentItems(groupRucksacks[1])
	local secondItems = getCompartmentItems(groupRucksacks[2])
	local thirdItems = getCompartmentItems(groupRucksacks[3])

	local itemExistingInGroupRucksacks = {}

	for i = 1, #firstItems do
		local firstItem = firstItems[i]

		for j = 1, #secondItems do
			local secondItem = secondItems[j]
			for k = 1, #thirdItems do
				local thirdItem = thirdItems[k]

				if (firstItem == secondItem) and (secondItem == thirdItem) then
					itemExistingInGroupRucksacks[#itemExistingInGroupRucksacks + 1] = firstItem
				end
			end
		end
	end

	return removeDuplicates(itemExistingInGroupRucksacks)
end

local groupsRucksacks = getGroupRucksacks()
local badgePrioritySum = 0
for i = 1, #groupsRucksacks do
	local itemExistingInGroupRucksacks = getItemExistingInGroupRucksacks(groupsRucksacks[i])
	local itemType = itemExistingInGroupRucksacks[1]
	local itemPriority = prioritiesTable[itemType]

	badgePrioritySum = badgePrioritySum + itemPriority
end

print(badgePrioritySum)