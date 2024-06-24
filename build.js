const { build } = require('esbuild');
const path = require('path');

const entryPoints = {
  lambda_create_harvest_job: './lambdas/create_harvest_job/index.js',
  lambda_harvest_event_handler: './lambdas/mp_harvest_event_handler/index.js',
};

const outputDir = 'dist';

const buildPromises = Object.entries(entryPoints).map(([entryName, entryPath]) => build({
  entryPoints: { [entryName]: entryPath },
  bundle: true,
  outfile: path.resolve(__dirname, outputDir, `${entryName}/index.js`),
  format: 'cjs',
  sourcemap: true,
  minify: true,
  platform: 'node',
  target: 'node20',
}),
);

Promise.all(buildPromises)
  .then(() => console.log('Build successful'))
  .catch(() => {
    console.error('Build failed');
    process.exit(1);
  }
);
