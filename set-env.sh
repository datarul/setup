#!/bin/bash

# Renk tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
NC='\033[0m'

# Ortam değişkenlerini listele
list_env_vars() {
    echo -e "\n${YELLOW}Ortam Değişkenleri:${NC}"

    echo -n "GITHUB_USERNAME: "
    if [ -n "$GITHUB_USERNAME" ]; then
        echo -e "${GREEN}✓${NC} $GITHUB_USERNAME"
    else
        echo -e "${GRAY}tanımlı değil${NC}"
    fi

    echo -n "GITHUB_TOKEN: "
    if [ -n "$GITHUB_TOKEN" ]; then
        echo -e "${GREEN}✓${NC} ***${GITHUB_TOKEN: -4}"
    else
        echo -e "${GRAY}tanımlı değil${NC}"
    fi

    echo -n "DATARUL_SUBNET: "
    if [ -n "$DATARUL_SUBNET" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_SUBNET"
    else
        echo -e "${GRAY}otomatik${NC}"
    fi

    echo -n "DATARUL_API_URL: "
    if [ -n "$DATARUL_API_URL" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_API_URL"
    else
        echo -e "${GRAY}otomatik${NC}"
    fi

    echo -n "DATARUL_MODULES: "
    if [ -n "$DATARUL_MODULES" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_MODULES"
    else
        echo -e "${GRAY}tanımlı değil${NC}"
    fi

    echo -n "DATARUL_ENV: "
    if [ -n "$DATARUL_ENV" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_ENV"
    else
        echo -e "${GRAY}test (varsayılan)${NC}"
    fi

    echo -n "DATARUL_DOTNET_TAG: "
    if [ -n "$DATARUL_DOTNET_TAG" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_DOTNET_TAG"
    else
        echo -e "${GRAY}latest (varsayılan)${NC}"
    fi

    echo -n "DATARUL_FRONTEND_TAG: "
    if [ -n "$DATARUL_FRONTEND_TAG" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_FRONTEND_TAG"
    else
        echo -e "${GRAY}latest (varsayılan)${NC}"
    fi

    echo -n "DATARUL_SQLPARSER_TAG: "
    if [ -n "$DATARUL_SQLPARSER_TAG" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_SQLPARSER_TAG"
    else
        echo -e "${GRAY}latest (varsayılan)${NC}"
    fi

    echo -n "DATARUL_SQLPARSER_LOG_DIR: "
    if [ -n "$DATARUL_SQLPARSER_LOG_DIR" ]; then
        echo -e "${GREEN}✓${NC} $DATARUL_SQLPARSER_LOG_DIR"
    else
        echo -e "${GRAY}logs (varsayılan)${NC}"
    fi

    echo "----------------------------------------"
}

echo -e "${GREEN}Datarul Ortam Değişkenleri Ayarlama${NC}"
echo "----------------------------------------"

# Mevcut değerleri kontrol et
ENV_FILE=.env
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
    echo -e "${GRAY}Mevcut ayarlar $ENV_FILE dosyasından yüklendi${NC}"
else
    echo -e "${GRAY}Ortam değişkenleri dosyası bulunamadı. Yeni dosya oluşturulacak.${NC}"
fi

# Mevcut değerleri listele
list_env_vars

echo -e "\n${GREEN}Yeni Değerleri Ayarlayın:${NC}"

# GitHub kullanıcı adını al
echo -n "GitHub kullanıcı adınız [${GITHUB_USERNAME:-datarul}]: "
read username
if [ -z "$username" ]; then
    GITHUB_USERNAME=${GITHUB_USERNAME:-datarul}  # Mevcut değeri koru veya varsayılanı kullan
else
    GITHUB_USERNAME=$username
fi
echo "GitHub kullanıcı adı $GITHUB_USERNAME olarak ayarlandı."

# GitHub token'ı al
echo -n "GitHub kişisel erişim tokeniniz [${GITHUB_TOKEN:+******}]: "
read -s token
echo
if [ -z "$token" ]; then
    if [ -z "$GITHUB_TOKEN" ]; then
        echo -e "${RED}Hata: GitHub token gereklidir!${NC}"
        exit 1
    fi
else
    GITHUB_TOKEN=$token
fi

# Subnet değerini al (opsiyonel)
echo -e "\n${GRAY}Önerilen Özel IP Aralıkları:${NC}"
echo -e "${GRAY}  • 10.0.0.0/8${NC}"
echo -e "${GRAY}  • 172.16.0.0/12${NC}"
echo -e "${GRAY}  • 192.168.0.0/16${NC}"
echo -n "Docker network subnet [${DATARUL_SUBNET:-otomatik}]: "
read subnet
if [ -z "$subnet" ]; then
    DATARUL_SUBNET=${DATARUL_SUBNET}  # Mevcut değeri koru (boş olabilir)
else
    DATARUL_SUBNET=$subnet
fi
if [ -z "$DATARUL_SUBNET" ]; then
    echo "Subnet değeri belirtilmedi. Docker otomatik atama yapacak."
else
    echo "Subnet değeri $DATARUL_SUBNET olarak ayarlandı."
fi

# API URL değerini al (opsiyonel)
echo -e "\n${GRAY}Örnek API URL'leri:${NC}"
echo -e "${GRAY}  • http://localhost:5100${NC}"
echo -e "${GRAY}  • https://api.datarul.com${NC}"
echo -e "${GRAY}  • https://test.datarul.com/api${NC}"
echo -n "API URL [${DATARUL_API_URL:-otomatik}]: "
read api_url
if [ -z "$api_url" ]; then
    DATARUL_API_URL=${DATARUL_API_URL}  # Mevcut değeri koru (boş olabilir)
else
    DATARUL_API_URL=$api_url
fi
if [ -z "$DATARUL_API_URL" ]; then
    echo "API URL belirtilmedi. Otomatik ayarlanacak."
else
    echo "API URL $DATARUL_API_URL olarak ayarlandı."
fi

# Environment değerini al
echo -n "Environment [${DATARUL_ENV:-test}]: "
read env
if [ -z "$env" ]; then
    DATARUL_ENV=${DATARUL_ENV:-test}  # Mevcut değeri koru veya varsayılanı kullan
else
    DATARUL_ENV=$env
fi
echo "Environment $DATARUL_ENV olarak ayarlandı."

# .NET image tag değerini al
echo -n ".NET image tag [${DATARUL_DOTNET_TAG:-latest}]: "
read tag
if [ -z "$tag" ]; then
    unset DATARUL_DOTNET_TAG
    echo ".NET image tag belirtilmedi. Varsayılan değer (latest) kullanılacak."
else
    DATARUL_DOTNET_TAG=$tag
    echo ".NET image tag $DATARUL_DOTNET_TAG olarak ayarlandı."
fi

# Frontend image tag değerini al
echo -n "Frontend image tag [${DATARUL_FRONTEND_TAG:-latest}]: "
read frontend_tag
if [ -z "$frontend_tag" ]; then
    unset DATARUL_FRONTEND_TAG
    echo "Frontend image tag belirtilmedi. Varsayılan değer (latest) kullanılacak."
else
    DATARUL_FRONTEND_TAG=$frontend_tag
    echo "Frontend image tag $DATARUL_FRONTEND_TAG olarak ayarlandı."
fi

# SQL Parser image tag değerini al
echo -n "SQL Parser image tag [${DATARUL_SQLPARSER_TAG:-latest}]: "
read sqlparser_tag
if [ -z "$sqlparser_tag" ]; then
    unset DATARUL_SQLPARSER_TAG
    echo "SQL Parser image tag belirtilmedi. Varsayılan değer (latest) kullanılacak."
else
    DATARUL_SQLPARSER_TAG=$sqlparser_tag
    echo "SQL Parser image tag $DATARUL_SQLPARSER_TAG olarak ayarlandı."
fi

# SQL Parser log dizinini al
echo -n "SQL Parser log dizini [${DATARUL_SQLPARSER_LOG_DIR:-logs}]: "
read log_dir
if [ -z "$log_dir" ]; then
    unset DATARUL_SQLPARSER_LOG_DIR
    echo "SQL Parser log dizini belirtilmedi. Varsayılan değer (logs) kullanılacak."
else
    DATARUL_SQLPARSER_LOG_DIR=$log_dir
    echo "SQL Parser log dizini $DATARUL_SQLPARSER_LOG_DIR olarak ayarlandı."
fi

# Frontend modüllerini seç
echo -e "\nAktif olacak modülleri seçin:"
modules=""

# Modülleri sıralı şekilde işle
for code in BG DD RC DL DQ; do
    case $code in
        BG) name="Business Glossary" ;;
        DD) name="Data Dictionary" ;;
        RC) name="Report Catalog" ;;
        DL) name="Data Lineage" ;;
        DQ) name="Data Quality" ;;
    esac

    echo -n "$name modülü aktif olsun mu? (E/h): "
    read answer
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
    if [[ -z "$answer" ]] || [[ "$answer" == "e" ]] || [[ "$answer" == "evet" ]]; then
        if [ -z "$modules" ]; then
            modules="$code"
        else
            modules="$modules|$code"
        fi
        echo -e "${GREEN}✓${NC} $name eklendi"
    else
        echo -e "${GRAY}✗${NC} $name atlandı"
    fi
done

if [ -z "$modules" ]; then
    echo -e "\n${RED}Hata: En az bir modül seçilmelidir!${NC}"
    exit 1
fi

DATARUL_MODULES=$modules
echo -e "\nSeçilen modüller: ${GREEN}$DATARUL_MODULES${NC}"

# Değerleri dosyaya kaydet ve yükle
cat > .env << EOF
export GITHUB_USERNAME="${GITHUB_USERNAME}"
export GITHUB_TOKEN="${GITHUB_TOKEN}"
export DATARUL_MODULES="${DATARUL_MODULES}"
export DATARUL_ENV="${DATARUL_ENV}"
export DATARUL_DOTNET_TAG="${DATARUL_DOTNET_TAG}"
export DATARUL_FRONTEND_TAG="${DATARUL_FRONTEND_TAG}"
export DATARUL_SQLPARSER_TAG="${DATARUL_SQLPARSER_TAG}"
export DATARUL_SQLPARSER_LOG_DIR="${DATARUL_SQLPARSER_LOG_DIR}"
EOF

# Eğer subnet tanımlandıysa dosyaya ekle
if [ -n "$DATARUL_SUBNET" ]; then
    echo "export DATARUL_SUBNET=\"${DATARUL_SUBNET}\"" >> .env
fi

# Eğer API URL tanımlandıysa dosyaya ekle
if [ -n "$DATARUL_API_URL" ]; then
    echo "export DATARUL_API_URL=\"${DATARUL_API_URL}\"" >> .env
fi

# Dosyaya execute izni verme
chmod 600 .env

# Mevcut oturuma değişkenleri yükle
source .env

echo -e "${GREEN}Ortam değişkenleri başarıyla kaydedildi.${NC}"
echo "Değişkenler .env dosyasına kaydedildi."

# Güncel değerleri listele
list_env_vars

echo "Her oturum açılışında değişkenlerin otomatik olarak yüklenmesi için ~/.bashrc veya ~/.zshrc dosyanıza şu satırı ekleyin:"
echo -e "${GREEN}source .env${NC}"