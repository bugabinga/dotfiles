--- Joins to tables into new table.
--- @param tableA table left table.
--- @param tableB table right table.
--- @return table table New table with left and right tables joined.
return function( tableA, tableB )
	vim.validate{
		tableA = { tableA, 'table' },
		tableB = { tableB, 'table' },
	}

	local sizeA = #tableA
	local sizeB = #tableB
	local index = 1
	local newTable = {}

	while index <= sizeA or index <= sizeB do
		if index <= sizeA then newTable[index] = tableA[index] end
		if index <= sizeB then newTable[index + sizeA] = tableB[index] end
		index = index + 1
	end

	return newTable
end
