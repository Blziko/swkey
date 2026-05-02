#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use File::Copy;
use File::Basename;
use POSIX qw(strftime);

my $key_path;
my $gitconfig_path;
my $type = 'ed25519';

GetOptions(
    "key=s" => \$key_path,
    "gitconfig=s" => \$gitconfig_path,
    "type=s" => \$type,
) or die("\033[1;31m[!] \033[0mCommand line args error!\n");

my $ssh_dest = "$ENV{HOME}/.ssh";
unless (-d $ssh_dest) {
    mkdir $ssh_dest, 0700 or die "\033[1;31m[!] \033[0mFailed to create directory: \033[0;32m$ssh_dest \033[0m($!)";
}

if ($key_path) {
    my @files = ("id_$type", "id_$type.pub");

    foreach my $f (@files) {
        my $src = "$key_path/$f";
        my $dst = "$ssh_dest/$f";

        if (-e $src) {
            backup_if_exists($dst);
            copy($src, $dst) or die "Failed to copy $src: $!";
            my $mode = ($f =~ /\.pub$/) ? 0644 : 0600;
            chmod($mode, $dst);
            print "\033[0mCopying: \033[0;32m$f \033[0m-> \033[0;32m~/.ssh/ \033[0m(chmod " . sprintf("%o", $mode) . ")\n";
        } else {
            warn "\033[1;31mWarning: \033[0mFile \033[0;32m$src \033[0mnot found!\n";
        }
    }
}

if ($gitconfig_path) {
    my $src = "$gitconfig_path/.gitconfig";
    my $dst = "$ENV{HOME}/.gitconfig";

    if (-e $src) {
        backup_if_exists($dst);
        copy($src, $dst) or die "Failed to copy .gitconfig: $!";
        print "\033[0mCopying: \033[0;32m.gitconfig \033[0m-> \033[0;32m~/\033[0m\n";
    } else {
        warn "\033[1;31mWarning: \033[0mFile \033[0;32m$src \033[0mnot found!\n";
    }
}

sub backup_if_exists {
    my ($file) = @_;
    if (-e $file) {
        my $timestamp = strftime("%H_%M_%d_%m", localtime);
        my $bak_file = "${file}_${timestamp}.bak";
        rename($file, $bak_file) or die "\033[1;31m[!] \033[0mFailed to backup: \033[0;32m$file \033[0m($!)";
    }
}