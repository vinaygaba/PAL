PAL : PDF Automation Language
==============================

![PAL Mascot](images/pal.png)

PAL is a programming language that was developed to make the process of programmatically generating a PDF extremely simple.

Setup
------

To run this locally on your machine, do the following steps:

Download the project the go to the project directory. Then run the following commands:

```
$ make clean
$ make
```

To run a .pal program, save the file on your local machine and run the following command:

```
$ ./pal path_to_pal_file
```

Additional Details
-------------------

The language is written in OCaml and the code is compiled down to Java. It uses Apache PDFBox to do a lot of the PDF specific operations after the code has been compiled down to Java.
