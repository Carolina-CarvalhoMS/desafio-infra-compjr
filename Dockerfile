# ==========================================
# Estágio 1: Instalação de Dependências
# ==========================================
FROM node:18-alpine AS dependencies

WORKDIR /app

# Copia os manifestos de dependências
COPY package*.json ./

# Instala apenas dependências de produção para manter a imagem leve
RUN npm ci --only=production --ignore-scripts

# ==========================================
# Estágio 2: Imagem Final de Produção
# ==========================================
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copia as dependências do estágio anterior
COPY --from=dependencies /app/node_modules ./node_modules
COPY package*.json ./
COPY src ./src

# Boa prática de segurança: executa como utilizador sem privilégios de root
USER node

EXPOSE 3000

CMD ["node", "src/index.js"]