# Handling Location Data
The core issue with handling locations is that there are technically infinitely many. I mean let's be honest, most tech jobs are in NYC or SF. But it would be annoying to input that each time - what if I type in "NYC" one time, but then "New York City, NY" another time?

We could use fuzzy matching, but that seems a little stupid because these are fixed cities that are knowable, and a little overkill since any fuzziness comes from user error, not variability between different locations.

We could use tries to do some funny string algorithm things, but this is definitely not the first concern of mine - though it will serve as an interesting extension.

> **Interesting Idea for the Future:** fuzzy entry to autocompletion via weighted tries