const std = @import("std");
//
// Defining Items outside
//

const Person = struct {
    first_name: []const u8,
    last_name: []const u8,
    phone: ?[]const u8,
    email: ?[]const u8,
    company: ?[]const u8,
    notes: []const u8,
};

const Location = []const u8; // right now, locations are just strings.

const Time = i64; // Unix Time

const Resume = struct {
    resumeId: []const u8, // identifier for which resume was submitted
};

//
// Career Related Sub-Items
//

const Metadata = struct {
    created_at: Time,
    notes: []const u8,
    link: ?[]const u8,
};

const OA = struct {
    status: enum { Received, Completed, Ignored },
    due: ?Time,

    metadata: Metadata,
};

const Meeting = struct {
    status: enum { Received, Scheduled, Completed },
    schedule: ?Time,
    location: ?Location,
    type: enum { CoffeeChat, BehavioralInterview, TechnicalInterview, RecruiterScreen },
    people: ?std.ArrayList(Person),

    metadata: Metadata,
};

const Offer = struct {
    status: enum { Received, Responded },
    outcome: enum { Accept, Reject, Reneg, Rescinded },

    metadata: Metadata,
};

const Position = struct {
    title: []const u8,
    location: Location,

    oas: std.ArrayList(OA),
    interviews: std.ArrayList(Meeting),
    offer: ?Offer,

    metadata: Metadata,
};

const Event = struct {
    oas: std.ArrayList(OA),

    metadata: Metadata,
};

const Chat = struct {
    meeting: Meeting,
};

const Bucket = struct { metadata: Metadata };
