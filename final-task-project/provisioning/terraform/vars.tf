variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = "my-project-butkem"
}

variable "credentials_file" {
  description = "Path to the Google Cloud credentials file"
  type        = string
  default     = "key.json"
}

variable "regions" {
  description = "List of regions to deploy resources"
  type        = list(string)
  default     = ["asia-southeast2", "asia-southeast1", "asia-east1", "asia-northeast1"] # Jakarta, Singapore, Taiwan, Tokyo
}

variable "zones" {
  description = "List of zones corresponding to each region"
  type        = list(string)
  default     = ["asia-southeast2-a", "asia-southeast1-b", "asia-east1-a", "asia-northeast1-b"]
}

variable "ssh_user" {
  description = "The SSH username to use for instances"
  type        = string
  default     = "imron"
}

variable "ssh_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "k3s_master_zone" {
  description = "Zone for the K3s master node"
  default     = "asia-east1-a"  # Taiwan zone
}

variable "k3s_worker_zone" {
  description = "Zone for the K3s worker nodes"
  default     = "asia-east1-b"  # Taiwan zone
}
