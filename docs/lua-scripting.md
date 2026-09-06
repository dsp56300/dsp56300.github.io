---
title: "Lua Scripting Guide"
layout: default
permalink: /docs/lua-scripting
---

# Lua Scripting for Skins

Gearmulator supports Lua scripting in plugin skins, giving skin authors the power to create dynamic, interactive UI elements without writing C++ code. Using Lua, you can read and write synthesizer parameters, react to parameter changes in real time, and manipulate the UI layout and appearance on the fly.

This feature is aimed at skin designers who want to go beyond static layouts and build things like custom visualizations, conditional UI logic, animated controls, or parameter-driven display elements.

Gearmulator uses [Lua 5.4](https://www.lua.org/manual/5.4/) embedded in the [RmlUi](https://mikke89.github.io/RmlUi/) skin framework. If you're new to RmlUi, check the [official RmlUi documentation](https://mikke89.github.io/RmlUi/) for details on RML elements, RCSS properties, data bindings, and events. For an overview of the skinning system itself, see the [Skinning Guide](/docs/rmlui-skinning).

> **Drawing custom graphics?** To render raster graphics (shapes, meters, scopes) on a `<canvas>` element from Lua using an HTML5-style 2D drawing API, see the [Canvas Scripting Guide](/docs/canvas-scripting).

## Quick Start

Add a `<script>` block in your RML file's `<head>` section to define Lua functions, then call them from event handlers on your elements:

```html
<rml>
  <head>
    <link type="text/rcss" href="myskin.rcss"/>
    <script>
      function onBodyLoad()
        local val = params.get("Osc1Pitch")
        Log.Message(Log.logtype.info, "Osc1Pitch = " .. val)
      end
    </script>
  </head>
  <body onload="onBodyLoad()">
    ...
  </body>
</rml>
```

## Script Execution Timing

Understanding when scripts run is important for writing correct Lua code:

- **`<script>` blocks in `<head>`** run during document parsing, **before** `<body>` elements exist. Define functions here, but do not access DOM elements yet.
- **`onload` on `<body>`** runs after all elements are created, but before layout is computed. Use this for element lookups and setting up parameter subscriptions.
- **`onshow` on any element** runs when that element becomes visible. Layout is computed at this point, so `offset_width`/`offset_height` return correct values. Use this for initial rendering that depends on element dimensions.
- **Inline event handlers** like `onclick="..."` receive `event`, `element`, and `document` as parameters.

## Global Variables

These globals are available in all Lua scripts and event handlers:

| Global | Type | Description |
|--------|------|-------------|
| `document` | ElementDocument | The current RML document. Use for DOM access like `document:GetElementById()`. |
| `params` | table | Parameter API for reading/writing synth parameters and subscribing to changes. |
| `Log` | table | RmlUi logging. Use `Log.Message(Log.logtype.info, "message")`. |
| `rmlui` | table | RmlUi core API (contexts, font loading, etc.). |
| `skinvars` | table | Storage for the skin's own state, per instance or shared by all of them. |

## Parameter API

The `params` table provides full access to the synthesizer's parameters. The part argument is optional for all functions --- when omitted, the currently selected part is used.

### Reading Values

```lua
-- Get raw integer value (current part)
local value = params.get("Osc1Pitch")

-- Get for a specific part
local value = params.get("Osc1Pitch", 3)

-- Get for explicit "current" part
local value = params.get("Osc1Pitch", "current")

-- Get formatted display text
local text = params.getText("Osc1Pitch")
local text = params.getText("Osc1Pitch", 3)
```

### Writing Values

```lua
-- Set value on current part
params.set("Osc1Pitch", 64)

-- Set value on specific part
params.set("Osc1Pitch", 64, 3)
```

### Parameter Info

```lua
local info = params.getInfo("Osc1Pitch")
-- info.min          (integer) minimum value
-- info.max          (integer) maximum value
-- info.name         (string)  internal parameter name
-- info.displayName  (string)  human-readable name
-- info.defaultValue (integer) default value
-- info.isBool       (boolean) true if parameter is a toggle
-- info.isBipolar    (boolean) true if parameter is bipolar
```

### Subscribing to Changes

```lua
-- Subscribe to changes on current part (auto-rebinds when part changes)
local id = params.onChange("Osc1Pitch", function(value, text)
  -- value: raw integer
  -- text: formatted display string
end)

-- Subscribe to changes on a specific part
local id = params.onChange("Osc1Pitch", function(value, text)
  -- ...
end, 3)

-- Unsubscribe
params.removeListener(id)
```

When subscribing with the current part (the default), the listener automatically rebinds to the new part's parameter when the current part changes. If the value differs between the old and new part, the callback fires immediately with the new value.

### Current Part

```lua
-- Get current part number (0-based)
local part = params.getCurrentPart()

-- Subscribe to part changes
local id = params.onPartChanged(function(newPart)
  -- newPart: 0-based part number
end)
```

## Frame Events

Anything that has to keep moving by itself --- an oscilloscope, a VU meter, a scrolling marquee --- needs a clock, because parameter callbacks only fire when a value changes. A document receives a `frame` event once per rendered frame if, and only if, it declares an `onframe` handler on its `<body>`:

```html
<body onframe="onFrame(event)">
```

```lua
function onFrame(event)
  local time  = event.parameters['time']   -- seconds since the editor was opened
  local delta = event.parameters['delta']  -- seconds since the previous frame event

  local needle = document:GetElementById("needle")
  needle.style.left = tostring(200 + 180 * math.sin(time * 2)) .. "dp"
end
```

Drive movement from `delta` or `time` rather than counting frames --- the rate is not guaranteed and differs per machine.

To use `AddEventListener` instead of an inline handler, declare an empty attribute --- `<body onframe="">` --- because the attribute is what opts the document in:

```lua
document:AddEventListener("frame", function(event)
  -- ...
end)
```

A few things worth knowing:

- The event does not bubble and cannot be interrupted; it is dispatched on the document.
- Frame events stop while the editor is hidden or minimized and resume when it comes back. `delta` reports the real interval between two events, so an animation driven by it continues where it should instead of jumping.
- The rate is capped at 60 Hz. Setting `refreshRateLimitHz` in the plugin's config XML lowers or raises that limit, up to 300, and paces the whole user interface with it.
- A skin that does not declare `onframe` costs nothing but an attribute lookup per frame.

## Skin Variables

State that belongs to the skin rather than to the synth --- which knobs a skin has linked together, which of its own pages was open --- has nowhere to live in the parameter set, and a plain Lua variable is gone as soon as the editor closes. The `skinvars` table is a small store for exactly that, in two scopes:

| Scope | Stored in | Survives |
|-------|-----------|----------|
| `"instance"` | the plugin state | saving and loading the host project, per instance |
| `"global"` | the plugin config file | every instance and every project, until changed |

```lua
skinvars.set("oscLink", 1)                  -- instance scope, the default
skinvars.set("theme", "dark", "global")     -- shared by every instance

local link  = skinvars.get("oscLink")       -- instance first, then global, nil if neither
local theme = skinvars.get("theme", "global")
```

Values are numbers or strings, and the type survives storage, so `"7"` and `7` stay apart. Booleans are accepted and stored as 1 and 0.

**Reading without a scope answers from the instance first and falls back to the global.** That is what makes a skin-wide default work: ship the default in the global scope and let a project override it for one instance without disturbing the others.

### Reacting to Changes

```lua
local id = skinvars.onChange("oscLink", function(value, scope)
  -- scope is "instance" or "global"
end)

skinvars.removeListener(id)
```

A third argument limits the callback to one scope:

```lua
skinvars.onChange("theme", onThemeChanged, "global")
```

A callback registered without a scope fires for both, and the value it receives is what a plain `get()` would answer --- so if an instance value shadows the global one, a change to the global still reports the instance value. Name the scope explicitly when that matters.

Loading a project reports every instance-scope variable it carries as a change, so a skin that rebuilds its UI in the callback picks up a restored project on its own.

### Removing

```lua
skinvars.remove("oscLink")            -- instance scope
skinvars.remove("theme", "global")
```

Global variables are written to the plugin's config XML as soon as they change, one key per variable, prefixed `skinvar_`.

## DOM Manipulation

The `document` global provides access to the RmlUi DOM. You can find elements, modify styles, toggle classes, and build dynamic content:

```lua
-- Find elements
local elem = document:GetElementById("myElement")

-- Read/write styles
elem.style.width = "100px"
elem.style.height = "50px"
elem.style["background-color"] = "#ff0000"

-- Read computed size (in px, available after layout)
local w = elem.offset_width
local h = elem.offset_height

-- Add/remove CSS classes
elem:SetClass("active", true)
elem:SetClass("hidden", false)

-- Read/write attributes
local val = elem:GetAttribute("id")
elem:SetAttribute("data-value", "42")

-- Read/write inner RML
elem.inner_rml = '<div class="child">Hello</div>'

-- Navigate the tree
local parent = elem.parent_node
local first = elem.first_child
local doc = elem.owner_document
```

## Logging

```lua
Log.Message(Log.logtype.info, "informational message")
Log.Message(Log.logtype.warning, "warning message")
Log.Message(Log.logtype.error, "error message")
```

Log levels: `always`, `error`, `warning`, `info`, `debug`.

## Example: Arpeggiator User Pattern Visualization

This example creates a bar graph showing the arpeggiator step pattern for the Virus TI, with bar width controlled by step length and height by step velocity. It demonstrates the key patterns for building parameter-driven visualizations.

**Styles and script in `<head>`:**
```html
<style>
  .arp-bar {
    position: absolute;
    bottom: 0px;
    background-color: #ffffffdd;
  }
  .arp-bar-even { background-color: #ccddffcc; }
  .arp-bar-odd  { background-color: #ddccffcc; }
  .arp-bar-inactive { background-color: #aaaaaa55; }
</style>
<script>
  local STEPS = 32
  local bars = {}
  local container = nil

  function updateArpBar(step)
    local bar = bars[step]
    if bar == nil or container == nil then return end

    local cw = container.offset_width
    local ch = container.offset_height
    if cw <= 0 or ch <= 0 then return end
    local stepMaxW = cw / STEPS

    local length   = params.get("Step " .. step .. " Length")
    local velocity = params.get("Step " .. step .. " Velocity")
    local bitfield = params.get("Step " .. step .. " Bitfield")
    local patLen   = params.get("Arpeggiator/UserPatternLength")

    local active = (step - 1) <= patLen and bitfield > 0

    bar.style.left   = math.floor((step - 1) * stepMaxW) .. "px"
    bar.style.width  = math.floor((length / 127) * stepMaxW) .. "px"
    bar.style.height = math.floor((velocity / 127) * ch) .. "px"

    bar:SetClass("arp-bar-inactive", not active)
  end

  function updateAllArpBars()
    for i = 1, STEPS do updateArpBar(i) end
  end

  function initArp()
    container = document:GetElementById("LuaArpUserGraphics")
    for i = 1, STEPS do
      bars[i] = document:GetElementById("arp-bar-" .. i)
    end
    for i = 1, STEPS do
      local step = i
      params.onChange("Step " .. step .. " Length",    function() updateArpBar(step) end)
      params.onChange("Step " .. step .. " Velocity",  function() updateArpBar(step) end)
      params.onChange("Step " .. step .. " Bitfield",  function() updateArpBar(step) end)
    end
    params.onChange("Arpeggiator/UserPatternLength", function() updateAllArpBars() end)
  end
</script>
```

**Container and bars in `<body>`:**
```html
<body onload="initArp()">
  ...
  <div id="LuaArpUserGraphics" onshow="updateAllArpBars()"
       style="width: 1921dp; height: 476dp; position: relative; overflow: hidden;">
    <div id="arp-bar-1"  class="arp-bar arp-bar-odd"/>
    <div id="arp-bar-2"  class="arp-bar arp-bar-even"/>
    <!-- ... bars 3-31 ... -->
    <div id="arp-bar-32" class="arp-bar arp-bar-even"/>
  </div>
  ...
</body>
```

**Key patterns:**
- `onload` on `<body>` for initialization (element lookup + parameter subscriptions)
- `onshow` on the container for initial and repeated rendering (layout is computed at this point)
- `offset_width`/`offset_height` for size-independent layout (values are in px)
- `params.onChange` with default current part for automatic part tracking

## Debugging

### RmlUi Debugger

Gearmulator includes the RmlUi visual debugger. To enable it, open the plugin's settings and enable it in the **Skin** section. The debugger overlay will appear immediately.

The debugger provides:

- **Element Info** --- Inspect any element's computed styles, box model, attributes, and classes by clicking on it.
- **DOM Tree** --- Browse the full document hierarchy to verify that Lua-created or Lua-modified elements are structured correctly.
- **Event Log** --- View all RmlUi log messages, including Lua errors, warnings, and `Log.Message` output. This is the primary way to see Lua debug output and diagnose script errors at runtime.

### Debug Logging from Lua

Use `Log.Message` to write to the RmlUi event log:

```lua
Log.Message(Log.logtype.info, "debug: value = " .. tostring(myVar))
```

These messages appear in the debugger's Event Log panel. Lua errors (syntax errors, runtime errors, timeouts) are also logged there automatically with full stack tracebacks.

## Safety

### Sandboxed Standard Libraries

Only safe Lua standard libraries are loaded: `base`, `coroutine`, `table`, `string`, `math`, `utf8`. The following are deliberately excluded:

| Library | Reason |
|---------|--------|
| `io` | Filesystem access |
| `os` | Shell commands, file operations |
| `package` | Loading arbitrary native code via `require` |
| `debug` | Internal state inspection/modification |

### Execution Timeout

Scripts are limited to **3 seconds** of execution time. If a script exceeds this limit (e.g., an accidental infinite loop), it is terminated with an error message and the plugin continues working normally. The timeout applies to all Lua execution: inline scripts, external scripts, event handlers, and parameter callbacks.

### Error Handling

All Lua errors are caught via protected calls. Errors are logged as warnings through the RmlUi logging system and **never crash the plugin or DAW**. A full stack traceback is included in the error message.

## Adding Lua Files to Skins

Place `.lua` files in the skin folder alongside `.rml`, `.rcss`, and image files. They are automatically compiled into the plugin's binary data and can be loaded from RML:

```html
<script src="myskin.lua"></script>
```

This lets you keep your Lua code in separate files for better organization, especially for larger scripts.
