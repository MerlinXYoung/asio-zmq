if( TARGET libzmq)
    return()
endif()

set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH ON)
find_package(PkgConfig)
pkg_check_modules(ZMQ QUIET libzmq)
function (CompareVersion REQUEST_VERSION LOCAL_VERSION RESULT)
    # set(REQUEST_VERSION ${ARGV0})
    # set(LOCAL_VERSION ${ARGV1})
    string(REPLACE "." ";" REQUEST_VERSION_LIST ${REQUEST_VERSION})
    list(LENGTH REQUEST_VERSION_LIST REQUEST_VERSION_COUNT)
    while(${REQUEST_VERSION_COUNT} LESS 4)
        list(APPEND REQUEST_VERSION_LIST 0)
        list(LENGTH REQUEST_VERSION_LIST REQUEST_VERSION_COUNT)
    endwhile()
    #message(STATUS "REQUEST_VERSION_LIST:${REQUEST_VERSION_LIST}")
    string(REPLACE "." ";" LOCAL_VERSION_LIST ${LOCAL_VERSION})
    list(LENGTH LOCAL_VERSION_LIST LOCAL_VERSION_COUNT)
    while(${LOCAL_VERSION_COUNT} LESS 4)
        list(APPEND LOCAL_VERSION_LIST 0)
        list(LENGTH LOCAL_VERSION_LIST LOCAL_VERSION_COUNT)
    endwhile()
    #message(STATUS "LOCAL_VERSION_LIST:${LOCAL_VERSION_LIST}")
    list(GET REQUEST_VERSION_LIST 0 REQUEST_VERSION_MAJOR)
    list(GET LOCAL_VERSION_LIST 0 LOCAL_VERSION_MAJOR)
    #message(STATUS "MAJOR:${REQUEST_VERSION_MAJOR} ${LOCAL_VERSION_MAJOR}")
    if(REQUEST_VERSION_MAJOR LESS LOCAL_VERSION_MAJOR)
        set(${RESULT} ON PARENT_SCOPE)
        return()
    elseif(Zeromq_FIND_VERSION_MAJOR GREATER ZMQ_VERSION_MAJOR)
        #set(${RESULT} OFF)
        return ()
    else()
    endif()
    #message(STATUS "RESULT:${RESULT}:${${RESULT}}")

    list(GET REQUEST_VERSION_LIST 1 REQUEST_VERSION_MINOR)
    list(GET LOCAL_VERSION_LIST 1 LOCAL_VERSION_MINOR)
    #message(STATUS "MINOR:${REQUEST_VERSION_MINOR} ${LOCAL_VERSION_MINOR}")
    if(REQUEST_VERSION_MINOR LESS LOCAL_VERSION_MINOR)
        set(${RESULT} ON PARENT_SCOPE)
        return()
    elseif(Zeromq_FIND_VERSION_MINOR GREATER ZMQ_VERSION_MINOR)
        #set(${RESULT} OFF)
        return ()
    else()
    endif()

    #message(STATUS "RESULT:${RESULT}")

    list(GET REQUEST_VERSION_LIST 2 REQUEST_VERSION_PATCH)
    list(GET LOCAL_VERSION_LIST 2 LOCAL_VERSION_PATCH)
    #message(STATUS "PATCH:${REQUEST_VERSION_PATCH} ${LOCAL_VERSION_PATCH}")
    if(REQUEST_VERSION_PATCH LESS LOCAL_VERSION_PATCH)
        set(${RESULT} ON PARENT_SCOPE)
        return()
    elseif(Zeromq_FIND_VERSION_PATCH GREATER ZMQ_VERSION_PATCH)
        #set(${RESULT} OFF)
        return ()
    else()
    endif()

    #message(STATUS "RESULT:${RESULT}")

    list(GET REQUEST_VERSION_LIST 3 REQUEST_VERSION_TWEAK)
    list(GET LOCAL_VERSION_LIST 3 LOCAL_VERSION_TWEAK)
    #message(STATUS "TWEAK:${REQUEST_VERSION_TWEAK} ${LOCAL_VERSION_TWEAK}")
    if(REQUEST_VERSION_TWEAK GREATER LOCAL_VERSION_TWEAK)
        #set(${RESULT} OFF)
        return()
    else()
        set(${RESULT} ON PARENT_SCOPE)
        return()
    endif()

