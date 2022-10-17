import std/strformat

type
  UPCA_Char = enum
    o0 = 0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0 = 10, e1, e2, e3, e4, e5, e6, e7, e8, e9
    borderGuard, middleGuard, quietZone

  Parity = enum
    odd, even

const
  W = false
  B = true
  Q = quietZone
  M = middleGuard
  I = borderGuard


func `not`(s: seq[bool]): seq[bool] =
  for i in s:
    result.add(not i)

func bits(u: UPCA_Char): seq[bool] =
  case u
  of o0: @[W, W, W, B, B, W, B]
  of o1: @[W, W, B, B, W, W, B]
  of o2: @[W, W, B, W, W, B, B]
  of o3: @[W, B, B, B, B, W, B]
  of o4: @[W, B, W, W, W, B, B]
  of o5: @[W, B, B, W, W, W, B]
  of o6: @[W, B, W, B, B, B, B]
  of o7: @[W, B, B, B, W, B, B]
  of o8: @[W, B, B, W, B, B, B]
  of o9: @[W, W, W, B, W, B, B]
  of e0 .. e9: not bits(UPCA_Char(u.int - 10))
  of borderGuard: @[B, W, B]
  of middleGuard: @[W, B, W, B, W]
  of quietZone: @[W, W, W, W, W, W, W, W, W]


func sup10(i: int): int =
  if i mod 10 == 0: i
  else: ((i div 10) + 1) * 10

func findCheck(digits: array[11, int]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 0: d*3
      else: d

  result = sup10(result) - result

func toUPCA_char(d: int, p: Parity): UPCA_Char =
  case p
  of odd: UPCA_Char d
  of even: UPCA_Char d+10

func upca(s: seq[int]): seq[UPCA_Char] =
  result.add Q
  result.add I

  for i in 0..5:
    result.add toUPCA_char(s[i], odd)

  result.add M

  for i in 6..11:
    result.add toUPCA_char(s[i], even)

  result.add I
  result.add Q

func barcode(digits: array[11, int]): seq[bool] =
  let final = upca( @digits & findCheck(digits))
  for s in final:
    result.add bits s

func toSVG(s: seq[bool]): string =
  for i ,bar in s:
    let color =
      case bar
      of W: "white"
      of B: "black"

    result &= fmt"""<rect x="{i*7}" height="100" width="7" style="fill: {color}"/>"""

  result = fmt"""
  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
    width="{7 * s.len}" height="100">
     {result}
  </svg>
  """



when false:
  original: @[1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1] # 11
  +checkDigit: @[1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 8] # 12

  @[1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 8]
  @[Q, I, o1, o2, o3, o4, o5, o6, M, e7, e8, e9, e0, e1, e8, I, Q]

  @[WBWBWBWBWBWBBBBBWBWWWWW]

echo upca @[4, 6, 5, 4, 6, 5, 4, 8, 4, 1, 6, 9]
let b = barcode [4, 6, 5, 4, 6, 5, 4, 8, 4, 1, 6]


writeFile("temp.svg", toSVG(b))
