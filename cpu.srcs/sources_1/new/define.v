`define		ZERO        	    32'd0
`define		NOP                 32'b00000000000000000000000000010011;
`define     NOP_PC              32'HFFFFFFFF
`define     NOP_TYPE            7'b1111111

`define		STRONG_TAKEN	    2'b11
`define		WEAK_TAKEN	        2'b10
`define		WEAK_NOT_TAKEN	    2'b01
`define		STRONG_NOT_TAKEN	2'b00

`define     ONE_BYTE            3'b001
`define     HALF_WORD           3'b010
`define     ONE_WORD            3'b100

`define		LOAD_TYPE			7'b0000011
`define		IMM_TYPE			7'b0010011
`define		BRANCH_TYPE			7'b1100011
`define		LOGICAL_TYPE        7'b0110011
`define		STORE_TYPE			7'b0100011 
`define		JUMP_TYPE		    7'b1101111 // no realize

`define     BEQ                 3'b000          //BRANCH_TYPE
`define     BGE                 3'b101          //BRANCH_TYPE
`define     BLT                 3'b100          //BRANCH_TYPE
`define     BNE                 3'b001          //BRANCH_TYPE
`define     BLTU                3'b110          //BRANCH_TYPE

`define		LB                  3'b000		    //LOAD_TYPE
`define		LH                  3'b001		    //LOAD_TYPE
`define		LW                  3'b010		    //LOAD_TYPE

`define		ADDI                3'b000   		//IMM_TYPE
`define		ANDI                3'b111   		//IMM_TYPE
`define 	XORI  			    3'b100   		//IMM_TYPE
`define 	ORI  			    3'b110   		//IMM_TYPE

`define		SB                  3'b000		    //S_TYPE	
`define		SH                  3'b001		    //S_TYPE	
`define		SW                  3'b010		    //S_TYPE	

`define 	AND  			    10'b0000000111  //LOGICAL_TYPE
`define 	OR   			    10'b0000000110  //LOGICAL_TYPE
`define 	XOR  			    10'b0000000100  //LOGICAL_TYPE
`define 	SLL  			    10'b0000000001  //LOGICAL_TYPE
`define 	SRA  			    10'b0100000101  //LOGICAL_TYPE
`define 	SRL  			    10'b0000000101  //LOGICAL_TYPE

`define 	ADD  			    10'b0000000000  //LOGICAL_TYPE
`define 	SUB  		        10'b0100000000  //LOGICAL_TYPE
`define 	MUL  			    10'b0000001000  //LOGICAL_TYPE
`define 	DIV  			    10'b0000001100  //LOGICAL_TYPE


// 寄存器宏定义
`define     x0                  regs[0]         // zero
`define     x1                  regs[1]         // ra
`define     x2                  regs[2]         // sp
`define     x3                  regs[3]         // gp
`define     x4                  regs[4]         // tp
`define     x5                  regs[5]         // t0
`define     x6                  regs[6]         // t1
`define     x7                  regs[7]         // t2
`define     x8                  regs[8]         // s0/fp
`define     x9                  regs[9]         // s1
`define     x10                 regs[10]        // a0
`define     x11                 regs[11]        // a1
`define     x12                 regs[12]        // a2
`define     x13                 regs[13]        // a3
`define     x14                 regs[14]        // a4
`define     x15                 regs[15]        // a5
`define     x16                 regs[16]        // a6
`define     x17                 regs[17]        // a7
`define     x18                 regs[18]        // s2
`define     x19                 regs[19]        // s3
`define     x20                 regs[20]        // s4
`define     x21                 regs[21]        // s5
`define     x22                 regs[22]        // s6
`define     x23                 regs[23]        // s7
`define     x24                 regs[24]        // s8
`define     x25                 regs[25]        // s9
`define     x26                 regs[26]        // s10
`define     x27                 regs[27]        // s11
`define     x28                 regs[28]        // t3
`define     x29                 regs[29]        // t4
`define     x30                 regs[30]        // t5
`define     x31                 regs[31]        // t6