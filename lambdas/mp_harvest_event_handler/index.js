const axios = require('axios');

// const createFeed = async (title, file_path) => {
//   console.info(`Creating feed with title: ${title} and file path: ${file_path}`);
//   const feed = `<feed xmlns:at="http://purl.org/atompub/tombstones/1.0" 
//       xmlns:dcterms="http://purl.org/dc/terms/" 
//       xmlns:vimond="http://www.vimond.com/vimondFeedExtension/1.0" 
//       xmlns:fn="http://www.w3.org/2005/xpath-functions" 
//       xmlns:media="http://search.yahoo.com/mrss/" 
//       xmlns="http://www.w3.org/2005/Atom">
//     <title>Test Feed</title>
//     <link href="http://www.vimond.no" rel="self"/>
//     <updated>2022-11-28T08:36:42.620Z</updated>
//     <entry>
//         <id>24f642bc-422e-4f27-89a1-0e7e082aa44a8798</id>
//         <title>harvest-job-live-to-vod-in-range-01</title>
//         <vimond:drmProtected>false</vimond:drmProtected>
//         <updated>2022-11-28T08:36:42.620Z</updated>
//         <media:group>
//             <media:content 
//                 medium="video"
//                 pipeline="EXTERNAL"
//                 url="https://vimond.video-output.eu-north-1-dev.vmnd.tv/harvested/harvest-job-live-to-vod-in-range-01/index.m3u8" 
//                 type="application/vnd.vimond.hls">
//                 <vimond:externalPlayback format="hls"/>
//             </media:content>
//         </media:group>
//     </entry>
// </feed>`;

//   try {
//     const res = await axios('https://vimond.asset-importer.eu-north-1-dev.vmnd.tv/ais/feed/90a1bde0-919f-11ed-8e73-997d088a1b83/v2/schedule', {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/xml',
//         'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjFvWDYwWDRtZXA0ZWZON0Mwb3dwOCJ9.eyJodHRwczovL3ZpbW9uZC9lbWFpbCI6InZpZGVvLXZvZC1pbnRlZ3JhdGlvbi10ZXN0QHZpbW9uZC5jb20iLCJodHRwczovL3ZpbW9uZC9yb2xlcyI6WyJhZG1pbiJdLCJodHRwczovL3ZpbW9uZC9jb21wYW55SWQiOiIyIiwiaXNzIjoiaHR0cHM6Ly92aW1vbmQtZGV2LW5leHQtdmNjLnZpbW9uZC1kZXYuYXV0aDAuY29tLyIsInN1YiI6IkJZQnVNOVAyZ1RZeXRyZkJnQTIzZWJZSTlxRnBablYxQGNsaWVudHMiLCJhdWQiOiJodHRwczovL3ZpbW9uZC1kZXYtbmV4dC12Y2Mudmltb25kLWRldi52Y2MuY29tLyIsImlhdCI6MTcxODAzNDcwOSwiZXhwIjoxNzE4MTIxMTA5LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJCWUJ1TTlQMmdUWXl0cmZCZ0EyM2ViWUk5cUZwWm5WMSJ9.P58_CLQMr8e1TtJHd1OYYi-u1_uSgXISFFUA4uGzPRf5XNw2Gtyvr_5gMiGKcjqO9e1n_omM6ALSPRs_8LuI6FlPVegTjbvZsU_jl3t5Ls7_h8Lnr5_TUZ2fnZtUBKpNCp2F5EkWKlsq2r95BD-dY18fwboc5g2tXeVyoPp_9ilPPc1thV95MkLvPrMWkZ58b0-poEsPhaxJZ2ipQhVhFzaHGG9BKNT0VRr-NldWdVRB4hdockf9MINXNI3d3ldnCMyIfbdh1d1njR25Klm1QPLpma7phwIesCfq1kVroJEDys0xnh3RDcmSSgxeL7S5Ba2GAcgUI3u-k3dppxBxNQ'
//       },
//       data: feed,
//     });
//     console.info(`Feed response: ${res}`); 
//   } catch (error) {
//     console.error(`Error creating feed: ${error}`);
//   }
// };

const createAsset = async (title, file_path) => {
  console.info(`Creating asset with title: ${title} and file path: ${file_path}`);
  const asset = {
    channelId: "0",
    categoryId: "376536",
    drmProtected: false,
    live: false,
    playbackStrategy: "EXTERNAL",
    title,
    autoPublish: true,
    externalPlaybacks: [
    	{
    		playoutUri: `https://vimond.video-output.eu-north-1-dev.vmnd.tv/${file_path}`,
    		format: "HLS"
    	}
    ]
  };

  try {
    const res = await axios('https://vimond.rest-api.eu-north-1-dev.vmnd.tv/api/web/asset', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;v=3',
        Accept: 'application/json;v=3',
        Authorization: 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjFvWDYwWDRtZXA0ZWZON0Mwb3dwOCJ9.eyJodHRwczovL3ZpbW9uZC9lbWFpbCI6InZpZGVvLXZvZC1pbnRlZ3JhdGlvbi10ZXN0QHZpbW9uZC5jb20iLCJodHRwczovL3ZpbW9uZC9yb2xlcyI6WyJhZG1pbiJdLCJodHRwczovL3ZpbW9uZC9jb21wYW55SWQiOiIyIiwiaXNzIjoiaHR0cHM6Ly92aW1vbmQtZGV2LW5leHQtdmNjLnZpbW9uZC1kZXYuYXV0aDAuY29tLyIsInN1YiI6IkJZQnVNOVAyZ1RZeXRyZkJnQTIzZWJZSTlxRnBablYxQGNsaWVudHMiLCJhdWQiOiJodHRwczovL3ZpbW9uZC1kZXYtbmV4dC12Y2Mudmltb25kLWRldi52Y2MuY29tLyIsImlhdCI6MTcxODk0NDM3OCwiZXhwIjoxNzE5MDMwNzc4LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJCWUJ1TTlQMmdUWXl0cmZCZ0EyM2ViWUk5cUZwWm5WMSJ9.j-scKrkv7VbVkunyoz8S7KkCJgy0aI4s3HHeBd5lwLiwdcI2IK2beQ2cfWLX0RAIGJrWHeTdh7i_pg6uPRrCxyy0NuGcvcbD9WrTOZCLwM6FpLJx1MHjyw37PKBnGSBVsY2qga-cHTxZQsnEMcRXJwVxFuw9Cxhrnbjh8C5oKT9Qxf6eGtbV0qXLLFtfXwlNO56b_G_9XLudIFLlMSAGaw7YH5NTbA2DsQqo1VIPhmfn8DGsUukXOXzkHUevXCi__N_Gi_NYTw2C4gFSgj3KmSwUL78Aovbj13sGbT5WDNzadhz2CPOq2Duh8rm5UZ3kW7Q4ellQtsmJew3-ynLXLQ'
      },
      data: asset,
    });
    console.info(`Asset response: ${res}`);
  } catch (error) {
    console.error(`Error creating asset: ${error}`);
  }
};

exports.handler = async (event) => {
  console.info(`EVENT: ${JSON.stringify(event)}`);

  const {
    status, id, s3_destination: { manifest_key },
  } = event?.detail?.harvest_job || {};
  if (status === 'SUCCEEDED') {
    await createAsset(id, manifest_key);
  }
};
