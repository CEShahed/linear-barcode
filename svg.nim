import std/xmltree


func rect*(x, y, w, h: int, color: string): XmlNode =
  <>rect(
    x = $x,
    y = $y,
    width = $w,
    height = $h,
    # stroke = "gray",
    # stroke-width = "1px",
    fill = color)

func svg*(w, h: int): XmlNode =
  <>svg(
    xmlns = "http://www.w3.org/2000/svg",
    width = $w,
    height = $h)
