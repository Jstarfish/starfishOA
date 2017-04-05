#ifndef _SAMPLE_H_
#define _SAMPLE_H_

#include <string>
#include <deque>
#include <vector>
#include <algorithm>
#include <iostream>
using namespace std;

#include "knuth.h"

// hardware RNG interface
#include "fm_def.h"
#include "fm_cpc_pub.h"

class Sample {
public: //--DATA MEMBERS--//
    // Copy the corresponding value from rngInfo in order to control the random
    // number generation mechanism.
    string deviceType;

    // Number of draws from this sample for each draw result.
    size_t draws;

    // 'permutation': draws can be repetitive.
    // 'combination': draws cannot be repetitive.
    string drawType;

    // The smallest number for this sample.
    int rMin;

    // The largest number for this sample.
    int rMax;

    // The lower bound chi-square value, an event of small probability happens
    // when the calculated chi-square value is smaller than this value.
    double X2Min;

    // The upper bound chi-square value, an event of small probability happens
    // when the calculated chi-square value is larger than this value.
    double X2Max;

    // Current X2 value, initialized to zero. We calculate the X2 value when the
    // sample pool is regenerated, and update this value every time we push or
    // pop an element from the sample pool. If we use hardware RNG, this value
    // will not change throughout the program and will always be in range.
    double X2Value;

    // The maximum size of the sample pool.
    int maxPoolSize;

    // The sample pool is stored in a double ended queue.
    deque<int> pool;

    // Frequency histogram, for calculating X2 value when using software RNG.
    vector<int> freqs;

    // Donald Knuth's RAN ARRAY algorithm is encapsulated in this 'Knuth' class.
    Knuth knuth;

    // Handle of the hardware RNG device.
    FM_HANDLE hdl;

    /* Thomas Wang's 32 bit Mix Function --- Copied from Redis-2.6.14 */
    unsigned int hash(unsigned int key);

public: //--MEMBER FUNCTIONS--//

    // Clear and regenerate the double ended queue 'pool' with 'maxPoolSize'
    // amount of new random numbers. Used during sample initialization and also
    // when the chi-square value of the pool is out of range.
    void regenerate(void);

    // Waste 'num' front random number from the 'pool' and push back 'num' new 
    // random number. Used to update the 'pool'.
    void rollPool(int num);

    // Calculate and return the current chi-square value of the 'pool'.
    double calculateX2(void);

    // Adjust the Chi^2 value when an element is removed from the pool,
    // and another element is inserted into the pool. We don't calculate Chi^2 
    // using the whole pool to save CPU.
    void updateX2(int elemRemove, int elemInsert);

    // Test whether the current chi-square value is out of range.
    // If the RNG is hardware-generated, then it always returns false.
    bool testX2OutOfRange(void) const;

    // Get a vector of random numbers from the 'pool' where elements can repeat.
    vector<int> getPermutation(void);

    // Get a vector of random numbers from the 'pool' where elements cannot
    // repeat.
    vector<int> getCombination(void);

    // Calling 'getPermutation' or 'getCombination' depending on 'drawType'.
    vector<int> getDrawResult(void);
};

#endif // _SAMPLE_H_
