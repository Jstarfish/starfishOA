
#include "global.h"
#include "sim_rng.h"



//=============测试代码  以下函数(6个)无RNG时使用,为方便测试======begin=====================
int32 get_random_fd(void)
{
    struct timeval tv;
    int fd;
    int i;

    gettimeofday(&tv, NULL);
    fd = open("/dev/urandom", O_RDONLY);
    if (fd == -1) {
        fd = open("/dev/random", O_RDONLY | O_NONBLOCK);
    }

    srand((getpid() << 16) ^ getuid() ^ tv.tv_sec ^ tv.tv_usec);
    /* Crank the random number generator a few times */
    gettimeofday(&tv, NULL);
    for (i = (tv.tv_sec ^ tv.tv_usec) & 0x1F; i > 0; i--) {
        rand();
    }

    return fd;
}
//测试代码
uint32 get_random_uint32(int fd)
{
    int i;
    unsigned int uint32_len = sizeof(unsigned int);
    int rand_uint32 = 0;
    char *cp = (char *)&rand_uint32;
    int lose_counter = 0;

    if (fd >= 0) {
        while (uint32_len > 0) {
            i = read(fd, cp, uint32_len);
            if (i <= 0) {
                if (lose_counter++ > 16)
                        break;
                continue;
            }
            uint32_len -= i;
            cp += i;
            lose_counter = 0;
        }
    }

    /*
     * We do this all the time, but this is the only source of
     * randomness if /dev/random/urandom is out to lunch.
     */
    uint32 j;
    for (cp = (char *)&rand_uint32, j = 0; j < sizeof(unsigned int); j++) {
        *cp++ ^= (rand() >> 7) & 0xFF;
    }

    return rand_uint32;
}
//测试代码 快开游戏 无RNG时，自已随机产生开奖号
int32 rand_drawcode_generate(int32 start_num, int32 end_num, uint8 *drawCodes, int32 drawCodes_len)
{
   if (start_num > end_num) {
        log_error("start_num[%d] > end_num[%d]", start_num, end_num);
        return -1;
    }

    if (end_num - start_num + 1 < drawCodes_len) {
        log_error("(end_num - start_num + 1)[%d] < drawCodes_len[%d]", end_num - start_num + 1, drawCodes_len);
        return -1;
    }

    vector<int> drawCodes_set;
    int i;

    for (i = start_num; i <= end_num; i++) {
        drawCodes_set.push_back(i);
    }

    int fd = get_random_fd();
    unsigned int count_tmp = end_num - start_num + 1;
    for (i = 0; i < drawCodes_len; i++) {
        unsigned int tmp_drawcode = get_random_uint32(fd)%count_tmp;
        drawCodes[i] = drawCodes_set[tmp_drawcode];
        drawCodes_set.erase(drawCodes_set.begin() + tmp_drawcode);
        count_tmp--;
    }

    if (fd >= 0) {
        close(fd);
    }

    return 0;
}
//测试代码 快开游戏 无RNG时，自已从文件中读取开奖号
int32 read_drawcode_from_file(uint8 *drawCodes, int *drawCodes_len, uint8 game_code)
{
    // Just a hack
    // Makesure drawCodes is big enough

    *drawCodes_len = 0;
    char path[PATH_MAX] = {0};
    snprintf(path, sizeof(path), "/tmp/drawCode_%u.txt", (uint32)game_code);
    int fd = open(path, O_RDONLY);
    if (fd < 0) {
        log_warn("open([%s]) failed. Reason: [%s]", path, strerror(errno));
        return -1;
    }

    char buffer[2048] = {'\0'};
    int len = read(fd, buffer, sizeof(buffer) - 1);
    if (len < 0) {
        log_warn("read([%s]) failed. Reason: [%s]", path, strerror(errno));
        close(fd);
        return -1;
    }

    // format: char buffer[] = "12, 23, 34, 45, 17, 19, ..."
    buffer[len + 1] = '\0';
    const char * split = ",";
    char *p = NULL;
    char *last = NULL;
    p = strtok_r(buffer, split, &last);
    while (p != NULL) {
        drawCodes[*drawCodes_len] = (uint8)atoi(p);
        (*drawCodes_len)++;
        p = strtok_r(NULL, split, &last);
    }
    close(fd);

    return 0;
}

char *drawCode_to_string(char *buffer, const uint8 *drawCode, int length, const char *delimiter)
{
    int i = 0;
    int str_len = 0;
    buffer[0] = '\0';
    for (i = 0; i<length-1; i++) {
        // make sure the printBuf is big enough
        str_len += sprintf(buffer+str_len, "%d%s", (unsigned int)drawCode[i], delimiter);
    }
    if (0!=length) {
        str_len += sprintf(buffer+str_len, "%d", (unsigned int)drawCode[i]);
    }

    return buffer;
}

