#!/usr/bin/env perl6
use nqp;

my $precomp-store = CompUnit::PrecompilationStore::File.new(:prefix($?FILE.IO.parent.child("precompiled")));
my $precomp = CompUnit::PrecompilationRepository::Default.new(store => $precomp-store);

my @pod-sources =
gather for dir("doc/Language") -> $f {
    take $f if $f.f and $f ~~ / '.pod6' /;
}

for @pod-sources.kv -> $num, $file {
    FIRST my @pod-files;

    push @pod-files, start {
        my $ffile = $file.IO;
        my $id = nqp::sha1(~$ffile);
        my $handle = $precomp.load($id,:since($ffile.modified))[0];

        if not $handle {
            $precomp.precompile($ffile, $id, :force);
        }
    }

    if $num %% 3 {
        await(@pod-files);
        @pod-files = ();
    }

    LAST await(@pod-files);
}

say "OK";
