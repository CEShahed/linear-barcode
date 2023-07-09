import std/sequtils

type
  UpcA* = enum
    o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    e0, e1, e2, e3, e4, e5, e6, e7, e8, e9
    uSpace, uBorderGuard, uMiddleGuard

  Parity = enum
    pOdd, pEven

  Digit* = range[0..9]


func negate(b: bool): bool = 
  not b

func `not`(bc: seq[bool]): seq[bool] =
  map bc, negate

func bits(n, size: int): seq[bool] =
  result = newSeq[bool](size)

  var acc = n
  for i in countdown(size - 1, 0):
    result[i] = acc mod 10 == 1
    acc = acc div 10

func bits*(u: UpcA): seq[bool] =
  case u:
  of o0: bits(0001101, 7)
  of o1: bits(0011001, 7)
  of o2: bits(0010011, 7)
  of o3: bits(0111101, 7)
  of o4: bits(0100011, 7)
  of o5: bits(0110001, 7)
  of o6: bits(0101111, 7)
  of o7: bits(0111011, 7)
  of o8: bits(0110111, 7)
  of o9: bits(0001011, 7)
  of e0: not bits o0
  of e1: not bits o1
  of e2: not bits o2
  of e3: not bits o3
  of e4: not bits o4
  of e5: not bits o5
  of e6: not bits o6
  of e7: not bits o7
  of e8: not bits o8
  of e9: not bits o9
  of uSpace: bits(0, 9)
  of uBorderGuard: bits(101, 3)
  of uMiddleGuard: bits(01010, 5)

func bits*(us: seq[UpcA]): seq[bool] =
  for u in us:
    result.add u.bits


func digit(u: UpcA): Digit =
  case u:
  of e0, o0: 0
  of e1, o1: 1
  of e2, o2: 2
  of e3, o3: 3
  of e4, o4: 4
  of e5, o5: 5
  of e6, o6: 6
  of e7, o7: 7
  of e8, o8: 8
  of e9, o9: 9
  else:
    raise newException(ValueError, "not a digit")

func name*(u: UpcA): string =
  case u:
  of e0..e9: "even " & $u.digit
  of o0..o9: "odd " & $u.digit
  of uSpace: "space"
  of uBorderGuard: "border guard"
  of uMiddleGuard: "middle guard"


func complement(n, base: int): int =
  if n mod base == 0: 0
  else: base - abs n mod 10


func checkDigitSum*(digits: seq[Digit]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 1: d
      else: d * 3

func checkDigit*(digits: seq[Digit]): Digit =
  complement checkDigitSum digits, 10


func upca(n: range[0..9], parity: Parity): UpcA =
  case parity:
  of pOdd: UpcA n
  of pEven: UpcA n+10

func toUpca*(digits: seq[Digit]): seq[UpcA] =
  assert digits.len == 11

  template `>>`(smth): untyped =
    result.add smth

  >> uSpace
  >> uBorderGuard
  for i in 0..5: >> upca(digits[i],  pOdd)
  >> uMiddleGuard
  for i in 6..10: >> upca(digits[i], pEven)
  >> upca(checkDigit digits, pEven)
  >> uBorderGuard
  >> uSpace
