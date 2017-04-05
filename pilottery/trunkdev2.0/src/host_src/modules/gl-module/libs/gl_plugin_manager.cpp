#include "global.h"
#include "glmod.h"



bool load_plugin_interface(GAME_PLUGIN_INTERFACE *gpi, char *shm_libname)
{
    char *error;

    //获得该游戏so库的handle
    gpi->fun_handle = dlopen(shm_libname, RTLD_NOW|RTLD_DEEPBIND|RTLD_LOCAL);
    if (!gpi->fun_handle)
    {
        log_error("dlopen() failed. Reason [%s].", dlerror());
        return false;
    }

    //获得这个so库中plugin_init函数的指针
    dlerror();
    PLUGIN_INIT_FUN plugin_init_fun = (PLUGIN_INIT_FUN)dlsym(gpi->fun_handle, "plugin_init");
    if ((error = dlerror()) != NULL)
    {
        log_error("dlsym( [plugin_init] ) failed. ( %s ). Reason [%s].", shm_libname, error);
        return false;
    }

    //调用该游戏中的plugin_init函数
    if (false == (*plugin_init_fun)(gpi))
    {
        log_error("plugin_init_fun( %s ) failed.", shm_libname);
        return false;
    }

    log_info("load_plugin_interface( %s ) success.", shm_libname);
    return true;
}

void release_plugin_interface(GAME_PLUGIN_INTERFACE *gpi)
{
    dlclose(gpi->fun_handle);
}



bool init_flag = false;
GAME_PLUGIN_INTERFACE game_plugin_funs[MAX_GAME_NUMBER];


//创建共享内存
int gl_game_plugins_create()
{
    uint8 gameCode = 0;
    char shm_libname[MAX_GAME_NAME_LENGTH];

    for (gameCode = 0; gameCode < MAX_GAME_NUMBER; gameCode++)
    {
        GAME_DATA* game_ptr = gl_getGameData(gameCode);

        GAME_PLUGIN_INTERFACE *gpi = &game_plugin_funs[game_ptr->gameEntry.gameCode];
        gpi->gameCode = gameCode;

        if (!game_ptr->used)
            continue;

        //初始化游戏插件动态库
        memset(shm_libname, 0, sizeof(shm_libname));
        sprintf(shm_libname, "libgl_%s.so", game_ptr->gameEntry.gameAbbr);
        if (!load_plugin_interface(gpi, shm_libname))
        {
            log_error("load_plugin_interface( %d ) failed.", gameCode);
            return -1;
        }

        //创建插件共享内存
        int issueCnt = game_ptr->transctrlParam.maxIssueCount*2;
        if (false == gpi->mem_creat(issueCnt))
        {
            log_error("mem_creat( gameCode[%d] ) failed!", gameCode);
            return -1;
        }
        //attach共享内存
        if (false == gpi->mem_attach())
        {
            log_error("mem_attach( gameCode[%d] ) failed!", gameCode);
            return -1;
        }
        //插件共享内存数据初始化
        if (false == gpi->load_memdata())
        {
            log_error("load_memdata( gameCode[%d] ) failed.", gameCode);
            return -1;
        }

        log_info("gl_game_plugins_create( gamecode:%d issueCount[%d]) success.", gameCode, issueCnt);
    }
    init_flag = true;
    return 0;
}

//销毁共享内存
int gl_game_plugins_destroy()
{
    uint8 gameCode = 0;
    for (gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        GAME_DATA* game_ptr = gl_getGameData(gameCode);
        GAME_PLUGIN_INTERFACE *gpi = &game_plugin_funs[game_ptr->gameEntry.gameCode];

        if (!game_ptr->used)
            continue;

        if (!gpi->mem_destroy())
        {
            log_error("mem_destroy( gameCode[%d] ) failed!", gameCode);
            return -1;
        }

        release_plugin_interface(gpi);

        log_info("gl_game_plugin_destroy( gamecode:%d ) success.", gameCode);
    }
    init_flag = false;
    return 0;
}

int gl_game_plugins_init_game(uint8 gameCode, GAME_PLUGIN_INTERFACE *out)
{
    //问题：1、game->used无法判断 2、插件中的gl_game_plugins_close-->dlclose，不会真正释放
    
    if (out->gameCode != 0)
    {
        return 0;
    }
    char shm_libname[MAX_GAME_NAME_LENGTH];
    char abbr[15] = {0};

    get_game_abbr(gameCode, abbr);

    GAME_PLUGIN_INTERFACE *gpi = out;
    gpi->gameCode = gameCode;

    //初始化游戏插件动态库
    memset(shm_libname, 0, sizeof(shm_libname));
    sprintf(shm_libname, "libgl_%s.so", abbr);
    if (!load_plugin_interface(gpi, shm_libname))
    {
        log_error("load_plugin_interface( %d ) failed.", gameCode);
        return -1;
    }

    return 0;
}

//使用游戏插件初始化
int gl_game_plugins_init()
{
    uint8 gameCode = 0;
    char shm_libname[MAX_GAME_NAME_LENGTH];

    for (gameCode = 0; gameCode < MAX_GAME_NUMBER; gameCode++)
    {
        GAME_DATA* game_ptr = gl_getGameData(gameCode);

        GAME_PLUGIN_INTERFACE *gpi = &game_plugin_funs[game_ptr->gameEntry.gameCode];
        gpi->gameCode = gameCode;

        if (!game_ptr->used)
            continue;

        //初始化游戏插件动态库
        memset(shm_libname, 0, sizeof(shm_libname));
        sprintf(shm_libname, "libgl_%s.so", game_ptr->gameEntry.gameAbbr);
        if (!load_plugin_interface(gpi, shm_libname))
        {
            log_error("load_plugin_interface( %d ) failed.", gameCode);
            return -1;
        }

        //attach共享内存
        if (false == gpi->mem_attach())
        {
            log_error("mem_attach( gameCode[%d] ) failed!", gameCode);
            return -1;
        }

        log_info("gl_game_plugins_init( gamecode:%d ) success.", gameCode);
    }
    init_flag = true;
    return 0;
}

//使用游戏插件完成关闭
int gl_game_plugins_close()
{
    uint8 gameCode = 0;
    for (gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        GAME_DATA* game_ptr = gl_getGameData(gameCode);
        GAME_PLUGIN_INTERFACE *gpi = &game_plugin_funs[game_ptr->gameEntry.gameCode];

        if (!game_ptr->used)
            continue;

        if (!gpi->mem_detach())
        {
            log_error("mem_detach( gameCode[%d] ) failed!", gameCode);
            return -1;
        }

        release_plugin_interface(gpi);

        log_info("gl_game_plugins_close( gamecode:%d ) success.", gameCode);
    }
    init_flag = false;
    return 0;
}


GAME_PLUGIN_INTERFACE *gl_plugins_handle()
{
    if(init_flag)
        return game_plugin_funs;
    return NULL;
}



