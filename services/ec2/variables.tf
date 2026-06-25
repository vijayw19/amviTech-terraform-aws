variable "ec2_instances" {
  description = <<EOT
Map of EC2 instance definitions. 
Each key = instance name, value = object of instance parameters.
EOT

  type = map(object({
    ami_id        = string
    instance_type = string
    subnet_id     = string
    key_name      = string

    associate_public_ip_address = optional(bool, false)
    vpc_security_group_ids      = optional(list(string), [])
    private_ip                  = optional(string, null)

    root_volume_size            = optional(number, 8)
    root_volume_type            = optional(string, "gp3")
    root_delete_on_termination  = optional(bool, true)
    root_encrypted              = optional(bool, false)

    ebs_block_devices = optional(list(object({
      device_name           = string
      volume_size           = number
      volume_type           = string
      delete_on_termination = optional(bool, true)
    })), [])

    user_data                   = optional(string, null)
    user_data_replace_on_change = optional(bool, false)

    tags          = optional(map(string), {})
    instance_name = string
  }))
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}
variable "common_tags" {
  description = "Tags applied to all instances"
  type        = map(string)
  default     = {}
}
