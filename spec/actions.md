# Actions: User Interface Behavior

Determining what actions the user will do also determines the buttons/workflows we'll support. A preliminary idea is to have all pending interviews/OAs/chats be in some sort of sidebar, and when the user is done, they can click on a "complete" button and be prompted to input the necessary data to update the entry. This could be part of the docket.

## Creating New Entries 
*Add new job application to apply to later.* The user inputs:
1. position title (*type is automatically set to job*)
2. location (may have several, may be remote)
3. company
4. application link or some sort of link to refer to it
5. (optional) notes about the company 
6. (optional) tags, e.g., SWE or something.
7. (optional) application due date 
8. (optional) people related to the job, e.g., friends who worked there before or a recruiter

*I just applied to some networking event for company X.* The user inputs the same as the first query, except the position title corresponds to an event name (e.g., Company X Outreach Event), and the type is automatically set to Update.

Weirdly, outreach events are becoming more and more like job applications (there's already some that give OAs, and maybe there could be interviews for these outreach events in the future...), and it makes sense to re-use the notion of an offer being accepted for attending an event.

*I've been invited to have a new coffee chat with company X. I've scheduled it for tomorrow at Cafe Foo.* The user inputs:
1. company to chat with
2. location
3. people (recruiter, the other side of the table, etc.)
4. time 
5. (optional) notes about the company 
6. (optional) tags, e.g., SWE or something.


*I just submitted by resume to this resume bucket/resume drop.* The user inputs:
1. company for the resume drop
2. link to the resume drop (may be an in-person thing, but this is getting rarer so we can assume online)
3. some identifier for the resume that was submitted.


## Updating Entries

### OAs
*I just received an OA for a position/event.* The user goes to the specific position/event entry and inputs:
1. (optional) OA due date, may be relative (e.g., due within the next 3 weeks, but the user can be smart enough to calculate that themselves...)
2. (optional) OA link
3. (optional) notes about the OA

*I just completed an OA for a position/event.* 
The user goes to the specific position/event entry and inputs:
1. (optional) notes about the OA

### Interviews 

We may receive several interview rounds, so we can just reuse these actions accordingly.

*I just received a request to interview.* The user goes to the specific position/event entry and inputs:
1. (maybe not yet) location (often remote)
2. (maybe not yet) scheduled time
3. (maybe not yet) people (recruiter, the other side of the table, etc.)
4. (optional) pre-interview notes 
5. interview type (defaults to General, may be more specifically Behavioral, Technical, or RecruiterScreen)

*I just scheduled my interview.* The user goes to the specific position/event entry and inputs:
1. (for sure now) location (often remote)
2. (for sure now) scheduled time
3. (maybe not yet) people (recruiter, the other side of the table, etc.)
4. (optional) pre-interview notes 

*For some reason, the interview is rescheduled or moved somewhere else, or updated in some way.* The user goes to the specific position/event entry and inputs:
1. (potentially updated) location 
2. (potentially updated) scheduled time
3. (potentially updated) people 
4. (optional) pre-interview notes. 
**the notes for this Update should summarize which fields were updated.**

*I just completed my interview.* The user goes to specific position/event entry and inputs:
1. (maybe not yet) people (recruiter, the other side of the table, etc.)
2. (optional) post-interview notes 


### Offers and Attending
*I just got an offer for a position.* The user marks it as such, and inputs
1. offer deadline to respond by

*I just got an invited to the event.* The user marks it as such.

### (Mostly) Terminal Updates

*I just got rejected from a position/event.* The user marks it as such, and inputs 
1. (optional) notes, e.g., speculating about maybe why they were rejected

> The user can reject an offer/invite to a position/event,

*I just declined an offer for a position.* The user marks it as such, and inputs 
1. (optional) notes, e.g., why they turned down the offer. 

> Analogously for events,

*I chose not to attend an event.* The user marks it as such, and inputs 
1. (optional) notes, e.g., why they chose not to go.

> or, the user can accept an offer/invite to a position/event,

*I just accepted an offer for a position.* The user marks it as such, and inputs 
1. (optional) notes, e.g., why they accepted the offer

> Analogously for events, 

*I just attended an event.* The user marks it as such, and inputs 
1. (optional) notes, e.g., what they learned at the event
2. (optional) people met at the event

> Analogously for chats, 

*I just attended a coffee chat.* The user marks it as such, and inputs 
1. (optional) notes, e.g., what they learned at the event
2. (optional) people met at the event




#### Unstructured Terminal Updates (Rare)
Hopefully the user does not do these things or does not have these things happen to them. But always prepare.

*I just reneged an offer for a position/event.* The user marks it as such, and inputs 
1. (optional) notes, e.g., why they reneged the offer

*I just moved my offer to a different semester.* The user marks it as such, and inputs 
1. (optional) notes, e.g., why they reneged the offer
**the system needs to update the position's season**

*The company just rescinded my offer for a position/event.* The user marks it as such, and inputs 
1. (optional) notes, e.g., why the company said they rescinded


## Automatic Updates
*After applying, a position/event has not been updated in X amount of time.* The system automatically marks that entry as ghosted.