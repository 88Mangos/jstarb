# Analytics: Charts and Queries
Common queries can be visualized on our dashboard. We'll outline the existing queries I already support, and extend them as I think of new ones. The goal is to have all summary statistics be easily computable, and to have common questions I have answered either via the dashboard, or easily queriable.

## Queries
*How many jobs have I applied to in the last week?* To answer this, we'd just query the most recent entries until their time falls outside of the most recent week. Then it becomes easy to make a pie chart that shows me how far I am from my weekly goal.

*How many jobs have I applied to in week X?* To answer this, we'd compute the week ID of week X, and then convert Unix time to a week ID, then query. We could use binary search (since our entry list is stored chronologically) to find an Entry in week X, and then just expand in both directions from there through two linear scans, left and right.

*Give me my job outcomes for each category: Rejections, Ghosted, Offers, In in Process.* To answer this, we'd have to query the status of each entry.


### Why we want tags as metadata
*How many software engineering roles?* To answer this, we could look for job titles with "software engineer" or "SWE" or something that also fuzzy matches. *How many roles in finance?* To answer this, we could look for companies in finance. 

However, notice that both would become substantially easier if we had metadata tags. So we'll leave optional metadata for each entry too--it's relatively lightweight anyways.

*How many roles for Summer 2025 did I apply to?* Again, would be nice to have tags for when the roles are supposed to be for. Or bake this directly into a position's information, and directly into an event's information (e.g., outreach event for Summer 2027 Internships).

### Out of Scope? Helping write supplements
*When did I last write about my hardest challenge, or greatest failure?* It would be nice to have some NLP approach to analyze the supplements of interview preps and collect them in one nice place. But this is not inherently part of this project, as I'm not using this as a text editor, but rather a database with visualizations. As such, most interview prep will be done in a corresponding Google Doc which is linked to in the notes metadata of an interview.

## Automatic Information
Some queries should definitely be done automatically for the user:

### Upcoming Deadlines
If there is an upcoming interview scheduled, or an OA/Application deadline is coming up, these should be available for the user on a docket of sorts.