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