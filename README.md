---
![tdc-2021](https://img.shields.io/badge/tdc-2021-yellowblue?style=flat-square)
![terraform-latest](https://img.shields.io/badge/terraform-latest-blueviolet?style=flat-square)
![google-cloud](https://img.shields.io/badge/google-cloud-blue?style=flat-square)
![k8s-v1_._22_._2](https://img.shields.io/badge/k8s-v1_._22_._2-blue?style=flat-square)
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

#### COMANDOS DE REFERENCIA

```sh
cd setup
terraform init
terraform plan
terraform apply -auto-approve
```