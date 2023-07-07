include karax/prelude
import barcode

# utils -------------------------------------

func parseDigit*(ch: char): int =
  ch.ord - '0'.ord

func digits*(s: string): seq[int] =
  for ch in s:
    result.add parseDigit ch

func checkDigitSum*(digits: seq[int]): int =
  for i, d in digits:
    result.inc:
      if i mod 2 == 1: d
      else: d * 3

# html -------------------------------------

func color(bit: bool): string =
  case bit:
  of true: "black"
  of false: "white"

func text(s: varargs[string]): VNode =
  buildHtml span:
    for p in s:
      text p

func url(desc, address: string): VNode =
  buildHtml:
    a(href = address):
      text desc

# app --------------------------------------

var userInput = kstring""

proc createDom: VNode =
  buildHtml tdiv:
    h1: text "Barcode Generator | UPC-A"
    tdiv:
      input(maxlength = "11"):
        proc onkeyup(ev: Event; n: VNode) =
          userInput = n.text

      text $(userInput.len), "/11"

    h2: text "Steps"
    if userInput.len == 11:
      let
        ds = digits $userInput
        s = checkDigitSum ds

      h3: text "calculating the 'check digit'"
      tdiv(class = "indent"):

        h4: text "sum"
        tdiv(class = "indent"):
          for i, d in ds:
            if i != 0:
              text " + "

            if i mod 2 == 0:
              text "(", $d, " * 3)"
            else:
              text $d

          text " = ", $s

        p:
          let sup =
            if s mod 10 == 0: s div 10 * 10
            else: (s div 10 + 1) * 10

          h4: text "10 complement"
          tdiv(class = "indent"):
            text $sup, " - ", $s
            text " = ", $ checkDigit ds

      h3: text "matching digits with the pattern"
      table(class = "indent"):
        tr:
          td: text "S"
          td: text "B"
          for i in 1..6: td: text "O"
          td: text "M"
          for i in 1..6: td: text "E"
          td: text "B"
          td: text "S"


      tdiv(class = "steps wrapper"):
        for g in toUPCA ds:
          tdiv(class = "upca-slice wrapper"):
            span(class = "name"):
              text g.name

            tdiv(class = "box"):
              for b in bits g:
                tdiv(class = "bit " & kstring(b.color))

      tdiv(class = "final wrapper"):
        h2:
          text "final result"

        tdiv(class = "barcode"):
          for g in toUPCA ds:
            for b in bits g:
              tdiv(class = "bit " & kstring(b.color))

        span:
          for d in ds:
            text $d

          text $checkDigit ds

    footer:
      p:
        text "created by "
        url "@hamidb80", "https://github.com/hamidb80"

        text " - you can read the explaination "
        url "in persian", "https://vrgl.ir/tqxlq"

        text " - here's the repository "
        url "on github", "https://github.com/CEShahed/linear-barcode"


when isMainModule:
  setRenderer createDom
