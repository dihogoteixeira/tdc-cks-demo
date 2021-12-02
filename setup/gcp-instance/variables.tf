variable "amount" {
  description = "Quantidade de máquinas que deseja criar"
  type        = number
  default     = 1
}

variable "name" {
  description = "Nome da instância"
  type        = string
}

variable "machine_type" {
  description = "Tamanho da instância"
  type        = string
  default     = "f1-micro"
}

variable "zone" {
  description = "Em qual zona sua instância irá ficar"
  type        = string
  default     = "us-central1-a"
}

variable "image" {
  description = "Qual Sistema deseja utilizar"
  type        = string
  default     = "debian-cloud/debian-9"
}

variable "network" {
  description = "Qual rede deseja utilizar"
  type        = string
  default     = "default"
}

variable "metadata_startup_script" {
  type        = string
  description = "Caminho do script shell do userdata"
  default      = null
}

variable "ssh_keys" {
  type = list(object({
    publickey = string
    user = string
  }))
  description = "list of public ssh keys that have access to the VM"
  default = [
      {
        user = "username"
        publickey = "ssh-rsa yourkeyabc username@PC"
      }
  ]
}