//
// NOTE: all `usize` fields are meant to be indices.
//

const Time = i64; // Unix timestamps

const Location = []const u8;

// foreign key that maps low-level entities to their parent entries
// via indices. The variant gives you the relation to search in the Manager.
const EntryContext = union(enum) {
    position: usize,
    event: usize,
    bucket: usize,
    none: void,
};

const Company = struct {
    id: usize,
    created_at: Time,
    notes: []const u8,
};

const Person = struct {
    id: usize,
    company_id: usize,

    created_at: Time,
    notes: []const u8,
};

//
// Low Level Entities
// NOTE: defined as flat records for easy JSON serialization
//

const Meeting = struct {
    id: usize,
    ctx: EntryContext,

    type: enum { CoffeeChat, Technical, Behavioral, Recruiter },
    scheduled_time: ?Time,
    location: ?Location,
    link: ?[]const u8,

    created_at: Time,
    notes: []const u8,
};

const OA = struct {
    id: usize,
    ctx: EntryContext,

    due_date: ?Time,
    link: ?[]const u8,

    created_at: Time,
    notes: []const u8,
};

//
// High Level Entries
// NOTE: Coffee Chats are just meetings,
//  thus meetings are both low and high level entities
//

const Offer = struct {
    received_at: Time,
    status: enum { Accepted, Rejected, Reneged, Rescinded },
};

const Position = struct {
    id: usize,
    company_id: usize,

    title: []const u8,
    link: ?[]const u8,

    offer: ?Offer,

    created_at: Time,
    notes: []const u8,
};

const Event = struct {
    id: usize,
    company_id: usize,

    title: []const u8,
    link: ?[]const u8,

    created_at: Time,
    notes: []const u8,
};

const Bucket = struct {
    id: usize,
    company_id: usize,

    title: []const u8,
    link: ?[]const u8,

    created_at: Time,
    notes: []const u8,
};
