# Incless: a portable and extensible Common Lisp printer implemetation

This project implements `print-object` methods for many standard
classes and provides the interface to `write`, `print`, etc.

# Requirements

[ABCL][], [Clasp][], [ECL][], and [SBCL][] is the only current
implementations that this system has been tested on. 

In addition to a clone of this repository in a location that is
discoverable by ASDF you will also need a clone of
[nontrivial-gray-streams][].  Incless does not implement pretty
printing or `format`. These systems are implemented by [Inravina][]
and [Invistra][] which work in coordination with Incless.

# Usage

The core functionality is in the `incless` package, but the Common
Lisp-like interface of `write` and `print-object` is in the
`invistra-extrinsic` package and system. To call write try the
following in SBCL:

```
* (asdf:load-system :incless-extrinsic)
T
* (incless-extrinsic:write :wibble)
:WIBBLE
NIL
```

Incless can be loaded along with Inravina and Invistra to provide a
printer, pretty printer, and format. To load the complete stack try
the following:

```
* (asdf:load-system :invistra-extrinsic)
T
* (incless-extrinsic:pprint '(loop for i in '(a b c) 
                                    unless (eq i b) do (stuff i) (quux i) and collect i))

(LOOP FOR I IN '(A B C)
      UNLESS (EQ I B)
        DO (STUFF I)
           (QUUX I)
        AND COLLECT I)
* (invistra-extrinsic:format t "Wibble: ~a~%"
                             :quux)
Wibble: QUUX
NIL
```

[ABCL]: https://armedbear.common-lisp.dev/
[CLASP]: https://github.com/clasp-developers/clasp
[ECL]: https://ecl.common-lisp.dev/
[Inravina]: https://github.com/s-expressionists/Inravina
[Invistra]: https://github.com/s-expressionists/Invistra
[SBCL]: http://sbcl.org
[SICL]: https://github.com/robert-strandh/SICL
[nontrivial-gray-streams]: https://github.com/yitzchak/nontrivial-gray-streams

