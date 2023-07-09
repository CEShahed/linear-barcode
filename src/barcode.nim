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

func `'bits`(lit: string): seq[bool] =
  for b in lit:
    result.add:
      case b
      of '1': true
      of '0': false
      of '_': continue
      else: raise newException(ValueError, "not a valid bit")

func bits*(u: UpcA): seq[bool] =
  case u
  of o0: 0001101'bits
  of o1: 0011001'bits
  of o2: 0010011'bits
  of o3: 0111101'bits
  of o4: 0100011'bits
  of o5: 0110001'bits
  of o6: 0101111'bits
  of o7: 0111011'bits
  of o8: 0110111'bits
  of o9: 0001011'bits
  of e0..e9: not bits UpcA(u.ord - e0.ord)
  of uSpace: 000_000_000'bits
  of uBorderGuard: 101'bits
  of uMiddleGuard: 01010'bits

func bits*(us: seq[UpcA]): seq[bool] =
  for u in us:
    result.add u.bits


func digit(u: UpcA): Digit =
  if u in o0..e9:
    u.ord mod 10
  else:
    raise newException(ValueError, "not a digit")

func name*(u: UpcA): string =
  case u
  of o0..o9: "odd " & $u.digit
  of e0..e9: "even " & $u.digit
  of uSpace: "space"
  of uBorderGuard: "border guard"
  of uMiddleGuard: "middle guard"


func complement(n, base: int): int =
  if n mod base == 0: 0
  else: base - abs n mod 10

func checkDigitSum*(digits: seq[Digit]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 1: d.int
      else: d.int * 3

func checkDigit*(digits: seq[Digit]): Digit =
  complement checkDigitSum digits, 10


func upca(n: range[0..9], parity: Parity): UpcA =
  case parity
  of pOdd: UpcA n + o0.ord
  of pEven: UpcA n + e0.ord

func toUpca*(digits: seq[Digit]): seq[UpcA] =
  assert digits.len == 11

  template `>>`(smth): untyped =
    result.add smth

  >> uSpace
  >> uBorderGuard
  for i in 0..5: >> upca(digits[i], pOdd)
  >> uMiddleGuard
  for i in 6..10: >> upca(digits[i], pEven)
  >> upca(checkDigit digits, pEven)
  >> uBorderGuard
  >> uSpace
