clear all; close all;
%eps - smallest increment (precision)

fprintf('single: realmin=%d, realmax=%d, eps=%d \n', realmin('single'), realmax('single'), eps('single'))
fprintf('double: realmin=%d, realmax=%d, eps=%d \n', realmin('double'), realmax('double'), eps('double'))
disp(' ')
fprintf('int8: intmin=%d, intmax=%d \n', intmin('int8'), intmax('int8'))
fprintf('int16: intmin=%d, intmax=%d \n', intmin('int16'), intmax('int16'))
fprintf('int32: intmin=%d, intmax=%d \n', intmin('int32'), intmax('int32'))
fprintf('int64: intmin=%d, intmax=%d \n', intmin('int64'), intmax('int64'))
disp(' ')
fprintf('uint8: uintmin=%d, uintmax=%d \n', intmin('uint8'), intmax('uint8'))
fprintf('uint16: uintmin=%d, uintmax=%d \n', intmin('uint16'), intmax('uint16'))
fprintf('uint32: uintmin=%d, uintmax=%d \n', intmin('uint32'), intmax('uint32'))
fprintf('uint64: uintmin=%d, uintmax=%d \n', intmin('uint64'), intmax('uint64'))

single_min = single(2^(-126))
double_min = double(2^(-1022))

num2bitstr(single_min);
num2bitstr(double_min);

single_max = single((2 - 2^(-23)) * 2^127)
double_max = double((2 - 2^(-52)) * 2^1023)

num2bitstr(single_max);
num2bitstr(double_max);

uint8(0xFF)
uint16(0xFFFF)
uint32(0xFFFFFFFF)
uint64(0xFFFFFFFFFFFFFFFF)


%bitcmp - flips the bits
bitcmp(int8(0xFF)) %largest value for 8-bit int = 127 --> -128 etc.
bitcmp(int16(0xFFFF))
bitcmp(int32(0xFFFFFFFF))
bitcmp(int64(0xFFFFFFFFFFFFFFFF))
