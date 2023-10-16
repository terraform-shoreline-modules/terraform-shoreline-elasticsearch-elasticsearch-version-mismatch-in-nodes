
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch Version Mismatch in Nodes
---

This incident type occurs when there is a version mismatch between the nodes in an Elasticsearch cluster. Elasticsearch is a distributed search and analytics engine that allows for real-time search and analysis of data. When nodes within the cluster have different versions of Elasticsearch installed, it can cause issues with data indexing, querying, and retrieval. This can lead to decreased performance, data inconsistencies, and even system downtime.

### Parameters
```shell
export LIST_OF_NODES="PLACEHOLDER"

export ANY_NODE="PLACEHOLDER"

export VERSION="PLACEHOLDER"

export NODE3="PLACEHOLDER"

export NODE1="PLACEHOLDER"

export NODE2="PLACEHOLDER"
```

## Debug

### 1. Check Elasticsearch version on each node
```shell
for node in ${LIST_OF_NODES}; do curl -s -XGET http://$node:9200 | jq '.version.number'; done
```

### 2. Check Elasticsearch cluster health status
```shell
curl -s -XGET http://${ANY_NODE}:9200/_cluster/health | jq '.status'
```

### 3. Check Elasticsearch cluster state
```shell
curl -s -XGET http://${ANY_NODE}:9200/_cluster/state | jq '.metadata.cluster_uuid'
```

### 4. Check Elasticsearch logs for version mismatch errors
```shell
grep -r "version mismatch" /var/log/elasticsearch/
```

## Repair

### Determine which version of Elasticsearch is the correct version for the cluster and ensure all nodes are running that version.
```shell


#!/bin/bash



# Define the correct version of Elasticsearch

ELASTICSEARCH_VERSION=${VERSION}



# Loop through all Elasticsearch nodes and check their version

for node in ${NODE1} ${NODE2} ${NODE3}

do

    # Get the version of Elasticsearch installed on the node

    node_version=$(ssh $node "rpm -qa | grep elasticsearch")



    # If the version on the node does not match the correct version, update it

    if [[ $node_version != *"$ELASTICSEARCH_VERSION"* ]]

    then

        ssh $node "yum install -y elasticsearch-$ELASTICSEARCH_VERSION"

        echo "Updated Elasticsearch on node $node to version $ELASTICSEARCH_VERSION"

    else

        echo "Elasticsearch on node $node is already at the correct version"

    fi

done



# Verify that all nodes are running the correct version of Elasticsearch

for node in ${NODE1} ${NODE2} ${NODE3}

do

    node_version=$(ssh $node "rpm -qa | grep elasticsearch")



    if [[ $node_version != *"$ELASTICSEARCH_VERSION"* ]]

    then

        echo "ERROR: Elasticsearch on node $node is not at the correct version"

        exit 1

    fi

done



echo "All nodes are running the correct version of Elasticsearch"


```