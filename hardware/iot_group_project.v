module iot_group_project(
	input wire clk,       // System clock
    input wire reset,     // Reset signal
    inout wire DHT11_pin, // DHT11 data pin
    output wire [0:7] temp_int,  // Temperature
    output wire [0:7] temp_float,  // Temperature
    output wire [0:7] hum_int,   // Humidity
    output wire [0:7] hum_float,  // Humidity
    output wire [0:7] parity  // Parity
);
    wire clock;
    // wire [0:7] HUM_int, HUM_float, TEMP_int, TEMP_float, PARITY;

    pll_100MHz pll_100MHz(clk, reset, clock);

    dht11 dht11(clock, reset, DHT11_pin, temp_int, temp_float, hum_int, hum_float, error);
endmodule