endfunction()
# message(STATUS "ZMQ_FOUND:${ZMQ_FOUND}")
if(ZMQ_FOUND)
    # message(STATUS "ZMQ_LIBRARIES:${ZMQ_LIBRARIES}")
    # message(STATUS "ZMQ_LINK_LIBRARIES:${ZMQ_LINK_LIBRARIES}")
    # message(STATUS "ZMQ_LIBRARY_DIRS:${ZMQ_LIBRARY_DIRS}")
    # message(STATUS "ZMQ_LDFLAGS:${ZMQ_LDFLAGS}")
    # message(STATUS "ZMQ_LDFLAGS_OTHER:${ZMQ_LDFLAGS_OTHER}")
    # message(STATUS "ZMQ_INCLUDE_DIRS:${ZMQ_INCLUDE_DIRS}")
    # message(STATUS "ZMQ_CFLAGS:${ZMQ_CFLAGS}")
    # message(STATUS "ZMQ_CFLAGS_OTHER:${ZMQ_CFLAGS_OTHER}")

    # message(STATUS "ZMQ_VERSION:${ZMQ_VERSION}")
    # message(STATUS "ZMQ_PREFIX:${ZMQ_PREFIX}")
    # message(STATUS "ZMQ_INCLUDEDIR:${ZMQ_INCLUDEDIR}")
    # message(STATUS "ZMQ_LIBDIR:${ZMQ_LIBDIR}")
    # message(STATUS "find version:${Zeromq_FIND_VERSION}")
    if(Zeromq_FIND_VERSION)
        CompareVersion(${Zeromq_FIND_VERSION} ${ZMQ_VERSION} VERSION_OK)
        #message(STATUS "VERSION_OK:${VERSION_OK}")
        if(NOT VERSION_OK)
            if(Zeromq_FIND_REQUIRED)
                message(FATAL_ERROR "Zeromq not found")
            else()
                message(WARNING "Zeromq not found")
            endif()
        endif()
        
    endif()

    find_library(Zeromq_LIBRARY NAMES libzmq.so libzmq.dylib libzmq.dll
        PATHS ${ZMQ_LIBDIR} ${ZMQ_LIBRARY_DIRS})
    find_library(Zeromq_STATIC_LIBRARY NAMES libzmq.a libzmq_a.a libzmq.dll.a
        PATHS ${ZMQ_LIBDIR} ${ZMQ_LIBRARY_DIRS})
    #message(STATUS "Zeromq_LIBRARY:${Zeromq_LIBRARY}")
    #message(STATUS "FOUND:${Zeromq_LIBRARY_FOUND},${Zeromq_STATIC_LIBRARY_FOUND}")
    if(Zeromq_LIBRARY OR Zeromq_STATIC_LIBRARY )
        set(Zeromq_FOUND ON)
        set(Zeromq_VERSION ${ZMQ_VERSION})
        set(Zeromq_INCLUDE_DIR ${ZMQ_INCLUDE_DIRS})
        set(Zeromq_LIBRARY_DIR ${ZMQ_INCLUDE_DIRS})
        message(STATUS "Found Zeromq ${Zeromq_LIBRARY} version:${Zeromq_VERSION}")

        add_library(libzmq SHARED IMPORTED )
        set_property(TARGET libzmq PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ZMQ_INCLUDEDIR})
        set_property(TARGET libzmq PROPERTY IMPORTED_LOCATION ${Zeromq_LIBRARY})
        
        add_library(libzmq-static STATIC IMPORTED )
        set_property(TARGET libzmq-static PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ZMQ_INCLUDEDIR})
        set_property(TARGET libzmq-static PROPERTY IMPORTED_LOCATION ${Zeromq_STATIC_LIBRARY})
    endif()
else()
    if(Zeromq_FIND_REQUIRED)
        message(FATAL_ERROR "Zeromq not found")
    else()
        message(WARNING "Zeromq not found")
    endif()
endif()



