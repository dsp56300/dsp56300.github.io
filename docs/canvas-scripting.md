---
title: "Canvas Scripting Guide"
layout: default
permalink: /docs/canvas-scripting
---

# Canvas Scripting

The `<canvas>` element lets skin authors draw custom, data-driven raster graphics — shapes, meters, scopes, envelope displays — directly from Lua. Drawing is done through a **2D context whose API mirrors the HTML5 [`CanvasRenderingContext2D`](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D)**, so if you have drawn on an HTML canvas before, the drawing code will look familiar.

This guide builds on the [Lua Scripting Guide](/docs/lua-scripting) — read that first for how skin scripts are structured, when they run, and how to access parameters. For the skinning system in general, see the [Skinning Guide](/docs/rmlui-skinning).

## Declaring a canvas

Add a `<canvas>` element to your RML with an `id` and a size. Like any skin element it is positioned with RCSS:

```html
<canvas id="myCanvas" style="position: absolute; left: 100dp; top: 100dp; width: 260dp; height: 160dp;"/>
```

## Getting the drawing context

`document:GetElementById` returns a generic element, so cast it to the canvas type with `Element.As.Canvas`, then register a **paint function**. The paint function receives the 2D context (`ctx`) and is called whenever the canvas needs to be (re)drawn:

```lua
local canvas = Element.As.Canvas(document:GetElementById("myCanvas"))

canvas:setPaintFunction(function(ctx)
    ctx.fillStyle = "#2a6bd4"
    ctx:fillRect(8, 8, 100, 60)
end)

canvas:repaint()   -- request the first paint
```

