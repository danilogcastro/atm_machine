# INFORMAÇÕES GERAIS

Este projeto é uma programa simulando o comportamento de um caixa eletrônico, utilizando as seguintes ferramentas:

- Sinatra
- Puma
- RSpec

## CONFIGURAÇÃO

Para rodar o projeto, é preciso ter instalado Docker e Docker Compose, com os seguintes comandos:


```bash
docker compose build
docker compose up
```

O servidor subirá na porta local `3000`. 

Para rodar a suíte de teste, com o container `app` rodando, em uma nova janela do seu terminal, basta digitar o comando:

```bash
docker compose run app bundle exec rspec
```

Caso deseje, é possível abrir um console interativo com o seguinte comando:

```bash
docker compose run app ruby bin/console
```

## OPERAÇÃO 1 - ABASTECIMENTO 

Para fazer um abastecimento no caixa, disponibilizando-o para uso:

```bash
curl --request POST \
  --url http://localhost:3000/fill \
  --header 'content-type: application/json' \
  --data '{
    "caixa":
    {
      "caixaDisponivel": true,
      "notas":
        {
           "notasDez":10,
           "notasVinte":30,
           "notasCinquenta":20,
           "notasCem":15
        } 
    }
}'
```

Resposta:

```json
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 10,
      "notasVinte": 30,
      "notasCinquenta": 20,
      "notasCem": 15
    }
  },
  "erros": []
}
```

Caso se tente fazer um novo abastecimento enquanto ele estiver em uso:

```bash
curl --request POST \
  --url http://localhost:3000/fill \
  --header 'content-type: application/json' \
  --data '{
    "caixa":
    {
      "caixaDisponivel": true,
      "notas":
        {
           "notasDez":10,
           "notasVinte":30,
           "notasCinquenta":20,
           "notasCem":15
        } 
    }
}'
```

Resposta:

```json
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 10,
      "notasVinte": 30,
      "notasCinquenta": 20,
      "notasCem": 15
    }
  },
  "erros": [
    "caixa-em-uso"
  ]
}
```

## OPERAÇÃO 2 - SAQUE

### CENÁRIO 1

Supondo o caixa abastecido anteriormente:

```bash
curl --request POST \
  --url http://localhost:3000/withdraw \
  --header 'content-type: application/json' \
  --data '{
   "saque":{
      "valor": 80,
      "horario":"2019-02-13T11:01:01.000Z"
   }
}'
```

Resposta de sucesso:

```json
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 9,
      "notasVinte": 29,
      "notasCinquenta": 19,
      "notasCem": 15
    }
  },
  "erros": []
}
```

### CENÁRIO 2

Caso se tente fazer um novo saque de mesmo valor em menos de 10 minutos:

```bash
curl --request POST \
  --url http://localhost:3000/withdraw \
  --header 'content-type: application/json' \
  --data '{
   "saque":{
      "valor": 80,
      "horario":"2019-02-13T11:01:01.000Z"
   }
}'
```

O saque não é permitido, retornando um erro:

```json
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 9,
      "notasVinte": 29,
      "notasCinquenta": 19,
      "notasCem": 15
    }
  },
  "erros": [
    "saque-duplicado"
  ]
}
```

### CENÁRIO 3

Supondo a tentativa de sacar um valor maior do que o saldo do caixa:

```bash
curl --request POST \
  --url http://localhost:3000/withdraw \
  --header 'content-type: application/json' \
  --data '{
   "saque":{
      "valor": 80000,
      "horario":"2019-02-13T11:01:01.000Z"
   }
}'
```

Resposta:

```json
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 9,
      "notasVinte": 29,
      "notasCinquenta": 19,
      "notasCem": 15
    }
  },
  "erros": [
    "valor-indisponível"
  ]
}
```


### CENÁRIO 4

Supondo um caixa ainda não disponível para saque:

```bash
curl --request POST \
  --url http://localhost:3000/withdraw \
  --header 'content-type: application/json' \
  --data '{
   "saque":{
      "valor": 800,
      "horario":"2019-02-13T11:01:01.000Z"
   }
}'
```

Resposta:

```json
{
  "caixa": {
    "caixaDisponivel": false,
    "notas": {
      "notasDez": 10,
      "notasVinte": 30,
      "notasCinquenta": 20,
      "notasCem": 15
    }
  },
  "erros": [
    "caixa-indisponível"
  ]
}
```

