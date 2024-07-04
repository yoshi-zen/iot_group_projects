#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    // 乱数のシードを初期化する
    srand(time(0));

    // 0から100までの乱数を生成する
    int temperature = rand() % 101;
    int humidity = rand() % 101;

    double ans;
    ans = 0.81*temperature+0.01*humidity*(0.99*temperature-14.3)+46.3;

    // 生成した乱数を出力する
    printf("%d\n", ans);

    return 0;
}
