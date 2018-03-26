#! /bin/bash
# Some automation to setting up OSE/K8 VM's

  echo ""
  if [ "$SKIPSOURCECLONE" == "N" ]
  then
    if [ "$FAST_CLONE" == "N" ]
    then
      cd $GOLANGPATH/go/src/k8s.io
      rm -rf kubernetes
      echo "...Cloning Kubernetes in $GOLANGPATH"
      echo ""
      git clone https://github.com/kubernetes/kubernetes.git
    else
     # TODO: suggestion from Jon to avoid long clone operations
      kubDir="$GOLANGPATH/go/src/k8s.io/kubernetes"
      if [ -d $kubeDir ]
      then
        cd $GOLANGPATH/go/src/k8s.io
        rm -rf kubernetes
      fi
      mkdir -p $kubDir
      curl -sSL https://github.com/kubernetes/kubernetes/archive/master.tar.gz | tar xvz --strip-components 1 -C $kubDir
    fi

    if [ "$FAST_CLONE" == "N" ]
    then
      echo "...Cloning OpenShift in $GOLANGPATH"
      cd $GOLANGPATH/go/src/github.com/openshift
      rm -rf origin
      git clone https://github.com/openshift/origin.git
    else
      oseDir="$GOLANGPATH/go/src/github.com/openshift"
      if [ -d $oseDir ]
      then
        cd $GOLANGPATH/go/src/github.com/openshift
        rm -rf origin
      fi
      mkdir -p $oseDir
      curl -sSL https://github.com/openshift/origin/archive/master.tar.gz | tar xvz --strip-components 1 -C $oseDir
    fi

    echo "...Cloning support repos in /root"
    cd /root
    rm -rf containerized-data-importer
    git clone https://github.com/kubevirt/containerized-data-importer.git

    if [ ! -d "/root/setupvm-dev" ]
    then
      git clone https://github.com/screeley44/setupvm-dev.git
    fi

    echo "...Cloning CDI repo in $GOLANGPATH/go/src/github.com/kubevirt"
    cd $GOLANGPATH/go/src/github.com/kubevirt
    git clone https://github.com/kubevirt/containerized-data-importer.git
    cd /root

    echo "...Cloning kubevirt in $GOLANGPATH"
    cd $GOLANGPATH
    git clone https://github.com/kubevirt/kubevirt-ansible.git 

    echo "...Cloning openshift-ansible in $GOLANGPATH"
    cd $GOLANGPATH
    git clone https://github.com/openshift/openshift-ansible.git  
  fi