# UPC-A Barcode Generator

## Install dependecies
```bash
nimble install
```

## Compile Web App
```bash
nim js web/src/script
```

Then open `./dist/index.html` in your web browser and enjoy!

## Run MVP
```bash
nim r play.nim
```

creates `temp.svg` in current directory

# بارکد ساز UPC-A

لینک مقاله:
https://vrgl.ir/tqxlq


## چگونه برنامه را خودم اجرا کنم؟
برای اینکار باید زبان Nim را در کامپیوتر خود نصب کرده باشید.

ورژنی از زبان Nim که من برای توسعه از آن استفاده کردم، ورژن `1.6.6` است.

بعد از نصب زبان Nim میتوانید با این کد در پوشه اصلی پروژه برنامه رو اجرا کنید:

```
nim r play.nim
```

که نتیجه آن یک فایل با نام `temp.svg` است که در همین پوشه ایجاد میشود