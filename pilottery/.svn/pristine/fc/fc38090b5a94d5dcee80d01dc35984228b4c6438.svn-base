#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Forrest Cao   2012.02

"""

import os, string, time
import ctypes as ct

class TsApi():
    ts_api = ct.CDLL('/ts_host/libs/libts4py.so')
    ts_init = False

def init():
    if TsApi.ts_api.ts4py_init() < 0:
        TsApi.ts_init = False
        return False
    TsApi.ts_init = True
    return True

def rt_sysdb():
    rs = ct.create_string_buffer(32768)
    TsApi.ts_api.tsv_sysdb(ct.byref(rs),32768)
    return rs.value

def rt_ncpc():
    rs = ct.create_string_buffer(32768)
    TsApi.ts_api.tsv_ncpc(ct.byref(rs),32768)
    return rs.value


def get_game_list():
    game_str = ct.create_string_buffer(1024)
    if TsApi.ts_api.ts4py_get_gamelist(ct.byref(game_str)) < 0:
        return ""
    else:
        return game_str.value

def extract_tsn(tsn):
    tsn_str = ct.create_string_buffer(32)
    tsn_str.value = tsn
    date_param = ct.create_string_buffer(32)
    unique_tsn = ct.create_string_buffer(32)
    if TsApi.ts_api.ts4py_get_date_and_digit_tsn(ct.byref(tsn_str), ct.byref(date_param),ct.byref(unique_tsn)) < 0:
        return (0,0)
    else:
        return (date_param.value, unique_tsn.value)

def dump_issue_blob_field(type_key,blob_buffer):
    b_buffer = ct.create_string_buffer(2048)
    b_buffer.raw = blob_buffer
    dump_buffer = ct.create_string_buffer(4096)
    if TsApi.ts_api.ts4py_issueBlob2str(type_key, ct.byref(b_buffer), 2048, ct.byref(dump_buffer), 4096) < 0:
        return "dump_issue_blob_field() error "
    else:
        return dump_buffer.value

