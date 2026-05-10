
## What I Want

1. I track both job applications and resume buckets/event registrations related to my career search. Ideally I'd like entries to fall into one of these categories, with some extensibility in the future in case there's some other wacky way to do career events. For example, I might add coffee chats and then related notes to that chat.

2. For job applications, there are position titles, locations, fields (e.g., Finance, Big Tech, startup, etc.), potentially supplementary materials (which are currently nicely embedded as Google docs tiles in Google sheets), as well as a status field that can be anywhere from submitted -> OA -> OA done -> interviewing and more. Due to the various differences between different interview processes, that becomes a very difficult thing to specify.

I'd also like a date of when I found something (optional), when I applied to something, and if there are interviews/OAs, dates on which I did those. Ideally these auto-update, i.e., once I click something to mark them as completed, the completion date/time metadata is stored automatically. I might also want to store the link t the application for reference later, in case I want to send the link to a friend.

3. Like I said, I also need to be able to make my visualizations. Currently, I have table columns telling me which week (e.g., week 15) of what year each thing was applied to, as well as a relative date column that can then be used to compute whether something occurred in the past week or not.



Designing a SQL schema to do all of these things seems difficult. But writing my own database engine also seems difficult. 

## Workflows I Want
I'm also thinking about how I want to interface with this tool. Honestly I would've been perfectly fine with Notion if it didn't make me pay for charts, and I would've been fine with sheets if making charts were a little less tedious. I envision the following workflows:

1. I see a job posting I am interested in and should apply to later. I open up this tool and enter it in as a job application, put the link in, and flag it for later. Ideally the app has a docket telling me what I have TO-DO (which may also include reachouts or upcoming coffee chats)

2. I apply to a job. Then I can do the same thing as above except I also mark it as applied to and that default sets the state to submitted.

3. I receive an OA for a job. Then I can mark that down and set the state to OA pending completion.

4. I complete an OA for a job. Then I can mark that down and again step the state.

If there are several OAs, I'd want a nice way to track that. A producer/consumer pattern is weird because sometimes I might receive several OAs for one job, or one OA for several roles in the same company. Thinking of the data structure there is a bit annoying.

5. I receive an interview. Then I again mark that down and step the state to interviewing, and optinally mark down the scheduled time of the interview.

6. I complete an interview round. I mark that down. Again the state shouldn't be a pure DFA state machine - we need to have some memory of how many interviews we've seen thus far.

Plus interviews can be split into behavioral or technical or general. And I'd like to have a place to put my interview prep notes, which can be GDoc links for now.

7. If I haven't updated a job in 6 months, I can assume I was ghosted. If I get a rejection email, I can mark it as rejected. If I get an offer, I can mark it as such too. There are also instances where a job may seem to ghost me but then eventually reject me. In that case I can just update to rejected after the state was ghosted.

8. And of course there's the visualization workflows, which could be a nice dashboard but this is probably going to come last.

## Charts I want
Existing ones are
1. number of jobs applied to overall, sorted by accepted/rejected/ghosted, should exclude resume buckets and events

2. the number of applications in the past 7 days, which can then become the bigger line chart for the weekly number of applications since I began applying to jobs 

3. hopefully some number of stats for average number of interviews, time between interviews, length of job process time (with and without the places that ghost me), though these won't be able to be done retroactively, so these stats aren't super important.

