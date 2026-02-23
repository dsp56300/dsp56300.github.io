---
title: "Software Renderer for TUS Plugins"
date: 2026-01-05
layout: post
---

Beginning with the 2.1.0 versions of our plugins, we have implemented and provided a built-in CPU-based "software" rendering option for our RmlUI rendering engine that can be used in lieu of OpenGL compatible graphics hardware. In fact, it is automatically used in the case that no such OpenGL compatible hardware is found or present on the system. This software renderer can also be enabled as a good troubleshooting step if you believe you may be experiencing graphics driver issues.

This is a bespoke renderer for our plugins only which is reasonably efficient, but of course is not intended to compete with the performance of more powerful graphics hardware. This option is primarily intended to be used with older computers with less-powerful graphics adapters or in many cases older CPUs with integrated graphics adapters that may not be highly performant. The use of this software renderer may increase CPU usage, so please use this option carefully.

## Steps to enable the software renderer:

Ensure your plugin(s)/DAW is shut down and not running.

You will be required to make a change in the config file for the emulator(s) you wish to use it with. This file can be found in the following locations:

Windows: **C:\\Users\[username\]\\Documents\\The Usual Suspects\[synthname\]\\config\[synthname\].xml**

MacOS: **~/Documents/The Usual Suspects/\[synthname\]/config/\[synthname\].xml**

Linux: **XDG_DATA_HOME/The Usual Suspects/\[synthname\]/config/\[synthname\].xml  
or  
~/.local/share/The Usual Suspects/\[synthname\]/config/\[synthname\].xml**

As an example, for Osirus running on Windows, you would find the file in the following path:

Windows: **C:\\Users\[username\]\\Documents\\The Usual Suspects\\Osirus\\config\\Osirus.xml**

We recommend that you make a "safe copy" of this config file before you make changes, call it something like **\[synthname\].xml.backup** or something similar.

Open the **\[synthname\].xml** file with a text editor.

Add the following line to the list of existing properties to **ENABLE** the software renderer (to **DISABLE** the software renderer, set val ="0" or remove the entire line from the config):

```
<VALUE name="forceSoftwareRenderer" val="1">
```

It should look like this:

![Image](/images/posts/software-renderer-for-tus-plugins/image.png)

Save the file.

Your plugin will now use the software renderer instead of your graphics hardware.
