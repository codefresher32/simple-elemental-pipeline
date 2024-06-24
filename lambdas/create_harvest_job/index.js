const { MediaPackageClient, CreateHarvestJobCommand } = require("@aws-sdk/client-mediapackage");

exports.handler = async (event) => {
  console.info(`EVENT: ${JSON.stringify(event)}`);

  const {
    Id, OriginEndpointId, StartTime, EndTime,
  } = JSON.parse(event?.body) || {};
  const {
    AWS_REGION, VOD_SOURCE_BUCKET, VOD_HARVESTED_FOLDER, MP_HARVEST_ROLE_ARN, 
  } = process.env;

  const mpClient = new MediaPackageClient({ region: AWS_REGION });
  const command = new CreateHarvestJobCommand({
    Id,
    StartTime,
    EndTime,
    OriginEndpointId,
    S3Destination: {
      BucketName: VOD_SOURCE_BUCKET,
      ManifestKey: `${VOD_HARVESTED_FOLDER}/${Id}/index.m3u8`,
      RoleArn: MP_HARVEST_ROLE_ARN,
    }
  });
  const response = await mpClient.send(command);
  return response;
};
