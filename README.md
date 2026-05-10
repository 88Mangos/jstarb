# J*b (Jstarb): Tyler's Personal Career Tracker
```sh
src/
├── main.zig          # Entrypoint: Init Raylib + DB, run loop. 
├── root.zig          # Top-level exports. 
├── back/
│   ├── data.zig      # Data Structures for Entries/Events 
│   ├── state.zig     # Transition Validator (DFA logic). 
│   ├── storage.zig   # SQLite/JSON serialization logic. 
│   └── analytics.zig # "Week ID" bucketing & stats calculation. 
└── front/
    ├── gui.zig       # Buttons, Text Boxes, and the "Docket" list.
    └── renderer.zig  # Raylib wrappers for drawing the charts.
```

## Exigence
I've been curious about a few things:

1. Zig
2. Databases
3. why does Notion charge me so much just to make a few charts

I used to use Notion, but quit after realizing they make people pay for multiple charts. 

I've been using Google Sheets as an alternative, but there are certain things that I'd ideally want to have for my job application tracker. Just fun insights. 

Right now it's a table in a google sheet with auxiliary columns to make graphs from, but the issue is that making certain charts requires extra table entries (such as a column that just uses a relative datetime formula to check if something was submitted in the last week). I also want a chart that shows applications per week, as a nice line timeseries chart, but it's unable to put in weeks that have zero because the count formula can't find it *(and I'm not good enough at spreadsheets to figure it out, nor do I care enough to get that good at spreadsheets).*

I brain dumped everything I want to be able to do in my workflows summary [Link](./design/WORKFLOWS.md).

## Designing Data Structures
I wanted to make this blazingly fast, even if it's very much useless since we're not handling that high volume of data. I mean at the very worst I'm applying to a thousand jobs? That's still very handle-able for modern hardware. But that's not fun. 
- [Entries and Events](./design/EVENTDB.md)
- [Handling Locations](./design/LOCATIONS.md)
