#include <pthread.h>
#include <errno.h>
#include <string.h>

#include <vector>
#include <queue>
#include <iostream>
using namespace std;

#include "sample.h"
#include "log.h"
#include "game_manager.h"
#include "shm_mod.h"

GameManager::GameManager()
{
    int err;
    err = pthread_mutex_init(&mutex, NULL);
    if (err) {
        log("pthread_mutex_init() failed [%s]", strerror(err));
        exit(1);
    }
    err = pthread_cond_init(&cond, NULL);
    if (err) {
        log("pthread_cond_init() failed [%s]", strerror(err));
        exit(1);
    }
}

GameManager::~GameManager()
{
    int err;
    err = pthread_mutex_destroy(&mutex);
    if (err) {
        log("pthread_mutex_destroy() failed [%s]", strerror(err));
        exit(1);
    }
    err = pthread_cond_destroy(&cond);
    if (err) {
        log("pthread_cond_destroy() failed [%s]", strerror(err));
        exit(1);
    }
}

void GameManager::initializeSamples()
{
    for (size_t i = 0; i < samples.size(); i++) {
        do {
            log("game [%s] sample pool [%zu] initialized", gameName.c_str(), i);
            shm_business_info("game [%s] sample pool [%zu] initialized (%f %f %f)",
                              gameName.c_str(), i,
                              samples[i].X2Min, samples[i].X2Value, samples[i].X2Max);
            samples[i].regenerate();
        } while (samples[i].testX2OutOfRange());
    }
}

void GameManager::rollSamples(int rollNum) {
    for (size_t i = 0; i < samples.size(); i++) {
        samples[i].rollPool(rollNum);
        while (samples[i].testX2OutOfRange()) {
            log("game [%s] sample pool [%zu] regenerated", gameName.c_str(), i);
            shm_business_info("game [%s] sample pool [%zu] regenerated (%f %f %f)",
                              gameName.c_str(), i,
                              samples[i].X2Min, samples[i].X2Value, samples[i].X2Max);
            samples[i].regenerate();
        }
    }
}

void GameManager::rollDrawResultQueue() {
    vector<int> result;
    vector<int> partialResult;
    for (size_t i = 0; i < samples.size(); i++) {
        partialResult.clear();
        partialResult = samples[i].getDrawResult();
        for (size_t j = 0; j < partialResult.size(); j++) {
            result.push_back(partialResult[j]);
        }
    }

    pthread_mutex_lock(&mutex);
    drawResultQueue.push(result);
    if (drawResultQueue.size() > maxQueueSize) {
        //log("game [%s] queue size exceeds limit [%zu]. pop the front elem",
        //    gameName.c_str(), drawResultQueue.size());
        drawResultQueue.pop();
    }
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
}

vector<int> GameManager::getDrawResultFromQueue() {
    vector<int> result;
    pthread_mutex_lock(&mutex);
    while (drawResultQueue.size() == 0) {
        pthread_cond_wait(&cond, &mutex);
    }
    result = drawResultQueue.front();
    drawResultQueue.pop();
    pthread_mutex_unlock(&mutex);
    return result;
}



