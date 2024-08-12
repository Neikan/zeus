import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/data/hive/hive_types.dart';
import 'package:zeusfile/presentation/widgets/file_icon.dart';
import 'package:video_player/video_player.dart';

class MediaPlayer extends StatefulWidget {
  final String sourceUrl;
  final String? fileName;

  final FileType? fileType;

  const MediaPlayer(
      {super.key, required this.sourceUrl, this.fileName, this.fileType});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();

  static MaterialPageRoute materialPageRoute(
          {required String sourceUrl, String? fileName}) =>
      MaterialPageRoute(
          builder: (context) => MediaPlayer(
                sourceUrl: sourceUrl,
                fileName: fileName,
              ));

  static Future<void> dialog(BuildContext context,
          {required String sourceUrl, String? fileName, FileType? fileType}) =>
      showDialog(
          context: context,
          builder: (context) => SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: MediaPlayer(
                      sourceUrl: sourceUrl,
                      fileName: fileName,
                      fileType: fileType,
                    ),
                  ),
                ),
              ));
}

class _MediaPlayerState extends State<MediaPlayer> {
  late VideoPlayerController _controller;

  FileType? get localFileType {
    if (_controller.value.hasError) return null;

    if (!_controller.value.isPlaying) return FileType.file;

    return _controller.value.size.longestSide == 0 &&
            _controller.value.isPlaying
        ? FileType.music
        : FileType.video;
  }

  FileType? get fileType => widget.fileType ?? localFileType;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.sourceUrl);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getPlaceholder() {
    switch (fileType) {
      case FileType.music:
        return const Center(
          child: FileIcon(
            fileType: FileType.music,
            width: 60,
            height: 60,
          ),
        );
      case null:
        return Center(
          child: SvgPicture.asset(
            'assets/icons/close_icon.svg',
            width: 60,
            height: 60,
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          getPlaceholder(),
          fileType == null
              ? Container()
              : _ControlsOverlay(controller: _controller),
          Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    top: 6,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/close_icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.black26,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<double>(
              initialValue: controller.value.playbackSpeed,
              tooltip: 'Playback speed',
              onSelected: (double speed) {
                controller.setPlaybackSpeed(speed);
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<double>>[
                  for (final double speed in _examplePlaybackRates)
                    PopupMenuItem<double>(
                      value: speed,
                      child: Text('${speed}x'),
                    )
                ];
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Text('${controller.value.playbackSpeed}x'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
