KPMWine
=======

A wine based image to Cythonize, build and package kivy applications for
windows using Python3.6.

This could probably work for other applications, but the focus for me is to
build kivy applications for windows.

Xvfb is used to be able to import kivy at package time, as well as using
InnoSetup (which is available) to package the app afterward.

MingW64 is used to build CPython extensions, (in my case generally created by
cython). I couldn't manage to install vs_BuildTools to do that, and MingW does
the job for me.

Make is available to script the various build/package actions.

Git is available because it's generally useful (i mostly have it for "git
describe --tag" to ship the release in the app)

The entrypoint just starts xvfb and runs whatever command you put on the
commandline.

Example usage:

         docker run --rm -v $PWD:/app tshirtman/kpmwine make

you can create a volume for the pip cache to save time on subsequent builds.

         mkdir /tmp/pipcache
         chmod a+w /tmp/pipcache
         docker run --rm -v $PWD:/app -v /tmp/pipcache:"/wine/drive_c/users/pyinstaller/Local Settings/application data/pip/cache/" tshirtman/kpmwine make
         
         
The pyinstaller output should be in `dist/`

This image is based on the cdrx/pyinstaller-windows:python3 which made it
possible at all.
