//
// Defining Data Structures
//
// Thankfully, structs are lazily declared, so we don't
// have to declare them in dependency order.
//
// TODO: to avoid memory leaks after the storage reader
// loads in the data, we tag all structs that contain
// allocatables with a `deinit` method.
//
const std = @import("std");

//
// MARK: Generic Data Structures: Time, Location, People
//

pub const time = i64; // Unix time

pub const location = []const u8; // right now, locations are just strings.

pub const Person = struct {
    first_name: []const u8,
    last_name: []const u8,
    phone: ?[]const u8,
    email: ?[]const u8,
    company: ?[]const u8,
    notes: []const u8,
};

//
// MARK: Entry Definition
//

pub const Status = enum {
    // Pending
    LookingAt,
    Applied,
    // Active
    Interviewing,
    Scheduled,
    OfferReceived,
    // Terminal
    OfferAccepted,
    OfferRejected,
    Rejected,
    Ghosted,
    Attended,
    // Discarded
    Ignored,
    Withdrawn,
    DeadlinePassed,
};

pub const Entry = struct {
    // metadata
    id: u64,
    created_at: i64,
    tags: [][]const u8,

    // data
    type: enum { JobOpening, OutreachEvent, CoffeeChat, ResumeBucket },
    company: []struct { type: enum { Startup, BigTech, Finance, Quant }, name: []const u8 },
    link: []const u8,
    notes: []const u8,
    location: location,
    scheduled: ?time,
    people: std.ArrayList(Person), // store interviewers, coffee chat people, or anyone else jotting down

    // defaults to "Resume Bucket @ [company_name]" or "Coffee Chat @ [company_name]"
    // but for events and job openings, has a specific name.
    title: []const u8,

    deadlines: ?std.ArrayList(struct {
        due: ?time,
        item: enum { Application, OA },
    }), // treated as a stack

    // based on Entry.type...
    //  we know what enum to use for Event.type
    //  NOTE: to save memory, no ledger for resume buckets
    ledger: ?std.ArrayList(Event),
    //  we know how to interpret this materialized view
    view: union(enum) {
        job_opening: JobOpeningInfo,
        outreach_event: OutreachEventInfo,
        coffee_chat: CoffeeChatInfo,
        resume_bucket: void, // parent Entry contains everything we need (company, link, notes)
    },
};

//
// MARK: Job Information
//

pub const JobOpeningInfo = struct {
    applied_at: ?time,

    state: union(enum) {
        // Did not apply for the j*b yet, with corresp. reason
        pending: enum { LookingAt, Withdrawn, DeadlinePassed, Ignored },

        // Process of getting the j*b
        submitted: void,
        oa: struct {
            status: enum { Received, Complete },
            due: ?time, // probably want to wrap this somewhere else right?
            notes: []const u8, // about what platform, AI-allowed or not, etc.
        },
        interview: struct {
            people: std.ArrayList(Person),
            location: ?location,
            scheduled: ?time,
            complete: bool,
            notes: []const u8,
            // identical to coffee_chat anonymous struct, except also has a type
            type: enum { Behavioral, Technical, General },
        },

        // Post j*b offer, with appropriate status
        offer: enum { Received, Accepted, Rejected },

        // Bad things, which we will not manifest
        noOffer: enum { Rejected, Ghosted },
    },
};

//
// MARK: Outreach Event Information
// NOTE: To be honest I think job openings and outreach events could be merged,
//  but I think I prefer the explicitly different treatment. I swear, if these
//  companies turn outreach events into whole job applications,
//  I might just stay j*bless.
//
pub const OutreachEventInfo = struct {
    state: union(enum) {
        pending: enum { LookingAt, Ignored },

        // Process of getting the j*b
        submitted: void,

        // most outreach events don't have OAs,
        // but there are exceptions, e.g., HRT explore
        oa: struct {
            status: enum { Received, Complete },
            due: ?time,
            notes: []const u8, // about what platform, AI-allowed or not, etc.
        },
        attended: void,
        rejected: void,
    },
};

//
// MARK: Event Definition
// Each event corresponds to updating fields in the appropriate information struct
//

pub const Event = struct {
    // metadata
    id: u64,
    created_at: time,
    entryId: u64,
    notes: []const u8,

    // data, with corresp. Entry fields to update, using 15210 as a placeholder time
    type: union(enum) {
        job_opening: enum {
            BeginTracking
            // Entry.job_opening.state.pending = LookingAt
            ,
            Applied
            // Entry.job_opening.state.submitted.{}
            ,
            OAReceived
            // Entry.job_opening.state.oa.status = Received
            // Entry.job_opening.state.oa.due = 15210
            // Entry.job_opening.state.oa.notes = "Pre-OA yap"
            ,
            OADone
            // Entry.job_opening.state.oa.status = Complete
            // Entry.job_opening.state.oa.notes = "Post-OA yap"
            ,
            InterviewReceived
            // Entry.job_opening.state.interview.people = [], add if known
            // Entry.job_opening.state.interview.location = null, add if known
            // Entry.job_opening.state.interview.scheduled = null, add if known
            // Entry.job_opening.state.interview.complete = false
            // Entry.job_opening.state.interview.notes = "Pre-interview yap"
            // Entry.job_opening.state.interview.type = Behavioral | Technical | General
            ,
            InterviewScheduled
            // Entry.job_opening.state.interview.people = [add people here]
            // Entry.job_opening.state.interview.location = "probably remote"
            // Entry.job_opening.state.interview.scheduled = 15210
            // Entry.job_opening.state.interview.notes = "More pre-interview yap"
            ,
            InterviewReScheduled,
            InterviewDone
            // Entry.job_opening.state.interview.complete = true
            // Entry.job_opening.state.interview.notes = "Post-interview yap"
            ,
            OfferReceived
            // Entry.job_opening.state.offer = Received
            ,
            OfferAccepted
            // Entry.job_opening.state.offer = Accepted
            ,
            OfferRejected
            // Entry.job_opening.state.offer = Rejected
            ,
            Rejected
            // Entry.job_opening.state.noOffer = Rejected
            ,
            Withdrawn
            // Entry.job_opening.state.pending = Withdrawn
            ,
        },
        outreach_event: enum {
            Applied
            // Entry.outreach_event.people = [], add if known
            // Entry.outreach_event.location = null, add if known
            // Entry.outreach_event.scheduled = null, add if known
            // Entry.outreach_event.complete = false
            // Entry.outreach_event.notes = "Pre-event yap"
            // Entry.outreach_event.state.submitted = {}
            ,
            OAReceived
            // Entry.outreach_event.state.oa = {.status=Received, due=null or add if known, notes="Pre-OA yap" }
            ,
            OADone
            // Entry.outreach_event.state.oa = {.status=Complete, notes="Post-OA yap" }
            ,
            Attended
            // Entry.outreach_event.state.attended = {}
            // Entry.outreach_event.notes = "Post-event yap"
            ,
            Rejected
            // Entry.outreach_event.state.rejected = {}
            ,
        },
        coffee_chat: enum {
            Scheduled
            // Entry.coffee_chat.people = [], add if known
            // Entry.coffee_chat.location = null, add if known
            // Entry.coffee_chat.scheduled = null, add if known
            // Entry.coffee_chat.complete = false
            // Entry.coffee_chat.notes = "Pre-chat yap"
            ,
            Done
            // Entry.outreach_event.complete = true
            // Entry.outreach_event.notes = "Post-chat yap"
            ,
        },
        resume_bucket: void, // submitted, TODO: add string linking to which resume I submitted?
    },
};
