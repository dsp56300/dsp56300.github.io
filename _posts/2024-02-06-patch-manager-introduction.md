---
title: "Patch Manager Introduction"
date: 2024-02-06
layout: post
---

**Version 1.3 of Osirus introduces a new feature called the _Patch Manager_ (included with all emulations in future builds)**

The _Patch Manager_ is a completely new feature that replaces the previous _Preset Browser_. While the old system didn’t provide much more than browsing files with patches on disk, the _Preset Manager_ uses an approach away from banks towards categories, tags and favourites to provide a modern user experience.

Furthermore, more file formats are now supported:

- .syx/.mid Virus A/B/C/TI/TI2 preset dumps

- .mid Virus A/B/C OS Update files that include Factory Presets

- .lib SoundDiver library import for Virus A/B/C Presets

- .vti Virus TI backup files containing Virus TI presets

- .syx/.mid microQ/Q preset dumps

- .syx/.mid microWAVE 1/2/XT preset dumps

- .syx/.mid Nord Lead 1/2/2x preset and performance dumps

- .syx/.mid JP-8000/8080 Patch and Performance dumps

- .fxb/.vstpreset Presets saved by DAW

- .cpr Cubase Project Files containing presets

![](/images/posts/patch-manager-introduction/image-11.png)

The Patch Manager is part of the plugin itself and can be accessed by clicking Presets (Osirus), Patches (Vavra) or Browser (OsTIrus, Xenia, NodalRed2x, JE8086) depending on which emulator you are using.

![](/images/posts/patch-manager-introduction/image-1.png)

Patches are provided by various sources called _Data Sources_, the ROM patches are automatically added to Factory where applicable (not for Waldorf or Nord synths due to the way they work in the hardware). Additional patches from disk can be added via right click on the _Data Sources_ node. Select a file or even a whole folder to add it to the database.

It is highly recommended to keep your patches and banks located on disk separately from your plugin and config folder locations to avoid operating system permissions issues that may cause incorrect operation of the Patch Manager, and also to prevent slowness of startup performance in the case of Vavra.

In this database, patches can be reorganized into Categories, Tags and Favourites. Some manufacturers had some of this type of information included in their Patch specification, others did not. You can create your own Categories, Tags and Favorites by right-clicking on the appropriate heading and selecting Add.  
  
As categories may not always be correct, you can modify categories and tags for all patches that have been added to the database, you can even modify the the categories of ROM patches if you like.

![](/images/posts/patch-manager-introduction/image-9.png)

Categories, tags and favourites can be colored and are displayed accordingly in any search result.

Text-based filtering allows to filter data sources, tags and patch lists.

![](/images/posts/patch-manager-introduction/image-2.png)

Categories, tags and favourites can be added via drag & drop, just drag patches onto an existing category/tag/favourite container to add the patch. Removal is done via drag & drop too, just hold shift while dragging.

![](/images/posts/patch-manager-introduction/image-3.png)

![](/images/posts/patch-manager-introduction/image-4.png)

It is important to note that the patches themselves are not modified, instead, all changes are kept in separate files to leave your imported banks untouched.

_User Banks_ allow you to save your custom patches, you can create an arbitrary amount of _User Bank_s and add your patches by dragging the patch name from the parts list onto a _User Bank_. Create a User Bank by right-clicking on User and select Create to add a User Bank.

![](/images/posts/patch-manager-introduction/image-5.png)

If you want to export a _User Bank_ to use your patches with a hardware synth, right click to show a context menu, you can export your patches as .syx or .mid.

If you intend to export a _User Bank_ to the actual hardware synth, consider to limit the number of patches in that bank to fit within the size of the hardware bank. Any patches beyond the limit of the hardware bank will be ignored by the hardware synth when importing from this file.

![](/images/posts/patch-manager-introduction/image-6.png)

## Technical Information

The Patch Manager consists of a database that keeps track of all patches that have been added to it. Furthermore, each patch can have modifications. Modifications can be either the addition or the removal of tags or a name change (User Banks only at the moment).

Technically, _Categories_, _Tags_ and _Favourites_ are all tags, but the tag type is different. Additional tag types are the _Virus Model_ and the _Virus Features_, internally (and in the json files) these are CustomA and CustomB because they vary from device to device.

Storage Format:

The database keeps track of which data sources have been added, it is stored at:

(Windows) **C:\\Users\\\[username\]\\Documents\\The Usual Suspects\\\[synthname\]\\patchmanager\\`patchmanagerdb.json`**  
(macOS) **~/Documents/The Usual Suspects/\[synthname\]/patchmanager/`patchmanagerdb.json`**

All user banks are stored in the same folder, the format is sysex, i.e. a user bank named MyUserBank is stored here:

(Win) **C`:\Users\[username]\Documents\The Usual Suspects\[synthname]\patchmanager\MyUserBank.syx`**  
(macOS) **~/Documents/The Usual Suspects/\[synthname\]/patchmanager`/MyUserBank.syx`**

Modifications to patches are stored as delta to what has been imported and are stored next to the imported file.

Example:

Lets say you have imported a file that is called

_Rob Papen Signature Soundset.MID_

There will be a file next to it that is called:

_Rob Papen Signature Soundset.MID.json_

These json files store modified tags compared to the tags that the source provides. Example:

```
{  "patches": {    "prog|0|hash|e1356f571f1194f5b3e3744321fca010": {      "tags": {        "category": {          "removed": [            "Favourite 3"          ]        }      }    }  }}
```

In this case, The category “Favourite 3” has been removed from the first patch of that bank.

## Backup Strategy

All tags that have been added to/removed from patches that you added as data source are saved next to the data source itself, i.e. if you backup your presets, be sure to copy the json files that are next to them too and you're done.

User banks are stored in the Application Support/Userdata Roaming folder (see above), if you want to backup those you can copy the whole folder or copy the individual .syx files along with the .json files that have the same name.

If you accidentally removed a user bank from the DB, you can create a "new" user bank with the same name. If the .syx file still exists on disk in the user data folder (which is likely because they are never physically deleted from disk), it will be loaded and used, i.e. the _Create_ becomes an _Add_.
