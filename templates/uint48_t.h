#ifndef UNIT48_T_H
#define UNIT48_T_H

// uint48_t: type as a byte array (or unsigned char array)
typedef unsigned char uint48_t[6];

// UINT48_MAX_VALUE: the maximum value of 'uint48_t'. (2^48)-1 = 16777215
#define UINT48_MAX_VALUE ((1 << 48)-1) 

// UINT48_SET: assign value to 'uint48_t'
#define UINT48_SET(uint48, value)               \
  uint48[0] = (unsigned char)(value);           \
  uint48[1] = (unsigned char)((value) >> 8);    \
  uint48[2] = (unsigned char)((value) >> 16);   \
  uint48[3] = (unsigned char)((value) >> 24);   \
  uint48[4] = (unsigned char)((value) >> 32);   \
  uint48[5] = (unsigned char)((value) >> 40);   \

// copies value of one UINT48 to other
#define UINT48_COPY(uint48, value)               \
  uint48[0] = value[0];           \
  uint48[1] = value[1];           \
  uint48[2] = value[2];           \
  uint48[3] = value[3];           \
  uint48[4] = value[4];           \
  uint48[5] = value[5];           


// UINT48_GET: obtain value of 'uint48_t'
#define UINT48_GET(uint48)   \
  (uint48[0]) +              \
  (uint48[1] << 8) +         \
  (uint48[2] << 16)+         \
  (uint48[3] << 24)+         \
  (uint48[4] << 32)+         \
  (uint48[5] << 40);         \



// UINT48_PRINT: print 'uint48_t' as 3 bytes
#define UINT48_PRINT(uint48) \
  printf("%hhu %hhu %hhu %hhu %hhu %hhu \n", uint48[5] , uint48[4], uint48[3],uint48[2], uint48[1], uint48[0]); \


#if (BYTE_ORDER==LITTLE_ENDIAN) 
  #define UINT48_HTON(a,b)  \
    a[0]=b[5];        \
    a[1]=b[4];        \
    a[2]=b[3];        \
    a[3]=b[2];        \
    a[4]=b[1];        \
    a[5]=b[0];        \
#else
  #define UINT48_HTON(a,b)   UINT48_COPY(a,b)
#endif

#define UINT48_NTOH(a,b) UINT48_HTON(a,b)

#endif 