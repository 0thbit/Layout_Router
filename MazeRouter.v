//-----------------------------------------------------
// Design Name : Maze Router
// File Name   : MazeRouter.v(second version)
// Function    : Read "map" saved inside RAM and output routing 
// Coder       : Kathan Shah
// Date		   : Sep 25th, 2014
// Compatible with 1st Modification in SRAM.v
//-----------------------------------------------------
`timescale 1ns/10ps
module maze_router (
reset		,
start		,
clk         , // Clock Input
address     , // Address Output
data_in        , // Data 
data_out,
cs          , // Chip Select
we          , // Write Enable/Read Enable
D); 

parameter DATA_WIDTH = 8 ;
parameter ADDR_WIDTH = 8 ;
localparam
INI=127, WAIT=126;//, W=4'b0100, DONE=4'b1000;

//------------Input--------------- 
input					reset		;
input 					start	;
input                  clk         ;


input [DATA_WIDTH-1:0]  data_in       ;

//------------output---------------
output                  cs          ;
output                  we          ;
output [DATA_WIDTH-1:0]  data_out       ;
output [ADDR_WIDTH-1:0] address     ;
output D;

reg cs,we;
reg [DATA_WIDTH-1:0]  data_out       ;
reg [ADDR_WIDTH-1:0] address     ;
reg D,flagr	;

reg [7:0] state;
reg [ADDR_WIDTH-1:0] sourceadd1,targadd1,sourceadd2,targadd2,servingadd,sourceadd,targadd;
reg [DATA_WIDTH-1:0] matrixa[31:0];
reg [DATA_WIDTH-1:0] matrixb[31:0];
integer cnta,cntb,dist,dir;


//integer counter;
//--------------Code Starts Here------------------ 
reg [DATA_WIDTH-1:0]  temp;

always@(posedge clk)
begin

if(reset)
	begin
		state<=INI;
		D<=0;
		we<=0;
		cs<=1;
		address<=0;
	end
else
	begin
		case(state)
			INI: begin
					address<=0;
					D<=0;
					we<=0;
					cs<=0;
					state<=WAIT;
					cnta<=0;
					cntb<=0;
				  end
		   WAIT: begin
						if(start)
							begin
								state<=1;
							end
						D<=0;
						cs<=0;
					end
			1: begin		//read from address 128
					we<=0;
					cs<=1;
					address<=128;
					state<=2;
				 end
			2: begin
					state<=3;
					cs<=0;
				end
			3: begin
					sourceadd1<=data_in;
					we<=1;
					cs<=1;
					data_out<=255;
					state<=4;
				end
				//read target 1
			4: begin
					we<=0;
					cs<=1;
					address<=129;
					state<=5;
				end
			5: begin
					state<=6;
					cs<=0;
				end
			6: begin
					targadd1<=data_in;
					we<=1;
					cs<=1;
					data_out<=255;
					state<=7;
				end
			7: begin		//read from address 130 source 2
					we<=0;
					cs<=1;
					address<=130;
					state<=8;
				 end
			8: begin
					state<=9;
					cs<=0;
				end
			9: begin
					sourceadd2<=data_in;
					we<=1;
					cs<=1;
					data_out<=255;
					state<=10;
				end
				//read target 2
			10: begin
					we<=0;
					cs<=1;
					address<=131;
					state<=11;
				end
			11: begin
					state<=12;
					cs<=0;
				end
			12: begin
					targadd2<=data_in;
					we<=1;
					cs<=1;
					data_out<=255;
					state<=13;
				 end
			13: begin
					address<=sourceadd1;
					we<=1;
					cs<=1;
					data_out<=0;
					state<=14;
				 end
			14: begin
					address<=sourceadd2;
					we<=1;
					cs<=1;
					data_out<=255;
					state<=15;
				 end
			15: begin
					address<=targadd1;
					we<=1;
					cs<=1;
					data_out<=238;
					state<=16;
				 end
			16: begin
					address<=targadd2;
					we<=1;
					cs<=1;
					data_out<=255;
					sourceadd<=sourceadd1;
					targadd<=targadd1;
					flagr<=0;
					state<=17;
				 end
//			124: begin
					//sourceadd<=sourceadd1;
					//targadd<=targadd1;
//					if(targadd1[2:0]==3'b000)
//						begin
//							tnl<=targadd1;
//						end
//					else
//						begin
//							tnl<=targadd1-1;
//						end
//					if(targadd1[2:0]==3'b111)
//						begin
//							tnr<=targadd1;
//						end
//					else
//						begin
//							tnr<=targadd1+1;
//						end
//					state<=17;
//				  end
			17: begin
					servingadd<=sourceadd;
					address<=sourceadd;
					dist<=1;
					cnta<=0;
					state<=18;
					we<=0;
				 end
			18: begin
					if(servingadd[2:0]!=3'b000)
						begin
							address<=servingadd-1;
							we<=0;
							cs<=1;
						end
					state<=19;
				 end
			19: begin
					state<=20;
					we<=0;
				 end
			20: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					else
						begin
							we<=0;
						end
					state<=21;
				 end
			21: begin
					if(servingadd[2:0]!=3'b111)
						begin
							address<=servingadd+1;
							we<=0;
							cs<=1;
						end
					state<=22;
				 end
			22: begin
					state<=23;
				 end
			23: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					state<=24;
				 end
			24: begin
					if(servingadd[5:3]!=3'b000)
						begin
							address<=servingadd-8;
							we<=0;
							cs<=1;
						end
					state<=25;
				 end
			25: begin
					state<=26;
				 end
			26: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					state<=27;
				 end
			27: begin
					if(servingadd[5:3]!=3'b111)
						begin
							address<=servingadd+8;
							we<=0;
							cs<=1;
						end
					state<=28;
				 end
			28: begin
					state<=29;
				 end
			29: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					state<=30;
				 end
			30: begin
					if(servingadd[7:6]!=2'b00)
						begin
							address<=servingadd-64;
							we<=0;
							cs<=1;
						end
					state<=31;
				 end
			31: begin
					state<=32;
				 end
			32: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					state<=33;
				 end
			33: begin
					if(servingadd[7:6]!=2'b11)
						begin
							address<=servingadd+64;
							we<=0;
							cs<=1;
						end
					state<=34;
				 end
			34: begin
					state<=35;
				 end
			35: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					//dist<=dist+1;
					state<=125;
				 end
			125: begin
						dist<=dist+1;
						cntb<=0;
						cnta<=cnta-1;
						state<=36;
				  end
			36: begin
					servingadd<=matrixa[cnta];
					we<=0;
					dir<=1;
					if(matrixa[cnta]==targadd)//make it general
						begin
							state<=45;
							dist<=dist-1;
							D<=0;
						end
					else
						begin
							state<=37;
						end
				 end
			37: begin
					case(dir)
						1: begin if(servingadd[2:0]!=3'b000)
							begin
								address<=servingadd-1;
								we<=0;
								cs<=1;
							end
							end
						2: begin if(servingadd[2:0]!=3'b111)
							begin
								address<=servingadd+1;
								we<=0;
								cs<=1;
							end
							end
						3: begin if(servingadd[5:3]!=3'b000)
							begin
								address<=servingadd-8;
								we<=0;
								cs<=1;
							end
							end
						4: begin if(servingadd[2:0]!=3'b111)
							begin
								address<=servingadd+8;
								we<=0;
								cs<=1;
							end
							end
						5: begin if(servingadd[7:6]!=2'b00)
							begin
								address<=servingadd-64;
								we<=0;
								cs<=1;
							end
							end
						6: begin if(servingadd[7:6]!=2'b11)
							begin
								address<=servingadd+64;
								we<=0;
								cs<=1;
							end
							cnta<=cnta-1;
							end
					endcase
					state<=38;
				 end
			38: begin
					state<=39;
					dir<=dir+1;
				 end
			39: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixb[cntb]<=address;
							cntb<=cntb+1;
						end
					if(cnta==-1)
						begin
							//address<=matrixb[0];
							state<=40;
							D<=0;
							cnta<=0;
							
						end
					else if(dir==7)
						begin
							state<=36;
						end
					else
						begin
							state<=37;
						end
				 end
			40: begin
					state<=41;
					dist<=dist+1;
					cntb<=cntb-1;
					cnta<=0;
				 end
			41: begin
					servingadd<=matrixb[cntb];
					we<=0;
					dir<=1;
					address<=matrixb[cntb];
					if(matrixb[cntb]==targadd)//make it general
						begin
							state<=45;
							dist<=dist-1;
							D<=0;
							if(flagr)
								begin
									state<=INI;
									D<=1;
								end
						end
					else
						begin
							state<=42;
						end
					
				 end
			42: begin
					we<=0;
					cs<=1;
					case(dir)
						1: begin if(servingadd[2:0]!=3'b000)
							begin
								address<=servingadd-1;
								we<=0;
								cs<=1;
							end
							end
						2: begin if(servingadd[2:0]!=3'b111)
							begin
								address<=servingadd+1;
								we<=0;
								cs<=1;
							end
							end
						3: begin if(servingadd[5:3]!=3'b000)
							begin
								address<=servingadd-8;
								we<=0;
								cs<=1;
							end
							end
						4: begin if(servingadd[2:0]!=3'b111)
							begin
								address<=servingadd+8;
								we<=0;
								cs<=1;
							end
							end
						5: begin if(servingadd[7:6]!=2'b00)
							begin
								address<=servingadd-64;
								we<=0;
								cs<=1;
							end
							end
						6: begin if(servingadd[7:6]!=2'b11)
							begin
								address<=servingadd+64;
								we<=0;
								cs<=1;
							end
							cntb<=cntb-1;
							end
					endcase
					state<=43;
				 end
			43: begin
					state<=44;
					dir<=dir+1;
				 end
			44: begin
					if(data_in==238)
						begin
							data_out<=dist;
							we<=1;
							cs<=1;
							matrixa[cnta]<=address;
							cnta<=cnta+1;
						end
					if(cntb==-1)
						begin
							state<=125;
							cntb<=0;
							D<=0;
							//cnta<=cnta-1;
						end
					else if(dir==7)
						begin
							//cntb<=cntb-1;
							state<=41;
						end
					else
						begin
							state<=42;
						end
				 end
				 //filling done; tracing back
			45: begin
					servingadd<=targadd;//make it general
					dir<=1;
					address<=dist;
					state<=46;
				 end
			46: begin
					we<=0;
					cs<=1;
					case(dir)
						1: begin if(servingadd[2:0]!=3'b000)
							begin
								address<=servingadd-1;
							end
							end
						2: begin if(servingadd[2:0]!=3'b111)
							begin
								address<=servingadd+1;
							end
							end
						3: begin if(servingadd[5:3]!=3'b000)
							begin
								address<=servingadd-8;
							end
							end
						4: begin if(servingadd[2:0]!=3'b111)
							begin
								address<=servingadd+8;
							end
							end
						5: begin if(servingadd[7:6]!=2'b00)
							begin
								address<=servingadd-64;
							end
							end
						6: begin if(servingadd[7:6]!=2'b11)
							begin
								address<=servingadd+64;
							end
							end
					endcase
					state<=47;
				end
			47: begin
					
					//dir<=dir+1;
					if(dist==1)
						begin
							state<=49;
							D<=0;
						end
					else
						begin
							state<=48;
						end
				 end
			48: begin
					if(data_in==dist-1)
						begin
							servingadd<=address;
							we<=1;
							cs<=1;
							data_out<=0;
							if(flagr==1)
								begin
									data_out<=17;
								end
							dist<=dist-1;
							dir<=1;
						end
					else
						begin
							we<=0;
							dir<=dir+1;
						end
					state<=46;
					end
				49: begin
						address<=targadd;
						we<=1;
						cs<=1;
						data_out<=0;
						state<=50;
					end
				50:begin
						address<=0;
						we<=0;
						cs<=1;
						state<=51;
					end
				51:begin
						state<=52;
						we<=0;
					end
				52:begin
						if(data_in!=0 && data_in!=255 && data_in!=17)
						begin
							data_out<=238;
							we<=1;
							cs<=1;
						end
						state<=53;
					end
				53:begin
						address<=address+1;
						we<=0;
						cs<=1;
						if(address==255)
							begin
								state<=54;
								address<=flagr;
								D<=0;
							end
						else
							begin
								state<=51;
								D<=0;
							end
					end
					//clearance over
				54: begin
						if(flagr)
							begin
								state<=56;
								D<=0;
							end
						else
							begin
								address<=sourceadd2;
								sourceadd<=sourceadd2;
								targadd<=targadd2;
								flagr<=1;
								data_out<=17;//writing 0x11 to source2
								we<=1;
								cs<=1;
								state<=55;
							end
					 end
				55: begin
						address<=targadd2;
						we<=1;
						cs<=1;
						data_out<=238;
						state<=17;
					end
				56: begin
						address<=targadd2;
						we<=1;
						cs<=1;
						data_out<=17;
						state<=57;
						D<=0;
					end
				57:
					begin
						cs<=0;
						D<=1;
					end
						
				
						
							
			endcase
		end	   
		

end	

endmodule // End of Module