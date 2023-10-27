// ==========================================================================
// CRC Generation Unit - Linear Feedback Shift Register implementation
// (c) Kay Gorontzi, GHSi.de, distributed under the terms of LGPL
// ==========================================================================
module CRC_Unit(CLK, BITVAL, BITSTRB, CLEAR, CRC);
   input         CLK;
   input         BITVAL;                            // Next input bit
   input         BITSTRB;                           // Current bit valid (Clock)
   input         CLEAR;                             // Init CRC value
   output [5:0] CRC;                               // Current output CRC value

   reg    [5:0] CRC;                               // We need output registers
   wire          inv;
   
   assign inv = BITVAL ^ CRC[5];                   // XOR required?

   reg   BITSTRB_reg;
   wire   BITSTRB_posedge;
   assign BITSTRB_posedge = BITSTRB&(~BITSTRB_reg);
   always @(posedge CLK) begin : proc_BITSTRB_reg
      BITSTRB_reg<=BITSTRB;
   end
   always @(posedge CLK or posedge CLEAR) begin
     if (CLEAR) begin
         CRC = 0;                                  // Init before calculation
      end else if(BITSTRB_posedge=='b1) begin
         CRC[5] = CRC[4];
         CRC[4] = CRC[3];
         CRC[3] = CRC[2];
         CRC[2] = CRC[1];
         CRC[1] = CRC[0] ^ inv;
         CRC[0] = inv;
      end
   end
   
endmodule