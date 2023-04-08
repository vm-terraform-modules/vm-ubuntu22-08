variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}
variable "vpc_info" {
  type = object({
    subnet_names   = list(string)
    public_subnets = list(string)
    zones          = list(string)
  })
  default = {
    public_subnets = ["web"]
    subnet_names   = ["web", "app", "db", "test"]
    zones          = ["a", "b"]
  }

}
variable "ami_id" {
  type    = string
  default = "ami-02eb7a4783e7e9317"
}
variable "instance_where_to_run" {
  type    = string
  default = "red"
}
variable "instance_names" {
  type    = list(string)
  default = ["red", "yellow"]
}