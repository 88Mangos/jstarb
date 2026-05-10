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