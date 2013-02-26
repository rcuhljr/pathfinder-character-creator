pathfinder-character-creator
============================

Goals
-----

Proof of concept, seeking a faster solution for Pathfinder character creation compared to PC-Gen and sCoreForge while maintaining the flexibility of said systems.

Usage
-----

~/ruby start.rb

Design
------

System Diagram - Starting with a relatively straight forward Presentation/Business/Data layer approach.

>start.db 
>    Entry point, initializes the main level of the program and gui.    
>main.rb 
>    Main GUI Screen. Creates a process object that keeps track of the current state of the system. 
>    will have some minimal business logic, for example hitting new character in the gui will probably trigger a method
>    resembling 
>    if process.unsaved_changes? then
>        save_prompt
>    end
>    process.new_character
>    reset_view #reload ui state based on process flags.
>datamanager.rb 
>    Deals with saving/loading data to flat files, used by the process class to manage character and campaign files.
>datacontainer.rb 
>    Database wrapper used by process, also controls methods for loading external sources (xml/yaml) into the internal database
>logicprocess.rb 
>    business logic class, controls the logical flow of creating a character, answers the ui's questions.
>character.rb
>    Strong possiblity I may make followers, familiars, animal companions, mounts, etc. all character objects, and you load/save
>    groups of characters that are all linked to a master character.
>    class structure that provides easy access to information about the current character e.g.
>    char.stat_arry("str")
>    [score:12,modifier:1,tempscore:7,tempmodifier:-2]
>    char.stat_score("str")
>    7
>    char.stat_arry("con")
>    [score:14,modifier:2,tempscore:,tempmodifier:]
>    char.stat_score("con")
>    14
>campaign.rb
>    class structure that wraps information about the current campaign.
>    camp.active_sources()
>    [1,2,3,15,17]
>    camp.point_buy()
>    15