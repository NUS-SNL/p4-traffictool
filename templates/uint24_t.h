
#ifndef UNIT24_T_H
#define UNIT24_T_H

// uint24_t: type as a byte array (or unsigned char array)
typedef unsigned char uint24_t[3];

// UINT24_MAX_VALUE: the maximum value of 'uint24_t'. (2^24)-1 = 16777215
#define UINT24_MAX_VALUE ((1 << 24)-1) 

// UINT24_SET: assign value to 'uint24_t'
#define UINT24_SET(uint24, value)               \
  uint24[0] = (unsigned char)(value);           \
  uint24[1] = (unsigned char)((value) >> 8);    \
  uint24[2] = (unsigned char)((value) >> 16);

// copies value of one uint24 to other
#define UINT24_COPY(uint24, value)               \
  uint24[0] = value[0];           \
  uint24[1] = value[1];           \
  uint24[2] = value[2];

// UINT24_GET: obtain value of 'uint24_t'
#define UINT24_GET(uint24)   \
  (uint24[0]) +              \
  (uint24[1] << 8) +         \
  (uint24[2] << 16);

// UINT24_PRINT: print 'uint24_t' as 3 bytes
#define UINT24_PRINT(uint24) \
  printf("%hhu %hhu %hhu \n", uint24[2], uint24[1], uint24[0]);


#if (BYTE_ORDER==LITTLE_ENDIAN)
    #define UINT24_HTON(a,b)  \
        a[0]=b[2];            \
        a[1]=b[1];            \
        a[2]=b[0];
#else
    #define UINT24_HTON(a,b) UINT24_COPY(a,b)
#endif


#endif 