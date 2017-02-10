#include <string.h>
#include <stdlib.h>
#include "include/VPIAssistant.h"

/*
    This is the part of the code that is not exactly preferable, but there isn't really a better way, it's impossible to set vlog_startup_routines anywhere in Swift.
*/
extern void _TF8Swiftlog7startupFT_T_(void);

void (*vlog_startup_routines[])() =
{
    _TF8Swiftlog7startupFT_T_,
    0
};

void vpi_finish()
{
    vpi_control(vpiFinish, 0);
}

char* UTF8String(const char *str)
{
    char* copy = malloc(1024);
    strcpy(copy, str);
    return copy;
}