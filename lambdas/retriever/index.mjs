import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

export const handler = async (event) => {
  console.info(`EVENT: ${JSON.stringify(event)}`);

  const { fileName } = event?.queryStringParameters;
  const {
    AWS_REGION, VOD_SOURCE_BUCKET, SIGNEDURL_EXPIRES, VOD_FOLDER
  } = process.env;

  const s3Client = new S3Client({ region: AWS_REGION });

  try {
    const command = new PutObjectCommand({
      Bucket: VOD_SOURCE_BUCKET, Key: `${VOD_FOLDER}${fileName}`,
    });
    const uploadUrl = await getSignedUrl(
      s3Client, command, { expiresIn: +(SIGNEDURL_EXPIRES) },
    );

    return {
      status: 200, uploadUrl,
    }
  } catch (err) {
    console.error(`ERROR: ${err}`);

    return {
      status: 500, error: err.message,
    };
  }
};
