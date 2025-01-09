/**
 * @file
 * @brief A metro station simulation.
 *        There is only one station with one single direction train line.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <math.h>
#include <time.h>
#include <stdint.h>
#include <signal.h> 
#include <utils.h>
#include <iostream>
#include "settings.h"
#include "train.h"
#include "station.h"
#include <libgen.h>
#include "thread.h"
/* DO NOT CHANGE THE FOLLOWING VALUES, run program with option -h to set a different values */

static int npassengers = 4;      // number of passengers
static int ntrains = 1;          // number of trains
static int nseats = 10;          // number of seats in each train
static int nticks = 10;          // time to departure (measures in number of ticks)
static int maxwait = 10000;      // max random wait time (microseconds)
static int countdown_tick = 100; // max random wait time (microseconds)

#define USAGE "Synopsis: %s [options]\n" \
    "\tOption\tDescription\n" \
    "\t -p num\t number of passengers (dflt. %d, min. %d, max. %d)\n" \
    "\t -t num\t number of trains (dflt. %d, min. %d, max. %d)\n" \
    "\t -s num\t number seats per train (dflt. %d, min. %d, max. %d)\n" \
    "\t -d num\t time (number of ticks) to departure (dflt. %d, min. %d, max. %d)\n" \
    "\t -w num\t max random wait time (dflt. %d, min. %d, max. %d)\n" \
    "\t -c num\t countdown tick time (dflt. %d, min. %d, max. %d)\n" \
    "\t -h\t this help\n"

#define USAGE_ARGS basename(argv[0]), npassengers, 1, MAX_PASSENGERS, ntrains, 1, MAX_TRAINS, \
    nseats, 1, MAX_TRAIN_NUM_SEATS, nticks, 1, MAX_DEPARTURE_TIME, \
    maxwait, 0, MAX_WAIT, countdown_tick, 1, MAX_COUNTDOWN_TICK

// TODO point: changes probably required in these data elements

// .brief Passenger data structure

typedef struct {
    char name[MAX_NAME+1];
    int seat;
    int arrived_to_destination; // 0: in transit; 1: destination reached (voyage ended)
    // TODO point: if necessary, add new fields here

    pthread_cond_t arrived;
    pthread_mutex_t access;

} Passenger;

typedef struct {
    int num_passengers;
    Passenger all_passengers[MAX_PASSENGERS];
    Train all_trains[MAX_TRAINS];
    Station station;
    // TODO point: if necessary, add new fields here
} Metro;

Metro * metro = NULL;

// TODO point: if necessary, add module variables here

/* 
    .brief verification tests
*/

#define check_valid_passenger(id) do { check_valid_passenger_id(id); check_valid_name(metro->all_passengers[id].name, "passenger"); } while(0)
#define check_valid_train(id) do { check_valid_train_id(id); check_valid_name(metro->all_trains[id].name, "train"); } while(0)

void new_passenger(Passenger* passenger); // Initializes a new passenger
void random_wait();

// TODO point: changes probably required to this function
void init_simulation(int np, int nt) {
    // This function is just to initialize all data structures
    printf("[e] Initializing simulation...\n");
    metro = (Metro*)mem_alloc(sizeof(Metro));
    memset(metro, 0, sizeof(Metro)); // mem-alloc is a malloc with NULL pointer verification
    metro->num_passengers = np;
    for (int i = 0; i < np; i++){
        new_passenger(&metro->all_passengers[i]);
    }
    init_station(&metro->station);
    for (int i = 0; i < nt; i++){
        init_train(&metro->all_trains[i], nseats, nticks);
    }
}

// TODO point: changes probably required to this function
void term_simulation(int np, int nt) {
    // This function is just to release the allocated resources
    printf("[e] Releasing resources...\n");
    for (int i = 0; i < nt; i++)
        term_train(&metro->all_trains[i]);

    term_station(&metro->station);
    free(metro);
    metro = NULL;
}


