# Package

version       = "0.1.0"
author        = "hamidb80"
description   = "linear barcode generator app & guide"
license       = "MIT"
srcDir        = "src"
bin           = @["linear_barcode"]


# Dependencies

requires "nim >= 1.6.6"
requires "karax >= 1.2.2"


task web, "builds web inside ./dist/":
  exec "nim -o:./dist/script.js js src/web"
