-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

function Utilities.getZero()
	return 0
end

function Utilities.tableItemCount( tableToCount )
	local count = 0
	for i=1, #tableToCount do
		count = count + 1
	end
	return count
end