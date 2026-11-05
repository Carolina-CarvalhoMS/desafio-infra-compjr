# Desafio de Infraestrutura - Comp Júnior

[![CI/CD Pipeline](https://github.com/Carolina-CarvalhoMS/desafio-infra-compjr/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Carolina-CarvalhoMS/desafio-infra-compjr/actions/workflows/ci-cd.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Carolina-CarvalhoMS_desafio-infra-compjr&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Carolina-CarvalhoMS_desafio-infra-compjr)

Boilerplate pronto para produção para construção de APIs RESTful usando **Node.js**, **Express** e **MongoDB**. O projeto foi atualizado e modernizado com suporte nativo ao **MongoDB 6.0**, **Node.js 18**, containerização otimizada com **Docker** e uma esteira automatizada de **CI/CD no GitHub Actions** com deploy contínuo no **Render**.

---

## Índice

- [Funcionalidades](#funcionalidades)
- [Pré-requisitos](#pré-requisitos)
- [Variáveis de Ambiente](#variáveis-de-ambiente)
- [Instalação e Execução Local](#instalação-e-execução-local)
- [Execução Local com Docker Compose](#execução-local-com-docker-compose)
- [Estrutura de Testes e Cobertura](#estrutura-de-testes-e-cobertura)
- [Esteira de CI/CD](#esteira-de-cicd)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Licença](#licença)

---

## Funcionalidades

- **Autenticação e Autorização:** JWT tokens, refresh tokens e controle de permissões por papéis (roles).
- **Banco de Dados:** MongoDB 6.0 com Mongoose ODM.
- **Validação de Dados:** Schemas flexíveis e reutilizáveis utilizando `Joi`.
- **Segurança:** 
  - Sanitização de dados contra *NoSQL Injection*.
  - Proteção de cabeçalhos HTTP com `Helmet`.
  - Controle de taxa de requisições com `express-rate-limit`.
  - Suporte a `CORS` e sanitização contra `XSS`.
- **Documentação da API:** Swagger/OpenAPI integrado e acessível via `/v1/docs`.
- **Logs:** Sistema de logs estruturado com `Winston` e `Morgan`.
- **Qualidade de Código:** Padronização com `ESLint` e `Prettier`.

---

## Pré-requisitos

Certifique-se de ter instalado em seu ambiente:

- **Node.js:** `>= 18.x`
- **npm:** `>= 9.x`
- **MongoDB:** `>= 6.0` (ou via Docker)
- **Docker & Docker Compose:** Versões recentes com suporte ao `Buildx`.

---

## Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto com base no arquivo `.env.example`:

```bash
cp .env.example .env
```

Configurações mínimas necessárias:

```env
# Porta da Aplicação
PORT=3000

# Conexão MongoDB
MONGODB_URL=mongodb://127.0.0.1:27017/node-express-boilerplate

# Configurações JWT
JWT_SECRET=sua_chave_secreta_super_segura
JWT_ACCESS_EXPIRATION_MINUTES=30
JWT_REFRESH_EXPIRATION_DAYS=30
JWT_RESET_PASSWORD_EXPIRATION_MINUTES=10
JWT_VERIFY_EMAIL_EXPIRATION_MINUTES=10

# Configurações de E-mail (SMTP para testes/desenvolvimento)
SMTP_HOST=email-server
SMTP_PORT=587
SMTP_USERNAME=seu_usuario_smtp
SMTP_PASSWORD=sua_senha_smtp
EMAIL_FROM=suporte@suaapp.com
```

---

## Instalação e Execução Local

1. **Instalar dependências:**
   ```bash
   npm ci
   ```

2. **Executar em modo de desenvolvimento (com auto-reload):**
   ```bash
   npm run dev
   ```

3. **Executar em modo de produção (nativo via Node.js):**
   ```bash
   npm start
   ```

4. **Verificar formatação e padronização do código:**
   ```bash
   npm run lint
   ```

---

## Execução Local com Docker Compose

Para subir a aplicação e o banco de dados MongoDB 6.0 em ambiente local containerizado:

```bash
# Modo de Desenvolvimento (Hot-reload)
npm run docker:dev

# Modo de Produção Local
npm run docker:prod

# Execução da Suíte de Testes no Container
npm run docker:test
```

### Serviços Subidos:
- **Node App:** `http://localhost:3000`
- **MongoDB 6.0:** `mongodb://localhost:27017/node-express-boilerplate`

---

## Estrutura de Testes e Cobertura

Os testes utilizam **Jest** e **Supertest**. A suíte de testes suporta execução conectada a um serviço MongoDB ativo ou em memória localmente.

- **Executar todos os testes:**
  ```bash
  npm test
  ```

- **Executar testes com relatório de cobertura:**
  ```bash
  npm run coverage
  ```

---

## Esteira de CI/CD

A pipeline de Integração e Entrega Contínua foi implementada com **GitHub Actions** (`.github/workflows/ci-cd.yml`) e é acionada a cada `push` ou `pull_request` na branch `main`.

A esteira é composta por **6 jobs sequenciais**:

1. **Lint & Testes com Cobertura:**
   - Executa a validação de código com ESLint.
   - Sobe um container de **MongoDB 6.0** como serviço do workflow.
   - Executa a suíte de testes completa com medição de cobertura de código.
   - Gera e armazena o artefato de cobertura.

2. **Análise de Segredos (Gitleaks):**
   - Realiza uma varredura estática em todo o histórico do Git procurando por chaves, senhas ou tokens expostos.

3. **Análise de Qualidade (SonarCloud):**
   - Integra o relatório de cobertura gerado na etapa 1 e analisa métricas de qualidade, *code smells* e duplicidades no SonarCloud.

4. **Varredura de Segurança da Imagem (Trivy):**
   - Compila a imagem Docker localmente e executa uma varredura por vulnerabilidades conhecidas (CVEs) de severidade `HIGH` e `CRITICAL` (configurado com `exit-code: 1` para interromper o pipeline caso vulnerabilidades graves sejam detectadas).

5. **Build & Push da Imagem Docker:**
   - Efetua a compilação final da imagem otimizada para produção.
   - Publica a imagem no repositório do **Docker Hub**.

6. **Deploy Automatizado no Render:**
   - Dispara um *Deploy Webhook* para atualizar o serviço em produção no **Render** com a imagem mais recente.

---

## Estrutura do Projeto

```text
src/
 ├── config/         # Variáveis de ambiente e configurações globais
 ├── controllers/    # Controladores das rotas (lógica de requisição/resposta)
 ├── docs/           # Definições do Swagger/OpenAPI
 ├── middlewares/    # Middlewares customizados (auth, error, rateLimiter, validate)
 ├── models/         # Schemas e modelos Mongoose
 ├── routes/         # Definições de rotas da API (v1)
 ├── services/       # Lógica de negócios
 ├── utils/          # Utilitários e classes de erro
 ├── validations/    # Schemas de validação com Joi
 ├── app.js          # Configuração da aplicação Express
 └── index.js        # Ponto de entrada da aplicação
tests/              # Suíte de testes unitários e de integração
.github/
 └── workflows/
     └── ci-cd.yml  # Pipeline de CI/CD no GitHub Actions
Dockerfile          # Instruções para construção da imagem Docker de produção
docker-compose.yml  # Orquestração do banco e da aplicação
```

---

## Licença

Este projeto é distribuído sob a licença [MIT](LICENSE).