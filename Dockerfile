FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl wget nasm

# RUST
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup-init
RUN chmod a+x rustup-init
RUN ./rustup-init -y
RUN /bin/bash -c "source /root/.profile"

RUN apt-get install -y cargo

# RAV1E
RUN mkdir -pv /root/bin /root/ffmpeg_sources /root/ffmpeg_build
RUN cd /root/ffmpeg_sources && \
    wget https://github.com/xiph/rav1e/archive/p20200127.tar.gz && \
    tar xvf p20200127.tar.gz
RUN cd /root/ffmpeg_sources/rav1e-p20200127 && \
    cargo build --release && \
    find target -name rav1e -exec install -m 755 {} /root/bin \; && \
    strip /root/bin/rav1e && \
    cargo install cargo-c && \
    cargo cinstall --release --prefix=/root/ffmpeg_build --libdir=/root/ffmpeg_build/lib --includedir=/root/ffmpeg_build/include

RUN rm -fv /root/ffmpeg_build/lib/librav1e.so*
RUN echo 'export PATH="/root/.cargo/bin:$PATH"' >> ~/.bashrc

# FFMPEG
RUN apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    pkg-config \
    texinfo \
    zlib1g-dev \
    yasm \
    libx264-dev \
    libx265-dev libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev
RUN apt-get -y upgrade
    
RUN mkdir -p ~/ffmpeg_sources ~/bin
RUN cd ~/ffmpeg_sources && \
    wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --extra-libs="-lpthread -lm" \
      --bindir="$HOME/bin" \
      --enable-gpl \
      #--enable-libaom \
      --enable-librav1e \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree && \
    PATH="$HOME/bin:$PATH" make && \
    make install && \
    hash -r

RUN /bin/bash -c "source /root/.profile"
RUN echo 'export PATH="/root/bin:$PATH"' >> ~/.bashrc



#CMD ["ffmpeg"]
CMD ["bash"]
