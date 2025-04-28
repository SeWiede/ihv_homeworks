#include <mti.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <sys/time.h>

// Implement the C functions here
//-- Enter your code here

void GetTimeC(int* hour, int* minute, int* second) {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    if (local != NULL) {
        *hour = local->tm_hour;
        *minute = local->tm_min;
        *second = local->tm_sec;
    } else {
        // Set default values in case of error
        *hour = *minute = *second = -1;
    }
    printf("GetTimeC called: %02d:%02d:%02d\n", *hour, *minute, *second);
}

/* void GetBetterTimeC(int* hour, int* minute, int* second, int* millisecond, int* microsecond) {
    struct timeval tv;
    struct tm* local;

    gettimeofday(&tv, NULL);
    local = localtime(&tv.tv_sec);

    if (local != NULL) {
        *hour = local->tm_hour;
        *minute = local->tm_min;
        *second = local->tm_sec;
        *millisecond = tv.tv_usec / 1000;
        *microsecond = tv.tv_usec % 1000;
    } else {
        *hour = *minute = *second = *millisecond = *microsecond = -1;
    }
    printf("GetBetterTimeC called: %02d:%02d:%02d\n", *hour, *minute, *second);

} */

void OneStepC(
    double* zr,
    double* zi,
    double* cr,
    double* ci,

    double* or,
    double* oi
) {
    *or = (*zr) * (*zr) - (*zi) * (*zi) + (*cr);
    *oi = 2.0 * (*zr) * (*zi) + (*ci); 
}


void IterateC(
    double* x,
    double* y,

    int* its
) {
    double zr = 0.0;
    double zi = 0.0;
    double next_r, next_i;

    *its = 0;

    while (*its < 200) {
        OneStepC(&zr, &zi, x, y, &next_r, &next_i);

        zr = next_r;
        zi = next_i;

        if (zr * zr + zi * zi > 4.0) {  // avoid sqrt thats why > 4
            break;
        }

        (*its)++;
    }
}