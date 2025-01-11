module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

parameter IDLE = 0, DISPLAY_A = 1, INPUT_A = 2, ERROR_A = 3, DISPLAY_B = 4, INPUT_B = 5, ERROR_B = 6, SHOW_SCORE = 7;
parameter SHOOT_A = 8, SINK_A = 9, WIN_A = 10, SHOOT_B = 11, SINK_B = 12, WIN_B = 13, OVRWIN_A = 14, OVRWIN_B = 15;

// Registers
reg [3:0] cState; 
reg [2:0] input_counter;  
reg [15:0] matrixA, matrixB;
reg [3:0] scoreA, scoreB, overallA, overallB;
reg [1:0] XQ, YQ;
reg buttonA, buttonB, Z, lastWinner;
reg [5:0] clk_counter;

// Sequential logic block - handles state transitions and register updates
always @(posedge clk) begin
  if (rst) begin
    input_counter <= 0;
    matrixA <= 0;
    matrixB <= 0;
    scoreA <= 0;
    scoreB <= 0;
    overallA <= 0;
    overallB <= 0;
    clk_counter <= 0;
    Z <= 0;
    cState <= IDLE;
    lastWinner <= 0;
  end 
  else begin
    XQ <= X;
    YQ <= Y;
    buttonA <= pAb;
    buttonB <= pBb;

    case (cState)
      IDLE: begin
        if (start) begin
          clk_counter <= 0;
          if(lastWinner)
            cState <= DISPLAY_B;
          else
            cState <= DISPLAY_A;
        end
        else begin
          cState <= IDLE;
        end
      end

      DISPLAY_A: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          cState <= INPUT_A;
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= DISPLAY_A;
        end
      end

      INPUT_A: begin
        if (buttonA) begin
          if (matrixA[{YQ,XQ}] == 1) begin
            clk_counter <= 0;
            cState <= ERROR_A;
          end
          else begin
            matrixA[{YQ,XQ}] <= 1;
            if (input_counter == 3) begin 
              clk_counter <= 0;
              input_counter <= 0;
              if(lastWinner)
                cState <= SHOW_SCORE;
              else
                cState <= DISPLAY_B;
            end
            else begin
              input_counter <= input_counter + 1;
              clk_counter <= clk_counter + 1;
              cState <= INPUT_A;
            end
          end
        end
        else begin
          matrixA <= matrixA;
          cState <= INPUT_A;
        end
      end

      ERROR_A: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          cState <= INPUT_A;
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= ERROR_A;
        end
      end

      DISPLAY_B: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          cState <= INPUT_B;
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= DISPLAY_B;
        end
      end
      
      INPUT_B: begin
        if (buttonB) begin
          if (matrixB[{YQ,XQ}] == 1) begin
            clk_counter <= 0;
            cState <= ERROR_B;
          end
          else begin
            matrixB[{YQ,XQ}] <= 1;
            if (input_counter == 3) begin 
              input_counter <= 0;
              clk_counter <= 0;
              if(lastWinner)
                cState <= DISPLAY_A;
              else
                cState <= SHOW_SCORE;
            end
            else begin
              input_counter <= input_counter + 1;
              clk_counter <= clk_counter + 1;
              cState <= INPUT_B;
            end
          end
        end
        else begin
          matrixB <= matrixB;
          cState <= INPUT_B;
        end
      end

      ERROR_B: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          cState <= INPUT_B;
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= ERROR_B;
        end
      end

      SHOW_SCORE: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          if(lastWinner)
            cState <= SHOOT_B;
          else
            cState <= SHOOT_A;
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= SHOW_SCORE;
        end 
      end

      SHOOT_A: begin
        if (buttonA) begin
          if (matrixB[{YQ,XQ}] == 1) begin
            scoreA <= scoreA + 1;
            Z <= matrixB[{YQ,XQ}];
            matrixB[{YQ,XQ}] <= 0;
          end
          else begin
            scoreA <= scoreA;
            Z <= matrixB[{YQ,XQ}];
          end
          clk_counter <= 0;
          cState <= SINK_A;
        end
        else begin
          matrixA <= matrixA;
          clk_counter <= clk_counter + 1;
          cState <= SHOOT_A;
        end
      end

      SINK_A: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          if (scoreA == 4) begin
            clk_counter <= 0;
            overallA <= overallA + 1;
            cState <= WIN_A;
          end
          else begin
            cState <= SHOOT_B;
          end
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= SINK_A;
        end
      end

      SHOOT_B: begin
        if (buttonB) begin
          if (matrixA[{YQ,XQ}] == 1) begin
            scoreB <= scoreB + 1;
            Z <= matrixA[{YQ,XQ}];
            matrixA[{YQ,XQ}] <= 0;
          end
          else begin
            scoreB <= scoreB;
            Z <= matrixA[{YQ,XQ}];
          end
          clk_counter <= 0;
          cState <= SINK_B;
        end
        else begin
          matrixB <= matrixB;
          clk_counter <= clk_counter + 1;
          cState <= SHOOT_B;
        end
      end

      SINK_B: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          if (scoreB == 4) begin
            clk_counter <= 0;
            overallB <= overallB + 1; 
            cState <= WIN_B;
          end
          else
            cState <= SHOOT_A;
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= SINK_B;
        end
      end

      WIN_A: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          if(overallA == 2) begin
            cState <= OVRWIN_A;
          end
          else begin
            matrixA <= 0;
            matrixB <= 0;
            scoreA <= 0;
            scoreB <= 0;
            input_counter <= 0;
            Z <= 0;
            lastWinner <= 0;
            cState <= DISPLAY_A;
          end
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= WIN_A;
        end
      end

      WIN_B: begin
        if (clk_counter == 49) begin
          clk_counter <= 0;
          if(overallB == 2) begin
            cState <= OVRWIN_B;
          end
          else begin
            matrixA <= 0;
            matrixB <= 0;
            scoreA <= 0;
            scoreB <= 0;
            input_counter <= 0;
            Z <= 0;
            lastWinner <= 1;
            cState <= DISPLAY_B;
          end
        end
        else begin
          clk_counter <= clk_counter + 1;
          cState <= WIN_B;
        end
      end

      OVRWIN_A: begin
        cState <= OVRWIN_A;
      end

      OVRWIN_B: begin
        cState <= OVRWIN_B;
      end

      default: begin
        cState <= IDLE;
      end
    endcase
  end
