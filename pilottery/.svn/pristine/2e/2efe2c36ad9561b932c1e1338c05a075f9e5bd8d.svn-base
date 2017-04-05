#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <signal.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <net/if.h>

#include <string>
#include <vector>
#include <queue>
#include <iostream>
#include <map>
using namespace std;

#include "3des.h"
#include "crc16.h"
#include "protocol.h"
#include "sample.h"
#include "xml.h"
#include "log.h"
#include "game_manager.h"
#include "shm_mod.h"

// hardware RNG interface
#include "fm_def.h"
#include "fm_cpc_pub.h"

#define RNG_CONFIG_PATH "/ts_rng/conf/conf.xml"


/******************************************************************************
* Data Type Definitions
*******************************************************************************/
typedef struct _RNG_INFO
{
    string device_type;
    int device_id;
    string ip;
    unsigned short port;
    int connect_interval;
    int heartbeat_interval;
    int heartbeat_timeout;

    int sock;

    RNG_STATUS status;
    bool send_hb; // set to true when alarm, set to false after sending hb
    time_t last_interaction; // last interaction between rng client and server,
                             // including the epochs of 1.server connection 2.server authentication
                             // 3.hb sent 4. hb recvd 5.draw request processed
} RNG_INFO;

/******************************************************************************
* Global Variables
*******************************************************************************/
static bool isExit = false;
static RNG_INFO rngInfo;
static map<int, GameManager> gameManagerMap;
static pthread_t network_tid;
static pthread_t game_tid;
static RNG_SHM_PTR pShm = NULL; // pointer to the shared memory

static char netcard_name[100] = {0};
static bool daemonize_g = false;
static char pidfile_g[1024] = {0};

/******************************************************************************
* Functions
*******************************************************************************/
static void exit_handler(int signo)
{
    (void)signo;
    isExit = true;
    log("exit_handler is excited");
    return;
}

static void alarm_handler(int signo)
{
    (void)signo;
    rngInfo.send_hb = true;
    return;
}

int init_signal()
{   
    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;

    sas.sa_handler = exit_handler;
    if (sigaction(SIGINT, &sas, NULL) == -1)
    {
        log("sigaction(SIGINT) failed. Reason [%s]", strerror(errno));
        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1)
    {
        log("sigaction(SIGTERM) failed. Reason [%s]", strerror(errno));
        return -1;
    }

    sas.sa_handler = alarm_handler;
    if (sigaction(SIGALRM, &sas, NULL) == -1)
    {
        log("sigaction(SIGALRM) failed. Reason [%s]", strerror(errno));
        return -1;
    }

    sas.sa_handler = SIG_IGN;
    if (sigaction(SIGPIPE, &sas, NULL) == -1)
    {
        log("sigaction(SIGPIPE) failed. Reason [%s]", strerror(errno));
        return -1;
    }

    return 0;
}

int get_local_ip(char *ip, char *netcard_name)
{
    struct ifreq ifreq;
    struct sockaddr_in *psockaddr;
    int sock, ret;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        log("get ip establish socket failed");
        return -1;
    }

    strcpy(ifreq.ifr_name, netcard_name);

    ret = ioctl(sock, SIOCGIFADDR, &ifreq);
    if (ret < 0) {
        log("ioctl(SIOCGIFADDR) failed");
        return -1;
    }

    psockaddr = (struct sockaddr_in *)&(ifreq.ifr_addr);

    strcpy(ip, inet_ntoa(psockaddr->sin_addr));

    close(sock);
    log("local ip: %s", ip);
    return 0;
}

int get_local_mac(uint8 *mac, char *netcard_name)
{
    struct ifreq ifreq;
    int sock, ret;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        log("get mac establish socket failed");
        return -1;
    }

    strcpy(ifreq.ifr_name, netcard_name);

    ret = ioctl(sock, SIOCGIFHWADDR, &ifreq);
    if (ret < 0) {
        log("ioctl(SIOCGIFHWADDR) failed");
        return -1;
    }

    mac[0] = (uint8)ifreq.ifr_hwaddr.sa_data[0];
    mac[1] = (uint8)ifreq.ifr_hwaddr.sa_data[1];
    mac[2] = (uint8)ifreq.ifr_hwaddr.sa_data[2];
    mac[3] = (uint8)ifreq.ifr_hwaddr.sa_data[3];
    mac[4] = (uint8)ifreq.ifr_hwaddr.sa_data[4];
    mac[5] = (uint8)ifreq.ifr_hwaddr.sa_data[5];

    log("MAC: %02x:%02x:%02x:%02x:%02x:%02x", mac[0], mac[1], mac[2], mac[3],
        mac[4], mac[5]);

    close(sock);
    return 0;
}

