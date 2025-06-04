#[evm_contract]
module Evm::Picture {
	use std::vector;
	
	/*
		let (start_x, end_x) = Verse_000001::Module_Domain_IV_Picture::theoretical_d1_values (100, 40, 1);
		let (start_y, end_y) = Verse_000001::Module_Domain_IV_Picture::theoretical_d2_values (100, 40, 1, 70);
		let intersect : bool = circles_intersect (50,50,4, 46,46,4);
	*/
	
	#[callable(sig=b"vectorize(uint64) returns (string)")]
    public fun Vectorize (_meal : u64) : vector<u8> {
		let vectors : vector<u8> = vector::empty<u8> ();

		vector::append (&mut vectors, b"<svg viewbox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>");
		
		vector::append (&mut vectors, b"\t<g style='fill: none; stroke: #000000;'>");
		vector::append (&mut vectors, b"\t\t<circle cx='50' cy='50' r='45' stroke-width='3' />");
		vector::append (&mut vectors, b"\t\t<circle cx='50' cy='50' r='40' stroke-width='2' />");
		vector::append (&mut vectors, b"\t</g>");
		
		vector::append (&mut vectors, b"\t<g style='fill: #000000; fill-opacity: 1;'>");
		vector::append (&mut vectors, b"\t\t<circle cx='80' cy='55' r='1' />");		
		vector::append (&mut vectors, b"\t</g>");

		vector::append (&mut vectors, b"</svg>");

		vectors
	}

	
	/*
		let (start_x, end_x) = theoretical_d1_values (100, 40, 1);
		
		Midpoint of inner circle is middle.
		
		 _____________ 100
		|
		|     
		|      
		| (----*----)
		| 10        90
		|     
		|
		
		0
	*/
	#[callable(sig=b"theoreticalD1Values(uint64,uint64,uint64) returns (uint64,uint64)")]
    public fun theoretical_d1_values (
		width : u64,
		outer_circle_radius : u64,
		inner_circle_radius : u64
	) : (u64, u64) {
		let circle_diameter = outer_circle_radius * 2;
		
		/*
			d1_boundary = (100 - 80) / 2 = 10 
		*/
		let d1_boundary = (width - circle_diameter) / 2;
		
		let start = d1_boundary + inner_circle_radius;
		let end = width - d1_boundary - inner_circle_radius;	
		
		(start, end)
	}
	#[test] public fun theoretical_d1_values__monitor_1 () {
		let (start, end) = theoretical_d1_values (100, 40, 1);
		assert! (start == 11, start);
		assert! (end == 89, end);		
	}
	#[test] public fun theoretical_d1_values__monitor_2 () {
		let (start, end) = theoretical_d1_values (100, 40, 2);
		assert! (start == 12, start);
		assert! (end == 88, end);		
	}
	
	
	/*
		let (start_y, end_y) = theoretical_d2_values (100, 40, 1, 70);
		
		Midpoint of inner circle is middle.
		
		 _____________ 100
		|
		|          /|
		|       c / | b
		|        /  | 
		| (-----*-a-*--)
		|        \  |
		|         \ |
		|          \|
		| 
		
		
		a:
			if (d1 >= (width/2)) {
				a = d1 - (width/2) 
			}
			else {
				a = (width/2) - d1  
			}
			
			a = 70 - 50 = 20
		
		
		c = 40 (outer circle radius)		
		
		
		a^2 + b^2 = c^2
		
		b^2 = c^2 - a^2
		b^2 = 40^2 - 20^2
		b = sqrt (1600 - 400)
		b = sqrt (1200)			
		b = 34.64101615137755		
		
		b = 34
			check equality: 34^2 vs 40^2 - 20^2
			check equality: 1156 vs 1600 - 400
			check equality: 1156 vs 1200
			
			is less, therefore rounded to lower number and therefore is good.
			is greater than, then there is problem.
		
		with rounding:
			(50 - 34, 50 + 34)
			(16, 84)		
		
		without rounding:
			(50 - 34.6, 50 + 34.6)
			(15.4, 84.6)
	*/

	
    #[callable(sig=b"distance(uint64,uint64) returns (uint64)")]
    public fun distance (a : u64, b : u64) : u64 {
		if (a > b) { return a - b };
		(b - a)
	}

	#[test] 
    public fun distance__monitor_1 () {
		assert! (distance (1,2) == 1, 1);
		assert! (distance (2,1) == 1, 1);
		assert! (distance (2,2) == 0, 1);
	}
	
	
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
		let c_sqr = (a*a) + b*b;
		let rr_sqr = (c1_r + c2_r)*(c1_r + c2_r);
		
		if (c_sqr > rr_sqr) {
			return false
		};
		
		true
	}

	#[test] 
    public fun circles_intersect__monitor_1 () {
		/*
			<svg xmlns='http://www.w3.org/2000/svg' viewBox="0 0 100 100">
				<g style="fill: #000000; fill-opacity: 1;">
					<circle cx="50" cy="50" r="2" />
					<circle cx="48" cy="48" r="2" />
				</g>
			</svg>
		*/
		
		assert! (circles_intersect (50,50,4, 46,46,4) == true, 1);
		
		assert! (circles_intersect (50,50,2, 46,46,2) == false, 1);
		assert! (circles_intersect (50,50,2, 46,46,3) == false, 1);
	}
}