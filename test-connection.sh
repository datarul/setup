#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'

# Gerekli dosyaları kontrol et
if [ ! -f ".env" ]; then
    echo -e "${RED}Hata: .env dosyası bulunamadı!${NC}"
    echo "Lütfen önce './set-env.sh' çalıştırın."
    exit 1
fi

# Ortam değişkenlerini yükle
source .env

echo -e "\n${BLUE}Datarul Bağlantı Testi${NC}"
echo -e "${GRAY}---------------------------${NC}"

# GitHub Container Registry bağlantı testi
echo -e "\n${YELLOW}1. GitHub Container Registry Bağlantısı${NC}"
if echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin; then
    echo -e "${GREEN}✓${NC} GitHub Container Registry bağlantısı başarılı"
else
    echo -e "${RED}✗${NC} GitHub Container Registry bağlantısı başarısız!"
    echo "  Lütfen GitHub token ve kullanıcı adınızı kontrol edin."
    exit 1
fi

# Test image'ı çekme denemesi
echo -e "\n${YELLOW}2. Test Image Çekme${NC}"
TEST_IMAGE="ghcr.io/datarul/app:latest"
echo -e "${GRAY}Frontend image çekiliyor...${NC}"
if docker pull $TEST_IMAGE; then
    echo -e "${GREEN}✓${NC} Image başarıyla çekildi"

    # Test image'ını temizle
    echo -e "\n${YELLOW}3. Test Image Temizleme${NC}"
    if docker rmi $TEST_IMAGE; then
        echo -e "${GREEN}✓${NC} Test image başarıyla silindi"
    else
        echo -e "${YELLOW}!${NC} Test image silinemedi"
    fi
else
    echo -e "${RED}✗${NC} Image çekilemedi!"
    echo "  Lütfen internet bağlantınızı ve erişim izinlerinizi kontrol edin."
    exit 1
fi

echo -e "\n${GREEN}Bağlantı Testi Başarılı!${NC}"
echo -e "${GRAY}Tüm testler başarıyla tamamlandı.${NC}"