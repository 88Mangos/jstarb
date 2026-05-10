# Entries and Events
We take inspiration from 15-210 SML Library's Single-Threaded Sequences (STSeq), which are views of a sequence derived from a history. A user should only use the "most-recent" version of an STSeq; doing otherwise violates the promised cost bounds, as that would require re-creating the most recent version from the history.

> Also technically lends from **event-based databases**. Entries contain a ledger which is just a list of events. Events have their own subvariants, but more importantly, Entries also store their own views, which are updated and materialized based on the ledger.

Similarly, the entire job tracker focuses on tracking an individual `Entry`, each containing a "ledger" of `Event`s. It is therefore possible to query everything we'd ever want to know about an `Entry` from the ledger, but we want to cache the information into a "view" for better cache locality and higher performance.

## Example Query 
To answer the question

> When did I apply to be a 15-210 TA?

The naive approach is is to find the entry for the 15-210 TA job opening, then iterate through the ledger in chronological order until we find the `Event` that says `Applied`. However, if we cache the `applied_at` time for each job opening, we needn't perform this search every time, and we also improve cache locality since it'll be stored in the struct, and not in some evil linked list. 

*Granted, this is a terrible example, because the `Event` of applying to a job opening is likely one of the first elements in the ledger, and therefore unlikely to take more than one or two linked-list pointer jumps. But we're not trying to be practical here are we? If we were, I'd just stick with my Google Sheet.*

## Future Ideas
For now, I'll store everything locally in a JSON-serialized format. But eventually (*after taking 15-445, Database Systems*) I'd like to try to write my own database engine in Zig. I think it'd be cool. So we'll see.

> **Interesting Idea for the Future:** custom Zig DB for Jstarb.

## Final Data Structure Design
Initially, there was a lot of `Entry`-specific fields that were organized into private sub-structs. But this design pattern is a little annoying to deal with, especially because so many of these things are shared.

### Designing an `Entry`

#### Shared Metadata
All entries need a unique identifier and their creation date, i.e., when they were added to the database. It is also helpful to track a list of tags.
```zig
// metadata
id: u64,
created_at: i64,
tags: [][]const u8,
```

#### Shared Data
All entries have a specific `Entry`-type, which is one of
1. Job Opening
2. Outreach Event
3. Coffee Chat
4. Resume Bucket 
These are all associated with some company, in some location and at some time. 

It would also be helpful to store links, notes, and a list of useful people related to the `Entry`.

All entries also have a short text title; *this isn't necessarily true for coffee chats and resume buckets, so we'll have the appropriate defaults there.*

Last, we'd ideally like to quickly query any impending deadlines.
```zig
// data
type: enum { JobOpening, OutreachEvent, CoffeeChat, ResumeBucket },
company: []const u8,
link: []const u8,
notes: []const u8,
location: location,
people: std.ArrayList(Person), // store interviewers, coffee chat people, or anyone else jotting down

// defaults to "Resume Bucket @ [company_name]" or "Coffee Chat @ [company_name]"
// but for events and job openings, has a specific name.
title: []const u8,

deadlines: ?std.ArrayList(struct {
    due: ?time,
    item: enum { Application, OA },
}), // treated as a stack
```



#### `Entry`-type-specific Data

#### Table Summary
To motivate the need for these struct fields, consider these examples below:

- tags: SWE, Startup, Finance, 

|   | Job Opening | Outreach Event | Coffee Chat | Resume Bucket |
|---|---|---|---|---|
| title | Google STEP Intern | HRT Explore | Coffee Chat w/ Jump Trading | Resume Drop for Apple |
| deadlines | Application due in a week, OA due in a week, Upcoming scheduled interview, Offer deadline | OA due in a week, Upcoming scheduled event | Upcoming scheduled chat | - |
| people | Interviewers, Recruiters | Host, Panelists | Hopefully obvious | - |
| location | Job Location | Event Location (often Remote) | Coffee Shop @ Carnegie Museum | Career Fair |
|   |   |   |   |   |
|   |   |   |   |   |


#### Final Definition