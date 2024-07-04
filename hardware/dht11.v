module dht11(
  input CLK,  // 100MHz(周期100nsのクロック信号)
  input RST,  // リセット信号
  inout DHT_data,  // DHT11とのデータ信号線
  output [7:0] tmp_int,  // 温度データ整数部分
  output [7:0] tmp_float,  // 温度データ小数部分
  output [7:0] hum_int,  // 湿度データ整数部分
  output [7:0] hum_float,  // 湿度データ小数部分
  output [7:0] parity  // パリティビットデータ
);
  reg DHT_out;
  reg DIR;  // データ方向を制御(0:入力, 1:出力)
  reg wait_reg;  // データの待ち状態を制御
  reg [25:0] counter;   // カウンタ
  reg [5:0] index;      // データビットのインデックス
  reg [39:0] DHT_data_reg;  // DHT11からのデータ(40bit格納用)
  reg error;  // エラーフラグ
  wire DHT_in;

  // 湿度の整数部分データを割り当て
  assign hum_int[7] = DHT_data_reg[0];
  assign hum_int[6] = DHT_data_reg[1];
  assign hum_int[5] = DHT_data_reg[2];
  assign hum_int[4] = DHT_data_reg[3];
  assign hum_int[3] = DHT_data_reg[4];
  assign hum_int[2] = DHT_data_reg[5];
  assign hum_int[1] = DHT_data_reg[6];
  assign hum_int[0] = DHT_data_reg[7];

  // 湿度の小数部分データを割り当て
  assign hum_float[7] = DHT_data_reg[8];
  assign hum_float[6] = DHT_data_reg[9];
  assign hum_float[5] = DHT_data_reg[10];
  assign hum_float[4] = DHT_data_reg[11];
  assign hum_float[3] = DHT_data_reg[12];
  assign hum_float[2] = DHT_data_reg[13];
  assign hum_float[1] = DHT_data_reg[14];
  assign hum_float[0] = DHT_data_reg[15];

  // 温度の整数部分データを割り当て
  assign tmp_int[7] = DHT_data_reg[16];
  assign tmp_int[6] = DHT_data_reg[17];
  assign tmp_int[5] = DHT_data_reg[18];
  assign tmp_int[4] = DHT_data_reg[19];
  assign tmp_int[3] = DHT_data_reg[20];
  assign tmp_int[2] = DHT_data_reg[21];
  assign tmp_int[1] = DHT_data_reg[22];
  assign tmp_int[0] = DHT_data_reg[23];

  // 温度の小数部分データを割り当て
  assign tmp_float[7] = DHT_data_reg[24];
  assign tmp_float[6] = DHT_data_reg[25];
  assign tmp_float[5] = DHT_data_reg[26];
  assign tmp_float[4] = DHT_data_reg[27];
  assign tmp_float[3] = DHT_data_reg[28];
  assign tmp_float[2] = DHT_data_reg[29];
  assign tmp_float[1] = DHT_data_reg[30];
  assign tmp_float[0] = DHT_data_reg[31];

  // パリティビットデータを割り当て
  assign parity[7] = DHT_data_reg[32];
  assign parity[6] = DHT_data_reg[33];
  assign parity[5] = DHT_data_reg[34];
  assign parity[4] = DHT_data_reg[35];
  assign parity[3] = DHT_data_reg[36];
  assign parity[2] = DHT_data_reg[37];
  assign parity[1] = DHT_data_reg[38];
  assign parity[0] = DHT_data_reg[39];

  reg [3:0] state;  // ステートマシンの状態保持用

  parameter S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, S9=9, STOP=0, START=11;

  // 以下ステートマシン
  always @(posedge CLK)
  begin
    if (RST == 1b'1)
    begin
      DHT_out <= 1'b1;
      counter <= 26'b00000000000000000000000000;  // カウンタを初期化
      DHT_data_reg <= 40'b0000000000000000000000000000000000000000;   // データを初期化
      DIR <= 1'b1;  // 出力方向とする
      error <= 1'b0;  // エラーフラグを初期化
      state <= START;  // ステートを初期化(START状態にする)
    end else begin
      case (state)
        START: 
          begin
            wait_reg <= 1'b1;
            DIR <= 1'b1;
            DHT_out <= 1'b1;
            state <= S0;
          end
        S0:
          begin
            DIR <= 1'b1;  // DHTピンは出力状態に指定（S2まで固定）
            DHT_out <= 1'b1;  // DHTピンをHIGHにする
            wait_reg <= 1'b1;
            error <= 1'b0;
            if (counter < 1800000)
            begin
              counter <= counter + 1;   // 少なくとも20ms待つ
            end else begin
              counter <= 26'b00000000000000000000000000;  // カウンタリセットし、状態をS1に遷移
              state <= S1;
            end
          end
        S1:
          begin
            DHT_out <= 1'b0;  // DHTピンをLOWにする(データ要求信号)
            wait_reg <= 1'b1;
            if (counter < 2000000)
            begin
              counter <= counter + 1;   // 少なくとも20ms出力してもらう
            end else begin
              counter <= 26'b00000000000000000000000000;  // カウンタリセットし、状態をS2に遷移
              state <= S2;
            end
          end
        S2:
          begin
            DHT_out <= 1'b1;  // DHTピンをHIGHにする
            if (counter < 2000)
            begin
              counter <= counter + 1;   // 少なくとも20us待つ
            end else begin
              DIR <= 1'b0;  // DHTピンを入力状態にする!!
              state <= S3;
            end
          end
        S3:
          begin
            // 「DHT11からお返事が届いていますか」という確認用状態
            if (counter < 6000 && DHT_in == 1'b1)
            begin
              counter <= counter + 1;
              state <= S3;
            end else begin
              if (DHT_in == 1'b1)
              begin
                // 6000us経過したにもかかわらず、まだ1のままであるとき、異常検知
                error <= 1'b1;
                counter <= 26'b00000000000000000000000000;
                state <= STOP;
              end else begin
                // 「0」を受信している時、状態をS4に遷移
                counter <= 26'b00000000000000000000000000;
                state <= S4;
              end
            end
          end
        default: 
      endcase
    end
  end






endmodule