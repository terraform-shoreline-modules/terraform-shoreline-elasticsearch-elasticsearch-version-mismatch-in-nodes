

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