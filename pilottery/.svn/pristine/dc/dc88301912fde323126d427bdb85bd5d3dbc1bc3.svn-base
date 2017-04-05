#ifndef _GAME_MANAGER_H_
#define _GAME_MANAGER_H_

#include <queue>
#include <vector>
#include <string>
using namespace std;

#include <pthread.h>

#include "sample.h"

class GameManager
{
public: //--DATA MEMBERS--//
    // Name of the game, read from configuration file.
    string gameName;

    // Maximum size of the draw result queue, when the size of the queue 
    // exceeds this number, we will pop the oldest element from the queue.
    size_t maxQueueSize;

    // Every manager has a draw result queue which contains a queue of draw
    // results made by stl vector. This queue is updated from time to time by
    // the function 'rollDrawResultQueue'. See below.
    queue< vector<int> > drawResultQueue;

    // A game may have multiple sample ranges, therefore we need to manage not
    // only one sample but a group of samples.
    vector<Sample> samples;

    // Since both the game manager thread and the network thread will access
    // the draw result queue, we need some memory protection mechanism.
    pthread_mutex_t mutex;

    // When the size of the draw result queue is zero, we release the mutex for 
    // a shortwhile so to let the queue be populated.
    pthread_cond_t cond;

public: //--MEMBER FUNCTIONS--//
    // Initialize the mutex, the cond.
    GameManager();

    // Destroy the mutex and the cond.
    ~GameManager();

    // Populate all the sample pools of this game manager. It also makes sure
    // that the X2 value of each of the sample pools is in the 95% confidence
    // interval.
    void initializeSamples();

    // Discard, for each sample pool, 'rollNum' number of oldest elements, and
    // add in 'rollNum' number of new elements. If the above procedure causes the
    // X2 value of any of the sample pools to be out of range, regenerate that
    // sample pool.
    void rollSamples(int rollNum);

    // Discard the oldest draw result vector from the draw result queue, make a
    // new draw result vector from this manager's samples, and push this draw 
    // result vector into the draw result queue. Additionally, it checks to
    // see whether the current queue size exceeds the maximum queue size 
    // allowed. This method is thread-safe.
    void rollDrawResultQueue();

    // As the name suggests. And it is thread-safe.
    // The returned draw result will be popped from drawResultQueue
    vector<int> getDrawResultFromQueue();
};

#endif // _GAME_MANAGER_H_
