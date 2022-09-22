import std/xmltree
import barcode, svg

proc draw(segments: seq[bool], width, height: int): XmlNode =
  result = svg(width*segments.len, height)

  for i, s in segments:
    let
      color =
        case s:
        of true: "black"
        of false: "white"

    result.add rect(i * width, 0, width, height, color)


writefile "temp.svg":
  $draw(toUpca @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0], 5, 200)
