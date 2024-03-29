# Package

version       = "0.1.2"
author        = "hamidb80"
description   = "linear barcode generator app & guide"
license       = "MIT"
srcDir        = "src"
bin           = @["barcode"]


# Dependencies

requires "nim >= 1.6.14"
requires "karax >= 1.2.2"

# Tasks

task web, "builds web inside ./dist/":
  exec "nim -o:./dist/script.js js src/web"
