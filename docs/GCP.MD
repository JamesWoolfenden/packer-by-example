# GCP images

There is an example Debian image to run with GCP.

## GCP setup

If this is a new use of GCP you will have to run thru a bit of initial set-up.
When you run:

### Bash
```bash
./build.sh -packfile ./packfiles/debian/base-gcp.json -environment
```
### Windows
```powershelll
 .\build.ps1 -packfile .\packfiles\Debian\base-gcp.json -environment .\environment\template-gcp.json
```

### Troubleshooting

You will get errors like these at first:

```bash
* googleapi: Error 403: Access Not Configured.
Compute Engine API has not been used in project XXXXXXXXXXX before or it is disabled.
Enable it by visiting
 https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=XXXXXXXXXXX then retry.
If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry, accessNotConfigured
```
**First time enablement of Google APIs**

## Solution 1 Enable via https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=XXXXXXXXXXX

## Solution 2 Via cli
From: https://cloud.google.com/endpoints/docs/openapi/enable-api

```
gcloud projects list

gcloud config set project [YOUR_PROJECT_ID]
gcloud config set project yourprojectname

gcloud services list --available
gcloud services enable [SERVICE_NAME]
gcloud services enable Compute Engine API
```
