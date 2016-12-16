#!/usr/bin/env perl6
use v6;

my $precomp-store = CompUnit::PrecompilationStore::File.new(:prefix($?FILE.IO.parent.child("precompiled")));
my $precomp = CompUnit::PrecompilationRepository::Default.new(store => $precomp-store);

sub extract-pod(IO() $file) {
    use nqp;
    my $id = nqp::sha1(~$file);
    my $handle = $precomp.load($id,:since($file.modified))[0];

    if not $handle {
        $precomp.precompile($file, $id, :force);
        $handle = $precomp.load($id)[0];
    }

    return nqp::atkey($handle.unit,'$=pod')[0];
}

my @pod-sources =
gather for dir("doc/Language") -> $f {
    take $f if $f.f and $f ~~ / '.pod6' /;
}

for @pod-sources.kv -> $num, $file {
    FIRST my @pod-files;

    push @pod-files, start {
        extract-pod($file.path);
    }

    if $num %% 3 {
        await(@pod-files);
        @pod-files = ();
    }

    LAST await(@pod-files);
}

say "OK";
