#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Env dosyasını kontrol et ve sil
ENV_FILE=~/datarul/.env

if [ -f "$ENV_FILE" ]; then
    # Önce değişkenleri unset et
    unset GITHUB_USERNAME
    unset GITHUB_TOKEN
    unset DATARUL_SUBNET
    unset DATARUL_API_URL
    unset DATARUL_MODULES
    unset DATARUL_ENV
    unset DATARUL_DOTNET_TAG
    unset DATARUL_FRONTEND_TAG
    unset DATARUL_SQLPARSER_TAG
    unset DATARUL_SQLPARSER_LOG_DIR

    # Dosyayı sil
    rm "$ENV_FILE"
    echo -e "${GREEN}Ortam değişkenleri başarıyla silindi.${NC}"

    # Kullanıcıya hatırlatma
    echo "Eğer ~/.bashrc veya ~/.zshrc dosyanıza 'source ~/datarul/.env' satırını eklediyseniz,"
    echo "lütfen bu satırı da kaldırın."
else
    echo -e "${YELLOW}Ortam değişkenleri dosyası bulunamadı.${NC}"
fi