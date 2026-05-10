//
// Implementing Query Logic
//  for Chart Summary Statistics
//

fn get_week(time: i64) i64 {
    const seconds_per_week = 7 * 24 * 60 * 60;
    return time / seconds_per_week;
}

// get last updated time by going to ledger, events, and then grabbing the timestamp of the last item
// if it's a resume bucket then last updated is just created_at.

// function for when did I apply to this job?
// search ledger for the applied event

// function for when did I interview?
// search ledger for interview events
