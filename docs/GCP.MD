# GCP images

There is an example Debian image to run with GCP.

## GCP setup

If this is a new use of GCP you will have to run through a bit of initial set-up.
When you run:

### Bash

```bash
./build.sh -packfile ./packfiles/debian/base-gcp.json -environment ./environment/template-gcp.json
```

### Windows

```powershelll
 .\build.ps1 -packfile .\packfiles\Debian\base-gcp.json -environment .\environment\template-gcp.json
```

### Troubleshooting

You will get errors like these at first:

```bash
* googleapi: Error 403: Access Not Configured.
Compute Engine API has not been used in project REPLACEME before or it is disabled.
Enable it by visiting
 https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=REPLACEME then retry.
If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry, accessNotConfigured
```

## First time enablement of Google APIs**

### Solution 1 Enable via http

Open you console [API page](https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=REPLACEME)

### Solution 2 Via CLI

From: <https://cloud.google.com/endpoints/docs/openapi/enable-api>

```cli
gcloud projects list

gcloud config set project [YOUR_PROJECT_ID]

gcloud services list --available
gcloud services enable [SERVICE_NAME]
```

Once your service API's are enabled, you can build your new image:

```powershell
 .\build.ps1 -packfile .\packfiles\Debian\base-gcp.json -environment .\environment\template-gcp.json
Checking .\environment\template-gcp.json Found: True
Checking .\packfiles\Debian\base-gcp.json Found: True
Template validated successfully.
googlecompute output will be in this color.

==> googlecompute: Checking image does not exist...
==> googlecompute: Creating temporary SSH key for instance...
==> googlecompute: Using image: debian-9-stretch-v20191115
==> googlecompute: Creating instance...
    googlecompute: Loading zone: us-central1-a
    googlecompute: Loading machine type: n1-standard-1
    googlecompute: Requesting instance creation...
    googlecompute: Waiting for creation operation to complete...
    googlecompute: Instance has been created!
==> googlecompute: Waiting for the instance to become running...
    googlecompute: IP: 34.68.207.109
==> googlecompute: Using ssh communicator to connect: 34.68.207.109
==> googlecompute: Waiting for SSH to become available...
==> googlecompute: Connected to SSH!
==> googlecompute: Deleting instance...
    googlecompute: Instance has been deleted!
==> googlecompute: Creating image...
==> googlecompute: Deleting disk...
    googlecompute: Disk has been deleted!
Build 'googlecompute' finished.

==> Builds finished. The artifacts of successful builds are:
--> googlecompute: A disk image was created: packer-1574001361
```
