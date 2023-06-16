# Terraform

ここではインフラのリソースファイルを管理しています。

## 開発環境

- AWS
- Terraform 1.5.0
- tflint
- terraform-docs

## Secrets の管理方法

KMS で Secrets ファイルを暗号化することで、安全に Secrets を管理できます。

Secrets を編集したい場合は、暗号化された Secrets ファイルを復号してから編集内容を適応し、再度暗号化する必要があります。

```shell
# 暗号化
$ aws kms encrypt --key-id <KMSのキーID> \
    --plaintext fileb://secrets.yaml \
    --output text \
    --query CiphertextBlob > secrets.yaml.encrypted
# 復号
$ aws kms decrypt \
    --ciphertext-blob fileb://<(cat secrets.yaml.encrypted | base64 -d) \
    --output text \
    --query Plaintext | base64 --decode > secrets.yaml
```

## Terraform ドキュメントの自動生成

### 初回のみ

- `modules/<service-name>/header.md` にタイトルなどヘッダー情報を記載する
- `modules/<service-name>/.terraform-docs.yml` という名前で以下のファイルを用意する

```yml
formatter: markdown table
header-from: header.md
output:
  file: README.md
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
    {{ .Content }}
    <!-- END_TF_DOCS -->
```

- `main.tf`, `variables.tf`, `outputs.tf` ファイルを用意してリソースを定義する

### ドキュメントの生成

```shell
terraform-docs modules/<service-name>
```
