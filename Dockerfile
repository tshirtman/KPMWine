FROM cdrx/pyinstaller-windows:python3

VOLUME /pipcache
VOLUME /app

RUN apt-get update; apt-get install -y xvfb make patch git p7zip unzip
RUN yes no|dpkg-reconfigure dash
RUN yes|adduser pyinstaller --disabled-password --quiet\
 && chown -R pyinstaller: /wine\
 && chown -R pyinstaller: /pipcache

USER pyinstaller

COPY distutils.cfg /wine/drive_c/Python36/Lib/distutils/distutils.cfg
COPY cygwinccompiler.patch /tmp/cygwinccompiler.patch
COPY entrypoint.sh /entrypoint.sh

RUN patch -d / -p0 --binary -i /tmp/cygwinccompiler.patch
RUN wget http://www.jrsoftware.org/download.php/is-unicode.exe?site=2 -O /tmp/is-unicode.exe \
 && xvfb-run wine /tmp/is-unicode.exe /ISP /VERYSILENT /SUPPRESSMSGBOXES /LANG=en  \
 && rm /tmp/is-unicode.exe

RUN wget https://freefr.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/6.4.0/threads-posix/sjlj/x86_64-6.4.0-release-posix-sjlj-rt_v5-rev0.7z -O /tmp/mingw64.7z \
 &&  7zr x /tmp/mingw64.7z -o/wine/drive_c/ \
 && rm /tmp/mingw64.7z

ENV WINEPATH=C:\\mingw64\\bin

RUN wget https://freefr.dl.sourceforge.net/project/pkgconfiglite/0.28-1/pkg-config-lite-0.28-1_bin-win32.zip -O /tmp/pkg-config-lite-0.28-1_bin-win32.zip \
 && unzip -d /tmp /tmp/pkg-config-lite-0.28-1_bin-win32.zip \
 && rm /tmp/pkg-config-lite-0.28-1_bin-win32.zip

RUN mv /tmp/pkg-config-lite-0.28-1/bin/pkg-config.exe /wine/drive_c/mingw64/bin/
RUN rm -rf /tmp/pkg-config-lite.zip /tmp/pkg-config-lite-0.28-1
RUN rm -rf "/wine/drive_c/users/pyinstaller/Local Settings/Application Data/pip/Cache/"\
 && mkdir -p "/wine/drive_c/users/pyinstaller/Local Settings/Application Data/pip/"\
 && ln -s /pipcache "/wine/drive_c/users/pyinstaller/Local Settings/Application Data/pip/Cache"

RUN cd /tmp \
 && wget https://www.libsdl.org/release/SDL2-devel-2.0.8-mingw.tar.gz \
         https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.2-mingw.tar.gz \
         https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.3-mingw.tar.gz \
         https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.14-mingw.tar.gz \
    && tar -xf SDL2-devel-2.0.8-mingw.tar.gz \
    && tar -xf SDL2_mixer-devel-2.0.2-mingw.tar.gz \
    && tar -xf SDL2_image-devel-2.0.3-mingw.tar.gz \
    && tar -xf SDL2_ttf-devel-2.0.14-mingw.tar.gz \
    && cp -rv SDL2-2.0.8/x86_64-w64-mingw32/*  \
              SDL2_mixer-2.0.2/x86_64-w64-mingw32/* \
              SDL2_image-2.0.3/x86_64-w64-mingw32/* \
              SDL2_ttf-2.0.14/x86_64-w64-mingw32/* \
          /wine/drive_c/mingw64/

RUN cd /tmp \
 && wget https://gstreamer.freedesktop.org/data/pkg/windows/1.14.0.1/gstreamer-1.0-devel-x86_64-1.14.0.1.msi
RUN xvfb-run wine msiexec /q /i /tmp/gstreamer-1.0-devel-x86_64-1.14.0.1.msi

RUN rm -rf /tmp/SDL2* /tmp/gstreamer*

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
