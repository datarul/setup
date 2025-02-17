#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m'

# Parametre kontrolü
PRUNE_IMAGES=true
for arg in "$@"; do
    case $arg in
        --no-prune)
            PRUNE_IMAGES=false
            shift
            ;;
    esac
done

# Gerekli dosyaların varlığını kontrol et
if [ ! -f "docker-compose.yml" ] || [ ! -f ".env" ]; then
    echo -e "${RED}Hata: Gerekli dosyalar bulunamadı!${NC}"
    echo "Lütfen scripti Datarul kurulum dosyalarının bulunduğu dizinde çalıştırın."
    exit 1
fi

# Ortam değişkenlerini yükle
if [ -f ".env" ]; then
    source ".env"
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

# Nginx konfigürasyonunu hazırla
setup_nginx_config() {
    echo -e "\n${YELLOW}Nginx Konfigürasyonu Hazırlanıyor${NC}"
    if [ -f "nginx/conf.d/00-upstream.conf.template" ]; then
        # Host IP'sini al
        HOST_IP=$(hostname -I | awk '{print $1}')

        # Template'i işle ve konfigürasyon dosyasını oluştur
        sed "s/\${HOST_IP}/$HOST_IP/g" nginx/conf.d/00-upstream.conf.template > nginx/conf.d/00-upstream.conf

        echo -e "${GREEN}✓${NC} Nginx konfigürasyonu oluşturuldu (Host IP: $HOST_IP)"
    else
        echo -e "${RED}✗${NC} Nginx template dosyası bulunamadı!"
        exit 1
    fi
}

# Ana deployment akışı
echo -e "\n${BLUE}Datarul Deployment${NC}"
echo -e "${GRAY}---------------------------${NC}"

setup_nginx_config

# Mevcut container'ları durdur ve kaldır
./stop.sh --remove || error_exit "Container'lar durdurulamadı"

if [ "$PRUNE_IMAGES" = true ]; then
    echo -e "\n${YELLOW}3. Kullanılmayan Image'ları Temizle${NC}"
    docker image prune -fa
else
    echo -e "\n${GRAY}Image temizleme adımı atlandı (--no-prune)${NC}"
fi

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