//使用游戏插件初始化(不attach共享内存)
//供期结开奖流程使用，使之可独立于主机进行
bool init_flag_s = false;

GAME_PLUGIN_INTERFACE game_plugin_funs_s;

GAME_PLUGIN_INTERFACE *gl_plugins_handle_s(uint8 game_code)
{
    if(init_flag_s)
        return &game_plugin_funs_s;

    char shm_libname[MAX_GAME_NAME_LENGTH];

    GAME_PLUGIN_INTERFACE *gpi = &game_plugin_funs_s;
    gpi->gameCode = game_code;

    //初始化游戏插件动态库
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    memset(shm_libname, 0, sizeof(shm_libname));
    sprintf(shm_libname, "libgl_%s.so", game_abbr);
    if (!load_plugin_interface(gpi, shm_libname))
    {
        log_error("load_plugin_interface( %d ) failed.", game_code);
        return NULL;
    }
    init_flag_s = true;

    return &game_plugin_funs_s;
}




//----- 游戏插件使用的通用函数定义 -----------------------------------------------------------------------------

uint8 bitToUint8(
        const uint8* bitArr,
        uint8 * const numArr,
        const uint8 bitSize,
        const uint8 bitBase)
{
    int narr_size = 0, mask = 0x01;

    for (int idx = 0; idx < bitSize; idx++)
    {
        uint16 uval = bitArr[idx] & 0xff;

        for (int jdx = 0; uval != 0 && jdx < 8; jdx++, uval >>= 1)
        {
            if ((uval & mask) != 0)
            {
                numArr[narr_size++] = idx * 8 + jdx + bitBase;
            }
        }
    }

    return narr_size;
}

int num2bit(
        const uint8 num[],      //待转换的数组
        uint8 len,              //待转换的个数
        uint8 bit[],            //数组存放转换后的bitmap
        uint8 bitOff,           //从bit数组的第几个字节开始进行转换
        uint8 base)             //最小的数  如 0:3D 1:SSQ....
{
    short quot = 0; //商
    short remd = 0; //余数
    for (int idx = 0; idx < len; idx++) {
        if (*(num+idx) < base) {
            log_error("num2bit fail. num[%d]base[%d]", *(num+idx), base);
            return -1;
        }
        quot = (*(num+idx) - base) / 8;
        remd = (*(num+idx) - base) % 8;

        *(bit + bitOff + quot) |= 1 << remd;
    }

    return 0;
}


int bit2num(
        const uint8 bit[],     //bitmap数组
        uint8 len,             //bitmap的长度
        uint8 num[],           //转换为数字的数组，并且数字由小到大排列
        uint8 base)            //最小的数  如 0:3D 1:SSQ....
{
    int numCnt = 0, mask = 0x01;

    for (int idx = 0; idx < len; idx++)
    {
        uint16 uval = bit[idx] & 0xff;

        for (int jdx = 0; uval != 0 && jdx < 8; jdx++, uval >>= 1)
        {
            if ((uval & mask) != 0) //取出最低有效比特
            {
                num[numCnt++] = idx * 8 + jdx + base;
            }
        }
    }

    return numCnt;
}

// 计算uint8 arr[len]中一共有多少个bit为1的位，从下标为off的字节开始计算
int bitCount(const uint8 *arr, uint8 off, uint8 len)
{
    int bitCnt = 0;

    for (int idx = 0; idx < len; idx++) {
        uint8 uval = arr[idx+off];
        for (; uval > 0; bitCnt += 1, uval &= (uval-1)) {
            ;
        }
        //        for (; uval > 0; bitcnt += uval & 0x1, uval >>= 1)
        //        {
        //            ;
        //        }
    }
    return bitCnt;
}

// 两个uint8数组按位做逻辑'与'操作
int bitAnd(
        const uint8* arr1,
        uint8 arr1Off,
        const uint8* arr2,
        uint8 arr2Off,
        uint8 len,
        uint8* ret)
{
    //printf("andBitsArray:%p,%d,%p,%d,%d,%p\n", andArr,andOff,cmpArr,cmpOff,andLen,result);

    for (int idx = 0; idx < len; idx++) {
        ret[idx] = arr1[arr1Off+idx] & arr2[arr2Off+idx];
    }

    return 0;
}

int bitHL2num(
        const uint8 *arr,
        uint8 off,
        uint8 len,
        int flagHL,//0:最低位 1：最高位
        int base)//ssq:1  3D:0....
{
    int bitpos = 0;
    int bitmove = 1;

    if (0 == flagHL) {//返回最低位代表的数字
        for (int idx = 0; idx<len; idx++) {
            uint8 uval = arr[idx+off];

            for (; uval>0; uval >>= 1) {
                if (uval&0x1) {
                    bitpos = bitmove;
                    return bitpos - 1 + base;
                }
                bitmove++;
            }
            bitmove = (idx+1)*8+1;
        }
    } else {
        for (int idx = 0; idx<len; idx++) {
            uint8 uval = arr[idx+off];

            for (; uval>0; uval >>= 1) {
                if (uval&0x1) {
                    bitpos = bitmove;
                }
                bitmove++;
            }
            bitmove = (idx+1)*8+1;
        }
        if (0 != bitpos) {
            return bitpos - 1 + base;
        }
    }
    return -1;
}


uint32 drawnumDistribute(
        const uint8 xcode[],
        uint8 len)
{
#define LENGTH (2048)
    int arrvar[LENGTH] = {0};
    int cnt = 0;
    int ret = 0;

    for (int idx = 0; idx<len; idx++) {
        arrvar[xcode[idx]]++;
    }

    //排序
    for (int idx = 0; idx<LENGTH-1; idx++) {
        int kdx = idx;
        for (int jdx = idx+1; jdx<LENGTH; jdx++) {
            if (arrvar[kdx]<arrvar[jdx]) {
                kdx = jdx;
            }
        }
        if (kdx!=idx) {
            int var = arrvar[idx];
            arrvar[idx] = arrvar[kdx];
            arrvar[kdx] = var;
        }
    }

    for (int idx = 0; idx<LENGTH; idx++) {
        if (0!=arrvar[idx]) {
            cnt++;
        } else {
            break;
        }
    }
    for (int idx = 0; idx<cnt; idx++) {
        ret += arrvar[idx]*(uint32)pow(10.0, 8-idx-1);
    }
    return ret;
}

uint32 mathpow(int base, int expr)
{
    uint32 result=1;
    for(int idx=0;idx<expr;idx++){
        result*=base;
    }
    return result;
}

// 从base中组合选expr个数 $C_{base}^{expr}$
uint32 mathc(
        int8 base,
        int8 expr)
{
    if (base > MAX_C)
    {
        perrork("mathc exceed boundary %d...", base);
        return 0;
    }
    else
    {
        if ((base < 0) || (expr < 0) || (expr > base))
        {
            return 0;
        }
        else if ((expr == 0) && (base >= 0))
        {
            return 1;
        }
        else
        {
            return CacheC[base][expr];
        }
    }
}

