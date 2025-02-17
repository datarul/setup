# Datarul Deployment

Bu repo, Datarul uygulamasının Docker Compose ile dağıtımını otomatize etmek için gerekli scriptleri içerir.

## Ön Gereksinimler

- Docker
- Docker Compose
- Git
- Internet erişimi
- GitHub hesabı ve kişisel erişim tokeni

## Ortam Değişkenleri

Deployment için aşağıdaki ortam değişkenlerinin tanımlanması gerekmektedir:

1. Ortam değişkenlerini ayarlamak için:

    ```bash
    ./set-env.sh
    ```

2. Ya da manuel olarak aşağıdaki değişkenleri tanımlayabilirsiniz:

    ```bash
    export GITHUB_USERNAME="datarul"  # Opsiyonel, varsayılan: datarul
    export GITHUB_TOKEN="github_kisisel_erisim_tokeniniz"
    export DATARUL_MODULES="BG|DD|RC|DL|DQ"  # Aktif modüller
    export DATARUL_SUBNET="172.25.0.0/16"  # Opsiyonel, varsayılan: 172.25.0.0/16
    export DATARUL_API_URL="http://sunucu_ip"  # Opsiyonel, varsayılan: http://sunucu_ip
    export DATARUL_ENV="test"  # Opsiyonel, varsayılan: test
    export DATARUL_DOTNET_TAG="latest"  # .NET uygulamaları için, varsayılan: latest
    export DATARUL_FRONTEND_TAG="latest"  # Frontend uygulaması için, varsayılan: latest
    export DATARUL_SQLPARSER_TAG="latest"  # SQL Parser uygulaması için, varsayılan: latest
    export DATARUL_SQLPARSER_LOG_DIR="logs"  # SQL Parser log dizini, varsayılan: logs
    ```

3. Ortam değişkenlerini kaldırmak için:

    ```bash
    ./remove-env.sh
    ```

## Kurulum

1. Repoyu klonlayın:

    ```bash
    git clone https://github.com/datarul/setup.git ~/datarul
    cd ~/datarul
    ```

2. Sistem gereksinimlerini kontrol edin:

    ```bash
    ./check-requirements.sh
    ```

3. Bağlantı testini yapın:

    ```bash
    ./test-connection.sh
    ```

4. Deployment scriptini çalıştırın:

    ```bash
    # Tüm adımları çalıştır
    ./deploy.sh

    # Image temizleme adımını atla
    ./deploy.sh --no-prune
    ```

5. Ortam değişkenlerinin kalıcı olması için:

    Her oturum açılışında değişkenlerin otomatik olarak yüklenmesi için ~/.bashrc veya ~/.zshrc dosyanıza şu satırı ekleyin:

    ```bash
    source ~/datarul/.env
    ```

## Container Yönetimi

Container'ları durdurmak veya kaldırmak için:

```bash
# Sadece container'ları durdur
./stop.sh

# Container'ları durdur ve kaldır
./stop.sh --remove
```

Bağlantı testini yapın:

```bash
./test-connection.sh
```
