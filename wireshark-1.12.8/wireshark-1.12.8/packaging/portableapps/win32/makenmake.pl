#
# makenmake.pl - create a nmake file from a generic manifest file that will create the appropriate PortableApp structure

print q{
#
# DO NOT EDIT - autogenerated from makenmake.pl and ../../wireshark.manifest
#

include ../../../config.nmake
include <win32.mak>

FILES       = Files
APP         = App
WIRESHARK   = Wireshark

TOPDIR      = ..\..\..
STAGING_DIR = $(TOPDIR)\$(INSTALL_DIR)
COPY        = xcopy
MOVE        = mv
MKDIR       = mkdir
COPY_FLAGS  = /d /y
PROGRAM_NAME_PATH_GTK = $(PROGRAM_NAME).exe

# XXX This should be defined in config.nmake.
!IF EXIST("$(TOPDIR)\wireshark-qt-release\qtshark.exe")
QT_DIR= "$(TOPDIR)\wireshark-qt-release"
PROGRAM_NAME_PATH_QT = "qtshark.exe"
!ENDIF
!IF EXIST("$(TOPDIR)\wireshark-qt-release\Qt5Core.dll")
NEED_QT5_DLL= USE
!ENDIF
!IF EXIST("$(TOPDIR)\wireshark-qt-release\QtCore4.dll")
NEED_QT4_DLL= USE
!ENDIF

distribution:
};

while($line = <>) {

    if($line =~ /^\#/) { # comment
        next;
    } elsif($line =~ /^\[(\S+)/) { # new directory
        if(defined $define) { # Clear out any leftover defines.
            print "!ENDIF\n";
            undef($define);
        }

        $dir = $1;

        $dir =~ s/\$INSTDIR?//; # remove $INSTDIR

        $dir =~ s/\{/\(/g; $dir =~ s/\}/\)/g; # convert curlies to round brackets

        if($dir ne '') {
            print "    if not exist \$(FILES)\\\$(APP)\\\$(WIRESHARK)$dir \$(MKDIR) \$(FILES)\\\$(APP)\\\$(WIRESHARK)$dir\n";
        }

    } else { # this is a file

        $line =~ /^\s+(\S+)/;
        $file = $1;

        $file =~ s/\{/\(/g; $file =~ s/\}/\)/g; # convert curlies to round brackets

        if($file =~ /^[^\$]/) {
            $file = "\$(TOPDIR)\\" . $file;
        }

        if($line =~ /ifdef=(\w+)/) { # dependency
            if($define ne $1) {
                if(defined $define) {
                    print "!ENDIF\n";
                }
                $define = $1;
                print "!IF DEFINED($define)\n";
            }
        } else {

            if(defined $define) {
                print "!ENDIF\n";
            }
            undef $define;
        }

        $oname = "";

        print "    \$(COPY) \"$file\" \"\$(FILES)\\\$(APP)\\\$(WIRESHARK)$dir\" \$(COPY_FLAGS)\n";

        if($line =~ /oname=(\S+)/) { # override this filename
            $oname = $1;
            $file =~ /\\(.*)$/;
            $name = $1;

            print "    \$(MOVE) \"\$(FILES)\\\$(APP)\\\$(WIRESHARK)\\$dir\\$name\" \"\$(FILES)\\\$(APP)\\\$(WIRESHARK)\\$dir\\$oname\"\n";

        }

    }
}

#
# Editor modelines
#
# Local Variables:
# c-basic-offset: 4
# tab-width: 8
# indent-tabs-mode: nil
# End:
#
# ex: set shiftwidth=4 tabstop=8 expandtab:
# :indentSize=4:tabSize=8:noTabs=true:
#
