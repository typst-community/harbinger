#let find-arg(source, ..args, default: none) = {
  for arg in args.pos() {
    if (source.keys().contains(arg)) {
      return source.at(arg)
    }
  }
  return default
}

#let parse-outset(outset) = {
  if (type(outset) == length) {
    (left: outset, right: outset, top: outset, bottom: outset)
  } else {
    (
      left: find-arg(outset, "left", "x", "other", default: 0pt),
      right: find-arg(outset, "right", "x", "other", default: 0pt),
      top: find-arg(outset, "top", "y", "other", default: 0pt),
      bottom: find-arg(outset, "bottom", "y", "other", default: 0pt),
    )
  }
}

#let shadow-block(
  width: auto, height: auto, radius: 0pt, outset: 0pt,
  blur: 1pt, dx: 10pt, dy: 10pt, shadow-color: rgb(0,0,0).lighten(0%),
  shadow-outset: 0pt,
  ..args, body
) = {
  let bwidth = if (type(width) == ratio) {100%} else {width}
  let bheight = if (type(height) == ratio) {100%} else {height}
  let outset = parse-outset(outset)
  let shadow-outset = parse-outset(shadow-outset)
  let shadow-outset = (
      left: shadow-outset.left - dx+outset.left+blur,
      right: shadow-outset.right + dx+outset.right+blur,
      top: shadow-outset.top - dy+outset.top+blur,
      bottom: shadow-outset.bottom + dy+outset.bottom+blur,
    )
  block(
    radius: radius,
    width: width,
    height: height,
    outset: shadow-outset,
    fill: if (blur == 0pt) {shadow-color} else {none},
    inset: 0pt,
    layout(size => style(st => {
      let bwidth = if (type(width) == ratio) {size.width} else {width}
      let bheight = if (type(height) == ratio) {size.height} else {height}
      let body = (block(width: bwidth, height: bheight, radius: radius, outset: outset, ..args, body))
      let bsize = measure(body, st)
      let radius = calc.max(radius, 2*blur)

      if (blur != 0pt) {
        let dx = dx 
        let dy = dy
        radius = radius+blur
        let bwidth = bsize.width - 2*radius + shadow-outset.left + shadow-outset.right
        let bheight = bsize.height - 2*radius + shadow-outset.top + shadow-outset.bottom 

        let grad = (shadow-color, rgb(255,255,255))
        let corn-grad = gradient.radial.with(..grad, radius: 100%, space:oklch)
        
        place(top+left, dx: -shadow-outset.left, dy: -shadow-outset.top,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(100%, 100%))))
        place(top+right, dx: shadow-outset.right, dy: -shadow-outset.top,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(0%,100%))))
        place(bottom+right, dx: shadow-outset.right, dy: shadow-outset.bottom,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(0%,0%))))
        place(bottom+left, dx: -shadow-outset.left, dy: shadow-outset.bottom,
          rect(width: radius, height: radius,
            fill: corn-grad(center:(100%,0%))))
        
        place(top+center, dx: dx, dy:  -shadow-outset.top,
          rect(height: radius , width: bwidth,
            fill: gradient.linear(dir: btt, ..grad, space:oklch)))
        place(horizon+right, dx: shadow-outset.right, dy: dy,
          rect(width: radius , height: bheight,
            fill: gradient.linear(dir: ltr, ..grad, space:oklch)))
        place(bottom+center, dx: dx, dy: shadow-outset.bottom,
          rect(height: radius , width: bwidth,
            fill: gradient.linear(dir: ttb, ..grad, space:oklch)))
        place(horizon+left, dx: -shadow-outset.left, dy: dy,
          rect(width: radius , height: bheight,
            fill: gradient.linear(dir: rtl, ..grad, space:oklch)))
        
        place(horizon+center, dx: dx, dy: dy,
          rect(width: bwidth, height: bheight, fill: shadow-color))
        place(horizon+center, dx: dx, dy: dy,
          rect(width: bwidth, height: bheight, fill: shadow-color))
      }
      (body)
    }))
  )
}


#let fast-shadow-box(..args) = box(shadow-block(..args))
