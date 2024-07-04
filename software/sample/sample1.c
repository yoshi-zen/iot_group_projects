#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    // 乱数のシードを初期化する
    srand(time(0));

    // 0から100までの乱数を生成する
    int random_number = rand() % 101;

    // 生成した乱数を出力する
    printf("%d\n", random_number);

    return 0;
}
