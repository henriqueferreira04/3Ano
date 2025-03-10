#include <dbc.h>
#include <utils.h>
#include <string.h>
#include "station.h"



static int train_number = 0;
static int empty_train(Train* train);
static int full_train(Train* train);

// ...existing code...
// TODO point: changes probably required to this function
void init_train(Train* train, int total_num_seats, int time_to_departure) {
    require (train != NULL, "NULL pointer to train");  // a false value indicates a program error
    require (total_num_seats > 0 && total_num_seats <= MAX_TRAIN_NUM_SEATS, "Invalid number of seats");  // a false value indicates a program error
    require (time_to_departure > 0 && time_to_departure <= MAX_DEPARTURE_TIME, "Invalid departure time");  // a false value indicates a program error

    train_number++;
    sprintf(train->name, "T%03d", train_number); // Corrigir a formatação do nome do trem
    
    train->total_num_seats = total_num_seats;
    train->num_seats_occupied = 0;

    for (int i = 0; i < MAX_TRAIN_NUM_SEATS; i++)
        train->pass_id[i] = INVALID_ID; // Initialize all seats as not taken
    train->total_num_seats = total_num_seats;
    train->in_transit = 0;
    train->num_seats_occupied = 0;
    train->time_to_departure = time_to_departure;

    
    mutex_init(&train->access, NULL);

}

// TODO point: changes probably required to this function
void term_train(Train* train) {
    require(train != NULL, "NULL pointer to train"); // a false value indicates a program error
    
    check(!train->in_transit, "Invalid final state in train (in transit)!");
    check(empty_train(train), "Invalid final state in train (train not empty)!");
    for(int i = 0; i < train->total_num_seats; i++) {
        check (train->pass_id[i] == INVALID_ID, "Invalid passenger ID");
    }

    
    mutex_destroy(&train->access);

    memset(train->name,0,sizeof(train->name));

    
    
}

// TODO point: changes probably required to this function
// TODO point: changes probably required to this function
int enter_train(Train* train, int pass_id) {  // returns seat number (TRAIN_FULL if train is full)
    require(train != NULL, "NULL pointer to train");  // a false value indicates a program error
    require(pass_id >= 0 && pass_id <= MAX_ID, "Invalid passenger ID");  // a false value indicates a program error

    mutex_lock(&train->access);

    int res;
    if (full_train(train)) {
        res = TRAIN_FULL;
    } else {

        do {
            res = random_int(0, train->total_num_seats - 1);
        } while(train->pass_id[res] != INVALID_ID);
        
            train->pass_id[res] = pass_id;
            train->num_seats_occupied++;
        }

    

    mutex_unlock(&train->access);
    
    return res;
}

// TODO point: changes probably required to this function
int decrement_departure_time(Train* train) {  // train leaves station when time_to_departure reaches zero
    require(train != NULL, "NULL pointer to train");  // a false value indicates a program error
    require(train->time_to_departure > 0, "Invalid departure time"); // conditional synchronization point
    
    int res = 0;
    train->time_to_departure--;
    if (train->time_to_departure == 0) {
        train->in_transit = 1;
        res = 1;
    }
    
    return res;
}

// TODO point: changes probably required to this function
void train_arrived_destination(Train* train) {  // train arrives to destination, notify all passengers to leave
    require(train != NULL, "NULL pointer to train"); // a false value indicates a program error

    mutex_lock(&train->access);

    require(train->in_transit, "Train already arrived"); // conditional synchronization point
    
    train->in_transit = 0;
    
    for (int i = 0; i < train->total_num_seats; i++) {
        if (train->pass_id[i] != INVALID_ID) {
            notify_passenger_of_train_arrival(train->pass_id[i]);
            train->pass_id[i] = INVALID_ID;
            train->num_seats_occupied--;
            
        }
    }

    mutex_unlock(&train->access);
}


static int empty_train(Train* train) {
    require(train != NULL, "NULL pointer to train"); // a false value indicates a program error

    return train->num_seats_occupied == 0;
}

static int full_train(Train* train) {
    require(train != NULL, "NULL pointer to train"); // a false value indicates a program error

    return train->num_seats_occupied == train-> total_num_seats;
}

