#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'

# Parametre kontrolü
REMOVE_CONTAINERS=false
for arg in "$@"; do
    case $arg in
        --remove)
            REMOVE_CONTAINERS=true
            shift
            ;;
    esac
done

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
    "api-sqlparser"
)

echo -e "\n${BLUE}Datarul Container Yönetimi${NC}"
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

if [ "$REMOVE_CONTAINERS" = true ]; then
    echo -e "\n${YELLOW}2. Container'ları Kaldır${NC}"
    for container in "${containers[@]}"; do
        echo -n "Kaldırılıyor: $container ... "
        if docker rm $container >/dev/null 2>&1; then
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GRAY}Mevcut Değil${NC}"
        fi
    done
fi

echo -e "\n${GREEN}İşlem Tamamlandı!${NC}"
echo -e "${GRAY}Container durumlarını kontrol etmek için: ${BLUE}docker ps -a${NC}"