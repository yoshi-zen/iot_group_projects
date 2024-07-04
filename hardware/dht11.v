module dht11(
  input CLK,  // 100MHz(周期100nsのクロック信号)
  input RST,  // リセット信号
  inout DHT_data,  // DHT11とのデータ信号線
  output [7:0] tmp  // DHT11からのデータ出力
)