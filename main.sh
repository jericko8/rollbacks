#!/bin/bash


source ./function.sh

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Menginisialisasi penghitung eror
error_count=0


# Memeriksa log secara terus-menerus
display_message 
sudo journalctl -u stationd -f --no-hostname -o cat | while IFS= read -r line; do
    case "$line" in
        *"Failed to Init VRF" | *"Failed to Validate VRF" | *"Switchyard client connection error" | *"Failed to Transact Verify pod")
            echo -e "${RED}Masalah ditemukan: ${line}${NC}"
            restart_stationd
            ;;
        *"Failed to get transaction by hash: not found")
            echo -e "${RED}Masalah ditemukan: Failed to get transaction by hash: not found${NC}"
            shutdown_stationd
            spinner
            sleep 120
            echo -e "${GREEN}StationD Telah berhenti${NC}"
            sleep 3
            echo -e "${GREEN}Memeriksa Pembaruan....."
            cd tracks && git pull 
            sleep 3
            echo -e "${GREEN}Pembaruan Telah Berhasil..."
            sleep 1
            echo -e "${YELLOW}Memulai Rollback${NC}"
            sleep 2
            go run cmd/main.go rollback
            sleep 10
            echo -e "${GREEN}Rollback Berhasil dilakukan${NC}"
            sleep 3
            restart_stationd
            ;;
        *)
            if [ "$error_count" -gt 4 ]; then
                ((error_count++))
                echo -e "${RED}Banyak error terdeteksi...${NC}"
                shutdown_stationd
                echo -e "${GREEN}Memeriksa Pembaruan....."
                cd tracks && git pull 
                sleep 3
                echo -e "${GREEN}Pembaruan Telah Berhasil..."
                sleep 2
                echo -e "${YELLOW}Memulai Rollback${NC}"
                run_rollback
                sleep 3
                echo -e "${GREEN}Rollback Berhasil dilakukan${NC}"
                sleep 3
                restart_stationd
                # Reset error_count setelah tindakan dilakukan
                error_count=0
            fi
            ;;
    esac
done
