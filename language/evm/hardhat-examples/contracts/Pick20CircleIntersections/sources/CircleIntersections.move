#[evm_contract]
module Evm::circle_intersections {

	/*
		let intersect : bool = circles_intersect (50,50,4, 46,46,4);
	
		 _____________ 100
		|
		|           *
		|          /| b
		|   /       | 
		|  *-------- 
		|       a
		|
		
		c^2 = a^2 + b^2
		
		does
		(c1_r + c2_r) ^ 2 = c^2
	*/

	#[callable(sig=b"circlesIntersect(uint64,uint64,uint64,uint64,uint64,uint64) returns (bool)")]
	public fun circles_intersect (
		c1_x : u64,
		c1_y : u64,
		c1_r : u64,

		c2_x : u64,
		c2_y : u64,
		c2_r : u64
	) : bool {
		
		let a = distance (c1_x, c2_x);
		let b = distance (c1_y, c2_y);

		//
		// Both of the these are integers
		// without rounding.
		//
		let c_sqr = a*a + b*b;
		let rr_sqr = (c1_r + c2_r) * (c1_r + c2_r);
		
		if (c_sqr > rr_sqr) {
			return false
		};
		
		true
	}

	#[callable(sig=b"circlesIntersectMonitor()")]
	public fun circles_intersect__monitor_1 () {		
		assert! (circles_intersect (50,50,4, 46,46,4) == true, 1);
		
		assert! (circles_intersect (50,50,2, 46,46,2) == false, 1);
		assert! (circles_intersect (50,50,2, 46,46,3) == false, 1);
	}
	
	
	
	fun distance (a : u64, b : u64) : u64 {
		if (a > b) { return a - b };
		(b - a)
	}
	
	
	
}