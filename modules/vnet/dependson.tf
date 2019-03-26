variable "depends_on" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = [""]
}

resource "null_resource" "dependent-res" {  
  triggers {
    got_dep = "${join(",", var.depends_on)}"
  }  
}

output "anchor" {
  description = "Special output for module dependency system"
  value       = "anchor"
}
