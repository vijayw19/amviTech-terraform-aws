##############################################
# General Settings
##############################################

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "availability_zone" {
  description = "The AZ to start the instance in"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for SSH access"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = false
}


##############################################
# Networking
##############################################

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to associate"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "List of IPv6 addresses to associate"
  type        = list(string)
  default     = []
}

variable "private_ip" {
  description = "Private IP address to assign to the instance"
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "List of secondary private IPs to assign"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "security_groups" {
  description = "List of classic security groups (EC2-Classic only)"
  type        = list(string)
  default     = []
}


##############################################
# Storage & Compute
##############################################

variable "ebs_optimized" {
  description = "If true, the launched instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 termination protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance (stop or terminate)"
  type        = string
  default     = "stop"
}

variable "monitoring" {
  description = "If true, enables detailed monitoring"
  type        = bool
  default     = false
}

variable "source_dest_check" {
  description = "If false, disables Source/Dest checking"
  type        = bool
  default     = true
}

variable "tenancy" {
  description = "The tenancy of the instance (default, dedicated, host)"
  type        = string
  default     = "default"
}

variable "host_id" {
  description = "Dedicated host ID for the instance"
  type        = string
  default     = null
}

variable "placement_group" {
  description = "Placement group to start the instance in"
  type        = string
  default     = null
}

variable "hibernation" {
  description = "If true, enables hibernation"
  type        = bool
  default     = false
}

variable "cpu_core_count" {
  description = "Number of CPU cores for the instance"
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Number of threads per core"
  type        = number
  default     = null
}


##############################################
# Root Block Device
##############################################

variable "root_delete_on_termination" {
  description = "Delete root volume on termination"
  type        = bool
  default     = true
}

variable "root_encrypted" {
  description = "Encrypt the root volume"
  type        = bool
  default     = false
}

variable "root_iops" {
  description = "IOPS for the root volume (for io1/io2/gp3)"
  type        = number
  default     = null
}

variable "root_kms_key_id" {
  description = "KMS key ID to use for root volume encryption"
  type        = string
  default     = null
}

variable "root_throughput" {
  description = "Throughput (MiB/s) for the root volume (gp3)"
  type        = number
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root volume in GiB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root volume (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "root_volume_tags" {
  description = "Additional tags for the root volume"
  type        = map(string)
  default     = {}
}


##############################################
# Additional EBS Volumes
##############################################

variable "ebs_block_devices" {
  description = "List of additional EBS block devices"
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    iops                  = optional(number)
    throughput            = optional(number)
    encrypted             = optional(bool)
    kms_key_id            = optional(string)
    delete_on_termination = optional(bool, true)
    snapshot_id           = optional(string)
  }))
  default = []
}


##############################################
# Ephemeral Volumes
##############################################

variable "ephemeral_block_devices" {
  description = "List of ephemeral block devices (instance store)"
  type = list(object({
    device_name  = string
    virtual_name = string
  }))
  default = []
}


##############################################
# User Data & Metadata
##############################################

variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Force replacement on user_data change"
  type        = bool
  default     = false
}

variable "metadata_http_endpoint" {
  description = "Enable or disable the metadata service"
  type        = string
  default     = "enabled"
}

variable "metadata_http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit"
  type        = number
  default     = 1
}

variable "metadata_http_tokens" {
  description = "Whether or not to require IMDSv2 tokens (required or optional)"
  type        = string
  default     = "required"
}

variable "metadata_instance_tags" {
  description = "Whether instance tags are exposed in metadata (enabled/disabled)"
  type        = string
  default     = "disabled"
}


##############################################
# Nitro Enclaves
##############################################

variable "enclave_enabled" {
  description = "Enable Nitro Enclaves on the instance"
  type        = bool
  default     = false
}


##############################################
# CPU Credits
##############################################

variable "cpu_credits" {
  description = "Credit option for CPU usage (standard or unlimited)"
  type        = string
  default     = "standard"
}


##############################################
# Lifecycle
##############################################

variable "lifecycle_create_before_destroy" {
  description = "Create before destroy strategy"
  type        = bool
  default     = false
}

variable "lifecycle_prevent_destroy" {
  description = "Prevent accidental instance deletion"
  type        = bool
  default     = false
}

variable "lifecycle_ignore_changes" {
  description = "List of attributes to ignore changes for"
  type        = list(string)
  default     = []
}


##############################################
# Tags
##############################################

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "Tags to apply to all attached volumes"
  type        = map(string)
  default     = {}
}
