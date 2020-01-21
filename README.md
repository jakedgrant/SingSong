# SingSong
An iOS app with a focus on bedtime and lullabies

<p align="center">
  <img src="https://raw.githubusercontent.com/jakedgrant/SingSong/master/screenshots/row%20options.png" width="200" title="row options">
  
  <img src="https://raw.githubusercontent.com/jakedgrant/SingSong/master/screenshots/edit%20view.png" width="200" title="edit view">
  
  <img src="https://raw.githubusercontent.com/jakedgrant/SingSong/master/screenshots/share%20sheet.png" width="200" title="share sheet">
  
  <img src="https://raw.githubusercontent.com/jakedgrant/SingSong/master/screenshots/lyrics%20view.png" width="200" title="lyrics view">
  
</p>

## Background
As part of our daughter's bedtime routine, we would sing her a couple of songs. She would ask us to "sing song pwease." Sometimes determining which song she requested required a lot of contextual information (what did we do that day, which Disney princess was she obsessed with at the time) and I'm not particularly good at remembering all the words and I'm pretty bad at making up lyrics when my memory fails me. So I created SingSong, a dedicated app with a focus on bedtime and lullabies.

## Features
* Add and Edit songs
* Song Nicknames - for us "Let It Go" was called "Elsa Song"
* Share individual songs - this helped keep our collections in sync between my spouse and I.
* Import songs from JSON files - if you're good at JSON you can create a whole collection to upload to the app.
* Low light interface - so you don't get blinded in a dark room while trying to get your child to sleep, the inteface is dark and the app sets your phone brightness to the lowest setting, just in case.

## Technical
Besides customizing the app experience to our specific needs, I wanted to gain additional experience in building an app using the Coordinator pattern (as presented by [Soroush Khanlou](https://vimeo.com/144116310)). I also wanted to reinforce my understanding of iOS framework basics (table views, table data sources, activity view controller).

### Possible Improvements
* Adding text display options
* Adding interface style options (high contrast, light mode, etc.)
* Improving accessibility
* Use Core Data for persistant storage, rather than UserDefaults
* iCloud sync
