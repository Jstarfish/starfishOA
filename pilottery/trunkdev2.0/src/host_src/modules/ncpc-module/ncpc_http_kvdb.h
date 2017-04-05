#ifndef NCPC_HTTP_KVDB_H_INCLUDED
#define NCPC_HTTP_KVDB_H_INCLUDED

#include <db.h>
#include <slice.h>
#include <write_batch.h>
#include <comparator.h>

class TsStrComparator: public leveldb::Comparator
{
public:
    int Compare(const leveldb::Slice& s1, const leveldb::Slice& s2) const {
        int ret = s1.ToString().compare(s2.ToString());
        if (ret>0) return +1; if (ret<0) return -1; return 0;
    };
    const char* Name() const { return "TsMemComparator"; };
    void FindShortestSeparator(string*, const leveldb::Slice&) const {};
    void FindShortSuccessor(string*) const {};
};

class KVDB
{
public:
    KVDB(const char *_db_name) {
        db_name = _db_name;
        leveldb::Options options;
        options.create_if_missing = true;
        options.comparator = &cmp;
        leveldb::Status status = leveldb::DB::Open(options, db_name, &db);
        assert(status.ok());
        pthread_mutex_init(&mutex, NULL);
    };
    ~KVDB() {
        delete db;
    };
    string get(char *key) {
        string svalue;
        leveldb::Status status = db->Get(leveldb::ReadOptions(), key, &svalue);
        if (status.ok()) return svalue;
        return "";
    };
    //put string '/0' end
    int put(char *key,char *value,int flag=0) {
        leveldb::WriteOptions write_options;
        if (flag == 0) write_options.sync = false;
        else write_options.sync = true;
        leveldb::Status status = db->Put(write_options, key, value);
        if (!status.ok()) return -1;
        return 0;
    };
    //put blob string.
    int put_b(char *key,char *value,int len,int flag=0) {
        leveldb::WriteOptions write_options;
        if (flag == 0) write_options.sync = false;
        else write_options.sync = true;
        leveldb::Slice s(value,len);
        leveldb::Status status = db->Put(write_options, key, s);
        if (!status.ok()) return -1;
        return 0;
    };
    int del(char *key) {
        leveldb::WriteOptions write_options;
        leveldb::Status status = db->Delete(write_options, key);
        if (status.ok()) return -1;
        return 0;
    };
#if 0
    //先get,如果存在则不处理，不存在才插入
    //如果不论是否存在均插入的话，应该直接使用put方法
    int put_ex(char *key,char *value,int flag=0) {
        pthread_mutex_lock(&mutex);

        leveldb::Status status;
        leveldb::WriteOptions write_options;
        if (flag == 0) write_options.sync = false;
        else write_options.sync = true;
        leveldb::WriteBatch batch;  //batch.Put()   batch.Delete()
        batch.Delete(key);
        batch.Put(key, value);
        status = db->Write(write_options,&batch);
        if (!status.ok()) return -1;

        pthread_mutex_unlock(&mutex);
        return 0;
    };
#endif
    //del all keys before key
    void del_before(char *key) {
        string skey = key;
        leveldb::WriteOptions write_options;
        leveldb::Iterator *iter = db->NewIterator(leveldb::ReadOptions());
        for (iter->SeekToFirst(); iter->Valid() && (iter->key().ToString() <= skey); iter->Next()) {
            db->Delete(write_options, iter->key().ToString());
        }
        assert(iter->status().ok());
        delete iter;
        /*
        for (iter->SeekToFirst(); iter->Valid();iter->Next()) {
            if (iter->key().ToString().compare(key) > 0)
                break;
            db->Delete(write_options, iter->key().ToString());
        }
        assert(iter->status().ok());
        delete iter;
        */
    };
    //del key_prefix key
    void del_prefix(char *key_prefix) {
        string skey_prefix = key_prefix;
        string skey_b = skey_prefix + " ";
        string skey_e = skey_prefix + "~";
        leveldb::WriteOptions write_options;
        leveldb::Iterator *iter = db->NewIterator(leveldb::ReadOptions());
        for (iter->Seek(skey_b); iter->Valid() && (iter->key().ToString() <= skey_e); iter->Next()) {
            db->Delete(write_options, iter->key().ToString());
        }
        assert(iter->status().ok());
        delete iter;
        /*
        for (iter->SeekToFirst(); iter->Valid();iter->Next()) {
            if (iter->key().ToString().compare(key_str_b) < 0)
                continue;
            if (iter->key().ToString().compare(key_str_e) > 0)
                break;
            i++;
            status = db->Delete(write_options, iter->key().ToString());
            if (status.ok()) count--;
        }
        */
        
    };
    //del key_prefix (begin - end) key
    void del_range(char *key_b, char *key_e) {
        string skey_b = key_b;
        string skey_e = key_e;
        leveldb::WriteOptions write_options;
        leveldb::Iterator *iter = db->NewIterator(leveldb::ReadOptions());
        for (iter->Seek(skey_b); iter->Valid() && (iter->key().ToString() <= skey_e); iter->Next()) {
            db->Delete(write_options, iter->key().ToString());
        }
        assert(iter->status().ok());
        delete iter;
        /*
        leveldb::Status status;
        for (iter->SeekToFirst(); iter->Valid();iter->Next()) {
            if (iter->key().ToString().compare(key_b) < 0)
                continue;
            if (iter->key().ToString().compare(key_e) > 0)
                break;
            status = db->Delete(write_options, iter->key().ToString());
            if (status.ok()) count--;
        }
        assert(iter->status().ok()); delete iter;
        */
    };
    void dump() {
        unsigned long count = 0;
        leveldb::Iterator *iter = db->NewIterator(leveldb::ReadOptions());
        for (iter->SeekToFirst(); iter->Valid(); iter->Next()) {
            count++;
            //cout << iter->key().ToString() << ": "  << iter->value().ToString() << endl;
        }
        assert(iter->status().ok()); delete iter;
        cout << "DUMP db total count -> " << count << endl;
    };
public:
    string db_name;
    leveldb::DB *db;
    TsStrComparator cmp;
    pthread_mutex_t mutex;
};

#endif