> **Timing:** as explained in the [Lua Scripting Guide](/docs/lua-scripting#script-execution-timing), `<script>` blocks in `<head>` run **before** the body exists. Set up your canvas from a `<body onload="...">` handler (or the document `load` event) so the element is available.

## Quick start

```html
<rml>
  <head>
    <link type="text/rcss" href="myskin.rcss"/>
    <script>
      function initCanvas()
        local canvas = Element.As.Canvas(document:GetElementById("myCanvas"))
        canvas:setPaintFunction(function(ctx)
          -- filled + outlined rectangle
          ctx.fillStyle = "#2a6bd4"
          ctx:fillRect(8, 8, 100, 60)
          ctx.strokeStyle = "#ffffff"
          ctx.lineWidth = 3
          ctx:strokeRect(8, 8, 100, 60)

          -- filled circle
          ctx.fillStyle = "#e33e3e"
          ctx:beginPath()
          ctx:arc(60, 110, 24, 0, math.pi * 2)
          ctx:fill()

          -- a line
          ctx.strokeStyle = "#ffcc00"
          ctx.lineWidth = 2
          ctx:beginPath()
          ctx:moveTo(8, 150)
          ctx:lineTo(230, 150)
          ctx:stroke()
        end)
        canvas:repaint()
      end
    </script>
  </head>
  <body onload="initCanvas()">
    <canvas id="myCanvas" style="position: absolute; left: 100dp; top: 100dp; width: 260dp; height: 160dp;"/>
  </body>
</rml>
```

## Canvas element methods

| Method | Description |
|--------|-------------|
| `canvas:setPaintFunction(fn)` | Registers the Lua paint function `fn(ctx)`. Replaces any previous one. |
| `canvas:repaint()` | Requests a redraw. Call this whenever the content should change (e.g. from a `params.onChange` callback). |
| `canvas:setClearEveryFrame(enabled)` | If `true` (the default when a paint function is set), the canvas is cleared before each paint. Set `false` for a persistent canvas that you draw onto incrementally. |

## The 2D context

The context passed to your paint function is only valid **during** that call — do not store it and draw later; draw inside the paint function and call `canvas:repaint()` to trigger it.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `ctx.fillStyle` | string or gradient | Fill color (CSS color string) or a [gradient](#gradients). Used by `fillRect` and `fill`. |
| `ctx.strokeStyle` | string or gradient | Stroke color (CSS color string) or a [gradient](#gradients). Used by `strokeRect` and `stroke`. |
| `ctx.lineWidth` | number | Line thickness in pixels. Used by `strokeRect` and `stroke`. Zero or negative values are ignored. |
| `ctx.lineJoin` | string | How corners of a stroke are drawn: `"miter"` (default), `"round"` or `"bevel"`. |
| `ctx.lineCap` | string | How the ends of an open stroke are drawn: `"butt"` (default), `"round"` or `"square"`. |
| `ctx.canvas` | element | The canvas element being drawn on (read-only). Use it to read the canvas size, see [Coordinate system and scaling](#coordinate-system-and-scaling). |

### Methods

| Method | Description |
|--------|-------------|
| `ctx:fillRect(x, y, w, h)` | Fills a rectangle with `fillStyle`. |
| `ctx:strokeRect(x, y, w, h)` | Outlines a rectangle with `strokeStyle` / `lineWidth` / `lineJoin`. |
| `ctx:clearRect(x, y, w, h)` | Makes a rectangle fully transparent. |
| `ctx:beginPath()` | Starts a new path. |
| `ctx:closePath()` | Closes the current sub-path back to its start. |
| `ctx:moveTo(x, y)` | Moves the pen to `(x, y)` without drawing. |
| `ctx:lineTo(x, y)` | Adds a line segment to `(x, y)`. |
| `ctx:rect(x, y, w, h)` | Adds a rectangle sub-path to the current path. |
| `ctx:arc(x, y, radius, startAngle, endAngle [, counterclockwise])` | Adds an arc / circle. Angles are in radians. |
| `ctx:ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle [, counterclockwise])` | Adds an elliptical arc. |
| `ctx:fill()` | Fills the current path with `fillStyle`. |
| `ctx:stroke()` | Strokes the current path with `strokeStyle` / `lineWidth` / `lineJoin` / `lineCap`. |
| `ctx:clip()` | Restricts everything drawn afterwards to the current path, see [Clipping](#clipping). |
| `ctx:createLinearGradient(x0, y0, x1, y1)` | Returns a [gradient](#gradients) along the line from `(x0, y0)` to `(x1, y1)`. |
| `ctx:createRadialGradient(x0, y0, r0, x1, y1, r1)` | Returns a [gradient](#gradients) from the circle at `(x0, y0)` with radius `r0` to the circle at `(x1, y1)` with radius `r1`. |

Filled and outlined shapes follow the standard HTML5 pattern — rectangles have the `fillRect`/`strokeRect` shortcuts, while circles, ellipses and lines are built as paths and then filled or stroked:

```lua
-- filled circle
ctx.fillStyle = "#e33e3e"
ctx:beginPath()
ctx:arc(cx, cy, r, 0, math.pi * 2)
ctx:fill()

-- outlined ellipse
ctx.strokeStyle = "#1db954"
ctx.lineWidth = 4
ctx:beginPath()
ctx:ellipse(cx, cy, rx, ry, 0, 0, math.pi * 2)
ctx:stroke()
```

## Colors

`fillStyle` and `strokeStyle` accept CSS color strings:

| Form | Example |
|------|---------|
| `#rgb` | `"#f00"` |
| `#rrggbb` | `"#ff0000"` |
| `#rrggbbaa` (with alpha) | `"#ff000080"` |
| `rgb(r, g, b)` | `"rgb(255, 0, 0)"` |
| `rgba(r, g, b, a)` | `"rgba(255, 0, 0, 0.5)"` |

## Gradients

Create a gradient from the context, add color stops to it, and assign it to `fillStyle` or `strokeStyle`:

```lua
local grad = ctx:createLinearGradient(0, 0, 0, h)   -- from the top to the bottom
grad:addColorStop(0, "rgba(70, 104, 132, 0.7)")
grad:addColorStop(1, "#1e3040")
ctx.fillStyle = grad
ctx:fillRect(0, 0, w, h)
```

| Method | Description |
|--------|-------------|
| `gradient:addColorStop(offset, color)` | Adds `color` at `offset`, from 0 (start) to 1 (end). Colors are blended between the stops; before the first and after the last stop, that stop's color continues. An offset outside 0..1 or an invalid color is an error. |

Gradient coordinates are canvas pixels and do not depend on the shape that is filled. A gradient without color stops draws nothing.

A radial gradient blends from the first circle to the second one, as in HTML5. For a plain round gradient, give both circles the same center:

```lua
local glow = ctx:createRadialGradient(cx, cy, 0, cx, cy, r)
glow:addColorStop(0, "#ffffffff")
glow:addColorStop(1, "#ffffff00")
ctx.fillStyle = glow
ctx:beginPath()
ctx:arc(cx, cy, r, 0, math.pi * 2)
ctx:fill()
```

## Clipping

`clip()` turns the current path into a clipping region: everything drawn afterwards, including `clearRect`, only affects the inside of that path. Calling `clip()` again narrows the region further. A clip lasts until the paint function returns, so every paint starts unclipped.

```lua
ctx:beginPath()
ctx:rect(10, 10, 200, 100)
ctx:clip()
-- from here on, drawing only shows up inside the rectangle
```

## Coordinate system and scaling

Drawing coordinates are in the canvas's **pixel** space with the origin `(0, 0)` at the **top-left** (same as HTML5, and unlike some low-level graphics APIs). Anything drawn outside the canvas is clipped.

The pixel size of a canvas is not fixed. It is the size of the element on screen, which depends on the skin's `rootScale`, the scale chosen in the plugin settings and the display scaling of the operating system. A canvas declared as `width: 260dp` can be 130 pixels wide in one host and 390 in another. Do not hard-code a scale factor for this: read the canvas size in the paint function and derive the factor from it.

```lua
canvas:setPaintFunction(function(ctx)
    local w = ctx.canvas.client_width     -- canvas size in pixels
    local h = ctx.canvas.client_height
    local s = w / 260                     -- pixels per dp, for a canvas declared 260dp wide

    ctx.lineWidth = 2 * s
    ctx:strokeRect(10 * s, 10 * s, 100 * s, 50 * s)   -- a 100 x 50 dp rectangle
end)
```

The canvas is repainted whenever its size changes, so the drawing always matches the current scale. `client_width` and `client_height` include padding, so keep a canvas free of padding and borders.

## Redrawing from parameter changes

The canvas is only repainted when you ask it to. Combine it with the [Parameter API](/docs/lua-scripting#parameter-api) to make it react to the synth:

```lua
local canvas = Element.As.Canvas(document:GetElementById("cutoffMeter"))

canvas:setPaintFunction(function(ctx)
    local value = params.get("Cutoff")          -- 0..127
    ctx.fillStyle = "#1db954"
    ctx:fillRect(0, 0, value / 127 * 200, 20)
end)

-- repaint whenever the parameter changes
params.onChange("Cutoff", function() canvas:repaint() end)
canvas:repaint()
```

## HTML5 compatibility

The context's property and method names match the HTML5 `CanvasRenderingContext2D`, so drawing code is portable. The one Gearmulator-specific step is the bootstrap: instead of `canvas.getContext("2d")` you register a **paint function** with `setPaintFunction`, and you trigger a redraw with `repaint()`. Everything inside the paint function is standard canvas 2D code.

The current implementation covers rectangles, lines, arcs/circles and ellipses; filling and stroking with colors or linear and radial gradients; line width, joins and caps; clipping and clearing. Transformations (`scale`, `translate`, `rotate`), `save`/`restore`, text and images are not available yet. More of the HTML5 surface may be added over time.

Gradients, `clearRect`, `clip`, `lineJoin`, `lineCap` and `ctx.canvas` are available as of version 2.2.25. A skin that should also run on older versions can check for a feature before using it, since a missing method or property reads as `nil`:

```lua
if ctx.createLinearGradient then
    -- use a gradient
else
    ctx.fillStyle = "#2b4764"
end
```
