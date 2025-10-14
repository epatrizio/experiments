#include <stdio.h>
#include <stdlib.h>

int mul2(int a)
{
    return a * 2;
}

int add(int a, int b)
{
    return a + b;
}

// signature: int func(int) (-operation elements function-) -> int[] -> int -> int[] (- array result -)
int* array_map(int (*op)(int), int* array, int array_size)
{
    int* arr_res = (int *)malloc(array_size);

    for (int i = 0 ; i < array_size ; i++)
        arr_res[i] = op(array[i]);

    return arr_res;
}

// signature:
//  int func(int,int) (-operation elements accumulator calculation function-) -> int (- acc init -) -> int[] -> int
//  -> int (- acc result -)
int array_fold(int (*op)(int, int), int acc, int* array, int array_size)
{
    int res = acc;

    for (int i = 0 ; i < array_size ; i++)
        res = op(res, array[i]);

    return res;
}

// signature: void func(int) (-element operation function-) -> int[] -> int
void array_iter(void (*op)(int), int* array, int array_size)
{
    for (int i = 0 ; i < array_size ; i++)
        op(array[i]);
}

void print_int(int i)
{
    printf("%i, ", i);
}

int main()
{
    int arr[] = {1, 2, 3, 4, 5};
    int size = sizeof(arr) / sizeof(int);

    int* arr_res = array_map(mul2, arr, size);
    array_iter(print_int, arr_res, size);               // 2, 4, 6, 8, 10
    printf("\n");

    int acc = array_fold(add, 0, arr, size);
    printf("array_fold result (init):%i\n", acc);       // 15
    acc = array_fold(add, 0, arr_res, size);
    printf("array_fold result (after map):%i\n", acc);  // 30

    array_iter(print_int, arr, size);                   // initial array unchanged: 1, 2, 3, 4, 5

    free(arr_res);

    return EXIT_SUCCESS;
}
