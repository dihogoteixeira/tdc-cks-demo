---
![tdc-2021](https://img.shields.io/badge/tdc-2021-red?style=flat-square)
![terraform-latest](https://img.shields.io/badge/terraform-latest-blueviolet?style=flat-square)
![google-cloud](https://img.shields.io/badge/google-cloud-blue?style=flat-square)
![k8s-v1.22.2](https://img.shields.io/badge/k8s-v1.22.2-blue?style=flat-square)
---

Repositório criado para auxiliar no processo de demonstração do TDC 2021 sessão FullCycle.

***Para provisionar seu ambiente certifique-se de ter seguido todos os passos a seguir***

---
#### CRIANDO CHAVE PARA CONTA DE SERVICO NA GCP

1. [Create Service Account](https://console.cloud.google.com/apis/credentials/serviceaccountkey "Create Service Account")

#### OBTENDO ID DO PROJETO NO CONSOLE GCP

2. [Project ID](https://console.cloud.google.com/home/dashboard "Project ID")

---
#### EXPORTANDO VARIAVEIS DE AMBIENTE

1. Adicionar caminho absoluto do `arquivo.json` que contem sua `ServiceAccountKey` obtida na criação da key:
```sh
export GOOGLE_APPLICATION_CREDENTIALS=/seu/path/para/arquivo.json
```

2. Adicionar `ID do projeto` GCP:
```sh
export GOOGLE_PROJECT=seu-project-id
```

---
### ADICIONANDO VARIAVEIS DE AMBIENTE NO BASH PROFILE

```sh
sudo tee -a ~/.bashrc > /dev/null <<EOF
# EXPORTING PROVIDER GCP VARS TO TERRAFORM
export GOOGLE_APPLICATION_CREDENTIALS=/seu/path/para/arquivo.json
export GOOGLE_PROJECT=seu-project-id
EOF
```
---
#### RESOLVENDO PROBLEMA DE EXPORT NO WINDOWS

```go
provider "google" {
  project     = "project-id"
  credentials = file("/path/para/arquivo.json")
}
```
---

#### CLONE O REPO

```sh
git clone https://github.com/dihogoteixeira/tdc-cks-demo.git
cd tdc-cks-demo/setup
```

### DEFININDO SSH-KEY E USERNAME PARA SSH

Edite o arquivo [main.tf](setup/main.tf) e altere os `VALUES` da lista `ssh_keys`, substituindo pela sua chave publica, e seu username conforme exemplo abaixo:

```go
  ...

  ssh_keys = [
      {
          publickey = "ssh-rsa yourkeyabc username@PC"
          user      = "username"
      } 
  ]

  ...
```

Realize essa substituição para ambos os módulos `master` e `worker` instanciados no arquivo [main.tf](setup/main.tf).

### EXECUTANDO O SETUP DO CLUSTER

```sh
terraform init
terraform plan
terraform apply -auto-approve
```