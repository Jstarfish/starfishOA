#include "sample.h"

#include <sys/time.h>
#include <stdlib.h>

unsigned int Sample::hash(unsigned int key)
{
    key += ~(key << 15);
    key ^=  (key >> 10);
    key +=  (key << 3);
    key ^=  (key >> 6);
    key += ~(key << 11);
    key ^=  (key >> 16);
    return key;
}

void Sample::regenerate(void) {
    if (deviceType == "software") {
        struct timeval tnow;
        gettimeofday(&tnow, NULL);
        long seed = hash(tnow.tv_usec);
        knuth.ran_start(seed);
        pool.clear();
        for (int i = 0; i < maxPoolSize; i++) {
            pool.push_back(knuth.ran_arr_next() % (rMax-rMin+1) + rMin);
        }
    }
    else if (deviceType == "hybrid") {
        FM_U32 seed;
        FM_RET fmrc = FM_CPC_GenRandom(hdl, 4, (FM_U8 *)&seed);
        if (fmrc != FME_OK) {
            cerr << "fatal error FM_CPC_GenRandom" << endl;
            exit(0);
        }
        knuth.ran_start(seed);
        pool.clear();
        for (int i = 0; i < maxPoolSize; i++) {
            pool.push_back(knuth.ran_arr_next() % (rMax-rMin+1) + rMin);
        }
    }
    else if (deviceType == "hardware") {
        FM_U32 *randoms = (FM_U32 *)malloc(sizeof(FM_U32)*maxPoolSize);
        FM_RET fmrc = FM_CPC_GenRandom(hdl, 4*maxPoolSize, (FM_U8 *)randoms);
        if (fmrc != FME_OK) {
            cerr << "fatal error FM_CPC_GenRandom" << endl;
            exit(0);
        }
        pool.clear();
        for (int i = 0; i < maxPoolSize; i++) {
            pool.push_back(randoms[i] % (rMax-rMin+1) + rMin);
        }
        free(randoms);
    }

    X2Value = calculateX2();
}

void Sample::rollPool(int num) {
    int elemRemove, elemInsert;

    if (deviceType == "software" || deviceType == "hybrid") {
        for (int i = 0; i < num; i++) {
            elemRemove = pool.front();
            pool.pop_front();
            elemInsert = knuth.ran_arr_next() % (rMax-rMin+1) + rMin;
            pool.push_back(elemInsert);
            updateX2(elemRemove, elemInsert);
        }
    }
    else if (deviceType == "hardware") {
        FM_U32 *randoms = (FM_U32 *)malloc(sizeof(FM_U32)*num);
        FM_RET fmrc = FM_CPC_GenRandom(hdl, 4*num, (FM_U8 *)randoms);
        if (fmrc != FME_OK) {
            cerr << "fatal error FM_CPC_GenRandom" << endl;
            exit(0);
        }
        for (int i = 0; i < num; i++) {
            elemRemove = pool.front();
            pool.pop_front();
            elemInsert = randoms[i] % (rMax-rMin+1) + rMin;
            pool.push_back(elemInsert);
            updateX2(elemRemove, elemInsert);
        }
        free(randoms);
    }
}

// Let $\{1, \cdots, k\}$ be the set of outcomes from an experiment.
// Let $n$ be the number of experiments performed.
// Let $O_s$ be the actual number of occurrences of outcome $s$, where $s$ is in
// $\{1, \cdots, k\}$.
// The chi-squared value of these experiments according to a discrete distribution
// $\{p_1, \cdots, p_k\}$ for corresponding outcome $\{1, \cdots, k\}$ is
// $$\chi^2 = \sum_{s=1}^k \frac{(O_s-np_s)^2}{np_s}.$$
// For uniform distribution, we have $p_i = 1/k$ for $i\in\{1, \cdots, k\}$.
double Sample::calculateX2(void) {
    double X2 = 0;
    double diff;
    double weight = maxPoolSize * 1.0 / (rMax-rMin+1);

    // reinitialize the frequency histogram
    freqs.clear();
    for (int i = 0; i < (rMax-rMin+1); i++) {
        freqs.push_back(0);
    }

    deque<int>::const_iterator it;
    for (it = pool.begin(); it != pool.end(); it++) {
        freqs[(*it)-rMin]++;
    }
    for (int i = 0; i < (rMax-rMin+1); i++) {
        diff = freqs[i] - weight;
        X2 += diff * diff / weight;
    }
    return X2;
}

