`timescale 1ns / 1ps

module dht11_tb(
  output reg CLK,
  output reg RST,
  output wire DHT_data,
  output wire [7:0] tmp_int,
  output wire [7:0] tmp_float,
  output wire [7:0] hum_int,
  output wire [7:0] hum_float,
  output wire [7:0] parity
 );

  reg DHT_data_in;
  wire DHT_data_out;
  reg DHT_dir;

  assign DHT_data = DHT_dir ? DHT_data_out : DHT_data_in;

  // DHT11モジュールのインスタンス
  dht11 uut (
    .CLK(CLK),
    .RST(RST),
    .DHT_data(DHT_data),
    .tmp_int(tmp_int),
    .tmp_float(tmp_float),
    .hum_int(hum_int),
    .hum_float(hum_float),
    .parity(parity)
  );

  // クロック生成 100MHz
  always #5 CLK = ~CLK;

  initial begin
    // 初期化
    CLK = 0;
    RST = 1;
    DHT_data_in = 1'bz;
    DHT_dir = 1;
    #100;

    // リセット解除
    RST = 0;

    // データ送信シミュレーション
    #50010000;
    DHT_dir = 0; // データ入力に切り替え
    send_data_sequence();

    // 終了
    #1000000;
    $finish;
  end

  // データ送信シーケンス
  task send_data_sequence;
    begin
      // DHT11からの応答シーケンスをシミュレート
      DHT_data_in = 0; #80000; // 80us LOW
      DHT_data_in = 1; #80000; // 80us HIGH
		DHT_data_in = 0;

      $monitor("Start sending data");

      // データ送信（40ビット）
      send_bit(8'h1A); // 湿度整数部分
      $monitor("Humidity int area sending completed!");
      send_bit(8'h0B); // 湿度小数部分
      $monitor("Humidity float area sending completed!");
      send_bit(8'h18); // 温度整数部分
      $monitor("Temperature int area sending completed!");
      send_bit(8'h00); // 温度小数部分
      $monitor("Temperature float area sending completed!");
      send_bit(8'h33); // パリティビット

      DHT_data_in = 1'bz;
    end
  endtask

  // 8ビットデータ送信
  task send_bit;
    input [7:0] data;
    integer i;
    begin
      for (i = 0; i < 8; i = i + 1) begin
        DHT_data_in = 0; #50; // 50us LOW
        if (data[i] == 1'b1)
		  begin
          $monitor("Sending 1");
          DHT_data_in = 1; #70; // 70us HIGH
        end else begin
          $monitor("Sending 0");
          DHT_data_in = 1; #26; // 26us HIGH
		  end
      end
    end
  endtask

  // モニタリング
  initial begin
    $monitor("Time = %d, temp = %d.%d, hum = %d.%d, parity = %h",
             $time, tmp_int, tmp_float, hum_int, hum_float, parity);
  end

endmodule
