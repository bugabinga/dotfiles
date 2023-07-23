local count = vim.tbl_count

local join = function( tableA, tableB )
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

--TODO: add methods from lua table and vim.tbl_*
return {
	join = join,
	count = count,
}
