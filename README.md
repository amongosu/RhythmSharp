



# RhythmSharp

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/RhythmSharpLogo.png?raw=true)


| If you like my project and if it helped you in any way, consider buying me a cup of coffee! | [<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Patreon_wordmark.svg/1280px-Patreon_wordmark.svg.png" width="250">](https://www.patreon.com/rwdkor) [![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M0209NY)
| ---      | ---       |

­

**RhythmSharp(=R#) - Reworked version of** [**RoKo**](https://github.com/rwdkor/RoKo)­­

This project aims to automatically boost a account of osu!mania.
R# provides many features like auto-playing bot with humanizer, tasks, scheduler, and etc... Additionally, the article below goes over all the details involved during the development of R#. Toward the end, it also considers possible improvements. Make sure to read it.

> This project was created solely for research and educational purposes. The usage of this project for malicious purposes in-game is against peppy's terms of service.

## Thanks to
- [@fs-c](https://github.com/fs-c) for his [bot logics](https://github.com/rwdkor/RhythmSharp#check-notes-hit-timing)
- [@andy1279](https://github.com/andy1279) the master developer in this project
- [@NotActualHuman](https://github.com/NotActualHuman) reported/fixed many bugs
- [ddxoft](http://www.ddxoft.com/) - DD94687.32.dll library
- and everyone who support me/this project

## Features

 - Supports latest version of osu!(stable, Not tested with custom build)
 - Multithreaded keystroke sending
 - User-friendly GUI Design (Not Console!)
 - Absolutely fully-automated account boosting
   - Automatic beatmap detection
   - Automatic beatmap selector
   - Customizable tasks
   - Botting scheduler
 - Advanced humanizer/randomizer
 - High performance optimized
 - Supports Mirror, Half, DoubleTime(Nightcore) Mode
 - Supports custom key-layout in game (=No need to change key anymore!)
 - '[**Streamming proof**](https://www.youtube.com/watch?v=j6-Sj9fcFuI)' Feature!
 

## Summary

1.  [Introduction](https://github.com/rwdkor/RhythmSharp#introduction)
    -   [What is osu!mania?](https://github.com/rwdkor/RhythmSharp#what-is-osumania)
    -   [What are you going to do?](https://github.com/rwdkor/RhythmSharp#what-are-you-going-to-do)
    -   [How can it be completed?](https://github.com/rwdkor/RhythmSharp#how-can-it-be-completed)
    -- [Reading the notes](https://github.com/rwdkor/RhythmSharp#reading-the-notes)
    -- [Getting the time offset](https://github.com/rwdkor/RhythmSharp#getting-the-time-offset)
    -- [Selecting the beatmap](https://github.com/rwdkor/RhythmSharp#selecting-the-beatmap)
2.  [The Pipeline](https://github.com/rwdkor/RhythmSharp#the-pipeline)
    -   [Overview](https://github.com/rwdkor/RhythmSharp#overview)
    -   [Initialize](https://github.com/rwdkor/RhythmSharp#initialize)
    -- [Getting the time offset](https://github.com/rwdkor/RhythmSharp#getting-the-time-offset)
    -- [Getting current status of the game](https://github.com/rwdkor/RhythmSharp#getting-current-status-of-the-game)
    -   [Select Beatmap](https://github.com/rwdkor/RhythmSharp#select-beatmap)
    -   [Read and classify/humanize notes](https://github.com/rwdkor/RhythmSharp#read-and-classify-humanize-notes)
    -- [Reading notes](https://github.com/rwdkor/RhythmSharp#reading-notes)
    -- [Classify and humanize notes](https://github.com/rwdkor/RhythmSharp#classify-and-humanize-notes)
    -  [Check note's hit-timing](https://github.com/rwdkor/RhythmSharp#check-notes-hit-timing)
    - [Send Keystrokes](https://github.com/rwdkor/RhythmSharp#send-keystrokes)
3.  [Result and Possible Improvements](https://github.com/rwdkor/RhythmSharp#result-and-possible-improvements)
    -   [Result](https://github.com/rwdkor/RhythmSharp#result)
    -   [Possible Improvements](https://github.com/rwdkor/RhythmSharp#possible-improvements)

## [](https://github.com/rwdkor/RhythmSharp#introduction)Introduction
osu! is on/offline rhythm game developed by peppy.

### [](https://github.com/rwdkor/RhythmSharp#what-is-osumania)What is osu!mania?

> osu!mania mode has been widely used in almost all of the major rhythm
> games. It require good hand and/or leg coordination where the notes
> (with their quantity depending on BPM and difficulty) move on a
> conveyer. The player will have to press the correct key for that
> specific note in time.
> 
>![osu!mania Interface](https://i.ppy.sh/2b8ecfe2440889b26cb351737e76f739470f7e44/68747470733a2f2f6f73752e7070792e73682f68656c702f77696b692f7368617265642f496e746572666163655f6d616e69612e6a7067)
>
> Notes are the hit circles of osu!mania. The falling notes must be
> tapped on the judgement line, with correct key corresponding to each
> of the note it falls to. More keys corresponding to the falling notes
> must be tapped simultaneously if the notes fall simultaneously.

*Excerpt descriptions from [official game page](https://osu.ppy.sh/help/wiki/Game_Modes/osu!mania)*.

That said, our goal is to create a computer program capable of pressing correct keys when each note falls.

### [](https://github.com/rwdkor/RhythmSharp#what-are-you-going-to-do)What are you going to do?

The goal of the game is to press the button at the right time to process the note. Furthermore, the ranking of the account is determined by the quantity of [Performance Points(PP)](https://osu.ppy.sh/help/wiki/Performance_Points).

If bot automatically pick a song and play the game superbly, resulting in a pp, and ranking will rise.


### [](https://github.com/rwdkor/RhythmSharp#how-can-it-be-completed)How can it be completed?


#### [](https://github.com/rwdkor/RhythmSharp#reading-the-notes)Reading the notes

Some investigation reveals that it is possible to determine the timing of the notes using less sophisticated techniques. Even though this task can be performed by reading beatmap, the simplest option is to read game's memory.

#### [](https://github.com/rwdkor/RhythmSharp#getting-the-time-offset)Getting the time offset

Once we have the timing of the notes, we need to know the time of the game to hit it. In-game beatmap editor provides the exact time, so we will use this to get the time offset.

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot02.png?raw=true)


#### [](https://github.com/rwdkor/RhythmSharp#selecting-the-beatmap)Selecting the beatmap

The game provides  [search system](https://osu.ppy.sh/help/wiki/Interface#search), so we will use this to select beatmap. 

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot03.png?raw=true)


## [](https://github.com/rwdkor/RhythmSharp#the-pipeline)The Pipeline

In this section, we will see how to put these steps together to create a program that automatically farms pp.

### [](https://github.com/rwdkor/RhythmSharp#overview)Overview
![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Pipeline.png?raw=true)

Each step of this pipeline will be thoroughly explained in the sections below. Also, the experimental results obtained during the development of this project will be presented.

### [](https://github.com/rwdkor/RhythmSharp#initialize)Initialize

#### [](https://github.com/rwdkor/RhythmSharp#getting-the-time-offset)Getting the time offset
I also read game's memory to get the time offset.

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot02.png?raw=true)


Just scanned directly with Cheat Engine, and I found the function that manages time offset.

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot05.png?raw=true)


#### [](https://github.com/rwdkor/RhythmSharp#getting-current-status-of-the-game)Getting current status of the game
Before selecting a song, we need to know the game is ready to select song.
I was struggled with only a simple scan, so I decided to decompile osu!

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot06.png?raw=true)


Also I made a simple cheat engine script to check status.

    [ENABLE]
    // Current Status (4 Bytes)
    // (+1) A1 ? ? ? ? A3 ? ? ? ? A1 ? ? ? ? A3 ? ? ? ? 83 3D ? ? ? ? 00 0F 84 ? ? ? ? B9 ? ? ? ? E8
    // 00 : Menu
    // 01 : Edit
    // 02 : Play
    // 03 : Exit
    // 04 : SelectEdit
    // 05 : SelectPlay
    // 06 : SelectDrawings
    // 07 : Rank
    // 08 : Update
    // 09 : Busy
    // 10 : Unknown
    // 11 : Lobby
    // 12 : MatchSetup
    // 13 : SelectMulti
    // 14 : RankingVs
    // 15 : OnlineSelection
    // 16 : OptionsOffsetWizard
    // 17 : RankingTagCoop
    // 18 : RankingTeam
    // 19 : BeatmapImport
    // 20 : PackageUpdater
    // 21 : Benchmark
    // 22 : Tourney
    // 23 : Charts
    
    aobScanRegion(Current_Status, 0x00000000, 0x7FFFFFFF, A1 ? ? ? ? A3 ? ? ? ? A1 ? ? ? ? A3 ? ? ? ? 83 3D ? ? ? ? 00 0F 84 ? ? ? ? B9 ? ? ? ? E8)
    define(Current_Status,Current_Status+1)
    registerSymbol(Current_Status)
    
    [DISABLE]
    unregisterSymbol(Current_Status)

Results:

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot07.png?raw=true)


### [](https://github.com/rwdkor/RhythmSharp#select-beatmap)Select Beatmap
I used the game's own [feature](https://github.com/rwdkor/RhythmSharp#selecting-the-beatmap). This is really simple, so no detailed explanations here.

### [](https://github.com/rwdkor/RhythmSharp#read-and-classify-humanize-notes)Read and classify/humanize notes
#### [](https://github.com/rwdkor/RhythmSharp#reading-notes)Reading notes
Notes are stored in each beatmap file (*.osu)

    [HitObjects]
    64,192,93,5,0,0:0:0:0:
    192,192,153,1,0,0:0:0:0:
    320,192,213,1,0,0:0:0:0:
    448,192,273,1,0,0:0:0:0:
    64,192,333,1,0,0:0:0:0:
    192,192,393,1,0,0:0:0:0:
    320,192,453,1,0,0:0:0:0:
Sorted like this: **ColumnX, ColumnY, Timing, Etc...**

I used to open beatmap file directly, but there was exception like converted map(standard mode map) or column mismatching(seems like 7k map, but actually 8k map).

So I decided to read game's memory and finally found array of 'HitObjects'.

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot04.png?raw=true)

You can see more details on [source code](https://github.com/rwdkor/RhythmSharp/blob/master/RhythmSharp.Core/Offset.pas#L108).

#### [](https://github.com/rwdkor/RhythmSharp#classify-and-humanize-notes)Classify and humanize notes
Classifing notes is really easy. Look at below codes.

```pas
if (timestart < timeend) then
begin
  HitObject.NoteType := 1; //long note down
  HitObject.Timing := timestart;
  bData.HitObjects.Add(HitObject);

  HitObject.NoteType := 2; //long note up
  HitObject.Timing := timeend;
  bData.HitObjects.Add(HitObject);
end
else
begin
  HitObject.NoteType := 0; //short note
  HitObject.Timing := timestart;
  bData.HitObjects.Add(HitObject);
end;
   
//Add to each array
~~snip~~
KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);
```
All notes have time pairs, TimeStart and TimeEnd. If TimeStart is less than TimeEnd, it is obviously long note.

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot10.png?raw=true)


**Humanizer?**

It was hard to humanize notes. At first, I tried to put a miss in a specific ratio, but the result was abnormal depending on the difficulty of the map.

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot09.png?raw=true)


You can see old codes on [RoKo](https://github.com/rwdkor/RoKo/blob/master/pasMain.pas#L677) repo.


I changed the humanize method, humanizing notes by KPS(key per second). It looked more human-like by adjusting the ratio according to the KPS(=almost same as difficulty).

![](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot08.png?raw=true)

[Here's the code!](https://github.com/rwdkor/RhythmSharp/blob/master/RhythmSharp.Core/Main.pas#L432) 

But humanization is still not perfect, so it needs improvement!

### [](https://github.com/rwdkor/RhythmSharp#check-notes-hit-timing)Check note's hit-timing
We need to compare current time and note's hit-timing to hit notes!
Copy/Pasted the logic from [fs-c's github](https://github.com/fs-c/maniac/blob/master/src/maniac/maniac.cpp#L29), just i was too lazy to code myself.

### [](https://github.com/rwdkor/RhythmSharp#send-keystrokes)Send Keystrokes
We need to know what to press before sending a keystrokes. Usually, you can use the default key layout, but someone can change the key layout like 'Q-W-O-P'.

Modified key layout is stored in 'osu!.@@.cfg' file, like this.

```ini
ManiaLayouts7K = Q W E Space I O P
ManiaLayoutSelected7K = 0
ManiaLayouts8K = Q W E R Space I O P
ManiaLayoutSelected8K = 0
ManiaLayouts4K = Q W O P
ManiaLayoutSelected4K = 0
```

Of course, we can read this file directly. However, I decided to read key layout stored in memory. ~~just for fun~~

Finding custom key layout in memory was a bit complicated and painful, so I'm going to skip the detailed explanation.

## [](https://github.com/rwdkor/RhythmSharp#result-and-possible-improvements)Result and Possible Improvements
### [](https://github.com/rwdkor/RhythmSharp#result)Result
Screenshot of RhythmSharp / Supports Korean and English. (since I'm Korean)

![English](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot11.png?raw=true)

![Korean](https://github.com/rwdkor/RhythmSharp/blob/master/Images/Screenshot12.png?raw=true)


### [](https://github.com/rwdkor/RhythmSharp#possible-improvements)Possible Improvements

 - [ ] Discord notification (or telegram, pushbullet, etc..)
 - [ ] Improve humanizer more human-like using statistics.
 - [ ] Automatic song selection in multiplayer - Like [Maid Bot](https://osu.ppy.sh/users/16173747)!
 - [ ] Random mode support
 - [x] Getting custom key layouts from memory