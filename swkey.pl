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
) or die("Command line args error!\n");

my $ssh_dest = "$ENV{HOME}/.ssh";
unless (-d $ssh_dest) {
    mkdir $ssh_dest, 0700 or die "Failed to create directory $ssh_dest: $!";
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
            print "Copying $f -> ~/.ssh (chmod " . sprintf("%o", $mode) . ")\n";
        } else {
            warn "Warning: File $src not found.\n";
        }
    }
}

if ($gitconfig_path) {
    my $src = "$gitconfig_path/.gitconfig";
    my $dst = "$ENV{HOME}/.gitconfig";

    if (-e $src) {
        backup_if_exists($dst);
        copy($src, $dst) or die "Failed to copy .gitconfig: $!";
        print "Copying .gitconfig -> $ENV{HOME}\n";
    } else {
        warn "Warning: File $src not found.\n";
    }
}

sub backup_if_exists {
    my ($file) = @_;
    if (-e $file) {
        my $timestamp = strftime("%H_%M_%d_%m", localtime);
        my $bak_file = "${file}_${timestamp}.bak";
        rename($file, $bak_file) or die "Failed to backup $file: $!";
        print "Backup: $bak_file\n";
    }
}