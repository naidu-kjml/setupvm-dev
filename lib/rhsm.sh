#! /bin/bash
# Some automation to setting up OSE/K8 VM's


if [ "$SKIPSUBSCRIBE" == "N" ]
then
  if [ "$HOSTENV" == "rhel" ]
  then
    # Installing subscription manager on CLOUD INSTANCE
    echo "...Checking to make sure subscription manager is installed..."
    $SUDO yum install subscription-manager -y> /dev/null
  fi

  if [ "$HOSTENV" == "rhel" ]
  then
    # Subscription Manager Stuffs - for RHEL 7.X devices
    echo "Setting up subscription services from RHEL..."
    $SUDO subscription-manager register --username=$RHNUSER --password=$RHNPASS


    if [ "$POOLID" == "" ]
    then
       $SUDO subscription-manager list --available | sed -n '/OpenShift Employee Subscription/,/Pool ID/p' | sed -n '/Pool ID/ s/.*\://p' | sed -e 's/^[ \t]*//' | xargs -i{} $SUDO subscription-manager attach --pool={}
       $SUDO subscription-manager list --available | sed -n '/OpenShift Container Platform/,/Pool ID/p' | sed -n '/Pool ID/ s/.*\://p' | sed -e 's/^[ \t]*//' | xargs -i{} $SUDO subscription-manager attach --pool={}
    else
       echo "Using Predefined POOLID..."
       $SUDO subscription-manager attach --pool=$POOLID
    fi
  fi
fi


if [ "$SKIPREPOS" == "N" ]
then
  if [ "$HOSTENV" == "rhel" ]
  then
    echo ""
    echo "...Attaching Repo Information..."    

    # FOR ALL
    if [ "$OCPVERSION" == "3.5" ]
    then
      echo "... ...Enabling rhel 7 rpms for OCP 3.5..."
      until $SUDO subscription-manager repos --disable="*"> /dev/null; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      until $SUDO yum-config-manager --disable \*> /dev/null; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      until $SUDO subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.5-rpms" --enable="rhel-7-fast-datapath-rpms" --enable="rh-gluster-3-for-rhel-7-server-rpms"; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      echo ""
    elif [ "$OCPVERSION" == "3.4" ]
    then
      echo "... ...Enabling rhel 7 rpms for OCP 3.4..."
      until $SUDO subscription-manager repos --disable="*"> /dev/null; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      until $SUDO yum-config-manager --disable \*> /dev/null; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      until $SUDO subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.4-rpms" --enable="rh-gluster-3-for-rhel-7-server-rpms"; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      echo ""
    elif [ "$OCPVERSION" == "3.6" ]
    then
      echo "... ...Enabling rhel 7 rpms for OCP 3.6..."
      until $SUDO subscription-manager repos --disable="*"> /dev/null; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      if [ "$ISCLOUD" == "gce" ]
      then
        echo "...skipping disable of yum-config-manager"
      else
        until $SUDO yum-config-manager --disable \*> /dev/null; do echo "Failure disabling yum-config-manager, retrying..."; sleep 8; done
      fi
      until $SUDO subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.6-rpms" --enable="rhel-7-fast-datapath-rpms" --enable="rh-gluster-3-for-rhel-7-server-rpms"; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      echo ""
    elif [ "$OCPVERSION" == "3.7" ]
    then
      echo "... ...Enabling rhel 7 rpms for OCP 3.7..."
      $SUDO subscription-manager repos --disable="*"> /dev/null
      if [ "$ISCLOUD" == "gce" ]
      then
        echo "... ...skipping disable of yum-config-manager"
      else
        $SUDO yum-config-manager --disable \*> /dev/null
      fi
      $SUDO subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.7-rpms" --enable="rhel-7-fast-datapath-rpms" --enable="rh-gluster-3-for-rhel-7-server-rpms"
      echo ""
    else
      echo "... ...Enabling rhel 7 rpms defaulting to OCP 3.7 as latest..."
      until $SUDO subscription-manager repos --disable="*"> /dev/null; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      if [ "$ISCLOUD" == "gce" ]
      then
        echo "...skipping disable of yum-config-manager"
      else
        until $SUDO yum-config-manager --disable \*> /dev/null; do echo "Failure disabling yum-config-manager, retrying..."; sleep 8; done
      fi
      until $SUDO subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.7-rpms" --enable="rhel-7-fast-datapath-rpms" --enable="rh-gluster-3-for-rhel-7-server-rpms"; do echo "Failure Enabling Repos, retrying..."; sleep 8; done
      echo ""
    fi
  fi
fi