uint32 mathp(
        int8 base,
        int8 expr)
{
    if ((base > MAX_P))
    {
        perrork("mathp exceed boundary %d...", base);
        return 0;
    }
    else
    {
        if ((base < 0) || (expr < 0) || (expr > base))
        {
            return 0;
        }
        else if ((expr == 0) && (base >= 0))
        {
            return 1;
        }
        else
        {
            return CacheP[base][expr];
        }
    }
}

// 检查投注行倍数是否大于交易控制参数中的倍数限制
int gl_verifyLineParam(uint8 gameCode, uint16 times)
{
    TRANSCTRL_PARAM* transctrlParam = gl_getTransctrlParam(gameCode);
    if ((transctrlParam==NULL)||(times > transctrlParam->maxTimesPerBetLine)) {
        //LOG
        return -1;
    }
    return 0;
}

// 将bettype的低四位存储的数值放入num[0]
// 若bettype的高四位非零，则将高四位存储的数值放入num[1]
int bettype2num(uint8 bettype, uint8 num[])
{
    if (bettype < 16) {
        num[0] = bettype;
        num[1] = 0;
    } else {
        num[0] = bettype & 0x0f;
        num[1] = (bettype & 0xf0) >> 4;
    }
    return 0;
}

// 将num[0]存储的数值放入bettype的低四位
// 若num[1]非零，则将num[1]放入bettype的高四位
int num2bettype(const uint8 num[], uint8 *bettype)
{
    *bettype = num[0];
    if (num[1] != 0) {
        *bettype = *bettype | num[1] << 4;
    }
    return 0;
}

// bettype: 在SUBTYPE中存储的bettype字段，以按位的方式存储该玩法支持的所有投注方式
// 检查某一玩法是否支持投注行中所包含的投注方式
int gl_bettypeVerify(
        uint32 bettype,
        const BETLINE *betline)
{
    uint8 num[2] = {0};
    int ret = 0;
    bettype2num(betline->bettype, num);

    ret = bettype & (0x1 << num[0]); //检查bettype中存储num[0]投注方式的位是否为1
    if ( 0 == ret ) {
        return -1;
    }

    if (num[1] != 0) {
        ret = bettype & (0x1 << (num[1] + 16)); //B区的投注方式存储在bettype的高16位
        if ( 0 == ret ) {
            return -1;
        }
    }

    return 0;
}

////////////////format  ticket /////////////////////////

//去掉字符串头尾部的空格字符
char *strtrim(char *string)
{
    char str[1024] = {0};
    int i = 0;
    int j = strlen(string) - 1;

    while (*(string + j) == ' ')
    {
        j--;
    }

    while (*(string + i) == ' ')
    {
        i++;
    }

    if (i > j)
    {
        return NULL;
    }

    memcpy(str, string + i, j - i + 1);
    memset(string, 0, strlen(string));
    memcpy(string, str, j - i + 1);

    return string;
}

const char betMode[MAX_GAME_NUMBER][MAX_SUBTYPE_COUNT][MAX_BETTYPE_COUNT] = {
    //0
    {{0}},

    //SSQ(1)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //ZX
        {0, MODE_JC, MODE_JC, MODE_JC},
    },

    //3D(2)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //ZX
        {0, MODE_FD, 0,       MODE_JC, 0,       MODE_JS, MODE_JC, MODE_FD, MODE_FD},
        //ZUX
        {0, 0,       0,       0,       MODE_FD, MODE_JS, 0,       0,       0},
        //Z3
        {0, MODE_FD, MODE_JC},
        //Z6
        {0, MODE_JC, MODE_JC},
    },

    //KENO(3)
    {{0}},

    //7LC(4)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //ZX
        {0, MODE_JC, MODE_JC, MODE_JC},
    },

    //SSC(5)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //1ZX
        {0, MODE_JC, MODE_JC, 0,       0,       0,       0,       0,       0},
        //2ZX
        {0, MODE_FD, 0,       0,       0,       MODE_JS, 0,       0,       MODE_FD},
        //2FX
        {0, MODE_FD, 0,       0,       0,       0,       0,       0,       0},
        //2ZUX
        {0, MODE_JC, MODE_JC, 0,       MODE_FD, MODE_JS, 0,       0,       MODE_FD},
        //3ZX
        {0, MODE_FD, 0,       0,       0,       MODE_JS, MODE_JC, 0,       MODE_FD},
        //3FX
        {0, MODE_FD, 0,       0,       0,       0,       0,       0,       0},
        //3ZUX
        {0, 0,       0,       0,       MODE_FD, MODE_JS, 0,       0,       0},
        //3Z3
        {0, MODE_FD, MODE_JC, 0,       0,       0,       0,       0,       0},
        //3Z6
        {0, MODE_JC, MODE_JC, 0,       0,       0,       0,       0,       0},
        //5ZX
        {0, MODE_FD, 0,       0,       0,       0,       0,       0,       MODE_FD},
        //5FX
        {0, MODE_FD, 0,       0,       0,       0,       0,       0,       0},
        //5TX
        {0, MODE_FD, 0,       0,       0,       0,       0,       0,       0},
        //DXDS
        {0, MODE_FD, 0,       0,       0,       0,       0,       0,       0},
    },

    //KOCTTY(6)
    {
      //{0, DS,      FS,      DT,        BD,         HZ,          BC,        BH,        YXFS,     FW},
        {0},
        //QH2
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
        //QH3
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
        //4ZX
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
        //Q2
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
        //H2
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
        //Q3
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
        //H3
        {0, MODE_FD, 0,       0,       MODE_FD,       0,       MODE_JC,       0,       MODE_FD,  MODE_YS},
    },

    //KOC7LX(7)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //ZX
        {0, MODE_JC, MODE_JC, MODE_JC, 0,       0,       0,       0,       0},
        //ZXHALF
        {0, MODE_JC, MODE_JC, MODE_JC, 0,       0,       0,       0,       0},
    },

    //KOCKENO(8)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
    	{0},
    	//X1
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X2
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X3
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X4
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X5
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X6
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X7
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X8
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X9
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//X10
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//DX
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    	//DS
    	{0, MODE_JC, 0,       0,       0,       0,       0,       0,       0},
    },

    //KOCK2(9)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //JC
        {0, MODE_JC, MODE_JC, 0,       0,       0,       0,       0,       0},
        //4T
        {0, MODE_JC, MODE_JC, 0,       0,       0,       0,       0,       0},
    },
    //KOCC30S6(10)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        {0},
        //ZX
        {0, MODE_JC, MODE_JC, MODE_JC, 0,       0,       0,       0,       0},
    },
    //KOCK3(11)
    {
      //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
    	{0},
    	//ZX
    	{0, 0,       0,       0,       0,       MODE_JS, 0,       0,       0},
    	//3TA
    	{0, MODE_YS, 0,       0,       0,       0,       0,       0,       0},
    	//3TS
    	{0, MODE_YS, 0,       0,       0,       0,       0,       0,       0},
    	//3QA
    	{0, MODE_YS, 0,       0,       0,       0,       0,       0,       0},
    	//3DS
    	{0, MODE_YS, 0,       0,       0,       0,       0,       0,       0},
    	//2TA
    	{0, MODE_JS, 0,       0,       0,       0,       0,       0,       0},
    	//2TS
    	{0, MODE_YS, 0,       0,       0,       0,       0,       0,       0},
    	//2DS
    	{0, MODE_JS, 0,       0,       0,       0,       0,       0,       0},

    },

    //KOC11X5(12)
	{
		//{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
		{ 0 },
		//RX2
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//RX3
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//RX4
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//RX5
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//RX6
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//RX7
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//RX8
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//Q1
		{ 0, MODE_JC,  MODE_JC, 0,        0,     0,       0,       0,       0 },
		//Q2ZU
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//Q3ZU
		{ 0, MODE_JC,  MODE_JC, MODE_FD,  0,     0,       0,       0,       0 },
		//Q2ZX
		{ 0, MODE_FD,  0,       0,        0,     0,       0,       0,       MODE_FD },
		//Q3ZX
		{ 0, MODE_FD,  0,       0,        0,     0,       0,       0,       MODE_FD },
	},

    //TEMA(13)
    {
        //{0, DS,      FS,      DT,      BD,      HZ,      BC,      BH,      YXFS},
        { 0 },
        // DG
        { 0, MODE_JC, MODE_JC,  0,       0,       0,       0,       0,      0 },
        // WH
        { 0, MODE_JC, MODE_JC,  0,       0,       0,       0,       0,      0 },
    },
};

