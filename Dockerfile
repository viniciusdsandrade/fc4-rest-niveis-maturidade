# 1. Definir a imagem base
FROM node:22.8.0-slim

# 2. Definir variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3000

# 3. Criar diretório de trabalho e definir permissões
WORKDIR /home/node/app

# 4. Copiar arquivos de dependência e instalar
COPY package.json package-lock.json ./
RUN npm install --production && npm cache clean --force

# 5. Copiar o restante do código da aplicação
COPY .. .

# 6. Copiar e configurar o script de inicialização
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# 7. Definir o usuário não privilegiado
USER node

# 8. Expor a porta da aplicação
EXPOSE 3000

# 9. Definir o entrypoint e comando
ENTRYPOINT ["/usr/local/bin/start.sh"]

# 10. Adicionar um HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
