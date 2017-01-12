![Build Status](https://travis-ci.org/iskolbin/priorityqueue.svg?branch=master)
[![license](https://img.shields.io/badge/license-public%20domain-blue.svg)]()

Priority Queue
==============

Lua implementation of *priority queue* data structure using *indirect binary heap*. 
Indirect heaps offer efficient removal and updating priority operations. This
implementation is based on [binaryheap libary](github.com/iskolbin/binaryheap) with
some changed design.

PriorityQueue.new( [array/ordering] )
---------------------------
Create new priority queue. You can pass **array** to initialize queue with *O(n)* 
complexity (implemented with **batchenq**, see below). First argument also could be
an ordering function defining higher priority or you can simply pass `"min"` for 
min-heap( default behavior ) or `"max"` for max-heap (also array can contain 
`higherpriority` field).

Min heap:

```lua
local q = PriorityQueue.new()
local q = PriorityQueue.new('min') 
```

Max heap using function notation:

```lua
local q = PriorityQueue( 'max' )
```

Array initialization:

```lua
local security = PriorityQueue{ 
	'high', 1, 
	'low', 10, 
	'moderate', 5, 
	'moderate-', 7, 
	'moderate+', 3,
}
```

Array initialization with max-heap ordering:

```lua
local security = PriorityQueue{
	higherpriority = 'max',
	'high', 10, 
	'low', 1, 
	'moderate', 5, 
	'moderate-', 3, 
	'moderate+', 7,
}
```

Custom comparator:

```lua
local security = PriorityQueue{
	higherpriority = function(a,b)
		return a.level > b.level
	end,
	'high', {level = 10}, 
	'low', {level = 1}, 
	'moderate', {level = 5}, 
	'moderate-', {level = 3}, 
	'moderate+', {level = 7},
}

enqueue( item, priority )
-------------------------
Enqueue the **item** with the **priority** to the heap. The **priority** must be
comparable if you use builtin comparators, i.e. it must be either number or string 
or a table with metatable with **__lt** metamethod defined. Otherwise you have to
define custom comparator.
Time complexity is *O(logn)*.

dequeue()
---------
Dequeue from the heap. Returns item and associated priority. If the heap is
empty then an **error** will raise. Returns an item with highest priority.
Time complexity is *O(logn)*.

peek()
------
Returns the item with minimal priority and priority itself for 
BinaryMinHeap(maximal for BinaryMaxHeap) or **nil** if the heap is empty.

len()
-----
Returns items count. Also you can use **#** operator for the same effect.

empty()
-------
Returns **true** if the heap has no items and **false** otherwise.

batchenq( iparray )
-------------------
Efficiently enqueues list of item-priority pairs into the heap. *Note that this
is efficient only when the amount of inserting elements greater or equal than
the current length*.
Time complexity of this operation is *O(n)*(sequential approach is *O(nlogn)*).

contains( item )
---------------
Checking that heap contains the **item**. This operation is *O(1)*.

remove( item )
--------------
Removes the **item** from the heap. Returns **true** if **item** was in
the heap and **false** otherwise. This operation is *O(logn)*.

update( item, priority )
------------------------
Changes **item** **priority**. Returns **true** if **item** was in the queue
(even if priority not changed) and **false** otherwise. This operation is
*O(logn)*, internally it's just **remove** followed by **enqueue**.
