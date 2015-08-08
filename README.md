# key-stats

This is an app I'm making to keep track of how well I type day-to-day. I'm doing this because I think my typing accuracy has plateaued, but I don't actually know because I don't have any numbers.

Currently this is just a key logger. It stores all of the keys you press, along with modifiers and timestamp, in a sqlite database at ~/.key_stats.sqlite3. From that I intend to add the ability to view statistics about how you type (for instance what letters you backspace the most) and perhaps build in some typing lessons.

/!\ Don't use this yet! I plan to encrypt the database, but I haven't implemented that part yet, so if you use this now, you'll just end up with a file on your computer with all of your system's passwords in it. /!\
