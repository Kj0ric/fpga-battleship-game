module top (
  input        clk    ,
  input  [3:0] sw     ,
  input  [3:0] btn    ,
  output [7:0] led    ,
  output [7:0] seven  ,
  output [3:0] segment
);

wire clk50hz;
wire clean_btn0, clean_btn1, clean_btn2, clean_btn3;
wire [7:0] disp0;
wire [7:0] disp1;
wire [7:0] disp2;
wire [7:0] disp3;

clk_divider clk_div_inst (
  .clk_in(clk),      
  .divided_clk(clk50hz)  
);

debouncer debouncer_btn0(
  .clk(clk50hz),
  .rst(~btn[2]), 
  .noisy_in(~btn[0]),
  .clean_out(clean_btn0)
);

debouncer debouncer_btn1(
  .clk(clk50hz),
  .rst(~btn[2]),
  .noisy_in(~btn[1]),
  .clean_out(clean_btn1)
);

debouncer debouncer_btn2(
  .clk(clk50hz),
  .rst(~btn[2]),      
  .noisy_in(~btn[2]),
  .clean_out(clean_btn2)
);

debouncer debouncer_btn3(
  .clk(clk50hz),
  .rst(~btn[2]),
  .noisy_in(~btn[3]),
  .clean_out(clean_btn3)
);

battleship battleship_inst(
  .clk(clk50hz),
  .rst(~btn[2]),
  .start(clean_btn1),
  .X(sw[3:2]),
  .Y(sw[1:0]),
  .pAb(clean_btn3),
  .pBb(clean_btn0),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .led(led)
);

ssd ssd_inst(
  .clk(clk),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .seven(seven),
  .segment(segment)  
);

endmodule
