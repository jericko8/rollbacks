#!/bin/bash


# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#fungsi buat nambahin tulisan
display_message() {
    local blue='\033[0;34m'      
    local NC='\033[0m'           
    local red='\033[0;31m'       
    echo -e "${blue}"
    # echo "   ,--,                                                                    "
    # echo ",---.'|                           ,--.                                    "
    # echo "|   | :      ,---,              ,--.'|                ,---,.    ,---,      "
    # echo ":   : |     '  .' \\         ,--,:  : |       ,---.  ,'  .' |  .'  .' \`    "
    # echo "|   ' :    /  ;    '.    ,\`--.'\`|  ' :      /__./|,---.'   |,---.'     \\   "
    # echo ";   ; '   :  :       \\   |   :  :  | | ,---.;  ; ||   |   .'|   |  .\`\\  |  "
    # echo "'   | |__ :  |   /\\   \\  :   |   \\ | :/___/ \\  | |:   :  |-,:   : |  '  | "
    # echo "|   | :.'||  :  ' ;.   : |   : '  '; |\\   ;  \\ ' |:   |  ;/||   ' '  ;  : "
    # echo "'   :    ;|  |  ;/  \\   \\'   ' ;.    ; \\   \\  \\: ||   :   .''   | ;  .  | "
    # echo "|   |  ./ '  :  | \\  \\ ,'|   | | \\   |  ;   \\  ' .|   |  |-,|   | :  |  ' "
    # echo ";   : ;   |  |  '  '--'  '   : |  ; .'   \\   \\   ''   :  ;/|'   : | /  ;  "
    # echo "|   ,/    |  :  :        |   | '\`--'      \\   \`  ;|   |    \|   | '\` ,/   "
    # echo "'---'     |  | ,'        '   : |           :   \\ ||   :   .';   :  .'     "
    # echo "          \`--''          ;   |.'            '---\" |   | ,'  |   ,.'       "
    # echo "                         '---'                    \`----'    '---'         "
    # echo "                                                                          "
    echo -e "  Monitoring Logs for ${red}Error ${blue}Message........${NC}                            "
    echo -e "${NC}"
}

# Fungsi untuk animasi spinner
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function Rollback 3x
run_rollback() {
    cd $HOME/tracks
    sleep 3
    for i in {1..3}
    do
        echo -e "${YELLOW}Running rollback attempt ${i}...${NC}"
        go run cmd/main.go rollback
        sleep 10
    done
}

# function Restart StationD
restart_stationd() {
    cd $HOME/tracks
    echo -e "${YELLOW}Memulai kembali StationD${NC}"
    sleep 2
    systemctl restart stationd &
    spinner
    sleep 5
    echo -e "${GREEN}StationD berhasil di Restart${NC}"
    sleep 2
    clear
}

#Function untuk mematikan StationD
shutdown_stationd(){
    echo -e "${YELLOW}Memberhentikan Stationd${NC}"
    sleep 2
    cd $HOME && systemctl stop stationd &
    spinner
    sleep 120
    echo -e "${GREEN}StationD Telah berhenti${NC}"
    sleep 3
}


# fungsi untuk handle beberapa Error selain RPC error
handle_errors() {
    errors=(
        "Failed to Init VRF"
        "Failed to Validate VRF"
        "Switchyard client connection error"
        "» Failed to Transact Verify pod"
        "» Failed to get transaction by hash: not found"
    )
    messages=(
        "Failed to Init VRF"
        "Failed to Validate VRF"
        "Switchyard client connection error"
        "Failed to Transact Verify pod"
        "Failed to get transaction by hash: not found"
    )

    for i in "${!errors[@]}"; do
        if echo "$line" | grep -q "${errors[$i]}"; then
            echo -e "${RED}Masalah ditemukan: ${messages[$i]}${NC}"
            
            if [ "${errors[$i]}" == "» Failed to get transaction by hash: not found" ]; then
                shutdown_stationd
                echo -e "${GREEN}Memeriksa Pembaruan....."
                cd tracks && git pull 
                sleep 3
                echo -e "${GREEN}Pembaruan Telah Berhasil..."
                sleep 1
                echo -e "${YELLOW}Memulai Rollback${NC}"
                cd ~/tracks && go run cmd/main.go rollback
                sleep 3
                echo -e "${GREEN}Rollback Berhasil dilakukan${NC}"
                sleep 3
                restart_stationd
                clear
                display_message
            fi
                echo -e "${YELLOW}Memulai kembali StationD${NC}"
                sleep 3
                restart_stationd
                clear
                display_message
            fi
     done
}