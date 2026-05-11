# J*b (Jstarb): Tyler's Personal Career Tracker
```sh
src/
├── main.zig          # entrypoint: Init Raylib + DB, run loop. 
├── root.zig          # Top-level exports. 
├── back/
│   ├── data.zig      # Data Structures for Entries/Updates 
│   ├── state.zig     # Transition Validator (DFA logic). 
│   ├── storage.zig   # SQLite/JSON serialization logic. 
│   └── analytics.zig # "Week ID" bucketing & stats calculation. 
└── front/
    ├── gui.zig       # Buttons, Text Boxes, and the "Docket" list.
    └── renderer.zig  # Raylib wrappers for drawing the charts.
```
See https://88mangos.github.io/projects/jstarb/ for the journey 