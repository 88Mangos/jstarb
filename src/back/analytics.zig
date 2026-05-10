//
// MARK: Add Entries to DB
//

fn add_job_application() void {}

//
// MARK: Update DB Entries
//

// if it's been too long since last new new ledger entry...

// and we haven't submitted an application to the job_opening,
//  if there's a due date and it's passed,
//    Entry.job_opening.state.pending = DeadlinePassed
//  else,
//    Entry.job_opening.state.pending = Ignored
// and we haven't heard back after submitting (including if we've interviewed)
//  Entry.job_opening.state.noOffer = Ghosted

//
// MARK: Query DB Entries for Charts
//

fn get_week(time: i64) i64 {
    const seconds_per_week = 7 * 24 * 60 * 60;
    return time / seconds_per_week;
}

// function for when did I apply to this job?
// search ledger for the applied event

// function for when did I interview?
// search ledger for interview events
