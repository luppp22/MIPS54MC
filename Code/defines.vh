`ifndef _defines_vh_

`define _defines_vh_

`define _WEB_TEST

`define TEST_FILE_NAME "14_jal.mem"

//----------Operation----------

`define OP_ADDI         6'b001000
`define OP_ADDIU        6'b001001
`define OP_ANDI         6'b001100
`define OP_BEQ          6'b000100
`define OP_BNE          6'b000101
`define OP_COP0         6'b010000
`define OP_J            6'b000010
`define OP_JAL          6'b000011
`define OP_LUI          6'b001111
`define OP_LB           6'b100000
`define OP_LBU          6'b100100
`define OP_LH           6'b100001
`define OP_LHU          6'b100101
`define OP_LW           6'b100011
`define OP_ORI          6'b001101
`define OP_REGIMM       6'b000001
`define OP_SLTI         6'b001010
`define OP_SLTIU        6'b001011
`define OP_SPECIAL      6'b000000
`define OP_SPECIAL2     6'b011100
`define OP_SB           6'b101000
`define OP_SH           6'b101001
`define OP_SW           6'b101011
`define OP_XORI         6'b001110

`define FUNCT_ADD       6'b100000
`define FUNCT_ADDU      6'b100001
`define FUNCT_AND       6'b100100
`define FUNCT_BREAK     6'b001101
`define FUNCT_CLZ       6'b100000
`define FUNCT_DIV       6'b011010
`define FUNCT_DIVU      6'b011011
`define FUNCT_ERET      6'b011000
`define FUNCT_JALR      6'b001001
`define FUNCT_JR        6'b001000
`define FUNCT_MFHI      6'b010000
`define FUNCT_MFLO      6'b010010
`define FUNCT_MTHI      6'b010001
`define FUNCT_MTLO      6'b010011
`define FUNCT_MUL       6'b000010
`define FUNCT_MULTU     6'b011001
`define FUNCT_NOR       6'b100111
`define FUNCT_OR        6'b100101
`define FUNCT_SLL       6'b000000
`define FUNCT_SLLV      6'b000100
`define FUNCT_SLT       6'b101010
`define FUNCT_SLTU      6'b101011
`define FUNCT_SRA       6'b000011
`define FUNCT_SRAV      6'b000111
`define FUNCT_SRL       6'b000010
`define FUNCT_SRLV      6'b000110
`define FUNCT_SUB       6'b100010
`define FUNCT_SUBU      6'b100011
`define FUNCT_SYSCALL   6'b001100
`define FUNCT_TEQ       6'b110100
`define FUNCT_XOR       6'b100110

`define RS_MF           5'b00000
`define RS_MT           5'b00100
`define RT_BGEZ         5'b00001



//----------CtrlUnit----------

`define CTRL_STATE_INIT  3'b000
`define CTRL_STATE_T1    3'b001
`define CTRL_STATE_T2    3'b010
`define CTRL_STATE_T3    3'b011
`define CTRL_STATE_T4    3'b100
`define CTRL_STATE_T5    3'b101



//----------Memory----------

`define EXT_MEM_CWIDTH      2
`define EXT_MEM_AWIDTH      2

`define MEM_WTYPE_WORD      2'b00
`define MEM_WTYPE_HALF      2'b01
`define MEM_WTYPE_BYTE      2'b10



//----------ALU----------

`define ALU_CWIDTH          4   //control signal width

`define ALU_OP_ADDU         4'b0000
`define ALU_OP_ADD          4'b0001
`define ALU_OP_SUBU         4'b0010
`define ALU_OP_SUB          4'b0011
`define ALU_OP_AND          4'b0100
`define ALU_OP_OR           4'b0101
`define ALU_OP_XOR          4'b0110
`define ALU_OP_NOR          4'b0111
`define ALU_OP_LUI          4'b1000
`define ALU_OP_SLT          4'b1001
`define ALU_OP_SLTU         4'b1010
`define ALU_OP_SRA          4'b1011
`define ALU_OP_SLL_SLA      4'b1100
`define ALU_OP_SRL          4'b1101
`define ALU_OP_CLZ          4'b1110



//----------MUX----------

`define MUX_PC_CWIDTH       4
`define MUX_MEM_CWIDTH      2
`define MUX_RDC_CWIDTH      3
`define MUX_RD_CWIDTH       8
`define MUX_ALUA_CWIDTH     4
`define MUX_ALUB_CWIDTH     6
`define MUX_EXT16_CWIDTH    2
`define MUX_HI_CWIDTH       4
`define MUX_LO_CWIDTH       4

`define MUX_PC_Z            4'b0001
`define MUX_PC_RS           4'b0010
`define MUX_PC_CON          4'b0100
`define MUX_PC_EPCOUT       4'b1000

`define MUX_MEM_Z           2'b01
`define MUX_MEM_PC          2'b10

`define MUX_RDC_RD          3'b001
`define MUX_RDC_RT          3'b010
`define MUX_RDC_31          3'b100

`define MUX_RD_Z            8'b00000001
`define MUX_RD_HI           8'b00000010
`define MUX_RD_LO           8'b00000100
`define MUX_RD_MULZ         8'b00001000
`define MUX_RD_CP0OUT       8'b00010000
`define MUX_RD_MD           8'b00100000
`define MUX_RD_EXT16        8'b01000000
`define MUX_RD_EXT8         8'b10000000

`define MUX_ALUA_PC         4'b0001
`define MUX_ALUA_RS         4'b0010
`define MUX_ALUA_EXT5       4'b0100
`define MUX_ALUA_16         4'b1000

`define MUX_ALUB_RT         6'b000001
`define MUX_ALUB_EXT16      6'b000010
`define MUX_ALUB_EXT18      6'b000100
`define MUX_ALUB_0          6'b001000
`define MUX_ALUB_4          6'b010000
`define MUX_ALUB_8          6'b100000

`define MUX_EXT16_MD        2'b01
`define MUX_EXT16_IMMOFF    2'b10

`define MUX_HI_SZ           4'b0001
`define MUX_HI_MULZ         4'b0010
`define MUX_HI_RS           4'b0100
`define MUX_HI_DIVR         4'b1000

`define MUX_LO_SZ           4'b0001
`define MUX_LO_MULZ         4'b0010
`define MUX_LO_RS           4'b0100
`define MUX_LO_DIVQ         4'b1000



//----------CP0----------

`define CP0_CAUSE_SYSCALL   32'b1000
`define CP0_CAUSE_BREAK     32'b1001
`define CP0_CAUSE_TEQ       32'b1101

`define CP0_STATUS_ADDR     12
`define CP0_CAUSE_ADDR      13
`define CP0_EPC_ADDR        14

`define CP0_SYSCALL_POS     1
`define CP0_BREAK_POS       2
`define CP0_TEQ_POS         3

`define CP0_STATUS_INIT     32'b1111

`endif