// Test bench for ALU
`timescale 1ps/1ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 10000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i, j;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0)) else 
			$error("result was expected to be %0d but instead was %0d. Negative was expected to be %0b but instead was %0b, zero was expected to be %0b but instead was %0b", B, result, B[63], negative, (B == '0), zero);
		end
		
		$display("%t testing addition (no overflow)", $time); // Addition No Overflow
		cntrl = ALU_ADD;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1) else $error("Addition No Overflow test failed! Expected result: %0d, actual result: %0d", 0, result);
		
		$display("%t testing addition (zero)", $time); // Addition Zero
		cntrl = ALU_ADD;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1) else $error("Addition Zero test failed! Expected result: %0d, actual result: %0d", 0, result);
		
		$display("%t testing addition (overflow positive)", $time); // Addition Overflow Positive
		cntrl = ALU_ADD;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == (64'h8000000000000000) && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0) else 
		$error("Addition Overflow Positive test failed! Expected result: %0d, actual result: %0d, carry_out expected: %0b, carry_out actual: %0b, overflow expected: %0b, overflow actual %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b",
		$signed(64'h8000000000000000), $signed(result), 0, carry_out, 1, overflow, 1, negative, 0, zero);
		
		$display("%t testing addition (overflow negative)", $time); // Addition Overflow Negative
		cntrl = ALU_ADD;
		A = 64'h8000000000000000 ; B = 64'hFFFFFFFFFFFFFFFF ;
		#(delay);
		assert(result == (64'h7FFFFFFFFFFFFFFF) && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0) else 
		$error("Addition Overflow Negative test failed! Expected result: %0d, actual result: %0d, carry_out expected: %0b, carry_out actual: %0b, overflow expected: %0b, overflow actual %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b",
		$signed(64'h7FFFFFFFFFFFFFFF), $signed(result), 1, carry_out, 1, overflow, 0, negative, 0, zero);
		
		$display("%t testing subtraction (no overflow)", $time); // Subtraction No Overflow
		cntrl = ALU_SUBTRACT;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == (64'hFFFFFFFFFFFFFFFE) && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0) else 
		$error("Subtraction No Overflow test failed! Expected result: %0d, actual result: %0d, carry_out expected: %0b, carry_out actual: %0b, overflow expected: %0b, overflow actual %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b",
		$signed(64'hFFFFFFFFFFFFFFFE), $signed(result), 1, carry_out, 0, overflow, 1, negative, 0, zero);
		
		$display("%t testing subtraction (zero)", $time); // Subtraction Zero
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1) else
		$error("Subtraction Zero test failed! Expected result: %0d, actual result: %0d, carry_out expected: %0b, carry_out actual: %0b, overflow expected: %0b, overflow actual %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b",
		$signed(64'h0000000000000000), $signed(result), 0, carry_out, 0, overflow, 0, negative, 1, zero); // should carry out be true for this???
		
		$display("%t testing subtraction (overflow negative)", $time); // Subtraction Overflow Negative
		cntrl = ALU_SUBTRACT;
		A = 64'h8000000000000000; B = 64'h0000000000000001;
		#(delay);
		assert(result == (64'h7FFFFFFFFFFFFFFF) && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0) else 
		$error("Subtraction Overflow Negative test failed! Expected result: %0d, actual result: %0d, carry_out expected: %0b, carry_out actual: %0b, overflow expected: %0b, overflow actual %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b",
		$signed(64'h7FFFFFFFFFFFFFFF), $signed(result), 1, carry_out, 1, overflow, 0, negative, 0, zero);
		
		$display("%t testing subtraction (overflow positive)", $time); // Subtraction Overflow Positive
		cntrl = ALU_SUBTRACT;
		A = 64'h7FFFFFFFFFFFFFFF ; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == (64'h8000000000000000) && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0) else 
		$error("Subtraction Overflow Positive test failed! Expected result: %0d, actual result: %0d, carry_out expected: %0b, carry_out actual: %0b, overflow expected: %0b, overflow actual %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b",
		$signed(64'h8000000000000000), $signed(result), 0, carry_out, 1, overflow, 1, negative, 0, zero);
		
		// this for loop tests the three bitwise functions of the ALU, AND, OR, and XOR
		for(i = 4; i < 7; i++)begin
			$display("%t testing bitwise code: %0b when both inputs are all zeros", $time, i);
			cntrl = i;
			A = 64'h0000000000000000; B = 64'h0000000000000000; // Both Inputs All Zeros Case
			#(delay);
			assert(result == (64'h0000000000000000) && negative == 0 && zero == 1) else 
			$error("Both Inputs Zero test failed! Expected result: %0b, actual result: %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b, test code: %0b",
			64'h0000000000000000, result, 0, negative, 1, zero, i);
			$display("%t testing bitwise code: %0b when both inputs are all ones", $time, i);
			A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; // Both Inputs All Ones Case
			#(delay);
			assert(result == ((i==6)?64'h0000000000000000:64'hFFFFFFFFFFFFFFFF) && negative == (i==6)?0:1 && zero == (i==6)?1:0) else 
			$error("Both Inputs All Ones test failed! Expected result: %0b, actual result: %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b, test code: %0b",
			((i==6)?64'h0000000000000000:64'hFFFFFFFFFFFFFFFF), result, (i==6)?0:1, negative, (i==6)?1:0, zero, i);
			$display("%t testing bitwise code: %0b when one input is all ones and the other input is all zeros", $time, i);
			A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000; // One Input All Ones Other Input All Zeros Case
			#(delay);
			assert(result == ((i==4)?64'h0000000000000000:64'hFFFFFFFFFFFFFFFF) && negative == (i==4)?0:1 && zero == (i==4)?1:0) else 
			$error("One Input All Ones Other Input All Zeros test failed! Expected result: %0b, actual result: %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b, test code: %0b",
			((i==4)?64'h0000000000000000:64'hFFFFFFFFFFFFFFFF), result, (i==4)?0:1, negative, (i==4)?1:0, zero, i);
			$display("Choosing random values of A and B for bitwise function");
			for (j=0; j<3; j++) begin
				A = $random(); B = $random();
				#(delay);
				case(i)
					4: assert(result == (A&B) && negative == A[63]&B[63] && zero == ((A&B) == 0)) else 
						$error("Random input test failed! Expected result: %0b, actual result: %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b, test code: %0b",
						(A&B), result, A[63]&B[63], negative, ((A&B) == 0), zero, i);
					5: assert(result == (A|B) && negative == A[63]|B[63] && zero == ((A|B) == 0)) else 
						$error("Random input test failed! Expected result: %0b, actual result: %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b, test code: %0b",
						(A|B), result, A[63]|B[63], negative, ((A|B) == 0), zero, i);
					6: assert(result == (A^B) && negative == A[63]^B[63] && zero == ((A^B) == 0)) else 
						$error("Random input test failed! Expected result: %0b, actual result: %0b, negative expected: %0b, negative actual: %0b, zero expected: %0b, zero actual: %0b, test code: %0b",
						(A^B), result, A[63]^B[63], negative, ((A^B) == 0), zero, i);
					default: $error("Invalid opcode: %0b", i);
				endcase
			end
		end
		$stop;
	end
endmodule
