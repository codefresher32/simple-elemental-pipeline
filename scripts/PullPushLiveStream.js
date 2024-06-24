const { HLSPullPush, MediaPackageOutput } = require("@eyevinn/hls-pull-push");

const startPullPushLiveStream = async (requestBody) => {
  const pullPushService = new HLSPullPush();
  pullPushService.registerPlugin("mediapackage", new MediaPackageOutput());
  const logger = pullPushService.getLogger();

  try {
    const url = new URL(requestBody.url);
    const requestedPlugin = pullPushService.getPluginFor(requestBody.output);
    const outputDest = requestedPlugin.createOutputDestination(requestBody.payload, pullPushService.getLogger());

    const sessionId = pullPushService.startFetcher({
      name: requestBody.name,
      url: url.href,
      destPlugin: outputDest,
      destPluginName: requestBody.output,
      concurrency: null,
      windowSize: null,
    });
    outputDest.attachSessionId(sessionId);
  } catch (error) {
    logger.error(`Error while pull and push: ${error}`);
  };
};

if (require.main === module) {
  const requestBody = {
    name: "Push_to_live-to-vod-workflow-channel",
    url: "https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8",
    output: "mediapackage",
    payload: {
      ingestUrls: [
        {
          url: "https://b5e30e0b015606af.mediapackage.eu-north-1.amazonaws.com/in/v2/704842d5cd8f40cfa4a95555a6c91c0b/704842d5cd8f40cfa4a95555a6c91c0b/channel",
          username: "11e889999be74ffe83153a24c9a22290",
          password: "422d9fbcac5f4b4b807206878c370c1d"
        }
        // {
        //   url: "https://e606928710bee8a7.mediapackage.eu-north-1.amazonaws.com/in/v2/704842d5cd8f40cfa4a95555a6c91c0b/e3255a0625ec4d84b860134e368c273a/channel",
        //   username: "433ea101725a4c5daba095c0e14ae341",
        //   password: "7c0c8a2ea26a4c7b95450ad875de2d2d"
        // }
      ]
    }
  };
  startPullPushLiveStream(requestBody);
}
