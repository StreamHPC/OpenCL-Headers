if (NOT EXE_PATH)
    message(FATAL_ERROR "Must provide -DEXE_PATH=...")
endif()
set(ADB_PATH "/usr/bin/adb")
cmake_path(GET EXE_PATH FILENAME EXE_FILENAME)

execute_process(
    COMMAND "${ADB_PATH}" wait-for-device
    RESULT_VARIABLE COMMAND_RESULT
)
if (NOT COMMAND_RESULT EQUAL "0")
    message(FATAL_ERROR "Could not wait for Android device")
endif()

execute_process(
    COMMAND "${ADB_PATH}" push "${EXE_PATH}" "/data/local/tmp/testing/${EXE_FILENAME}"
    RESULT_VARIABLE COMMAND_RESULT
)
if (NOT COMMAND_RESULT EQUAL "0")
    message(FATAL_ERROR "Could not push binary to Android device")
endif()

execute_process(
    COMMAND "${ADB_PATH}" shell "/data/local/tmp/testing/${EXE_FILENAME}"
    RESULT_VARIABLE COMMAND_RESULT
)
if (NOT COMMAND_RESULT EQUAL "0")
    message(FATAL_ERROR "Executing program on Android device returned with ${COMMAND_RESULT}")
endif()
