---
Gemini Source: https://gemini.google.com/share/f59576ddbb6f
---
Building your Job Tracker as a local-first, native desktop application using **Raylib** allows you to create a high-performance "Game-Style" dashboard that completely bypasses the complexity of web servers or CSS. Because Raylib uses **Immediate Mode GUI** principles, you can "paint" your "Weekly Pulse" charts and "Job Dockets" directly to the GPU every frame.

Here is your implementation roadmap, categorized by the core concepts and dependencies you will need to master.

### 1. Essential Dependencies

**Raylib (Zig-Bindings)**: Use the `raylib-zig` package to interface with the C graphics library. This handles your window, inputs, and 2D/3D drawing.


**SQLite (C-Library)**: Since Zig has excellent C-interop, you will pull in `libsqlite3` to act as your "black box" storage engine.


**Zig Standard Library**: You will rely heavily on `std.ArrayList` for your in-memory ledger and `std.json` if you decide to store metadata as blobs.



---

### 2. Implementation Roadmap

#### Phase 1: The "Materialized" Backend

Before touching graphics, you must finalize the data flow.

* [X] **Define the Core Structs**: Finalize the `Entry` (parent) and `Event` (ledger) structs.


* [ ] **SQLite Schema**: Implement **Single Table Inheritance** for entries, where different categories (Coffee Chat vs. Application) use different nullable columns.


* [ ] **The Ledger Writer**: Create a function to append `Event` logs to your database whenever a status changes.


* [ ] **State Machine Logic**: Write a `Transition Validator` in Zig that ensures an entry's state only changes based on valid ledger history.



#### Phase 2: The Graphics Engine & "Docket" View

Get your first window running and displaying live data.

* [ ] **Raylib Initialization**: Set up a basic $60$ FPS window loop.


* [ ] **The "Docket" Renderer**: Write a loop that iterates through your "To-Do" applications and draws them as a scrollable list of text cards.


* [ ] **Input Handling**: Use Raylib’s `IsMouseButtonPressed` to allow clicking on an entry to "open" its full history.



#### Phase 3: The "Weekly Pulse" Visualization

Transform your raw timestamps into the visual insights you currently miss in Notion/Sheets.

* [ ] **Time Bucketing**: Write a Zig function to group your `Applied` events into weeks ($604,800$ second intervals).


* [ ] **"Zero-Count" Filling**: Ensure weeks with no applications still appear on the X-axis by pre-populating your bucket list with zeros.


* [ ] **Drawing the Line Chart**: Use `DrawLineEx` in Raylib to connect your weekly data points into a smooth timeseries graph.



#### Phase 4: Automated Insights & Cleanup

Add the "smart" features that automate your workflow.

* [ ] **Auto-Ghosting**: Implement a check that flags any entry with no ledger updates in the last 6 months.


* [ ] **Tag Filtering**: Add a "Command Palette" or button row to filter your dashboard by "Field" (e.g., Big Tech vs. Startups).



---

### 3. Key Concepts to Master

| Concept | Description |
| --- | --- |
| **Immediate Mode GUI** | Unlike web DOMs, you don't "update" a button; you draw it every frame and check if the mouse is over its coordinates. |
| **Unix Time (i64)** | Store all dates as integers. This makes the math for your "Weekly Pulse" trivial and ensures SQLite compatibility. |
| **Data Normalization** | Fetching raw data from SQL and "filling in the gaps" in Zig memory before you hand it to the renderer. |
| **C-Interop** | Calling `sqlite3_step()` or `InitWindow()` from Zig. You will need to manage the transition between Zig slices and C pointers.|

Does this "Game-Engine" roadmap feel like a manageable weekend-by-weekend progression, or is there a specific phase you'd like to dive into first?