int gl_gameCode(char str[])
{
    char abbr[8] = {0};
    for (int i = 0; i < MAX_GAME_NUMBER; i++) {
        memset(abbr, 0, sizeof(abbr));
        get_game_abbr(i, abbr);

        if (strcmp(str, abbr) == 0) {
            return i;
        }
    }
    return -1;
}

int gl_bettype(char str[][10], uint8 *bettype)
{
    uint8 num[2] = {0};
    for (int j = 0; ; j++) {
        if (strcmp(str[j], "") == 0) {
            break;
        }

        for (int i = 0; i < MAX_BETTYPE_COUNT; i++) {
            if (strcmp(str[j], bettypeAbbr[i]) == 0) {
                num[j] = i;
                break;
            }
        }
    }

    num2bettype(num, bettype);

    return num[0]; //返回A区投注方式枚举值
}

int gl_subtype(char str[], int gameCode)
{
    for (int i = 0; i < 32; i++) {
        if (strcmp(str, subtypeAbbr[gameCode][i]) == 0) {
            return i;
        }
    }
    return -1;
}

int gl_mode(int gameCode, uint8 subtype, uint8 bettype)
{
    switch (gameCode) {
        case GAME_SSQ:
            return MODE_JC;
            break;
        case GAME_3D:
        case GAME_7LC:
        case GAME_SSC:
        case GAME_KOCKENO:
        case GAME_KOCTTY:
        case GAME_KOC7LX:
        case GAME_KOCK2:
        case GAME_KOCC30S6:
        case GAME_KOCK3:
		case GAME_KOC11X5:
        case GAME_TEMA:
            return betMode[gameCode][subtype][bettype];
            break;

        default:
            return 0;
            break;
    }

    return 0;
}

// 将投注号码区括号里的投注号码拆分成若干部分放入BETPART_STR结构体中，便于以后解析
int splitBetpart(const char buf[], BETPART_STR *bpStr, int flag)
{
    //flag(0: 默认值 1: TTY.FW)

    int i = 0;
    char str[500] = {0};
    strcpy(str, buf);

    // 将投注号码中以冒号':'分隔的各部分析出，放入BETPART_STR结构体bpALL中
    char *p = NULL;
    char *last = NULL;
    p = strtok_r(str, ":", &last);
    for (i = 0; ; i++) {
        if (p == NULL) {
            break;
        }

        strcpy(bpStr->bpALL[i], strtrim(p));
        p = strtok_r(NULL, ":", &last);
    }
    bpStr->bpALLCnt = i; //记录以冒号分隔部分的个数,无冒号时i=1

    // 将bpALL[0]中以小于号'<'分隔的两部分析出，放入BETPART_STR结构体bpADT中
    p = strtok_r(bpStr->bpALL[0], "<", &last);
    for (i = 0; ; i++) {
        if (p == NULL) {
            break;
        }

        strcpy(bpStr->bpADT[i], strtrim(p));
        p = strtok_r(NULL, "<", &last);
    }
    bpStr->bpADTCnt = i; //记录以小于号分隔部分的个数(1无胆拖2有胆拖)

    // 将bpADT[0]中以加号'+'分隔的各部分析出，每一个数当作一个uint8,
    // 放入BETPART_STR结构体bpAE[0]中
    // 如果解析到一个星号'*'，则将bpAE[0]的前十位设为0到9，并将bpAECnt[0]设为10
    p = strtok_r(bpStr->bpADT[0], "+", &last);
    for (i = 0; ; i++) {
        if (p == NULL) {
            break;
        }

        if (strcmp(strtrim(p), "*") == 0) {
            for (int k = 0; k < 10; k++)
            {
                bpStr->bpAE[0][k] = k;
            }
            i = 10;
            break;
        } else {
            if (1 == flag)
            {
                strcpy(bpStr->bpAE[0], p);//TTY->FW, 注意字符数字
            }
            else
            {
                bpStr->bpAE[0][i] = atoi(p);
            }

            p = strtok_r(NULL, "+", &last);
        }
    }
    bpStr->bpAECnt[0] = i; //记录以加号分隔部分的个数

    // 如果存在拖码，则将拖码bpADT[1]中以加号'+'分隔的各部分析出，每一个数当作一个uint8，
    // 放入BETPART_STR结构体bpAT中。
    if (2 == bpStr->bpADTCnt) {
        p = strtok_r(bpStr->bpADT[1], "+", &last);
        for (i = 0; ; i++) {
            if (p == NULL) {
                break;
            }

            bpStr->bpAT[i] = atoi(p);
            p = strtok_r(NULL, "+", &last);
        }
        bpStr->bpATCnt = i; //记录以加号分隔部分的个数
    }

    // 将bpALL中剩下的各部分(从bpALL[1]开始)中以加号分隔的投注号析出，每一个数当作一个uint8，
    // 放入BETPART_STR结构体bpAE的对应部分里，并将各对应部分的bpAECnt置为正确的值。
    // 如果在解析下标为j的部分时看到到一个星号'*'，则将bpALL[j]的前十位设为0到9，
    // 将bpAECnt[j]设为10，并跳出循环开始解析下标为j+1的部分。
    for (int j = 1; j < bpStr->bpALLCnt; j++) {
        p = strtok_r(bpStr->bpALL[j], "+", &last);
        for (i = 0; ; i++) {
            if (p == NULL) {
                break;
            }
            if (strcmp(strtrim(p), "*") == 0) {
                for (int k = 0; k < 10; k++)
                {
                    bpStr->bpAE[j][k] = k;
                }
                i = 10;
                break;
            } else {
                if (1 == flag)
                {
                    strcpy(bpStr->bpAE[j], p);//TTY->FW
                }
                else
                {
                    bpStr->bpAE[j][i] = atoi(p);
                }

                p = strtok_r(NULL, "+", &last);
            }
        }
        bpStr->bpAECnt[j] = i;
    }

    return 0;
}

