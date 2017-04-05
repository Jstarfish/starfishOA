
set(ncp_server_src cache_mgr.cpp ncp_server.cpp ncp_worker.cpp ncp_util.cpp ncp_ncpc.cpp crypt.cpp)
add_executable(ncp_server ${ncp_server_src})
target_link_libraries(ncp_server pthread ev)

INSTALL(TARGETS ncp_server
        RUNTIME DESTINATION task
        LIBRARY DESTINATION libs
        ARCHIVE DESTINATION libs
)
