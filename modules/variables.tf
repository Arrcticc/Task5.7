variable "subnet" {
    description = "Subnet"
    type = string
}

variable "image" {
    description = "Family image"
    type = string
    default = "lamp"
}

variable "zone_ins" {
    description = "zone"
    type = string
}