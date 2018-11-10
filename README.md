# BASH_REPO

## Create vm-machine
```bash
# Create centos 7 disk
gcloud compute disks create centos-7-kvm --image-project centos-cloud --image-family centos-7;

# Create image from previous disk and add kvm licence
gcloud compute images create nested-vm-image \
  --source-disk centos-7-kvm --source-disk-zone us-east1-b \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx";

# Delete previous disk
gcloud compute disks delete centos-7-kvm -q;

# Create instance with kvm licenced imaage
gcloud compute instances create centos-7kvm --zone us-east1-b \
    --machine-type=n1-standard-2 --can-ip-forward --maintenance-policy=TERMINATE \
    --service-account=428900971504-compute@developer.gserviceaccount.com \
    --metadata=startup-script=curl\ -O\ curl\ -O\ https://raw.githubusercontent.com/poxstone/BASH_REPO/master/desktostart/centos7-cloud/i.sh\; \
    --scopes=https://www.googleapis.com/auth/cloud-platform --tags=all,vnc,http-server,https-server \
    --image=nested-vm-image --boot-disk-size=50GB --boot-disk-type=pd-ssd;
```

## Create instance centos ans install manual
```bash

# As root
sudo su;
cd;

# Pull script
curl -O curl -O https://raw.githubusercontent.com/poxstone/BASH_REPO/master/desktostart/centos7-cloud/i.sh;

# First step update system
source i.sh;

# Second step, run tmux for create ps session
tmux;
# run again for install full and complete required info
source i.sh;

# Alternative when session is closed, load again
tmux attach;

```
> Note: Wait 2 hours for complete installation, configure main menú with app links
_

### Create definitive instance
```bash
# Create definitive image
gcloud compute images create nested-centos-7-kvm \
  --source-disk centos-7kvm --source-disk-zone us-east1-b;

# delete prevous instance
gcloud compute instances delete centos-7kvm --zone us-east1-b -q;

# Create definitive instance (preemptible)
gcloud compute instances create centos-7-kvm --zone us-east1-b \
    --machine-type=n1-standard-2 --can-ip-forward --maintenance-policy=TERMINATE --preemptible \
    --service-account=428900971504-compute@developer.gserviceaccount.com \
    --metadata=startup-script=curl\ -O\ curl\ -O\ https://raw.githubusercontent.com/poxstone/BASH_REPO/master/desktostart/centos7-cloud/i.sh\; \
    --scopes=https://www.googleapis.com/auth/cloud-platform --tags=all,vnc,http-server,https-server \
    --image=nested-centos-7-kvm --boot-disk-size=50GB --boot-disk-type=pd-ssd;
```

