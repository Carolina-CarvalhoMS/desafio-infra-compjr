# Desafio de Infraestrutura - Comp Júnior

Projeto de implantação automatizada da aplicação node-express-boilerplate utilizando esteira de CI/CD completa, análise contínua de segurança/qualidade e deploy automático em nuvem.

- API Base URL (Produção): https://desafio-infra-compjr.onrender.com/v1
- Documentação Interativa (Swagger): https://desafio-infra-compjr.onrender.com/v1/docs/

---

## Arquitetura da Pipeline de CI/CD

A pipeline de Integracao e Entrega Continua foi desenvolvida utilizando GitHub Actions, estruturada em um fluxo sequencial e paralelo focado em Fail-Fast (detectar erros o mais cedo possivel antes de avancar para o deploy).

```text
[Push / PR em main]
       │
       ├──> 1. Lint & Testes (Jest + Cobertura)
       │
       ├──> 2. Analise de Segredos (Gitleaks) ──┐
       │                                       ├──> 4. Varredura de Imagem (Trivy) ──> 5. Build & Push Docker ──> 6. Deploy Render
       └──> 3. Qualidade de Codigo (SonarQube) ┘
```

### Etapas da Esteira:

1. Lint & Testes: Executa o ESLint para garantir os padroes do codigo e roda a suite de testes unitarios/integracao gerando relatorio de cobertura de testes.
2. Analise de Segredos (Gitleaks): Varre o historico de commits e o codigo-fonte em busca de credenciais, chaves de API ou tokens expostos.
3. Analise de Qualidade (SonarQube): Avalia a saude do codigo, apontando bugs, vulnerabilidades, code smells e validando a cobertura minima de testes.
4. Varredura de Seguranca da Imagem (Trivy): Analisa a imagem Docker antes do envio ao registro, identificando vulnerabilidades de pacotes (CVEs) do sistema operacional e runtime.
5. Build & Push da Imagem Docker: Compila a imagem containerizada com suporte a cache para otimizacao de tempo e publica no registro de containers.
6. Deploy Automatizado no Render: Aciona o deploy do servico em nuvem via webhook assim que todas as etapas anteriores sao concluidas com sucesso.

---

## Decisoes de Seguranca Adotadas

A seguranca foi implementada em diferentes camadas do ciclo de desenvolvimento (DevSecOps):

- Gestao de Segredos e Variaveis: Nenhuma variavel sensivel (MONGODB_URL, JWT_SECRET) foi versionada no repositorio Git. As credenciais sao injetadas estritamente via GitHub Secrets (para o CI/CD) e Render Environment Variables (para a aplicacao em producao).
- Varredura Estatica de Segredos: Implementacao do Gitleaks para prevenir o vazamento acidental de tokens e senhas no repositorio.
- Seguranca de Dependencias e Imagem Docker: Utilizacao do Trivy para auditoria de CVEs na imagem base Node.js e nos pacotes do ecossistema.
- Validacao Pre-Commit Local: Integracao com Husky, lint-staged e Prettier para garantir que apenas codigo formatado e sem erros sintaticos chegue ao repositorio local.

---

## Funcionamento do Quality Gate (SonarQube)

O Quality Gate funciona como uma trava de qualidade que impede que codigos fora dos padroes estabelecidos cheguem a producao:

- Metricas Avaliadas:
  - Coverage: Garante cobertura de testes unitarios e de integracao nas rotas principais.
  - Duplications: Bloqueia a adicao de blocos repetidos de codigo.
  - Maintainability & Security: Avalia debitos tecnicos (Code Smells) e brechas de seguranca (Security Hotspots).
- Impacto no CI/CD: Se qualquer criterio estipulado no perfil do SonarQube falhar, o job falha e bloqueia a execucao da compilacao Docker e do deploy.

---

## Fluxo de Branches e Deploy

- Estrategia Utilizada: Trunk-Based Development / GitHub Flow.
- Branch Principal (main): Representa o estado do codigo em producao. Cada push direcionado a main dispara automaticamente a esteira de validacao e entrega.
- Garantia de Integridade: Modificacoes passam por hooks de pre-commit e checagens automaticas na nuvem, garantindo estabilidade continua (Always Deployable).

---

## Como Executar o Projeto Localmente

### Pre-requisitos

- Node.js (v18+)
- Yarn ou NPM
- MongoDB rodando localmente ou URL do MongoDB Atlas

### Passos:

1. Clone o repositorio:

   ```bash
   git clone https://github.com/Carolina-CarvalhoMS/desafio-infra-compjr.git
   cd desafio-infra-compjr
   ```

2. Instale as dependencias:

   ```bash
   yarn install
   # ou npm install
   ```

3. Configure as variaveis de ambiente criando um arquivo .env baseado no .env.example:

   ```env
   PORT=3000
   MONGODB_URL=mongodb://127.0.0.1:27017/node-express-boilerplate
   JWT_SECRET=sua_chave_secreta_aqui
   ```

4. Inicie o servidor em modo de desenvolvimento:

   ```bash
   yarn dev
   # ou npm run dev
   ```

5. Acesse a documentacao local no navegador:
   http://localhost:3000/v1/docs/
