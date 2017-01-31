Not intended to be merged to master!

To show the bug, run:

while [ 1 ] ; do perl6 htmlify.p6 ; done

I haven't seen a segfault with recent rakudos, but it will often get caught
in a CPU-chewing frenzy and not die, or throw an error like:

Tried to get the result of a broken Promise
  in block <unit> at htmlify.p6 line 22

Original exception:
    Type check failed in binding to &block; expected Callable but got Any (Any)
      in block  at htmlify.p6 line 18


OR

Tried to get the result of a broken Promise
  in block <unit> at htmlify.p6 line 22

Original exception:
    Tried to read() on a socket from outside its originating thread
      in block  at htmlify.p6 line 18
