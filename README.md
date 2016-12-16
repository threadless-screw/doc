Not intended to be merged to master!

To show the bug, run:

while [ 1 ] ; do perl6 htmlify.p6 ; done

And it should (often, but not 100% of the time) generate a segfault.