end

// Combinational logic block - handles output assignments
always @(*) begin
  disp3 = 8'b00000000;
  disp2 = 8'b00000000;
  disp1 = 8'b00000000;
  disp0 = 8'b00000000;
  led = 8'b00000000;

  case (cState)
    IDLE: begin
      disp3 = 8'b00000110; // I
      disp2 = 8'b01011110; // D
      disp1 = 8'b00111000; // L
      disp0 = 8'b01111001; // E
      led = 8'b10011001;
    end

    DISPLAY_A: begin
      disp3 = 8'b01110111;
      disp2 = 8'b00000000;
      disp1 = 8'b00000000;
      disp0 = 8'b00000000;
    end

    INPUT_A: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;
      
      if (XQ == 2'b00)
        disp1 = 8'b00111111;
      else if (XQ == 2'b01)
        disp1 = 8'b00000110;
      else if (XQ == 2'b10)
        disp1 = 8'b01011011;
      else if (XQ == 2'b11)
        disp1 = 8'b01001111;
      else 
        disp1 = 8'b00000000;

      if (YQ == 2'b00)
        disp0 = 8'b00111111;
      else if (YQ == 2'b01)
        disp0 = 8'b00000110;
      else if (YQ == 2'b10)
        disp0 = 8'b01011011;
      else if (YQ == 2'b11)
        disp0 = 8'b01001111;
      else 
        disp0 = 8'b00000000;

      led = 8'b10000000;
      led[5:4] = input_counter;
    end

    ERROR_A: begin
      disp3 = 8'b01111001; // E
      disp2 = 8'b01010000; // r
      disp1 = 8'b01010000; // r
      disp0 = 8'b01011100; // o
      led = 8'b10011001;
    end

    DISPLAY_B: begin
      disp3 = 8'b01111100;
      disp2 = 8'b00000000;
      disp1 = 8'b00000000;
      disp0 = 8'b00000000;
      led = 8'b10011001;
    end

    INPUT_B: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (XQ == 2'b00)
        disp1 = 8'b00111111;
      else if (XQ == 2'b01)
        disp1 = 8'b00000110;
      else if (XQ == 2'b10)
        disp1 = 8'b01011011;
      else if (XQ == 2'b11)
        disp1 = 8'b01001111;
      else 
        disp1 = 8'b00000000;

      if (YQ == 2'b00)
        disp0 = 8'b00111111;
      else if (YQ == 2'b01)
        disp0 = 8'b00000110;
      else if (YQ == 2'b10)
        disp0 = 8'b01011011;
      else if (YQ == 2'b11)
        disp0 = 8'b01001111;
      else 
        disp0 = 8'b00000000;

      led = 8'b00000001;
      led[3:2] = input_counter;
    end

    ERROR_B: begin
      disp3 = 8'b01111001; // E
      disp2 = 8'b01010000; // r
      disp1 = 8'b01010000; // r
      disp0 = 8'b01011100; // o
      led = 8'b10011001;
    end

    SHOW_SCORE: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00111111;
      disp1 = 8'b01000000;
      disp0 = 8'b00111111;
      led = 8'b10011001;
    end

    SHOOT_A: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (XQ == 2'b00)
        disp1 = 8'b00111111;
      else if (XQ == 2'b01)
        disp1 = 8'b00000110;
      else if (XQ == 2'b10)
        disp1 = 8'b01011011;
      else if (XQ == 2'b11)
        disp1 = 8'b01001111;
      else 
        disp1 = 8'b00000000;

      if (YQ == 2'b00)
        disp0 = 8'b00111111;
      else if (YQ == 2'b01)
        disp0 = 8'b00000110;
      else if (YQ == 2'b10)
        disp0 = 8'b01011011;
      else if (YQ == 2'b11)
        disp0 = 8'b01001111;
      else 
        disp0 = 8'b00000000;

      led = 8'b00000000;
      led[5:4] = scoreA[1:0];
      led[3:2] = scoreB[1:0];
      led[7] = 1;
    end

    SINK_A: begin
      disp3 = 8'b00000000;

      if (scoreA == 2'b00)
        disp2 = 8'b00111111;
      else if (scoreA == 2'b01)
        disp2 = 8'b00000110;
      else if (scoreA == 2'b10)
        disp2 = 8'b01011011;
      else if (scoreA == 2'b11)
        disp2 = 8'b01001111;
      else if (scoreA == 3'b100)
        disp2 = 8'b01100110;
      else 
        disp2 = 8'b00000000;

      disp1 = 8'b01000000;

      if (scoreB == 2'b00)
        disp0 = 8'b00111111;
      else if (scoreB == 2'b01)
        disp0 = 8'b00000110;
      else if (scoreB == 2'b10)
        disp0 = 8'b01011011;
      else if (scoreB == 2'b11)
        disp0 = 8'b01001111;
      else if (scoreB == 3'b100)
        disp0 = 8'b01100110;
      else 
        disp0 = 8'b00000000;

      if (Z)
        led = 8'b11111111;
      else 
        led = 8'b00000000;
    end

    SHOOT_B: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (XQ == 2'b00)
        disp1 = 8'b00111111;
      else if (XQ == 2'b01)
        disp1 = 8'b00000110;
      else if (XQ == 2'b10)
        disp1 = 8'b01011011;
      else if (XQ == 2'b11)
        disp1 = 8'b01001111;
      else 
        disp1 = 8'b00000000;

      if (YQ == 2'b00)
        disp0 = 8'b00111111;
      else if (YQ == 2'b01)
        disp0 = 8'b00000110;
      else if (YQ == 2'b10)
        disp0 = 8'b01011011;
      else if (YQ == 2'b11)
        disp0 = 8'b01001111;
      else 
        disp0 = 8'b00000000;

      led = 8'b00000000;
      led[5:4] = scoreA[1:0];
      led[3:2] = scoreB[1:0];
      led[0] = 1;
    end

    SINK_B: begin
      disp3 = 8'b00000000;
  
      if (scoreA == 2'b00)
        disp2 = 8'b00111111;
      else if (scoreA == 2'b01)
        disp2 = 8'b00000110;
      else if (scoreA == 2'b10)
        disp2 = 8'b01011011;
      else if (scoreA == 2'b11)
        disp2 = 8'b01001111;
      else if (scoreA == 3'b100)
        disp2 = 8'b01100110;
      else 
        disp2 = 8'b00000000;

      disp1 = 8'b01000000;

      if (scoreB == 2'b00)
        disp0 = 8'b00111111;
      else if (scoreB == 2'b01)
        disp0 = 8'b00000110;
      else if (scoreB == 2'b10)
        disp0 = 8'b01011011;
      else if (scoreB == 2'b11)
        disp0 = 8'b01001111;
      else if (scoreB == 3'b100)
        disp0 = 8'b01100110;
      else 
        disp0 = 8'b00000000;
  
      if (Z)
          led = 8'b11111111;
      else 
          led = 8'b00000000;
    end
  
    WIN_A: begin
      disp3 = 8'b00000000;

      if (overallA == 2'b00)
        disp2 = 8'b00111111;
      else if (overallA == 2'b01)
        disp2 = 8'b00000110;
      else if (overallA == 2'b10)
        disp2 = 8'b01011011;

      disp1 =  8'b01000000;

      if (overallB == 2'b00)
        disp0 = 8'b00111111;
      else if (overallB == 2'b01)
        disp0 = 8'b00000110;
      else if (overallB == 2'b10)
        disp0 = 8'b01011011;
      
      led <= 8'b10101010;
    end
  
    WIN_B: begin
      disp3 = 8'b00000000;

      if (overallA == 2'b00)
        disp2 = 8'b00111111;
      else if (overallA == 2'b01)
        disp2 = 8'b00000110;
      else if (overallA == 2'b10)
        disp2 = 8'b01011011;

      disp1 =  8'b01000000;

      if (overallB == 2'b00)
        disp0 = 8'b00111111;
      else if (overallB == 2'b01)
        disp0 = 8'b00000110;
      else if (overallB == 2'b10)
        disp0 = 8'b01011011;
      
      led <= 8'b10101010;
    end

    OVRWIN_A: begin
      disp3 = 8'b01110111;
      disp2 = 8'b01011011;
      disp1 =  8'b01000000;

      if (overallB == 2'b00)
        disp0 = 8'b00111111;
      else if (overallB == 2'b01)
        disp0 = 8'b00000110;
      else if (overallB == 2'b10)
        disp0 = 8'b01011011;
      
      led <= 8'b10101010;
    end

    OVRWIN_B: begin
      disp3 = 8'b01111100;
      if (overallA == 2'b00)
        disp2 = 8'b00111111;
      else if (overallA == 2'b01)
        disp2 = 8'b00000110;
      else if (overallA == 2'b10)
        disp2 = 8'b01011011;

      disp1 = 8'b01000000;
      disp0 = 8'b01011011; 
      
      led <= 8'b10101010;
    end
  
    default: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;
      disp1 = 8'b00000000;
      disp0 = 8'b00000000;
      led = 8'b00000000;
    end
  endcase
end
  
endmodule
