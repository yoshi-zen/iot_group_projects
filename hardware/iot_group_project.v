module iot_group_project(
	input wire clk,       // System clock
    input wire reset,     // Reset signal
    inout wire DHT11_pin, // DHT11 data pin
    output wire [7:0] temp_int,  // Temperature
    output wire [7:0] temp_float,  // Temperature
    output wire [7:0] hum_int,   // Humidity
    output wire [7:0] hum_float,  // Humidity
    output wire [7:0] parity  // Parity
);
    wire clock;
    wire [39:0] data;

    pll_100MHz pll_100MHz(clk, reset, clock);

    dht11 dht11(clock, reset, DHT11_pin, data[39:32], data[31:24], data[23:16], data[15:8], data[7:0]);

    assign temp_int = data[39:32];
endmodule