#include <string.h>
#include <stdlib.h>
#include "include/VPIAssistant.h"

/*
    This is the part of the code that is not exactly preferable, but there isn't really a better way, it's impossible to set vlog_startup_routines anywhere in Swift.
*/
extern void swiftlog_startup(void);

void (*vlog_startup_routines[])() =
{
    swiftlog_startup,
    0
};

void vpi_finish()
{
    vpi_control(vpiFinish, 0);
}
