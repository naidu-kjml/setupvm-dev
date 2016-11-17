# setupvm-ose-dev
Simple, quick and dirty shell script to provision/configure local or cloud based instance of VM to run single node development cluster from source code for OpenShift/Kubernetes.  This
script will setup/automate and configure a complete dev environment based on the normal prereqs (i.e. subscription manager, yum installs, go install, etc...) and allow developers to change/update source and switch between K8 and Origin.

Use this for RHEL 7.x instances using normal dev type setup (i.e. hack/local-up-cluster.sh for K8 and openshift start for origin). 

# How To Run

1.  create RHEL 7.X AWS instance in us-east1-d (t2.Large) or GCE in us-east-1d or a local VM Instance (don't forget to add 2nd storage volume for docker registry) - you will run out of memory on builds without t2.large (or equivalent in GCE), at least my experience
2.  create unattached volume for use with our pod (if cloud based setup) - note the volumeID or identifier
3.  scp the attached scripts (SetUpVM.sh and setupvm.config) to your VM (I base everything out of /home/$USER, i.e. /home/ec2-user if running on aws, typically /root if running local VM or GCE)
4.  edit or modify the setupvm.config as these are the params used to run the SetUpVM.sh script and allows you to customize your source paths, gopath, etc...
5.  run the script

           ./SetUpVM.sh 

6.  Script takes about (8 to 10 minutes total depending on network latency) but about 7 minutes in, it will ask to setup docker registry - so look for that as it expects some input on what block device to use
7.  after completion
      - sudo -s or exit and log back in or execute the bash profiles  (to work as root and also pick up .bashrc/.bash_profile exports)
      - Change to your source GOPATH directory specified in the setupvm.config (default is /opt/go) (i.e. <$GOPATH>/src/k8s.io/kubernetes)
      - ./hack/local-up-cluster.sh   (note:  this will build and run the K8 process in this terminal, to stop ctrl+C)
      - Once this is running open another terminal and navigate to KUBEWORKDIR from the setupvm.config (default is /etc/kubernetes) and run ./config-k8.sh
      - you are ready to interact with kubectl
      - To use custom source code, replace /opt/go/src/k8s.io/kubernetes with your forked repo and git checkout <your-branch>

      or

      - sudo -s
      - cd to your source GOPATH directory specified in setupvm.config file (default is /opt/go) (i.e. <$GOPATH>/src/github.com/openshift/origin)
      - make clean build
      - after completion, you will need to run the start-ose.sh script found in the parameter ORIGINWORKDIR from the setupvm.config (default is /etc/openshift)
      - ./start-ose.sh   (this will run openshift as a process - logging is in home dir or openshift working dir at openshift.log)


# Some Things To Note:

1.  By default, if you did not change the work directory or gopath parameters in the setupvm.config
      - GOPATH = /opt/go   (/opt/go/src/github.com/openshift/origin and /opt/go/src/k8s.io/kubernetes)
      - Kube Work Dir = /etc/kubernetes  (config scripts and dev-configs dir with some sample yamls)
      - Origin Work Dir = /etc/openshift (config scripts and dev-configs dir with some sample yamls)
    All tasks, scripts and configurations (openshift in particular) will be located there.

2.  If you will be switching frequently between K8 and Origin, uncomment the last line in the stop-ose.sh script, that removes the /etc/.kube dir (prevents crossing wires between Origin and Kube)