//根据游戏名缩写，得到游戏编码，游戏不可用返回0，失败返回-1
int gl_formatGame(const char *betStr)
{
    // 投注字符串betStr在本函数里的一份拷贝
    char str[100] = {0};
    char *p = NULL;
    char *last = NULL;
    int gameCode = 0;
    memcpy(str, betStr, 20);

    // 将投注字符串中以竖杠'|'分隔的各部分析出
    p = strtok_r(str, "|", &last);
    if (p == NULL)
    {
        log_error("gl_formatTicket [|]NULL");
        return -1;
    }

    // 解析游戏标识
    gameCode = gl_gameCode(strtrim(p));
    if (-1 == gameCode) {
        log_debug("gl_formatGame--game:%s", strtrim(p));
        return -1;
    }

    if (!isGameBeUsed(gameCode))
    {
        log_debug("gl_formatTicket--game:%d not used", gameCode);
        return 0; //游戏不可用
    }

    return gameCode;
}

// 投注字符串的样式
//char str[] = "SSQ|21030814007|8|24000|0|ZX-DS*DS-(1+2+3+4+5+6:7)-1-0/ZX-DS-(1+2+3+4+5+6:7)-1-0/ZX-DS-(1+2+3+4+5+6:7)-1-0";
int gl_formatTicket(const char *betStr, char *ticket_buf, int buf_len)
{
    // 投注字符串betStr在本函数里的一份拷贝
    char str[100+2048] = {0};
    
    // 将投注字符串中以竖杠'|'分隔的各部分析出
    // tkt[0]: 存放游戏标识
    // tkt[1]: 存放期号
    // tkt[2]: 存放期数
    // tkt[3]: 存放总金额
    // tkt[4]: 存放扩展参数
    // tkt[5]: 存放投注行信息
    char tkt[6][2048] = {{0}};

    // 将投注行信息里以斜杠'/'分隔的各投注行析出
    // 每条投注字符串最多有10个投注行
    char lineS[10][200] = {{0}};

    // 将每个投注行中的各个以减号'-'分隔的部分析出
    // line[0]: 玩法
    // line[1]: 投注方式
    // line[2]: 投注号码区
    // line[3]: 倍数
    // line[4]: 投注行扩展参数
    char line[5][200] = {{0}};
    //char bp[2][100] = {{0}};

    char *p = NULL;
    char *last = NULL;
    int i = 0;
    int j = 0;
    int lineCnt = 0;
    int ret = 0;

    TICKET *ticket = (TICKET *)ticket_buf;

    // 将投注字符串拷入本函数的str数组
	if (ticket->betStringLen >= sizeof(str)) {
        log_error("bet string length is too long. length[%d]", ticket->betStringLen);
        return -1;
    }
    memcpy(str, betStr, ticket->betStringLen);
    if (ts_regex_ticket_match(str))
    {
        log_warn("betstr regex error! betStr[%s]", str);
        return -1;
    }

    // 将投注字符串中以竖杠'|'分隔的各部分析出
    p = strtok_r(str, "|", &last);
    if (p == NULL)
    {
        log_error("gl_formatTicket [|]NULL");
        return -1;
    }
    for (i = 0; p != NULL; i++)
    {
        strcpy(tkt[i], strtrim(p));
        p = strtok_r(NULL, "|", &last);
    }

    // 解析游戏标识(tkt[0])，获得游戏编码，拷入ticket结构中
    ret = gl_gameCode(tkt[0]);
    if (-1 == ret) {
        log_debug("gl_formatTicket--game:%s", tkt[0]);
        return -1;
    } else {
        ticket->gameCode = ret;
    }

    // 解析tkt[1]内容，获得期号，拷入ticket结构
    ticket->issue = atoll(tkt[1]);

    // 解析tkt[2]内容，获得期数，拷入ticket结构
    ticket->issueCount = atoi(tkt[2]);

    // 解析tkt[3]内容，获得总金额，拷入ticket结构
    ticket->amount = atoll(tkt[3]);

    // 解析tkt[4]内容，获得扩展参数，拷入ticket结构
    ticket->flag = atoi(tkt[4]);

    // 解析tkt[5]内容，将投注行信息中以斜杠'/'分隔的各投注行析出并放入lineS中
    p = strtok_r(tkt[5], "/", &last);
    if (p == NULL)
    {
        log_error("gl_formatTicket [/]NULL--game:%s", tkt[0]);
        return -1;
    }
    lineCnt = 0;
    for (i = 0; p != NULL; i++) { //如果有多于10个投注行，这里会segfault
        strcpy(lineS[i], strtrim(p));
        p = strtok_r(NULL, "/", &last);
    }

    lineCnt = i;
    ticket->betlineCount = lineCnt; //将投注行个数拷入ticket结构

    char strBettype[2][10] = {{0}}; // 存放投注方式字符串，一个投注行可能有一到两个投注方式
    char strBetline[1024] = {0};
    BETLINE *betline = (BETLINE *)strBetline;
    for (j = 0; j < lineCnt; j++) {
        memset(strBettype, 0, sizeof(strBettype));
        memset(strBetline, 0, sizeof(strBetline));

        // 将每个投注行中的各个以减号'-'分隔的部分析出
        p = strtok_r(lineS[j], "-", &last);
        if (p == NULL)
        {
            log_error("gl_formatTicket [-]NULL--game:%s", tkt[0]);
            return -1;
        }
        for (i = 0; p != NULL; i++) {
            strcpy(line[i], strtrim(p));
            p = strtok_r(NULL, "-", &last);
        }

        // 解析line[0]内容，获得玩法索引值，拷入betline结构
        ret = gl_subtype(line[0], ticket->gameCode);
        if (-1 == ret) {
            log_debug("gl_formatTicket--subtype:%s", line[0]);
            return -1;
        } else {
            betline->subtype = ret;
        }

        // 解析line[1]内容，获得投注方式，放入strBettype[0]中。如果存在AB区两种投注方式，
        // 则A区投注方式存入strBettype[0]中，B区投注方式存入strBettype[1]中。
        p = strtok_r(line[1], "*", &last);
        for (i = 0; p != NULL; i++) {
            strcpy(strBettype[i], strtrim(p));
            p = strtok_r(NULL, "*", &last);
        }
        // 将解析下来的投注方式拷入betline结构体的bettype字段中
        // (如果存在AB区两种投注方式，则这个uint8的bettype字段里低四位存放A区投注方式枚举值，
        // 高四位存放B区投注方式枚举值)
        // 函数gl_bettype只返回A区投注方式枚举值
        int bettypeNum = gl_bettype(strBettype, &betline->bettype);
        if(bettypeNum == 0)
        {
            log_error("gl_bettype return 0" );
            return -1;
        }

        // 解析line[3]内容，获得倍数，放入betline结构
        betline->betTimes = atoi(line[3]);

        // 解析line[4]内容，获得投注行扩展参数，放入betline结构
        betline->flag = atoi(line[4]);

        // (以下内容)解析line[2]内容，获得投注号码区的号码
        char bpStr[200] = {0};

        if (strlen(line[2]) < 2)
        {
            log_error("gl_formatTicket line[2] error, line[2]=%s,ticket=%s", line[2], betStr);
            return -1;
        }
        int len = (strlen(line[2]) - 2) > 0 ? (strlen(line[2]) - 2) : 0;
        // 删掉号码区的括号
        memcpy(bpStr, &line[2][1], len);

        if (ts_regex_bettype_match(betline->bettype,bpStr))
        {
            log_warn("ts_regex_bettype_match error!");
            return -1;
        }

        // 通过游戏编码，玩法索引值，投注方式获得bitmap模式
        int mode = gl_mode(ticket->gameCode, betline->subtype, bettypeNum);

        // 调用游戏插件，填充betline结构中的betCount，singleAmount，bitmapLen和bitmap字段
        GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();
        ret = game_plugins_handle[ticket->gameCode].format_ticket(bpStr, sizeof(bpStr), mode, betline);
        if (ret != 0 ) {
            log_error("game_plugins_handle.format_ticket fail.game[%d]", ticket->gameCode);
            return -1;
        }

        // 把这个新做好的betline拷到ticket结构中去
        memcpy(ticket->betString + ticket->betStringLen + ticket->betlineLen, (char*)betline, sizeof(*betline) + betline->bitmapLen);

        // 最后更新ticket结构中保存的全部betline长度
        ticket->betlineLen += sizeof(*betline) + betline->bitmapLen;

        ticket->betCount += betline->betCount * betline->betTimes * ticket->issueCount;
    }

    ticket->length = sizeof(TICKET) + ticket->betStringLen + ticket->betlineLen;

    if (ticket->length > buf_len) {
        log_error("ticket->len[%d], buf_len[%d]", ticket->length, buf_len);
        return -1;
    }

    return 0;
}