//测试代码 自动开奖游戏 无RNG时，发送开奖号码时使用
int32 generate_drawNumber(uint8 game_code, uint64 issue_num, INM_MSG_ISSUE_DRAWNUM_INPUTE *draw_rec)
{

    int ret;
    draw_rec->gameCode = game_code;
    draw_rec->timeStamp = (uint32)time(NULL);
    draw_rec->issueNumber = issue_num;
    draw_rec->header.type = INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED;
    draw_rec->header.length = sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE);

    int len_tmp = 0;
    int ret_tmp = read_drawcode_from_file(draw_rec->drawCodes, &len_tmp, game_code);

    if (game_code == GAME_SSQ) { // 双色球
        draw_rec->count = 7;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            // 红球 1 - 33 选择 6
            ret = rand_drawcode_generate(1, 33, draw_rec->drawCodes, 6);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 33);
                return -1;
            }
            // 兰球 1- 16 选择 1
            ret = rand_drawcode_generate(1, 16, draw_rec->drawCodes + 6, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 16);
                return -1;
            }
        }

        char str_buf[512] = {0};
        drawCode_to_string(str_buf, draw_rec->drawCodes, draw_rec->count - 1, ",");
        snprintf(draw_rec->drawCodesStr, sizeof(draw_rec->drawCodesStr), "%s|%d", str_buf, draw_rec->drawCodes[6]);
    } else if (game_code == GAME_3D) { // 3D
        draw_rec->count = 3;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            // 百位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }

            // 十位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 1, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }

            // 个位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 2, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    } else if (game_code == GAME_KOCK3) { // K3
               draw_rec->count = 3;
               if (0 != ret_tmp || len_tmp != draw_rec->count) {
                   // 百位
                   ret = rand_drawcode_generate(1, 6, draw_rec->drawCodes, 1);
                   if (ret != 0) {
                       log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 6);
                       return -1;
                   }

                   // 十位
                   ret = rand_drawcode_generate(1, 6, draw_rec->drawCodes + 1, 1);
                   if (ret != 0) {
                       log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 6);
                       return -1;
                   }

                   // 个位
                   ret = rand_drawcode_generate(1, 6, draw_rec->drawCodes + 2, 1);
                   if (ret != 0) {
                       log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 6);
                       return -1;
                   }
               }

               drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    } else if ( (game_code == GAME_KENO) || (game_code == GAME_KOCKENO) ) { // 开乐彩
        draw_rec->count = 20;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            ret = rand_drawcode_generate(1, 80, draw_rec->drawCodes, draw_rec->count);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 80);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    } else if (game_code == GAME_7LC) { // 七乐彩
        draw_rec->count = 8;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            ret = rand_drawcode_generate(1, 30, draw_rec->drawCodes, draw_rec->count);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 30);
                return -1;
            }
        }

        char str_buf[512] = {0};
        drawCode_to_string(str_buf, draw_rec->drawCodes, draw_rec->count - 1, ",");
        snprintf(draw_rec->drawCodesStr, sizeof(draw_rec->drawCodesStr), "%s|%d", str_buf, draw_rec->drawCodes[7]);
    } else if (game_code == GAME_KOC11X5) { // 11选5
        draw_rec->count = 5;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            ret = rand_drawcode_generate(1, 11, draw_rec->drawCodes, draw_rec->count);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 11);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    } else if (game_code == GAME_SSC)  { // 时时彩
        draw_rec->count = 5;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            // 个位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }

            // 十位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 1, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }

            // 百位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 2, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }

            // 千位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 3, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }

            // 万位
            ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 4, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    } else if (game_code == GAME_KOCTTY)  { // 柬埔寨天天赢
		draw_rec->count = 4;
		if (0 != ret_tmp || len_tmp != draw_rec->count) {
			// 个位
			ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes, 1);
			if (ret != 0) {
				log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
				return -1;
			}

			// 十位
			ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 1, 1);
			if (ret != 0) {
				log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
				return -1;
			}

			// 百位
			ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 2, 1);
			if (ret != 0) {
				log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
				return -1;
			}

			// 千位
			ret = rand_drawcode_generate(0, 9, draw_rec->drawCodes + 3, 1);
			if (ret != 0) {
				log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 0, 9);
				return -1;
			}
		}

		drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
	}else if (game_code == GAME_KOCK2)  { // 柬埔寨快2
		draw_rec->count = 1;
		if (0 != ret_tmp || len_tmp != draw_rec->count) {
			ret = rand_drawcode_generate(1, 22, draw_rec->drawCodes, 1);
			if (ret != 0) {
				log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 22);
				return -1;
			}
		}

		drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
	}
    else if (game_code == GAME_TEMA) { // 
        draw_rec->count = 1;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            ret = rand_drawcode_generate(1, 40, draw_rec->drawCodes, 1);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 40);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    }
    else if (game_code == GAME_KOC7LX) { //
        draw_rec->count = 7;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            ret = rand_drawcode_generate(1, 40, draw_rec->drawCodes, draw_rec->count);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 40);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    }

/*
    else if (game_code == GAME_XYNC) { // 幸运农场
        draw_rec->count = 8;
        if (0 != ret_tmp || len_tmp != draw_rec->count) {
            ret = rand_drawcode_generate(1, 20, draw_rec->drawCodes, draw_rec->count);
            if (ret != 0) {
                log_error("rand_drawcode_generate(start_num[%d], end_num[%d]) failed.", 1, 20);
                return -1;
            }
        }

        drawCode_to_string(draw_rec->drawCodesStr, draw_rec->drawCodes, draw_rec->count, ",");
    }
*/

    return 0;
}
//=============测试代码  无RNG时使用======end=====================


