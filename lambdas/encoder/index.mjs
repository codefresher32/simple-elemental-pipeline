import {
  MediaConvertClient, GetJobTemplateCommand, CreateJobCommand,
} from "@aws-sdk/client-mediaconvert";

const addInputSource = ({ Settings }, inputFileKey, VOD_SOURCE_BUCKET) => ({
  ...Settings,
  Inputs: Settings.Inputs.map((input) => ({
    ...input,
    FileInput: `s3://${VOD_SOURCE_BUCKET}/${inputFileKey}`,
  })),
});

const addOutputDestination = ({ Settings }, VOD_SOURCE_BUCKET) => ({
  ...Settings,
  OutputGroups: Settings.OutputGroups.map((outputGroup) => ({
    ...outputGroup,
    OutputGroupSettings: {
      ...outputGroup.OutputGroupSettings,
      HlsGroupSettings: {
        ...outputGroup.OutputGroupSettings.HlsGroupSettings,
        Destination: `s3://${VOD_SOURCE_BUCKET}/encoded/hls/`,
      },
    },
  })),
});

const createJob = async (mediaConvertClient, JobTemplate) => {
  const { MEDIACONVERT_ROLE_ARN } = process.env;
  const jobParams = {
    Settings: JobTemplate.Settings,
    Queue: JobTemplate.Queue,
    Priority: JobTemplate.Priority,
    Role: MEDIACONVERT_ROLE_ARN,
    BillingTagsSource: 'JOB',
    StatusUpdateInterval: 'SECONDS_60',
  };
  const command = new CreateJobCommand(jobParams);
  const createJobResp = await mediaConvertClient.send(command);
  return createJobResp;
};

export const handler = async (event) => {
  console.info(`EVENT: ${JSON.stringify(event)}`);
  const {
    AWS_REGION,
    MEDIACONVERT_ENDPOINT_URL,
    MEDIACONVERT_JOB_TEMPLATE,
    VOD_SOURCE_BUCKET,
  } = process.env;
  const inputFileKey = event.Records[0].s3.object.key;
  console.log(`inputFileKey: ${inputFileKey}`);

  const mediaConvertClient = new MediaConvertClient({
    region: AWS_REGION, endpoint: MEDIACONVERT_ENDPOINT_URL,
  });

  const getJobTemplateCmd = new GetJobTemplateCommand({ Name: MEDIACONVERT_JOB_TEMPLATE });
  const { JobTemplate } = await mediaConvertClient.send(getJobTemplateCmd);
  console.info(`Mediaconvert Job Template: ${JSON.stringify(JobTemplate)}`);

  JobTemplate.Settings = addInputSource(JobTemplate, inputFileKey, VOD_SOURCE_BUCKET);
  console.info(`After adding input: Job Template: ${JSON.stringify(JobTemplate)}`);
  JobTemplate.Settings = addOutputDestination(JobTemplate, VOD_SOURCE_BUCKET);
  console.info(`After adding output: Job Template: ${JSON.stringify(JobTemplate)}`);
  const resp = await createJob(mediaConvertClient, JobTemplate);
  console.log(`create job resp: ${JSON.stringify(resp)}`);
};
