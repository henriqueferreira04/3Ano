#include <dbc.h>
#include <utils.h>
#include <string.h>
#include "station.h"


// TODO point: changes probably required to this function
void init_station(Station* station)
{
    require (station != NULL, "NULL pointer to station"); // a false value indicates a program error

    station->train = NULL; // no train in station
    station->total_num_seats = 0; // no seats in station
    station->num_seats_occupied = 0;
    station->open = 1;

    cond_init(&station->closed, NULL);
    mutex_init(&station->access, NULL);


}

// TODO point: changes probably required to this function
void term_station(Station* station)
{
    require (station != NULL, "NULL pointer to station"); // a false value indicates a program error
    check (station->train == NULL, "a train still in station");
    check (station->total_num_seats == 0 && station->num_seats_occupied == 0, "a train still in station");

    cond_destroy(&station->closed);
    mutex_destroy(&station->access);
}

// TODO point: changes probably required to this function
void close_station(Station* station)
{   
    mutex_lock(&station->access);

    require (station != NULL, "NULL pointer to station"); // a false value indicates a program error
    require (station->open, "station not opened");

    station->open = 0;

    cond_broadcast(&station->closed);
    mutex_unlock(&station->access);
    // TODO point: PUT YOUR STATION TERMINATION NOTIFICATION CODE HERE
    // no more trains, so pending passengers should be notified to leave station
}

// TODO point: changes probably required to this function
void set_next_train(Station* station, Train* train) {
    require (station != NULL, "NULL pointer to station");
    require (train != NULL, "NULL pointer to train");
    require (station->train == NULL, "a train still in station");

    mutex_lock(&station->access);
    mutex_lock(&train->access);

    station->train = train;
    station->total_num_seats = train->total_num_seats;
    station->num_seats_occupied = 0;

    cond_broadcast(&station->notFull_inStation);
    

    mutex_unlock(&station->access);
}

// TODO point: changes probably required to this function
void train_departure(Station* station) {
    require(station != NULL, "NULL pointer to station"); // a false value indicates a program error

    // TODO point: PUT YOUR TRAIN DEPARTURE NOTIFICATION CODE HERE
    station->train = NULL;
    station->total_num_seats = 0;
    station->num_seats_occupied = 0;
}

// TODO point: changes probably required to this function
int passenger_enters_station_and_wait_next_train(Station* station, int pass_id) { // returns seat number
    require(station != NULL, "NULL pointer to station");
    require(pass_id >= 0 && pass_id <= MAX_ID, "invalid passenger id"); // a false value indicates a program error

    mutex_lock(&station->access);

    while(!(station->num_seats_occupied < station->total_num_seats)) {

        cond_wait(&station->notFull_inStation, &station->access);
    }

    require(station->num_seats_occupied < station->total_num_seats, "train full"); // IMPORTANT: in a shared station, it may not result from change or comment this line in the concurrent version


    int res;
    res = enter_train(station->train, pass_id);
    check_valid_seat(res);
    station->num_seats_occupied++;

    mutex_unlock(&station->access);

    return res;
}

int passenger_seat_assign(Station* station, int pass_id) {
    require(station != NULL, "NULL pointer to station");
    require(pass_id >= 0 && pass_id <= MAX_ID, "invalid passenger id");
    require(station->train != NULL, "no train in station");

    return enter_train(station->train, pass_id);
}
