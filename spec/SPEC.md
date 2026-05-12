We store a chronologically ordered list of entries. Each entry, amongst other things, contains a ledger of events. We use a manager pattern, which upon initialization, reads in all existing entries and stores them, and as an implementation detail, contains the arena allocator that allocates all the relevant strings.

The intended usage pattern is that the app is spun up, the manager is initialized, the user does all their updates, then shuts down the app and the manager then frees all the strings. Note that the manager is responsible for updating all of the entries according to the user's actions before being deinitialized.

# `Manager` Struct
- arena allocator that allocates and frees strings during reading in entries and writing out entries 
- `ArrayList` of `Entry`, or using Data-Oriented Design:
  - Instead of storing an array of structs, I could store a struct of arrays using `std.MultiArrayList`. But this is actually an overoptimization because we're reading entire events and entries at a time, not updating all entries simultaneously. So a standard ArrayList is better for cache locality here.
- the number of entries and events, if only to have methods to produce fresh entry ids and events. I'd rather not use UUIDs.
- future work: may or may not consider doing concurrent updates? Where one manager handles several entry lists? 

# Defining our Nouns
The overall trouble we have to overcome is distinguishing between first class nouns and entries.

TODO: fill everything out from this [gemini link](https://gemini.google.com/share/91b588ec2333)