int recv_msg(int fd, void *buf)
{
    ssize_t nr;
    unsigned char *p = (unsigned char *)buf;
    size_t msg_size;

    nr = recv(fd, p, 2, 0);
    if (nr < 0) {
        log("get msg size failure [%s]", strerror(errno));
        return -1;
    } else if (nr == 0) {
        log("get msg size failure. peer orderly shutdown");
        return -1;
    } else if (nr != 2) {
        log("get msg size failure. recv bytes != 2");
        return -1;
    }

    msg_size = *(unsigned short *)p;
    msg_size -= 2;
    p += 2;

    while (msg_size > 0) {
        nr = recv(fd, p, msg_size, 0);
        if (nr < 0) {
            if (errno == EINTR) continue;
            else {
                log("recv failed [%s]", strerror(errno));
                return -1;
            }
        } else if (nr == 0) {
            log("recv failed. peer orderly shutdown");
            return -1;
        } else {
            p += nr;
            msg_size -= nr;
        }
    }

    return 0;
}

int recv_msg_timed(int fd, void *buf, struct timeval *tv)
{
    int ret;
    struct pollfd fds;

    if (!tv) return recv_msg(fd, buf);

REDO_RECV:

    fds.fd = fd;
    fds.events = POLLIN;
    ret = poll(&fds, 1, tv->tv_sec*1000 + (tv->tv_usec/1000));
    if (ret < 0) {
        if (errno == EINTR) goto REDO_RECV;
        log("poll error [%s]", strerror(errno));
        return -1;
    } else if (ret == 0) {
        //log("poll timeout");
        return 1;
    } else if (fds.revents & POLLIN) {
        return recv_msg(fd, buf);
    } else {
        log("abnormal conditions happened over the network");
        return -1;
    }
}

int send_msg(int fd, void *buf)
{
    ssize_t ns;
    unsigned char *p = (unsigned char *)buf;
    size_t left = *(unsigned short *)buf;

    while (left > 0) {
        ns = send(fd, p, left, 0);
        if (ns < 0) {
            if (errno == EINTR) continue;
            else {
                log("send failed [%s]", strerror(errno));
                return -1;
            }
        } else {
            p += ns;
            left -= ns;
        }
    }

    return 0;
}