// TODO point: changes probably required to this function
void notify_passenger_of_train_arrival(int pass_id) { // pass_id is passenger identification
    check_valid_passenger(pass_id); 
    // TODO point: PUT YOUR PASSENGER DESTINATION ARRIVAL NOTIFICATION CODE HERE

    mutex_lock(&metro->all_passengers[pass_id].access);

    metro->all_passengers[pass_id].arrived_to_destination = 1;

    cond_broadcast(&metro->all_passengers[pass_id].arrived);

    mutex_unlock(&metro->all_passengers[pass_id].access);
}

// TODO point: changes probably required to this function
void train_life(int id) {
    // travel_time:

    mutex_lock(&metro->station.access);

    while(metro->station.train != NULL) {
        cond_wait(&metro->station.notFull_inStation, &metro->station.access);
    }

    random_wait();
    check_valid_train(id);
    printf("[e] Train %s (number %d): service starts\n", metro->all_trains[id].name, id);
    set_next_train(&metro->station, &metro->all_trains[id]);
    printf("[e] Train %s (number %d): stops at station\n", metro->all_trains[id].name, id);

    // wait a fixed time for passengers
    do {
        usleep((useconds_t)countdown_tick);
    } while (decrement_departure_time(&metro->all_trains[id]));

    printf("[e] Train %s (number %d): leaves station\n", metro->all_trains[id].name, id);
    random_wait();
    printf("[e] Train %s (number %d): arrives destination\n", metro->all_trains[id].name, id);
    train_arrived_destination(&metro->all_trains[id]);
    printf("[e] Train %s (number %d): service ended\n", metro->all_trains[id].name, id);

    mutex_unlock(&metro->station.access);
}

// TODO point: changes probably required to this function
int passenger_try_to_enter_train(int id) {
    int res = 1; // succeeds by default
    check_valid_passenger(id);
    Passenger* passenger = &metro->all_passengers[id];
    printf("[e] Passenger %s (number %d): enters station and waits train\n", passenger->name, id);

    passenger->seat = passenger_seat_assign(&metro->station, id); // Corrigir chamada para passenger_seat_assign
    printf("[e] Passenger %s (number %d): enters train in seat %d\n", passenger->name, id, passenger->seat);

    return res;
}

// TODO point: changes probably required to this function
void passenger_wait_arrival_to_destination(int id) {
    check_valid_passenger(id);

    mutex_lock(&metro->all_passengers[id].access);
    while(&metro->all_passengers[id].arrived_to_destination == 0) {

        cond_wait(&metro->all_passengers[id].arrived, &metro->all_passengers[id].access);
    }
    //notify_passenger_of_train_arrival(id); // TODO point: to be commented/deleted in concurrent version

    mutex_unlock(&metro->all_passengers[id].access);
    printf("[e] Passenger %s (number %d): arrived to destination\n", metro->all_passengers[id].name, id);
}

// TODO point: changes probably required to this function
void passenger_life(int id) {
    random_wait();

    if (passenger_try_to_enter_train(id))
        passenger_wait_arrival_to_destination(id);
    else
        printf("[e] Passenger %s (number %d): misses all trains (station closed)\n", metro->all_passengers[id].name, id);
}


void* passenger_Thread(void *arg) {

    int* id = (int*)arg;

    passenger_life(*id);

    return NULL;
}


void* train_Thread(void *arg) {

    int* id = (int*)arg;

    train_life(*id);

    return NULL;
}

