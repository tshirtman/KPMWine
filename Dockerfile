FROM cdrx/pyinstaller-windows:python3

VOLUME /pipcache
VOLUME /app

RUN apt-get update; apt-get install xvfb make patch git p7zip -y
RUN yes|adduser pyinstaller --disabled-password --quiet; chown -R pyinstaller: /wine ; chown -R pyinstaller: /pipcache
RUN ln -s "/wine/drive_c/users/pyinstaller/Local Settings/application data/pip/cache/" /pipcache/

USER pyinstaller

COPY distutils.cfg /wine/drive_c/Python36/Lib/distutils/distutils.cfg
COPY cygwinccompiler.patch /tmp/cygwinccompiler.patch
COPY entrypoint.sh /entrypoint.sh

RUN patch -d / -p0 --binary -i /tmp/cygwinccompiler.patch
RUN wget http://www.jrsoftware.org/download.php/is-unicode.exe?site=2 -O /tmp/is-unicode.exe
RUN xvfb-run wine /tmp/is-unicode.exe /ISP /VERYSILENT /SUPPRESSMSGBOXES /LANG=en

RUN wget https://freefr.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/6.4.0/threads-posix/sjlj/x86_64-6.4.0-release-posix-sjlj-rt_v5-rev0.7z -O /tmp/mingw64.7z
RUN 7zr x /tmp/mingw64.7z -o/wine/drive_c/ && rm /tmp/mingw64.7z

ENV WINEPATH=C:\\mingw64\\bin

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