int load_config()
{
    char buffer[100];
    XML xmlconf(RNG_CONFIG_PATH);

    if (xmlconf.IntegrityTest()) {
        log("conf.xml is valid");
    }
    else {
        log("conf.xml is invalid");
        return -1;
    }

    XMLElement *rng_device = xmlconf.GetRootElement();
    if (!rng_device) {
        log("root element <rng_device> does not exist");
        return -1;
    }

    XMLElement *device_type = rng_device->FindElementZ("device_type");
    if (!device_type) {
        log("<device_type> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        device_type->GetContents()[0]->GetValue(buffer);
        if (strcmp(buffer, "software") != 0 &&
            strcmp(buffer, "hardware") != 0 &&
            strcmp(buffer, "hybrid") != 0) {
            log("invalid device mode %s", buffer);
            return -1;
        }
        rngInfo.device_type = buffer;
    }
    log("device_type: %s", rngInfo.device_type.c_str());

    XMLElement *device_id = rng_device->FindElementZ("device_id");
    if (!device_id) {
        log("<device_id> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        device_id->GetContents()[0]->GetValue(buffer);
        rngInfo.device_id = atoi(buffer);
    }
    log("device_id: %d", rngInfo.device_id);

    XMLElement *rng_server = rng_device->FindElementZ("rng_server");
    if (!rng_server) {
        log("<rng_server> does not exist");
        return -1;
    }

    XMLElement *netcard = rng_server->FindElementZ("netcard");
    if (!netcard) {
        log("<netcard> does not exist");
        return -1;
    }
    else {
        netcard->GetContents()[0]->GetValue(netcard_name);
    }
    log("netcard: %s", netcard_name);

    XMLElement *ip = rng_server->FindElementZ("ip");
    if (!ip) {
        log("<ip> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        ip->GetContents()[0]->GetValue(buffer);
        rngInfo.ip = buffer;
    }
    log("ip: %s", rngInfo.ip.c_str());

    XMLElement *port = rng_server->FindElementZ("port");
    if (!port) {
        log("<port> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        port->GetContents()[0]->GetValue(buffer);
        rngInfo.port = atoi(buffer);
    }
    log("port: %hu", rngInfo.port);

    XMLElement *connect_interval = rng_server->FindElementZ("connect_interval");
    if (!connect_interval) {
        log("<connect_interval> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        connect_interval->GetContents()[0]->GetValue(buffer);
        rngInfo.connect_interval = atoi(buffer);
    }
    log("connect_interval: %d", rngInfo.connect_interval);

    XMLElement *heartbeat_interval = 
        rng_server->FindElementZ("heartbeat_interval");
    if (!heartbeat_interval) {
        log("<heartbeat_interval> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        heartbeat_interval->GetContents()[0]->GetValue(buffer);
        rngInfo.heartbeat_interval = atoi(buffer);
    }
    log("heartbeat_interval: %d", rngInfo.heartbeat_interval);

    XMLElement *heartbeat_timeout = 
        rng_server->FindElementZ("heartbeat_timeout");
    if (!heartbeat_timeout) {
        log("<heartbeat_timeout> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        heartbeat_timeout->GetContents()[0]->GetValue(buffer);
        rngInfo.heartbeat_timeout = atoi(buffer);
    }
    log("heartbeat_timeout: %d", rngInfo.heartbeat_timeout);

    XMLElement *games = rng_device->FindElementZ("games");
    if (!games) {
        log("<games> does not exist");
        return -1;
    }

    int nGames;
    XMLElement *number_of_games = games->FindElementZ("number_of_games");
    if (!number_of_games) {
        log("<number_of_games> does not exist");
        return -1;
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        number_of_games->GetContents()[0]->GetValue(buffer);
        nGames = atoi(buffer);
    }
    log("nGames: %d", nGames);

    XMLElement **gamesChildren = games->GetChildren();
    for (int i = 1; i <= nGames; i++) {
        XMLElement *game = gamesChildren[i];

        int key;
        XMLElement *game_code = game->FindElementZ("game_code");
        if (!game_code) {
            log("<game_code> does not exist");
            return -1;
        }
        else {
            memset(buffer, 0, sizeof(buffer));
            game_code->GetContents()[0]->GetValue(buffer);
            key = atoi(buffer);
        }
        log("game_code: %d", key);

        XMLElement *game_name = game->FindElementZ("game_name");
        if (!game_name) {
            log("<game_code> does not exist");
            return -1;
        }
        else {
            memset(buffer, 0, sizeof(buffer));
            game_name->GetContents()[0]->GetValue(buffer);
            gameManagerMap[key].gameName = buffer;
        }
        log("gameName: %s", gameManagerMap[key].gameName.c_str());

        XMLElement *max_queue_size = game->FindElementZ("max_queue_size");
        if (!max_queue_size) {
            log("<max_queue_size> does not exist");
            return -1;
        }
        else {
            memset(buffer, 0, sizeof(buffer));
            max_queue_size->GetContents()[0]->GetValue(buffer);
            gameManagerMap[key].maxQueueSize = atoi(buffer);
        }
        log("maxQueueSize %zu", gameManagerMap[key].maxQueueSize);

        int nRanges;
        XMLElement *number_of_ranges = game->FindElementZ("number_of_ranges");
        memset(buffer, 0, sizeof(buffer));
        number_of_ranges->GetContents()[0]->GetValue(buffer);
        nRanges = atoi(buffer);
        log("range: %d", nRanges);

        XMLElement **ranges = game->GetChildren();
        for (int j = 4; j < 4+nRanges; j++) {
            XMLElement *range = ranges[j];
            int id = range->FindVariableZ("id")->GetValueInt();
            log("range id: %d", id);

            Sample sample;

            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("draws_per_range")->GetContents()[0]
                ->GetValue(buffer);
            sample.draws = atoi(buffer);
            log("draws: %zu", sample.draws);

            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("draw_type")->GetContents()[0]->GetValue(buffer);
            sample.drawType = buffer;
            log("drawType: %s", sample.drawType.c_str());

            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("range_min")->GetContents()[0]->GetValue(buffer);
            sample.rMin = atoi(buffer);
            log("rMin: %d", sample.rMin);

            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("range_max")->GetContents()[0]->GetValue(buffer);
            sample.rMax = atoi(buffer);
            log("rMax: %d", sample.rMax);

            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("chi_square_min")->GetContents()[0]
                ->GetValue(buffer);
            sample.X2Min = atof(buffer);
            log("X2Min: %f", sample.X2Min);

            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("chi_square_max")->GetContents()[0]
                ->GetValue(buffer);
            sample.X2Max = atof(buffer);
            log("X2Max: %f", sample.X2Max);
    
            memset(buffer, 0, sizeof(buffer));
            range->FindElementZ("sample_pool_size")->GetContents()[0]
                ->GetValue(buffer);
            sample.maxPoolSize = atoi(buffer);
            log("maxPoolSize: %d", sample.maxPoolSize);
    
            gameManagerMap[key].samples.push_back(sample);
        }
    }

    return 0;
}


int network_status_unconnected()
{
    int ret;
    struct sockaddr_in sain;

    rngInfo.sock = socket(AF_INET, SOCK_STREAM, 0);
    if (rngInfo.sock < 0) {
        log("socket() [%s]", strerror(errno));
        return -1;
    }

    int yes = 1;
    ret = setsockopt(rngInfo.sock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
    if (ret < 0) {
        log("setsockopt(SO_REUSEADDR) [%s]", strerror(errno));
        return -1;
    }

    memset(&sain, 0, sizeof(sain));
    sain.sin_family = AF_INET;
    sain.sin_port = htons(rngInfo.port);
    ret = inet_aton(rngInfo.ip.c_str(), &sain.sin_addr);
    if (ret == 0) {
        log("inet_aton(%s)", rngInfo.ip.c_str());
        return -1;
    }

    while (connect(rngInfo.sock, (const struct sockaddr *)&sain, sizeof(sain)) < 0) {
        log("connect() [%s]", strerror(errno));
        shm_runlog_info("connect() [%s]", strerror(errno));
        if (isExit) return -1;
        sleep(rngInfo.connect_interval);
    }

    // the socket connection has been successfully established
    rngInfo.status = RNG_CONNECTED;
    pShm->work_status = RNG_CONNECTED;
    get_date_time_format(time(NULL), pShm->last_connect_time);
    // update the interaction time
    rngInfo.last_interaction = time(NULL); // when rng is connected

    shm_runlog_info("the rng device is connected");

    return 0;
}

bool crc_consistent(void *buf)
{
    char *header = (char *)buf;
    uint16 length = *(uint16 *)header;
    uint16 crc_recv = *(uint16 *)(header + length - 2);
    uint16 crc_calc = calc_crc(buf, length - 2);

    if (crc_recv == crc_calc) return true;
    else {
        log("crc_recv (%hu) crc_calc (%hu)", crc_recv, crc_calc);
        shm_runlog_info("crc_recv (%hu) crc_calc (%hu)", crc_recv, crc_calc);
        return false;
    }
}


int network_status_connected()
{
    int ret;
    char sendbuf[1024] = {0};
    char sendencbuf[1024] = {0};
    char recvbuf[1024] = {0};
    char recvdecbuf[1024] = {0};

    // make message authentication request
    RNG_MSG_AUTH_REQ *g = (RNG_MSG_AUTH_REQ *)sendbuf;
    g->header.len = sizeof(RNG_MSG_AUTH_REQ);
    g->header.type = RNG_MSG_TYPE_AUTH_REQ;
    g->header.deviceID = rngInfo.device_id;
    g->header.time = (uint32)time(NULL);
    ret = get_local_mac(g->mac, netcard_name);
    if (ret < 0) {
        log("get_local_mac()");
        return -1;
    }
    g->crc = calc_crc(g, g->header.len - 2);

    // encrypt message authentication request
    ret = enc_3des(sendbuf, sendencbuf);
    if (ret < 0) {
        log("enc_3des(auth req)");
        return -1;
    }

    // send message authentication request
    ret = send_msg(rngInfo.sock, sendencbuf);
    if (ret < 0) {
        log("send_msg(auth req) failed");
        return -1;
    }

    // auth request sent, log it
    log("authentication request is sent");

    // receive a message
    struct timeval tv = {3, 0};
    ret = recv_msg_timed(rngInfo.sock, recvbuf, &tv);
    if (ret < 0) {
        log("recv_msg_timed(3second) failed");
        return -1;
    }
    else if (ret == 1) {
        log("recv_msg_timed(3second) overtime");
        return -1;
    }

    // decrypt the received message
    ret = dec_3des(recvbuf, recvdecbuf);
    if (ret < 0) {
        log("dec_3des(auth rsp)");
        return -1;
    }

    // check whether the crc of the received message is consistent
    if (!crc_consistent(recvdecbuf)) {
        log("crc is not consistent");
        return -1;
    }

    // check whether the received message is an auth response
    RNG_MSG_AUTH_RSP *h = (RNG_MSG_AUTH_RSP *)recvdecbuf;
    if (h->header.type != RNG_MSG_TYPE_AUTH_RSP) {
        log("received a message that is not an auth response");
        return -1;
    }

    // check whether the auth response's device id is the device id of this rng
    if (h->header.deviceID != rngInfo.device_id) {
        log("received an auth response of incorrect device id, msg (%hhu) rng (%d)",
            h->header.deviceID, rngInfo.device_id);
        return -1;
    }

    // check whether the return code is successful or not
    if (h->retcode != RNG_SUCCESS) {
        log("the authentication is unsuccessful");
        return -1;
    }

    // yes! this rng device is authenticated. now we set the heartbeat alarm
    // and update the interaction time
    rngInfo.status = RNG_AUTHENTICATED;
    pShm->work_status = RNG_AUTHENTICATED;
    alarm(rngInfo.heartbeat_interval); // when rng authenticated for the 1st time
    rngInfo.last_interaction = time(NULL); // when rng is authenticated

    // log it
    log("the rng device is authenticated");
    shm_runlog_info("the rng device is authenticated");

    return 0;
}

// a helper function
int fetch_and_send_draw_result(RNG_MSG_DRAW_REQ *dreq, char *sendbuf, char *sendencbuf)
{
    int ret;

    RNG_MSG_DRAW_RSP *drsp = (RNG_MSG_DRAW_RSP *)sendbuf;
    drsp->header.type = RNG_MSG_TYPE_DRAW_RSP;
    drsp->header.deviceID = rngInfo.device_id;
    drsp->header.time = (uint32)time(NULL);
    drsp->header.param = 0;
    drsp->gameCode = dreq->gameCode;
    drsp->issueNumber = dreq->issueNumber;

    if (gameManagerMap.find(dreq->gameCode) == gameManagerMap.end()) {
        log("requested game code (%hhu) not found", dreq->gameCode);
        shm_runlog_info("requested game code (%hhu) not found", dreq->gameCode);
        drsp->retcode = RNG_GAME_NOT_SUPPORTED;
        drsp->resultLen = 0;
        drsp->header.len = sizeof(RNG_MSG_DRAW_RSP) + 2;
    }
    else {
        log("requested game code (%hhu) found in game manager", dreq->gameCode);
        drsp->retcode = RNG_SUCCESS;
        // get a draw result from the game manager
        vector<int> drawResult = gameManagerMap[dreq->gameCode].getDrawResultFromQueue();
        drsp->resultLen = drawResult.size();
        drsp->header.len = sizeof(RNG_MSG_DRAW_RSP) + drsp->resultLen*sizeof(drsp->result[0]) + 2;
        for (size_t i = 0; i < drawResult.size(); i++) {
            drsp->result[i] = drawResult[i];
        }

        // log this draw result as business info in shared memory
        char drawbuf[1024] = {0};
        for (size_t i = 0; i < drawResult.size(); i++) {
            sprintf(drawbuf, "%s %d", drawbuf, drawResult[i]);
        }
        log("drawbuf (%s)", drawbuf);
        shm_business_info("game (%hhu) issue (%lu) name (%s)",
                          drsp->gameCode,
                          drsp->issueNumber,
                          gameManagerMap[drsp->gameCode].gameName.c_str());
        shm_business_info("drawnum (%s)", drawbuf);
    }

    // calculate and set message crc, the crc of this message has to be set in
    // the following manner
    uint16 *crc = (uint16 *)(&drsp->result[0] + drsp->resultLen);
    *crc = calc_crc(drsp, drsp->header.len - 2);

    // encrypt the draw response message
    ret = enc_3des(sendbuf, sendencbuf);
    if (ret < 0) {
        log("enc_3des(draw rsp)");
        return -1;
    }

    // send the encrypted draw response message
    ret = send_msg(rngInfo.sock, sendencbuf);
    if (ret < 0) {
        log("send_msg(draw rsp)");
        return -1;
    }

    return 0;
}


int network_status_authenticated()
{
    int ret;
    char sendbuf[1024] = {0};
    char sendencbuf[1024] = {0};
    char recvbuf[1024] = {0};
    char recvdecbuf[1024] = {0};

    // check whether the heartbeat has timeout
    if (time(NULL) - rngInfo.last_interaction > rngInfo.heartbeat_timeout) {
        log("heartbeat interval exceeds limit %d. close socket.", rngInfo.heartbeat_timeout);
        shm_runlog_info("heartbeat interval exceeds limit %d. close socket.", rngInfo.heartbeat_timeout);
        return -1;
    }

    // time to send a heartbeat message
    if (rngInfo.send_hb) {
        // make hb message
        rngInfo.send_hb = false;
        RNG_MSG_HB *hb = (RNG_MSG_HB *)sendbuf;
        hb->header.len = sizeof(RNG_MSG_HB);
        hb->header.type = RNG_MSG_TYPE_HB;
        hb->header.deviceID = rngInfo.device_id;
        hb->header.time = (uint32)time(NULL);
        hb->crc = calc_crc(hb, hb->header.len - 2);
        // encrypt hb message
        ret = enc_3des(sendbuf, sendencbuf);
        if (ret < 0) {
            log("enc_3des(heartbeat)");
            return -1;
        }
        // send encrypted hb message
        ret = send_msg(rngInfo.sock, sendencbuf);
        if (ret < 0) {
            log("send_msg(heartbeat)");
            return -1;
        }
        // log it
        log("heartbeat sent at (%u)", hb->header.time);
        pShm->last_hb_sent = (long)time(NULL);
        // update interaction time
        rngInfo.last_interaction = time(NULL); // when an hb is sent
    }

    // receive a message in half a second
    struct timeval tv = {0, 500*1000};
    ret = recv_msg_timed(rngInfo.sock, recvbuf, &tv);
    if (ret < 0) {
        log("recv_msg_timed() failed");
        return -1;
    }
    else if (ret == 1) {
        // time out, we just return successfully
        return 0;
    }

    // decrypt the received message
    ret = dec_3des(recvbuf, recvdecbuf);
    if (ret < 0) {
        log("dec_3des(hb or dr req)");
        return -1;
    }

    // check whether the crc of the received message is consistent
    if (!crc_consistent(recvdecbuf)) {
        log("crc is not consistent");
        return -1;
    }

    // get the header of the received message
    RNG_MESSAGE_HEADER *hdr = (RNG_MESSAGE_HEADER *)recvdecbuf;

    // check the device id of this received message
    if (hdr->deviceID != rngInfo.device_id) {
        log("incorrect device id, msg (%hhu) rng (%d)", hdr->deviceID, 
            rngInfo.device_id);
        return -1;
    }

    // received message is an heartbeat message
    if (hdr->type == RNG_MSG_TYPE_HB) {
        log("heartbeat recvd at (%u)", hdr->time);
        pShm->last_hb_recv = (long)time(NULL);
        // reset the heartbeat alarm
        alarm(rngInfo.heartbeat_interval); // when an hb is recvd
        // update last interaction time
        rngInfo.last_interaction = time(NULL); // when an hb is recvd
    }
    // received message is a draw request message
    else if (hdr->type == RNG_MSG_TYPE_DRAW_REQ) {
        log("draw request recvd at (%u)", hdr->time);
        shm_runlog_info("draw request recvd at (%u)", hdr->time);
        RNG_MSG_DRAW_REQ *dreq = (RNG_MSG_DRAW_REQ *)recvdecbuf;
        // fetch and send draw result
        memset(sendbuf, 0, sizeof(sendbuf));
        memset(sendencbuf, 0, sizeof(sendencbuf));
        ret = fetch_and_send_draw_result(dreq, sendbuf, sendencbuf);
        if (ret < 0) {
            log("fetch_and_send_draw_result() failed");
            return -1;
        }
        // update last interaction time
        rngInfo.last_interaction = time(NULL); // when a draw request is recvd and response successfully sent
    }
    else {
        log("unknown message type (%hhu) received", hdr->type);
        shm_runlog_info("unknown message type (%hhu) received", hdr->type);
        return -1;
    }

    return 0;
}


void *network_manager_thread(void *arg)
{
    (void)arg;
    int ret;

    log("network_manager_thread starts");
    shm_runlog_info("network_manager_thread starts");

    // Initialize RNG_INFO status
    rngInfo.sock = -1;
    rngInfo.status = RNG_UNCONNECTED;
    pShm->work_status = RNG_UNCONNECTED;
    rngInfo.send_hb = false;
    rngInfo.last_interaction = (time_t)0;

    while (!isExit) {
        //log("network thread working");

        switch (rngInfo.status) {
            case RNG_UNCONNECTED:
            {
                ret = network_status_unconnected();
                if (ret < 0) {
                    log("network_status_unconnected() returns -1. close socket.");
                    shm_runlog_info("network_status_unconnected() returns -1. close socket.");
                    close(rngInfo.sock);
                    rngInfo.status = RNG_UNCONNECTED;
                    pShm->work_status = RNG_UNCONNECTED;
                    pShm->last_hb_sent = -1;
                    pShm->last_hb_recv = -1;
                    get_date_time_format(time(NULL), pShm->last_disconnect_time);
                    rngInfo.send_hb = false;
                    rngInfo.last_interaction = (time_t)0;
                }
                // if successful rngInfo.status becomes 'RNG_CONNECTED'
                break;
            }
            case RNG_CONNECTED:
            {
                ret = network_status_connected();
                if (ret < 0) {
                    log("network_status_connected() returns -1. close socket.");
                    shm_runlog_info("network_status_connected() returns -1. close socket.");
                    close(rngInfo.sock);
                    rngInfo.status = RNG_UNCONNECTED;
                    pShm->work_status = RNG_UNCONNECTED;
                    pShm->last_hb_sent = -1;
                    pShm->last_hb_recv = -1;
                    get_date_time_format(time(NULL), pShm->last_disconnect_time);
                    rngInfo.send_hb = false;
                    rngInfo.last_interaction = (time_t)0;
                    // if rng becomes unconnected, we sleep for 1 second before reconnect
                    sleep(1);
                }
                // if successful rngInfo.status becomes 'RNG_AUTHENTICATED'
                break;
            }
            case RNG_AUTHENTICATED:
            {
                ret = network_status_authenticated();
                if (ret < 0) {
                    log("network_status_authenticated() returns -1. close socket.");
                    shm_runlog_info("network_status_authenticated() returns -1. close socket.");
                    close(rngInfo.sock);
                    rngInfo.status = RNG_UNCONNECTED;
                    pShm->work_status = RNG_UNCONNECTED;
                    pShm->last_hb_sent = -1;
                    pShm->last_hb_recv = -1;
                    get_date_time_format(time(NULL), pShm->last_disconnect_time);
                    rngInfo.send_hb = false;
                    rngInfo.last_interaction = (time_t)0;
                    // if rng becomes unconnected, we sleep for 1 second before reconnect
                    sleep(1);
                }
                // if successful status does not change
                break;
            }
            default:
            {
                log("unknown status %d. exit program", rngInfo.status);
                shm_runlog_info("unknown status %d. exit program", rngInfo.status);
                exit(1);
                break;
            }
        }
    }

    log("network_manager_thread ends");

    pthread_exit(NULL);
}

void *game_manager_thread(void *arg)
{
    (void)arg;
    map<int, GameManager>::iterator pgm;

    log("game_manager_thread starts");
    shm_runlog_info("game_manager_thread starts");

    for (pgm = gameManagerMap.begin(); pgm != gameManagerMap.end(); pgm++) {
        pgm->second.initializeSamples();
    }

    while (!isExit) {
        //log("game thread working");

        // For every game in the game manager map, roll its sample pools and 
        // roll a draw result vector from the draw result queue.
        // To 'roll' here means to waste some amount and feed with new ones.
        for (pgm = gameManagerMap.begin(); pgm != gameManagerMap.end(); pgm++) {
            pgm->second.rollSamples(10);
            pgm->second.rollDrawResultQueue();
        }

        // print debug information to shared memory
        memset(pShm->debug_info, 0, sizeof(pShm->debug_info));
        for (pgm = gameManagerMap.begin(); pgm != gameManagerMap.end(); pgm++) {
            sprintf(pShm->debug_info,
                    "%s(%d,%zu,",
                    pShm->debug_info, pgm->first, pgm->second.drawResultQueue.size());
            for (size_t i = 0; i < pgm->second.samples.size(); i++) {
                sprintf(pShm->debug_info,
                        "%s%zu%c",
                        pShm->debug_info, pgm->second.samples[i].pool.size(),
                        (i + 1 == pgm->second.samples.size())?')':',');
            }
        }

        usleep(100*1000);
    }

    log("game_manager_thread ends");

    pthread_exit(NULL);
}



static void usage(void)
{
    fprintf(stderr, "Usage: rngclient [--daemonize] [--pidfile filename]");
    exit(1);
    return;
}


static void parse_opts(int argc, char **argv)
{
    for (int i = 1; i < argc; i++) {
        if (0 == strcmp(argv[i], "--daemonize")) {
            daemonize_g = true;
        }
        else if (0 == strcmp(argv[i], "--pidfile")) {
            if (i + 1 < argc) {
                strncpy(pidfile_g, argv[i+1], sizeof(pidfile_g));
                i++;
            }
            else {
                usage();
            }
        }
        else {
            usage();
        }
    }
    return;
}


static bool rng_daemonize(void)
{
    fflush(stdout);
    fflush(stderr);

    switch (fork()) {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }
    if (setsid() == -1) {
        return false;
    }
    switch (fork()) {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }
    umask(0);
    close(0);
    close(1);
    close(2);
    int fd = open("/dev/null", O_RDWR, 0);
    if (fd != -1) {
        dup2(fd, 0);
        dup2(fd, 1);
        dup2(fd, 2);
        if (fd > 2) {
            close(fd);
        }
    }
    return true;
}


int main(int argc, char *argv[])
{
    int ret, err;

    parse_opts(argc, argv);

    if (daemonize_g) {
        if (!rng_daemonize()) {
            log("ncp_daemonize() failed");
            return -1;
        }
    }

    if ('\0' != pidfile_g[0]) {
        FILE *f = fopen(pidfile_g, "w+");
        if (NULL == f) {
            printf("fopen([%s]) failed.\n", pidfile_g);
            return -1;
        }
        fprintf(f, "%ld", (long)getpid());
        fclose(f);
    }

    ret = init_signal();
    if (ret < 0) {
        log("init_signal() failed");
        return -1;
    }

    ret = load_config();
    if (ret < 0) {
        log("load_config() failed");
        return -1;
    }

    ret = shm_create();
    if (ret < 0) {
        log("shm_create() failed");
        return -1;
    }

    ret = shm_init();
    if (ret < 0) {
        log("shm_init() failed");
        return -1;
    }

    // if we use hardware RNG, we need to initialize the RNG device.
    // if the initialization fails, we fall back to use software RNG.
    FM_RET fmrc;
    FM_U8 index = 0;
    FM_HANDLE hdl;
    if (rngInfo.device_type == "hardware" || rngInfo.device_type == "hybrid") {
        fmrc = FM_CPC_OpenDevice(&index, FM_DEV_TYPE_PCIE_1_0X, FM_OPEN_MULTITHREAD, &hdl);
        if (fmrc != FME_OK) {
            log("FM_CPC_OpenDevice() failed. Use software RNG instead");
            shm_runlog_info("Mode %s device initialization fails. Use software RNG instead",
                            rngInfo.device_type.c_str());
            rngInfo.device_type = "software";
        }
    }
    // for convenience, every sample shall store the type of RNG used
    for (map<int, GameManager>::iterator pgm = gameManagerMap.begin();
         pgm != gameManagerMap.end();
         pgm++) {
        for (size_t i = 0; i < pgm->second.samples.size(); i++) {
            pgm->second.samples[i].deviceType = rngInfo.device_type;
            // if we use hardware RNG, then every sample shall keep a copy of
            // the RNG device handle
            if (rngInfo.device_type == "hardware" || rngInfo.device_type == "hybrid") {
                pgm->second.samples[i].hdl = hdl;
            }
            else {
                pgm->second.samples[i].hdl = (FM_HANDLE)0;
            }
        }
    }
    if (rngInfo.device_type == "hardware") {
        log("hardware RNG initialization success!!!");
        shm_runlog_info("hardware RNG initialization success!!!");
    }
    else if (rngInfo.device_type == "hybrid") {
        log("RNG hybrid mode initialization success!!!");
        shm_runlog_info("RNG hybrid mode initialization success!!!");
    }
    else {
        log("RNG is in software mode");
        shm_runlog_info("RNG is in software mode");
    }

    // initialize data in the shared memory
    pShm = get_shm_ptr();
    memset(pShm->server_ip, 0, 16);
    strcpy(pShm->server_ip, rngInfo.ip.c_str());
    pShm->port = rngInfo.port;
    pShm->device_id = rngInfo.device_id;
    if (rngInfo.device_type == "software") {
        strcpy(pShm->device_type, "software");
    }
    else if (rngInfo.device_type == "hybrid") {
        strcpy(pShm->device_type, "hybrid");
    }
    else if (rngInfo.device_type == "hardware") {
        strcpy(pShm->device_type, "hardware");
    }
    pShm->connect_interval = rngInfo.connect_interval;
    pShm->heartbeat_interval = rngInfo.heartbeat_interval;
    pShm->heartbeat_timeout = rngInfo.heartbeat_timeout;
    pShm->work_status = RNG_UNCONNECTED;
    ret = get_local_ip(pShm->local_ip, netcard_name);
    if (ret < 0) {
        log("get_local_ip()");
        return -1;
    }
    ret = get_local_mac((uint8 *)pShm->local_mac, netcard_name);
    if (ret < 0) {
        log("get_local_mac()");
        return -1;
    }
    get_date_time_format(time(NULL), pShm->start_time);
    pShm->last_hb_sent = -1;
    pShm->last_hb_recv = -1;
    memset(pShm->debug_info, 0, sizeof(pShm->debug_info));

    // start the threads
    err = pthread_create(&network_tid, NULL, network_manager_thread, NULL);
    if (err) {
        log("pthread_create(network_manager_thread) failed [%s]", strerror(err));
        return -1;
    }

    err = pthread_create(&game_tid, NULL, game_manager_thread, NULL);
    if (err) {
        log("pthread_create(network_manager_thread) failed [%s]", strerror(err));
        return -1;
    }

    // join the threads
    err = pthread_join(network_tid, NULL);
    if (err) {
        log("pthread_join(network_tid) failed [%s]", strerror(err));
        return -1;
    }

    err = pthread_join(game_tid, NULL);
    if (err) {
        log("pthread_join(game_tid) failed [%s]", strerror(err));
        return -1;
    }

    // if we use hardware RNG, we need to close the RNG device before quitting.
    if (rngInfo.device_type == "hardware" || rngInfo.device_type == "hybrid") {
        fmrc = FM_CPC_CloseDevice(hdl);
        if (fmrc != FME_OK) {
            log("FM_CPC_CloseDevice failed");
            return -1;
        }
    }

    ret = shm_destroy();
    if (ret < 0) {
        log("shm_destroy() failed");
        return -1;
    }

    log("program safely exits");

    return 0;
}






