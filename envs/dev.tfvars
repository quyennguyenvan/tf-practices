vpc_name = "dev_env"
cidrvpc  = "10.0.0.0/16"
vm-config = {
  vm1 = {
    instance_type = "t2.small",
    tags = {
      "ext-name" = "vm2"
      "funct"    = "purpose test"
    }
  },
  vm2 = {
    instance_type = "t2.medium",
    tags          = {}
  }
}
bastion_definition = {
  "bastion" = {
    associate_public_ip_address = false
    bastion_ami                 = "ami-09927fda4a30717cd"
    bastion_instance_class      = "t3.medium"
    bastion_monitoring          = true
    bastion_name                = "bastion"
    bastion_public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWBo4K5WRbXPsldPwfV+OklXw+Sa8Rt+fJWPW4xGy/QL2M9j+PDaH4N+Lh29GanaNugMpmzGgDH0cb3DtgSbBlld9YKpO57Ew4alAjoIm/3qJRIIdTu8xMrvm8dvSEs760/MUoqxrt04ExPmvghy3hoyTBpYOwUWnc8R2KP5gmrzldbt1lyKytHujHhFel4aeefxctRFZTfbt7+2X5QE4dMB7po55soxTkcGRyghd8/RbJJYi1jvuA5zU1ecpetgu6DtPkcKWKJMz+e6y2N4xHyg8r8UU28O4eJ+LXQQA48HbX8zXzwteSOBS7b1C42yXFwnQXct+QR2X7D88GkAJt rsa-key-20220711"
    trusted_ips                 = ["42.119.163.140/32"]
    user_data_base64            = null
    ext-tags = {
      "fucnt" = "demo-tf"
    }
  }
}