void Sample::updateX2(int elemRemove, int elemInsert)
{
    // X2 will be the same
    if (elemRemove == elemInsert) {
        //cerr << "happy (-__-)" << endl;
        return;
    }

    double weight = maxPoolSize * 1.0 / (rMax-rMin+1);
    double diff1, diff2;

    diff1 = (freqs[elemRemove-rMin]*1.0 - weight);
    diff2 = (freqs[elemInsert-rMin]*1.0 - weight);
    X2Value -= (diff1 * diff1 + diff2 * diff2) / weight;

    freqs[elemRemove-rMin]--;
    freqs[elemInsert-rMin]++;

    diff1 = (freqs[elemRemove-rMin]*1.0 - weight);
    diff2 = (freqs[elemInsert-rMin]*1.0 - weight);
    X2Value += (diff1 * diff1 + diff2 * diff2) / weight;
}

bool Sample::testX2OutOfRange(void) const {
    if (deviceType == "hardware") {
        return false; // We don't check X2 for pure hardware RNG. We assume it's truly random.
    }
    else {
        return (X2Value < X2Min) || (X2Value > X2Max);
    }
    //return (X2Value < X2Min) || (X2Value > X2Max);
}

vector<int> Sample::getPermutation(void) {
    vector<int> ret;
    int elemRemove, elemInsert;

    for (size_t i = 0; i < draws; i++) {
        elemRemove = pool.front();
        ret.push_back(elemRemove);
        pool.pop_front();
    
        if (deviceType == "software" || deviceType == "hybrid") {
            elemInsert = knuth.ran_arr_next() % (rMax-rMin+1) + rMin;
            pool.push_back(elemInsert);
        }
        else if (deviceType == "hardware") {
            FM_U32 rn;
            FM_RET fmrc = FM_CPC_GenRandom(hdl, 4, (FM_U8 *)&rn);
            if (fmrc != FME_OK) {
                cerr << "fatal error FM_CPC_GenRandom" << endl;
                exit(0);
            }
            elemInsert = rn % (rMax-rMin+1) + rMin;
            pool.push_back(elemInsert);
        }
        updateX2(elemRemove, elemInsert);
    }

    return ret;
}

vector<int> Sample::getCombination(void) {
    vector<int> ret;
    int elemRemove, elemInsert;

    while (ret.size() < draws) {
        elemRemove = pool.front();
        pool.pop_front();
        if (deviceType == "software" || deviceType == "hybrid") {
            elemInsert = knuth.ran_arr_next() % (rMax-rMin+1) + rMin;
            pool.push_back(elemInsert);
        }
        else if (deviceType == "hardware") {
            FM_U32 rn;
            FM_RET fmrc = FM_CPC_GenRandom(hdl, 4, (FM_U8 *)&rn);
            if (fmrc != FME_OK) {
                cerr << "fatal error FM_CPC_GenRandom" << endl;
                exit(0);
            }
            elemInsert = rn % (rMax-rMin+1) + rMin;
            pool.push_back(elemInsert);
        }
        updateX2(elemRemove, elemInsert);
    
        if (find(ret.begin(), ret.end(), elemRemove) == ret.end()) {
            ret.push_back(elemRemove);
        }
    }

    return ret;
}

vector<int> Sample::getDrawResult(void) {
    if (drawType == "combination") {
        return getCombination();
    }
    else if (drawType == "permutation") {
        return getPermutation();
    }
    else return vector<int>();
}

