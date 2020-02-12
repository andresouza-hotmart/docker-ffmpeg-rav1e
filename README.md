# docker-ffmpeg-rav1e
Dockerized FFmpeg with AV1 encoder (rav1e)

## Usage

```bash
$ docker pull andrecsouza/docker-ffmpeg-rav1e
$ docker run -it --volume /PATH/TO/VIDEO/:/media/ andrecsouza/docker-ffmpeg-rav1e -i /media/input.mp4 -c:v librav1e -qp 80 -speed 10 -tile-columns 2 -tile-rows 2 -c:a libfdk_aac -b:a 128k /media/output_av1.mp4
```

Where:
- `/PATH/TO/VIDEO/` is the directory where the **input media** is located
- `input.mp4` is the the **input media** file name
- `output_av1.mp4` is the **output media** file name (will be created)

## Advanced

The parameters after `andrecsouza/docker-ffmpeg-rav1e` will be used to run `ffmpeg`. The example above can be adapted.
