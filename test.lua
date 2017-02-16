local PriorityQueue = require 'PriorityQueue'

local cases = {
	length = function()
		local bh = PriorityQueue()
		bh:enqueue( 'a', 2 )
		bh:enqueue( 'b', 4 )
		bh:enqueue( 'c', 1 )
		bh:enqueue( 'd', 6 )
		local bhx = PriorityQueue('max')
		bhx:enqueue( 'a', 2 )
		bhx:enqueue( 'b', 4 )
		bhx:enqueue( 'c', 1 )
		bhx:enqueue( 'd', 6 )
		return #bh == 4 and bh:len() == 4 and bhx:len() == 4 and #bhx == 4
	end,

	enq_deq = function()
		local bh = PriorityQueue()
		bh:enqueue( 'a', 2 )
		bh:enqueue( 'b', 4 )
		bh:enqueue( 'c', 1 )
		bh:enqueue( 'd', 6 )
		local bhx = PriorityQueue('max')
		bhx:enqueue( 'a', 2 )
		bhx:enqueue( 'b', 4 )
		bhx:enqueue( 'c', 1 )
		bhx:enqueue( 'd', 6 )
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c'
	end,

	batch_enq = function()
		local bh = PriorityQueue.new()
		bh:batchenq{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = PriorityQueue.new('max')
		bhx:batchenq{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c'
	end,

	new_batch = function()
		local bh = PriorityQueue{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = PriorityQueue{ higherpriority = 'max', 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c'
	end,

	empty = function()
		local bh = PriorityQueue{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bh2 = PriorityQueue.new()
		local bhx = PriorityQueue{ higherpriority = 'max', 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx2 = PriorityQueue( 'max' )
		return not bh:empty() and bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bh:empty() and bh2:empty() and
			not bhx:empty() and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c' and bhx2:empty()
	end,
	
	peek = function()
		local bh = PriorityQueue.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = PriorityQueue.new{ higherpriority = 'max', 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:peek() == 'c' and bh:dequeue() == 'c' and bh:peek() == bh:dequeue() and bhx:peek() == 'd' and bhx:dequeue() == 'd' and bhx:peek() == 'b'
	end,

	heapsort = function()
		local bh = PriorityQueue()
		local bhx = PriorityQueue('max')
		local array = {}
		for i = 1, 1000 do
			array[i] = math.random()
			bh:enqueue( array[i], array[i] )
			bhx:enqueue( array[i], -array[i] )
		end
		table.sort( array )
		for i = 1, #bh do
			if bh:dequeue() ~= array[i] or bhx:dequeue() ~= array[i] then
				return false
			end
		end

		return true
	end,

	simulation = function()
		local items = {}
		local bh = PriorityQueue('min')
		local bhx = PriorityQueue('max')

		for i = 1, 1000 do
			if #items == 0 or math.random() < 0.5 then
				local item = math.random()
				bh:enqueue( item, item )
				bhx:enqueue( item, -item )
				table.insert( items, item )
				table.sort( items )
			else
				local item = bh:dequeue()
				if item ~= table.remove( items, 1 ) or item ~= bhx:dequeue() then
					return false
				end
			end
		end

		return true
	end,
	
	existence = function()
		local bh = PriorityQueue.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = PriorityQueue.new{ higherpriority = 'max', 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:contains('a') and bh:contains('b') and bh:contains('c') and bh:contains('d') and
		(not bh:contains('z')) and (not bh:contains('x')) and (not bh:contains('y')) and (not bh:contains('q'))
		and bhx:contains('a') and bhx:contains('b') and bhx:contains('c') and bhx:contains('d') and
		(not bhx:contains('z')) and (not bhx:contains('x')) and (not bhx:contains('y')) and (not bhx:contains('q'))
	end,

	remove = function()
		local bh = PriorityQueue.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = PriorityQueue.new{ higherpriority = 'max', 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:contains('a') and (not bh:remove('z')) and bh:len() == 4 and #bh == 4 and bh:remove('a') and (not bh:contains('a')) and bh:len() == 3 and bh:remove('b') and bh:remove('d') and bh:remove('c') and bh:empty()
		and bhx:contains('a') and (not bhx:remove('z')) and bhx:len() == 4 and #bhx == 4 and bhx:remove('a') and (not bhx:contains('a')) and bhx:len() == 3 and bhx:remove('b') and bhx:remove('d') and bhx:remove('c') and bhx:empty()
		end,

	update = function()
		local bh = PriorityQueue.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = PriorityQueue.new{ higherpriority = 'max', 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:update('a', 0) and bh:peek() == 'a' and bh:remove('a') and (not bh:contains('a')) and (bh:update('c', 2)) and (not bh:update('z',5))
	end,

	contains_remove = function()
		local bh = PriorityQueue()
		bh:enqueue( 'a', 22 )
		bh:enqueue( 'b', 33 )
		return bh:contains('a') and #bh == 2 and bh:remove('a') and #bh == 1 and bh:remove('b') and #bh == 0
	end,

	custom_sort = function()
		local two = {2}
		local four = {4}
		local one = {1}
		local six = {6}
		local bh = PriorityQueue.new{ 'a', two, 'b', four, 'c', one, 'd', six, higherpriority = function(a,b)
			return a[1] < b[1]
		end}
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd'
	end,
}

local log = {'','Testing PriorityQueue'}
table.insert( log, ('='):rep( #log[2] ))

local function runCases( cs )
	local count, passed = 0, 0
	for name, case in pairs( cs ) do
		count = count + 1
		local pass = case()
		if pass then
			passed = passed + 1
		end
		table.insert( log, name .. ' => ' .. (pass and 'OK' or 'FAIL') )
	end
	local failed = count - passed
	table.insert( log, ('\nSummary\n-------\nPassed: %d\nFailed: %d'):format( passed, failed ))
	return passed, failed
end

local passed, failed = runCases( cases )

if failed > 0 then
	print( table.concat( log, '\n' ))
	error( 'Tests failed!' )
end
