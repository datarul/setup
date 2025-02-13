#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'

# Change directory if not in the correct path
if [ ! "$(pwd)" == "~/datarul" ]; then
  cd ~/datarul
fi

# Ortam değişkenlerini yükle
if [ -f .env ]; then
    source .env
    echo -e "${GRAY}Ortam değişkenleri .env dosyasından yüklendi${NC}"
else
    echo -e "${RED}Hata: .env dosyası bulunamadı!${NC}"
    echo "Lütfen önce './set-env.sh' çalıştırın."
    exit 1
fi

error_exit()
{
    local exit_code=$?
    echo -e "\n${YELLOW}Uyarı: $1${NC}"
    echo -e "${GRAY}Bu bir hata olmayabilir, lütfen container durumlarını kontrol edin:${NC}"
    echo -e "${BLUE}docker ps -a${NC}"
    echo -e "${YELLOW}Çıkış kodu: $exit_code${NC}"
    exit $exit_code
}

# Container listesi
containers=(
    "api-gateway"
    "api-auth"
    "api-shared"
    "api-bg"
    "api-dd"
    "api-rc"
    "api-dl"
    "api-dq"
    "api-de"
    "worker-dd"
    "worker-dq"
    "app-frontend"
)

echo -e "\n${BLUE}Datarul Deployment${NC}"
echo -e "${GRAY}---------------------------${NC}"

echo -e "\n${YELLOW}1. Container'ları Durdur${NC}"
for container in "${containers[@]}"; do
    echo -n "Durduruluyor: $container ... "
    if docker stop $container >/dev/null 2>&1; then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${GRAY}Zaten Durmuş${NC}"
    fi
done

echo -e "\n${YELLOW}2. Container'ları Kaldır${NC}"
for container in "${containers[@]}"; do
    echo -n "Kaldırılıyor: $container ... "
    if docker rm $container >/dev/null 2>&1; then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${GRAY}Mevcut Değil${NC}"
    fi
done

echo -e "\n${YELLOW}3. Kullanılmayan Image'ları Temizle${NC}"
docker image prune -fa

echo -e "\n${YELLOW}4. GitHub Container Registry'e Giriş${NC}"
if echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin; then
    echo -e "${GREEN}Giriş başarılı${NC}"
else
    error_exit "GitHub Container Registry'e giriş yapılamadı"
fi

echo -e "\n${YELLOW}5. Container'ları Başlat${NC}"
echo -e "${GRAY}Bu işlem biraz zaman alabilir...${NC}"
docker compose -p datarul up -d || error_exit "Docker Compose çalıştırılırken bir hata oluştu."

echo -e "\n${GREEN}Deployment Tamamlandı!${NC}"
echo -e "${GRAY}Container durumlarını kontrol etmek için: ${BLUE}docker ps${NC}"