void gl_dumpTicket(TICKET *ticket)
{
    char tmp = ticket->betString[ticket->betStringLen];
    ticket->betString[ticket->betStringLen] = '\0';

    char space1[] = {"    "};
    char space2[] = {"        "};
    char space3[] = {"             "};

    fprintf(stderr, "\nTicket  ----------------->\n");

    fprintf(stderr, "%s length[%d] game[%d] issue[%llu] amount[%lld]\n",
            space1, ticket->length, ticket->gameCode, ticket->issue, ticket->amount);

    fprintf(stderr, "%s issueSerial[%d] issueCount[%d] lastIssue[%llu] betlineCount[%d] betCount[%d]\n",
            space1, ticket->issueSeq, ticket->issueCount, ticket->lastIssue, ticket->betlineCount, ticket->betCount);

    fprintf(stderr, "%s isTrain[%d] flag[%d] betStringLen[%d] betlineLen[%d]\n",
            space1, ticket->isTrain, ticket->flag, ticket->betStringLen, ticket->betlineLen);

    fprintf(stderr, "  >> %s\n", ticket->betString);

    ticket->betString[ticket->betStringLen] = tmp;

    fprintf(stderr, "%s Betline  ----------->\n", space1);
    const BETLINE *bl = (BETLINE*)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++)
    {
        fprintf(stderr, "%s <%02d> subtype[%d] bettype[%d] betTimes[%u] flag[%u]\n",
                space2, idx, bl->subtype, bl->bettype, bl->betTimes, bl->flag);

        fprintf(stderr,"%s singleAmount[%lld] betCount[%d] bitmapLen[%u]\n",
                space3, bl->singleAmount, bl->betCount, bl->bitmapLen);

        fprintf(stderr, "%s ", space3);
        for (int jdx = 0; jdx < bl->bitmapLen; jdx++)
        {
            fprintf(stderr, "%02x ", (unsigned char)bl->bitmap[jdx]);
            if ((jdx+1) % 16 == 0)
            {
                if (jdx != (bl->bitmapLen-1))
                {
                    fprintf(stderr, "\n%s ", space3);
                }
            }
        }
        fprintf(stderr, "\n");

        bl = (BETLINE*)GL_BETLINE_NEXT(bl);
    }

    fprintf(stderr, "\n");

    fflush(stderr);
    return;
}


void swap_p(uint8 str[], int a, int b)
{
    uint8 temp = str[a];
	str[a] = str[b];
	str[b] = temp;
}

void permutation(uint8 arr[], int begin, int end, uint8 post[][5], int *idx)
{
    if (begin == end)
    {
        for (int i = 0; i <= end; i++)
        {
            post[*idx][i] = arr[i];
        }
        (*idx)++;
        return;
    }
    else
    {
        for (int j = begin; j <= end; j++)
        {
            swap_p(arr, begin, j);
            permutation(arr, begin + 1, end, post, idx);
            swap_p(arr, j, begin);
        }
    }
}

bool next_comb(int* comb, const int n, const int k)
{
	int i = k - 1;
	const int e = n - k;
	do
		comb[i]++;
	while (comb[i] > e + i && i--);
	if (comb[0] > e)
		return 0;
	while (++i < k)
		comb[i] = comb[i - 1] + 1;
	return 1;
}

int combintion(int n, int k, uint8 post[][4])
{
	int count = 0;
	int comb[4] = { -1 };

	for (int i = 0; i < k; i++)
		comb[i] = i;
	do
	{
		for (int i = 0; i < k; i++)
		{
			post[count][i] = comb[i];
		}
		count++;
	} while (next_comb(comb, n, k));
	return count;
}

//typedef struct _BETLINE
//{
//    ---uint8   subtype; //玩法
//    ---uint8   bettype; //投注方式
//    ---uint16  betTimes; //倍数
//    ---uint16  flag; //投注行扩展参数
//       money_t singleAmount;//单注金额(分);
//
//    uint16  betCount; //投注行注数
//
//    uint8   bitmapLen; //Bitmap长度
//    char    bitmap[];
//}BETLINE;




