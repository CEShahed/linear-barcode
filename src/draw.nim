import std/xmltree
import ../lib/barcode

# helpers -------------------------------------

func svg*(w, h: int): XmlNode =
  <>svg(
    xmlns = "http://www.w3.org/2000/svg",
    width = $w,
    height = $h)

func rect*(x, y, w, h: int, color: string): XmlNode =
  <>rect(
    x = $x,
    y = $y,
    width = $w,
    height = $h,
    # stroke = "gray",
    # stroke-width = "1px",
    fill = color)

# main -------------------------------------

proc draw(segments: seq[bool], width, height: int): XmlNode =
  result = svg(width*segments.len, height)

  for i, s in segments:
    let
      color =
        case s:
        of true: "black"
        of false: "white"

    result.add rect(i * width, 0, width, height, color)


when isMainModule:
  writefile "temp.svg":
    $draw(bits toUpca @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0], 5, 200)
