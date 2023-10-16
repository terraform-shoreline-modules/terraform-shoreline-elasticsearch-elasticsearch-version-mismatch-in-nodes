resource "shoreline_notebook" "elasticsearch_version_mismatch_in_nodes" {
  name       = "elasticsearch_version_mismatch_in_nodes"
  data       = file("${path.module}/data/elasticsearch_version_mismatch_in_nodes.json")
  depends_on = [shoreline_action.invoke_update_elasticsearch_version]
}

resource "shoreline_file" "update_elasticsearch_version" {
  name             = "update_elasticsearch_version"
  input_file       = "${path.module}/data/update_elasticsearch_version.sh"
  md5              = filemd5("${path.module}/data/update_elasticsearch_version.sh")
  description      = "Determine which version of Elasticsearch is the correct version for the cluster and ensure all nodes are running that version."
  destination_path = "/tmp/update_elasticsearch_version.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_elasticsearch_version" {
  name        = "invoke_update_elasticsearch_version"
  description = "Determine which version of Elasticsearch is the correct version for the cluster and ensure all nodes are running that version."
  command     = "`chmod +x /tmp/update_elasticsearch_version.sh && /tmp/update_elasticsearch_version.sh`"
  params      = ["NODE2","VERSION","NODE1","NODE3"]
  file_deps   = ["update_elasticsearch_version"]
  enabled     = true
  depends_on  = [shoreline_file.update_elasticsearch_version]
}

