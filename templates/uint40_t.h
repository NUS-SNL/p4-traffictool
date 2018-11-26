#ifndef UNIT40_T_H
#define UNIT40_T_H

// uint40_t: type as a byte array (or unsigned char array)
typedef unsigned char uint40_t[5];

// UINT40_MAX_VALUE: the maximum value of 'uint40_t'. (2^40)-1 = 16777215
#define UINT40_MAX_VALUE ((1 << 40)-1) 

// UINT40_SET: assign value to 'uint40_t'
#define UINT40_SET(uint40, value)               \
  uint40[0] = (unsigned char)(value);           \
  uint40[1] = (unsigned char)((value) >> 8);    \
  uint40[2] = (unsigned char)((value) >> 16);   \
  uint40[3] = (unsigned char)((value) >> 24);   \
  uint40[4] = (unsigned char)((value) >> 32);   \

// copies value of one UINT40 to other
#define UINT40_COPY(uint40, value)               \
  uint40[0] = value[0];           \
  uint40[1] = value[1];           \
  uint40[2] = value[2];           \
  uint40[3] = value[3];           \
  uint40[4] = value[4];           

// UINT40_GET: obtain value of 'uint40_t'
#define UINT40_GET(uint40)   \
  (uint40[0]) +              \
  (uint40[1] << 8) +         \
  (uint40[2] << 16)+         \
  (uint40[3] << 24)+         \
  (uint40[4] << 32);         \


// UINT40_PRINT: print 'uint40_t' as 3 bytes
#define UINT40_PRINT(uint40) \
  printf("%hhu %hhu %hhu %hhu %hhu \n", uint48[4], uint48[3],uint40[2], uint40[1], uint40[0]); \


#if (BYTE_ORDER==LITTLE_ENDIAN) 
  #define UINT40_HTON(a,b)  \
    a[0]=b[4];				\
    a[1]=b[3];				\
    a[2]=b[2];				\
    a[3]=b[1];        \
    a[4]=b[0];        \
#else
  #define UINT40_HTON(a,b)  UINT40_COPY(a,b)
#endif

#define UINT40_NTOH(a,b) UINT40_HTON(a,b)

#endif 