resource "shoreline_notebook" "airflow_worker_node_overload" {
  name       = "airflow_worker_node_overload"
  data       = file("${path.module}/data/airflow_worker_node_overload.json")
  depends_on = [shoreline_action.invoke_cpu_mem_disk_thresholds,shoreline_action.invoke_update_resources]
}

resource "shoreline_file" "cpu_mem_disk_thresholds" {
  name             = "cpu_mem_disk_thresholds"
  input_file       = "${path.module}/data/cpu_mem_disk_thresholds.sh"
  md5              = filemd5("${path.module}/data/cpu_mem_disk_thresholds.sh")
  description      = "Configuration issues such as improper settings for worker node resources like CPU, memory, or disk space that do not align with the workload requirements."
  destination_path = "/agent/scripts/cpu_mem_disk_thresholds.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_resources" {
  name             = "update_resources"
  input_file       = "${path.module}/data/update_resources.sh"
  md5              = filemd5("${path.module}/data/update_resources.sh")
  description      = "Increase the capacity of the worker node by adding more resources such as CPU, memory, or storage."
  destination_path = "/agent/scripts/update_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_mem_disk_thresholds" {
  name        = "invoke_cpu_mem_disk_thresholds"
  description = "Configuration issues such as improper settings for worker node resources like CPU, memory, or disk space that do not align with the workload requirements."
  command     = "`chmod +x /agent/scripts/cpu_mem_disk_thresholds.sh && /agent/scripts/cpu_mem_disk_thresholds.sh`"
  params      = ["MEMORY_THRESHOLD","CPU_THRESHOLD","DISK_THRESHOLD"]
  file_deps   = ["cpu_mem_disk_thresholds"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_mem_disk_thresholds]
}

resource "shoreline_action" "invoke_update_resources" {
  name        = "invoke_update_resources"
  description = "Increase the capacity of the worker node by adding more resources such as CPU, memory, or storage."
  command     = "`chmod +x /agent/scripts/update_resources.sh && /agent/scripts/update_resources.sh`"
  params      = ["NEW_MEM_VALUE","NEW_CPU_VALUE"]
  file_deps   = ["update_resources"]
  enabled     = true
  depends_on  = [shoreline_file.update_resources]
}

