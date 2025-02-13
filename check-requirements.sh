#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Sistem Gereksinimleri Kontrolü"
echo "-----------------------------"

FAIL_COUNT=0

# Internet bağlantısı kontrolü
echo -n "Internet Bağlantısı: "
if curl -s --head https://github.com > /dev/null; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}HATA${NC}"
    echo "  Internet bağlantısı bulunamadı!"
    ((FAIL_COUNT++))
fi

# Docker kontrolü
echo -n "Docker: "
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}OK${NC} - $DOCKER_VERSION"
else
    echo -e "${RED}HATA${NC}"
    echo "  Docker kurulu değil!"
    ((FAIL_COUNT++))
fi

# Docker Compose kontrolü
echo -n "Docker Compose: "
if command -v docker compose &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version)
    echo -e "${GREEN}OK${NC} - $COMPOSE_VERSION"
else
    echo -e "${RED}HATA${NC}"
    echo "  Docker Compose kurulu değil!"
    ((FAIL_COUNT++))
fi

# Kurulum dizini kontrolü
echo -n "Kurulum Dizini: "
if [ "$(pwd)" == "$HOME/datarul" ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}HATA${NC}"
    echo "  Script ~/datarul dizininde çalıştırılmalıdır!"
    echo "  Lütfen repoyu şu şekilde klonlayın:"
    echo "  git clone https://github.com/datarul/setup.git ~/datarul"
    ((FAIL_COUNT++))
fi

# Ortam değişkenleri kontrolü
echo -n "GitHub Kimlik Bilgileri: "
if [ -n "$GITHUB_USERNAME" ] && [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${YELLOW}UYARI${NC}"
    echo "  GITHUB_USERNAME ve/veya GITHUB_TOKEN tanımlanmamış!"
    ((FAIL_COUNT++))
fi

echo -e "\n${GREEN}Kontroller tamamlandı!${NC}"
echo "-----------------------------"
if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "${RED}$FAIL_COUNT hata bulundu.${NC}"
    echo "  Lütfen hataları düzeltip tekrar deneyiniz."
    exit 1
else
    echo -e "${GREEN}Tüm kontroller başarılı!${NC}"
fi
