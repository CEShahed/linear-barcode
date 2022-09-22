import std/[xmltree]
import barcode, svg

proc draw(segments: seq[bool], width = 5, height = 20): XmlNode =
  result = svg(width*segments.len, height)

  var pos = 0
  for s in segments:
    let
      color =
        case s:
        of true: "black"
        of false: "white"

    result.add rect(pos, 0, width, height, color)
    pos.inc width


writefile "temp.svg":
  $draw(toUpca @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0])