//typedef struct _TICKET
//{
//    uint16  length;//结构长度，含自身两个字节
//    ---uint8   gameCode;
//    ---uint64  issue; //期号 (*)(售票如果当期期填0，则此GL模块更新此字段为当前期号)
//    uint32  issueSeq; //期次序号 (*)
//    ---uint8   issueCount; //购买期数
//    uint64  lastIssue; //购买的最后一期期号 (*)
//    int16   betCount; //总注数 (*)
//    ---money_t amount; //总金额
//    ---uint16  flag; //票扩展参数
//
//    uint8   isTrain; //是否培训模式: 否(0)/是(1)
//
//    ---uint8   betlineCount; //投注行数
//
//    ---uint16  betStringLen; //投注字符串长度
//
//    uint16  ticketBitmapLen; //投注bitmap长度
//    ---char    betString[]; //投注字符串
//
//    //BETLINE betlines[]; //投注行信息
//}TICKET;







void send_rkNotify(uint8 gameCode,uint64 issue,uint8 subtype, char *betString)
{
	GLTP_MSG_NTF_GL_RISK_CTRL notify;
    notify.gameCode = gameCode;
    notify.issueNumber = issue;
    notify.subType = subtype;
    memset(notify.betNumber,0,sizeof(notify.betNumber));
    memcpy(notify.betNumber,betString,strlen(betString));
    sys_notify(GLTP_NTF_GL_RISK_CTRL, _INFO, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_RISK_CTRL));
}



uint16 gl_sortArray(const uint8 array[],int count)
{
	uint16 end = 0;
	uint16 times = 1;
	uint8 ret[10] = {0};
	for(int i = 0; i < count; i++)
	{
		ret[array[i]]++;
	}
	for(int j = 9; j >= 0; j--)
	{
		for(int k = 0; k < ret[j]; k++)
		{
			end += j * times;
			times *= 10;
		}
	}
	return end;
}


const char *ISSUE_STATE_STR(uint32 type)
{
    switch (type) {
        case ISSUE_STATE_RANGED:
            return "ISSUE_STATE_RANGED";
        case ISSUE_STATE_PRESALE:
            return "ISSUE_STATE_PRESALE";
        case ISSUE_STATE_OPENED:
            return "ISSUE_STATE_OPENED";
        case ISSUE_STATE_CLOSING:
            return "ISSUE_STATE_CLOSING";
        case ISSUE_STATE_CLOSED:
            return "ISSUE_STATE_CLOSED";
        case ISSUE_STATE_SEALED:
            return "ISSUE_STATE_SEALED";
        case ISSUE_STATE_DRAWNUM_INPUTED:
            return "ISSUE_STATE_DRAWNUM_INPUTED";
        case ISSUE_STATE_MATCHED:
            return "ISSUE_STATE_MATCHED";
        case ISSUE_STATE_FUND_INPUTED:
            return "ISSUE_STATE_FUND_INPUTED";
        case ISSUE_STATE_LOCAL_CALCED:
            return "ISSUE_STATE_LOCAL_CALCED";
        case ISSUE_STATE_PRIZE_ADJUSTED:
            return "ISSUE_STATE_PRIZE_ADJUSTED";
        case ISSUE_STATE_PRIZE_CONFIRMED:
            return "ISSUE_STATE_PRIZE_CONFIRMED";
        case ISSUE_STATE_DB_IMPORTED:
            return "ISSUE_STATE_DB_IMPORTED";
        case ISSUE_STATE_ISSUE_END:
            return "ISSUE_STATE_ISSUE_END";
        default:
            return "unknown issue state";
    }
    return "unknown issue state";
}

const char *ISSUE_STATE_STR_S(uint32 type)
{
    switch(type)
    {
        case ISSUE_STATE_RANGED:
            return "RANGED";
        case ISSUE_STATE_PRESALE:
            return "PRESALE";
        case ISSUE_STATE_OPENED:
            return "OPENED";
        case ISSUE_STATE_CLOSING:
            return "CLOSING";
        case ISSUE_STATE_CLOSED:
            return "CLOSED";
        case ISSUE_STATE_SEALED:
            return "SEALED";
        case ISSUE_STATE_DRAWNUM_INPUTED:
            return "DRAWNUM_INPUTED";
        case ISSUE_STATE_MATCHED:
            return "MATCHED";
        case ISSUE_STATE_FUND_INPUTED:
            return "FUND_INPUTED";
        case ISSUE_STATE_LOCAL_CALCED:
            return "LOCAL_CALCED";
        case ISSUE_STATE_PRIZE_ADJUSTED:
            return "PRIZE_ADJUSTED";
        case ISSUE_STATE_PRIZE_CONFIRMED:
            return "PRIZE_CONFIRMED";
        case ISSUE_STATE_DB_IMPORTED:
            return "DB_IMPORTED";
        case ISSUE_STATE_ISSUE_END:
            return "ISSUE_END";
        default:
            return "UNKNOW";
    }
    return "UNKNOW";
}

const char *ISSUE_STATE_STR_S_FBS(uint32 type)
{
    switch(type)
    {
        case M_STATE_ARRANGE:
            return "RANGED";
        case M_STATE_OPEN:
            return "OPENED";
        case M_STATE_CLOSE:
            return "CLOSED";
        case M_STATE_RESULT:
            return "DRAWNUM_INPUTED";
        case M_STATE_DRAW:
            return "LOCAL_CALCED";
        case M_STATE_CONFIRM:
            return "PRIZE_CONFIRMED";
        default:
            return "UNKNOW";
    }
    return "UNKNOW";
}



//  FBS 相关 --------------------------------------------------------------------

//投注方式字符串
const char *BetTypeString[BET_15C1+1] = {
    "",
    "1C1",
    "2C1",
    "2C3",
    "3C1",
    "3C4",
    "3C7",
    "4C1",
    "4C5",
    "4C11",
    "4C15",
    "5C1",
    "5C6",
    "5C16",
    "5C26",
    "5C31",
    "6C1",
    "6C7",
    "6C22",
    "6C42",
    "6C57",
    "6C63",
    "7C1",
    "8C1",
    "9C1",
    "10C1",
    "11C1",
    "12C1",
    "13C1",
    "14C1",
    "15C1"
};

int gl_fbs_bettype(char *str)
{
    for (int i = 0; i < BET_15C1 + 1; i++) {
        if (strcmp(str, BetTypeString[i]) == 0) {
            return i;
        }
    }
    return -1;
}

