import { HLSPullPush, MediaPackageOutput } from "@eyevinn/hls-pull-push";

const pullPushService = new HLSPullPush();
pullPushService.registerPlugin("mediapackage", new MediaPackageOutput());
// Start the Service
pullPushService.listen(8080);
