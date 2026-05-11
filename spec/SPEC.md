We store a chronologically ordered list of entries. Each entry, amongst other things, contains a ledger of events. We use a manager pattern, which upon initialization, reads in all existing entries and stores them, and as an implementation detail, contains the arena allocator that allocates all the relevant strings.

The intended usage pattern is that the app is spun up, the manager is initialized, the user does all their updates, then shuts down the app and the manager then frees all the strings. Note that the manager is responsible for updating all of the entries according to the user's actions before being deinitialized.

# `Manager` Struct
- arena allocator that allocates and frees strings during reading in entries and writing out entries 
- `ArrayList` of `Entry`, or using Data-Oriented Design:
  - Instead of storing an array of structs, I could store a struct of arrays using `std.MultiArrayList`
- the number of entries and events, if only to have methods to produce fresh entry ids and events. I'd rather not use UUIDs.
- future work: may or may not consider doing concurrent updates? Where one manager handles several entry lists? 

# `Status` Enum
should have an underlying integer type so we can make these things comparable, and maybe with some funny gimmick (e.g., making all pending things a multiple of 2, and terminals a multiple of 3 or smth) we can easily categorize the status enum into higher level status categories. I mean pending is p easy, just check if its nonzero and also less than Rejected/Offered/Ghosted yk.

- Before the process
  - looking at 
- Pending
  - already applied/submitted
  - OA received
  - OA complete (awaiting interview)
  - interviewing 
    - Interview invite received
    - Interview Scheduled
    - Interview complete (awaiting next interview, or offer/rejection)
- Company Terminal
  - Rejected
  - Offered
  - Ghosted 
- User Terminal
  - offer accepted or rejected
  - ignored
  - application withdrawn

# `Entry` Struct
- type: job opening, outreach event, coffee chat, resume bucket
- entry status
- a union based on the type, containing the information for each type of entry.

metadata: id, creation time, tags, notes

## Shared information between Entry Types
1. company the thing is relevant to
2. location (position location, event location, chat location, resume drop where did I find it (e.g., career fair))
3. people: interviewers, recruiters, people who worked at the company previously, etc.
4. a string title for what the entry is 
5. upcoming deadlines, a stack of due dates and the item (item being an application, or OA, or interview, or chat upcoming). Such `Items` can be considered maybe deliverables? Or executables? Not quite sure how to organize these.
6. when did I apply (submit app for position or event, schedule coffee chat, drop the resume)

## Optional Information for Entries 
1. a link to the entry source (job app link, event link, maybe not for coffee chats, resume drop link)
2. ledger (`ArrayList` of `Update`). to save memory, may not have to have the resume bucket store a ledger, since it's a one-event thing.


## Job Openings: `Position`


## Outreach Events: `Event`

## Coffee Chats: `Chat`

## Resume Buckets: `Bucket`
1. company for the resume drop
2. link to the resume drop (may be an in-person thing, but this is getting rarer so we can assume online)
3. some identifier for the resume that was submitted.



# `Update` Struct
- some sort of description of the update