int main(int argc, char *argv[]) {
    // command line processing (no change required)
    int option;
    while ((option = getopt(argc, argv, "p:t:s:d:w:c:h")) != -1) {
        switch (option) {
            case 'p':
                npassengers = atoi(optarg);
                if (npassengers <= 0 || npassengers > MAX_PASSENGERS) {
                    fprintf(stderr, "Invalid number of passengers\n");
                    fprintf(stderr, "run: %s -h\n", argv[0]);
                    return EXIT_FAILURE;
                }
                break;
            case 't':
                ntrains = atoi(optarg);
                if (ntrains <= 0 || ntrains > MAX_TRAINS) {
                    fprintf(stderr, "Invalid number of trains\n");
                    fprintf(stderr, "run: %s -h\n", argv[0]);
                    return EXIT_FAILURE;
                }
                break;
            case 's':
                nseats = atoi(optarg);
                if (nseats <= 1 || nseats > MAX_TRAIN_NUM_SEATS) {
                    fprintf(stderr, "Invalid number of seats per train\n");
                    fprintf(stderr, "run: %s -h\n", argv[0]);
                    return EXIT_FAILURE;
                }
                break;
            case 'd':
                nticks = atoi(optarg);
                if (nticks <= 1 || nticks > MAX_DEPARTURE_TIME) {
                    fprintf(stderr, "Invalid departure time\n");
                    fprintf(stderr, "run: %s -h\n", argv[0]);
                    return EXIT_FAILURE;
                }
                break;
            case 'w':
                maxwait = atoi(optarg);
                if (maxwait <= 1 || maxwait > MAX_WAIT) {
                    fprintf(stderr, "Invalid max wait time\n");
                    fprintf(stderr, "run: %s -h\n", argv[0]);
                    return EXIT_FAILURE;
                }
                break;
            case 'c':
                countdown_tick = atoi(optarg);
                if (countdown_tick <= 1 || countdown_tick > MAX_COUNTDOWN_TICK) {
                    fprintf(stderr, "Invalid countdown tick time\n");
                    fprintf(stderr, "run: %s -h\n", argv[0]);
                    return EXIT_FAILURE;
                }
                break;
            case 'h':
                printf(USAGE, USAGE_ARGS);
                return EXIT_SUCCESS;
            default:
                fprintf(stderr, "Non valid option\n");
                fprintf(stderr, USAGE, USAGE_ARGS);
                return EXIT_FAILURE;
        }
    }
    if (argc - optind != 0) {
        fprintf(stderr, "Invalid argument(s).\n");
        fprintf(stderr, "run: %s -h\n", argv[0]);
        return EXIT_FAILURE;
    }

    // start random generator
    srand(getpid() + time(NULL));

    // init simulation
    init_simulation(npassengers, ntrains);


    // TODO point: REPLACE THE FOLLOWING DUMMY CODE WITH code to launch
    // active entities and code to properly terminate the simulation.
    // Dummy code to show a proper termination with sequential behavior.
    
    pthread_t passengers[npassengers];

    int p_ids[npassengers];

    for (int i = 0; i < npassengers; i++) {
        p_ids[i] = i;

        thread_create(&passengers[i], NULL, passenger_Thread, &p_ids[i]);
    }

    pthread_t trains[ntrains];

    int t_ids[ntrains];

    for (int i = 0; i < npassengers; i++) {
        t_ids[i] = i;

        thread_create(&trains[i], NULL, train_Thread, &t_ids[i]);
    }

    for (int i = 0; i < ntrains; i++) {

        thread_join(trains[i], NULL);
    }

    close_station(&metro->station);
    // end of dummy code

    for (int i = 0; i < npassengers; i++) {
        t_ids[i] = i;

        thread_join(passengers[i], NULL);
    }

    // terminate simulation
    term_simulation(npassengers, ntrains);
    return EXIT_SUCCESS;
}

// IGNORE THE FOLLOWING CODE */
static char **names = (char *[]) {"Ana", "Miguel", "Luis", "Joao", "Artur", "Maria", "Luisa", "Pedro", "Paulo", "Paula", NULL};

char* random_name() {
    static int names_len = 0;
    if (names_len == 0) {
        for (names_len = 0; names[names_len] != NULL; names_len++);
    }
    return names[(int)(names_len * (double)rand() / ((double)RAND_MAX + 1))];
}

void new_passenger(Passenger* passenger) {
    strcpy(passenger->name, random_name());
    passenger->arrived_to_destination = 0;
    passenger->seat = INVALID_SEAT;
}

void random_wait() {
    usleep((useconds_t)(maxwait * (double)rand() / ((double)RAND_MAX + 1)));
}