const ffmpeg = require('fluent-ffmpeg');

const source = 'https://5eefe582b5018010.mediapackage.eu-north-1.amazonaws.com/out/v1/b3a6fdd006564c8182ad231f02a6ebbe/index.m3u8';

ffmpeg.ffprobe(source, (err, metadata) => {
  if (err) {
    console.error(err);
    return;
  }

  console.log(metadata);
});

// ffprobe -hide_banner -loglevel fatal -show_error -show_format -show_streams -show_programs -show_chapters -show_private_data -print_format json {input}