int gl_fbs_formatTicket(const char *betStr, char *ticket_buf, int buf_len)
{
	int ret = 0;
    // 投注字符串betStr在本函数里的一份拷贝
	char str[100+2048] = {0};
	char tkt[9][2048] = {{0}};
	char strMatch[50][100] = {{0}};
	char strTmp[100] = {0};
	//uint16 matchCode[100] = {0};
	//每场比赛投注的结果数组,数组下标对应比赛场次,每个字节代表这场比赛选择的结果数目(相当于复式),只投注一个结果就填1
	//char matchBetOption[100] = {0};
    char *p = NULL;
    char *last = NULL;
    int i = 0;
    int j = 0;
    int matchCnt = 0;

    FBS_TICKET *ticket = (FBS_TICKET *)ticket_buf;
    memcpy(str, betStr, strlen(betStr));

    // 将投注字符串拷入本函数的str数组
    if (strlen(betStr) >= sizeof(str)) {
        log_error("bet string length is too long. length[%d]", strlen(betStr));
        return -1;
    }
    memcpy(str, betStr, strlen(betStr));

    FBS_BETM *bm = (FBS_BETM*)ticket->data;
    ticket->length = sizeof(FBS_TICKET);

    p = strtok_r(str, "|", &last);
    if (p == NULL)
    {
        log_error("gl_fbs_format_ticket [|]NULL");
        return -1;
    }
    for (i = 0; p != NULL; i++)
    {
        //k-debug
        log_debug("p:%s", p);
        strcpy(tkt[i], strtrim(p));
        p = strtok_r(NULL, "|", &last);
    }

    //解析 游戏标识(tkt[0])，获得游戏编码，拷入ticket结构中
    ret = gl_gameCode(tkt[0]);
    if (-1 == ret) {
        log_debug("gl_fbs_format_ticket--game:%s", tkt[0]);
        return -1;
    } else {
        ticket->game_code = ret;
    }

    // 解析 玩法内容
    ret = gl_subtype(tkt[1], ticket->game_code);
    if (-1 == ret) {
        log_debug("gl_fbs_format_ticket--subtype:%s", tkt[1]);
        return -1;
    } else {
        ticket->sub_type = ret;
    }

    // 解析 过关方式
    ret = gl_fbs_bettype(tkt[2]);
    if (-1 == ret) {
        log_debug("gl_fbs_format_ticket--bettype:%s", tkt[2]);
        return -1;
    } else {
        ticket->bet_type = ret;
    }

    ticket->match_count = atoi(tkt[3]);
    ticket->bet_amount  = atoi(tkt[5]);
    //ticket->bet_count   = atoi(tkt[6]);
    ticket->bet_times   = atoi(tkt[6]);
    ticket->flag        = atoi(tkt[7]);

    //比赛及赛果
    p = strtok_r(tkt[4], "+", &last);
    if (p == NULL)
    {
        log_error("gl_fbs_format_ticket match[+]NULL--game:%s", tkt[0]);
        return -1;
    }
    matchCnt = 0;
    for (i = 0; p != NULL; i++) { //支持<=50场比赛
        strcpy(strTmp, strtrim(p));
        memcpy(strMatch[i], strTmp+1, strlen(strTmp)-2);
        log_info("fbs_format:%s,%s, %d",strMatch[i], strTmp, strlen(strTmp)-2);
        p = strtok_r(NULL, "+", &last);
        if (i > 49) {
        	log_error("gl_fbs_format_ticket (match > 50) --game:%s", tkt[0]);
        	return -1;
        }
    }

    matchCnt = i;
    if (matchCnt != ticket->match_count) {
    	log_error("match count error, cnt_calc[%d] cnt_tkt[%d]", i, ticket->match_count);
    	return -1;
    }

    //解析 FBS_BETM
    for (j = 0; j < matchCnt; j++) {
    	memset(strTmp, 0, sizeof(strTmp));
        p = strtok_r(strMatch[j], ":", &last);
        if (p == NULL)
        {
            log_error("gl_fbs_format_ticket [:]NULL--game:%s", tkt[0]);
            return -1;
        }

        //k-debug:FBS
        log_info("fbs_format:%s,%d",strMatch[j], atoi(strtrim(p)));

        bm->match_code = atoi(strtrim(p));
        p = strtok_r(NULL, ":", &last);
        //赛果
        strcpy(strTmp, strtrim(p));
        p = strtok_r(strTmp, "-", &last);

        log_info("fbs_format:%s",strTmp);
        if (p == NULL)
        {
            log_error("gl_fbs_format_ticket [-]NULL--game:%s", tkt[0]);
            return -1;
        }
        for (i = 0; p != NULL; i++) {
            bm->results[i] = atoi(strtrim(p));
            p = strtok_r(NULL, "-", &last);
            log_info("fbs_format:%d, %d",i, bm->results[i]);
        }
        bm->result_count = i;

        //临时存储
        //matchCode[j] = bm->match_code;
        //matchBetOption[j] = bm->result_count;

        bm++;
    }

    log_info("fbs_format:%d", ((FBS_BETM*)ticket->data)->match_code);
    // 调用游戏插件(calc betCount)
	GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();
	ret = game_plugins_handle[ticket->game_code].fbs_format_ticket(str, ticket);

	ticket->length += (sizeof(FBS_BETM) * matchCnt);
	if (ticket->length > buf_len) {
		ret = -1;
	}
    return ret;
}

void gl_dumpFbsTicket(FBS_TICKET *ticket)
{
    FBS_BETM* tmp = (FBS_BETM*)ticket->data;

    char space1[] = {"    "};
    char space2[] = {"        "};
    char space3[] = {"             "};

    fprintf(stderr, "\nFBS_Ticket  ----------------->\n");

    fprintf(stderr, "%s length[%d] game[%d] issue[%llu] amount[%lld] subType[%d] betType[%d]\n",
            space1, ticket->length, ticket->game_code, ticket->issue_number, ticket->bet_amount, ticket->sub_type, ticket->bet_type);

    fprintf(stderr, "%s betCount[%u] betTimes[%d] matchCount[%d] orderCount[%d] isTrain[%d] flag[%d]\n",
            space1, ticket->bet_count, ticket->bet_times, ticket->match_count, ticket->order_count, ticket->is_train, ticket->flag);

    fprintf(stderr, "%s FBS_BETM  ----------->\n", space1);

    for (int idx = 0; idx < ticket->match_count; idx++)
    {
        fprintf(stderr, "%s <%02d> matchCode[%u] resultCount[%d]\n",
                space2, idx, tmp->match_code, tmp->result_count);

        fprintf(stderr, "%s ", space3);
        for (int jdx = 0; jdx < tmp->result_count; jdx++)
        {
            fprintf(stderr, "%02x ", (unsigned char)tmp->results[jdx]);
            if ((jdx+1) % 16 == 0)
            {
                if (jdx != (tmp->result_count-1))
                {
                    fprintf(stderr, "\n%s ", space3);
                }
            }
        }
        fprintf(stderr, "\n");

        tmp++;
    }

    fprintf(stderr, "\n");

    fflush(stderr);
    return;
}

const char *MATCH_STATE_STR(uint32 type)
{
    switch (type) {
        case M_STATE_ARRANGE:
            return "M_STATE_ARRANGE";
        case M_STATE_OPEN:
            return "M_STATE_OPEN";
        case M_STATE_CLOSE:
            return "M_STATE_CLOSE";
        case M_STATE_RESULT:
            return "M_STATE_RESULT";
        case M_STATE_DRAW:
            return "M_STATE_DRAW";
        case M_STATE_CONFIRM:
            return "M_STATE_CONFIRM";
        default:
            return "unknown match state";
    }
    return "unknown match state";
}














