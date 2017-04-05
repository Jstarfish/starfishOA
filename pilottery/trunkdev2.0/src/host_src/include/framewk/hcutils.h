#ifndef HCUTILS_H_INCLUDED
#define HCUTILS_H_INCLUDED


/*=========================================================================================================
 * ȫ�ֳ�����ֵ�궨�壬��������м�Ҫ˵��
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/

/*=========================================================================================================
 * ���Ͷ���(struct��enum)��,�������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * ʹ�����ͻع鱾�س�������(const)�ȣ��������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/


/*=========================================================================================================
 * �����Ժ궨�壬��������м�Ҫ˵��
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/

/*=========================================================================================================
 * �ⲿ�������壬��������м�Ҫ˵��
 * Functions Definitions and Brief Description
 =========================================================================================================*/

bool env_read(
        const char* env_key,
        char * const env_val);

bool ini_read(
        const char* inipath,
        const char* section,
        const char* ini_key,
        char* const ini_val);

/*=========================================================================================================
 * �����������壬��������м�Ҫ˵��
 * Static Inline Functions Definitions and Brief Description
 =========================================================================================================*/

static __inline__ bool ini_read_int(
        const char* inipath,
        const char* section,
        const char* ini_key,
        int * const ini_val)
{
    char strval[512];
    memset(strval, 0, sizeof(strval));
    if (ini_read(inipath, section, ini_key, strval))
    {
        int index, strsz = strlen(strval);
        for (index = 0; index < strsz; index++)
        {
            if (isdigit(strval[index]) == 0)
            {
                return false;
            }
        }

        *ini_val = atoi(strval);
        return true;
    }
    else
    {
        return false;
    }
}

static __inline__ bool ini_read_hex(
        const char* inipath,
        const char* section,
        const char* ini_key,
        int * const ini_val)
{
    char strval[512];
    memset(strval, 0, sizeof(strval));
    if (ini_read(inipath, section, ini_key, strval))
    {
        int index, strsz = strlen(strval);
        for (index = 0; index < strsz; index++)
        {
            if (isxdigit(strval[index]) == 0)
            {
                return false;
            }
        }

        *ini_val = (int) strtol(strval, null, 16);
        return true;
    }
    else
    {
        return false;
    }
}

static __inline__ bool ini_read_bool(
        const char* inipath,
        const char* section,
        const char* ini_key,
        bool * const ini_val)
{
    char strval[512];
    memset(strval, 0, sizeof(strval));
    if (ini_read(inipath, section, ini_key, strval))
    {
        if (strcasecmp("true", strval) == 0)
        {
            *ini_val = true;
        }
        else
        {
            *ini_val = false;
        }
        return true;
    }
    else
    {
        return false;
    }
}

static __inline__ bool ini_read_long(
        const char* inipath,
        const char* section,
        const char* ini_key,
        long * const ini_val)
{
    char strval[512];
    memset(strval, 0, sizeof(strval));
    if (ini_read(inipath, section, ini_key, strval))
    {
        int index, strsz = strlen(strval);
        for (index = 0; index < strsz; index++)
        {
            if (isdigit(strval[index]) == 0)
            {
                return false;
            }
        }

        *ini_val = atol(strval);
        return true;
    }
    else
    {
        return false;
    }
}

static __inline__ bool ini_read_double(
        const char* inipath,
        const char* section,
        const char* ini_key,
        double * const ini_val)
{
    char strval[512];
    memset(strval, 0, sizeof(strval));
    if (ini_read(inipath, section, ini_key, strval))
    {
        *ini_val = atof(strval);
        return true;
    }
    else
    {
        return false;
    }
}

static __inline__ void viewbits(
        void *array,
        int start,
        int length)
{
    char c_temp;
    char *ptr = (char*) array;
    int i, j, count = 0;
    int line, v_temp, value;
    int temp_start = start;
    ptr += start;
    length += start;
    if (length % 8 == 0)
    {
        line = length / 8;
    }
    else
    {
        line = length / 8 + 1;
    }
    printf("res_start:str[%d]  res_length:%d-->\n", start, length - start);
    for (i = 0; i < line; i++)
    {
        printf("ADDR %08d    ", i * 8);
        while (start)
        {
            for (j = 0; j < 8; j++)
            {
                printf("*");
            }
            start -= 1;
            printf("   ");
        }
        if (((v_temp = length % 8) > 0) && (i == line - 1))
        {
            for (count = 0; count < v_temp; count++)
            {
                c_temp = *ptr;
                for (j = 0; j < (int)(8 * sizeof(char)); j++)
                {
                    value = ((0x1u << 7) >> j) & c_temp;
                    if (value == 0)
                        printf("0");
                    else
                        printf("1");
                }
                if (count != v_temp - 1)
                    printf("   ");
                else
                    printf("\n");
                ptr += 1;
            }
        }
        else
        {
            for (count = 0; count < 8 - temp_start; count++)
            {
                c_temp = *ptr;
                for (j = 0; j < (int)(8 * sizeof(char)); j++)
                {
                    value = ((0x1u << 7) >> j) & c_temp;
                    if (value == 0)
                        printf("0");
                    else
                        printf("1");
                }
                if (count != 7 - temp_start)
                    printf("   ");
                ptr += 1;
            }
        }
        printf("\n");
    }
}

static __inline__ void viewbyte(
        const void * const data,
        const int offset,
        const int length)
{

    unsigned char *array;

    array = (unsigned char*) data;

    array = array + offset;

    int line = length / 16;

    if (length % 16 != 0)
    {
        line = length / 16 + 1;
    }

    printf(
            ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");

    printf("data array dump index: start_pos:%d inspect_len:%d\n", offset,
            length);

    for (int idx = 0; idx < line; idx++)
    {
        printf("  ADDR %04d  ", idx * 16 + offset);

        int count = (idx < (line - 1)) ? 16 : (length % 16);

        for (int jdx = 0; jdx < 16; jdx++)
        {
            uint8 value = *(array + jdx);

            if (jdx < count)
            {
                if (value < 16)
                {
                    printf("0%X ", value);
                }
                else
                {
                    printf("%2X ", value);
                }
            }
            else
            {
                printf("   ");
            }
        }

        printf("%s", "   ");

        for (int jdx = 0; jdx < 16; jdx++)
        {
            uint8 value = *(array + jdx);
            if (jdx < count)
            {
                if ((value < 32) || (value > 127))
                {
                    value = '.';
                }

                printf("%c", value);
            }
            else
            {
                printf(" ");
            }
        }

        array = array + 16;

        printf("\n");
    }

    printf(
            "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
}

int mkdirs(const char *path);
int rmdirs(const char *name);
ssize_t safe_read(int fd, void *buf, size_t count);
ssize_t safe_write(int fd, const void *buf, size_t count);
ssize_t full_write(int fd, const void *buf, size_t len);
int file_copy(const char *in_file, const char *out_file);
int file_copy_md5sum(const char *in_file, const char *out_file);
//�����ļ� �� ����md5�ļ�������ԭ�ļ���md5���бȽ�
int copy_file_md5(char *filepath, char *file_new);
int get_file_size(const char *file_path, uint64 *f_size);

//bufferת16�����ַ���
char *binary_encode_hex(uint8 *buf, int length, char *outputStr);

//16�����ַ���תbuffer
//�ڲ�ʹ�ã�������û�����Ƿ��ַ� �� ż������ �ı��� 
int32 hex_decode_binary(char *str, int length, uint8 *outputBuf);

#endif //HCUTILS_H_INCLUDED
