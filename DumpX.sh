#!/data/data/com.termux/files/usr/bin/bash
clear
apt update -y
apt upgrade -y
clear
    
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
RESET="\033[0m"

# Cool Banner
echo -e "${CYAN}"
echo "⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛"
echo "⬛⬛⬛⬛⬛🟥🟥🟥⬛⬛⬛⬛⬛"
echo "⬛⬛⬛⬛🟥🟥🟥🟥🟥⬛⬛⬛⬛"
echo "⬛⬛⬛🟥🟥🟥🟦🟦🟦⬛⬛⬛⬛"
echo "⬛⬛⬛🟥🟥🟥🟦🟦🟦⬛⬛⬛⬛"
echo "⬛⬛⬛🟥🟥🟥🟥🟥🟥⬛⬛⬛⬛"
echo "⬛⬛⬛🟥🟥🟥🟥🟥🟥⬛⬛⬛⬛"
echo "⬛⬛⬛⬛🟥🟥🟥🟥🟥⬛⬛⬛⬛"
echo "⬛⬛⬛⬛🟥🟥⬛🟥🟥⬛⬛⬛⬛"
echo "⬛⬛⬛⬛🟥🟥⬛🟥🟥⬛⬛⬛⬛"
echo "⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛"
echo -e "${RESET}\n"

echo -e "${CYAN}=============================="
echo -e "       DumpX v12.1"
echo -e "   Premium Lib Dumper"
echo -e "==============================${RESET}\n"

sleep 2

if [ ! -d "$HOME/radare2" ]; then
    echo -e "${YELLOW}[*] Radare2 kuruluyor.....${RESET}"
    echo -e "${YELLOW}[*] Lütfen bekleyin...${RESET}"
    pkg install git -y &>/dev/null
    git clone https://github.com/ibrahimadaballi/radare2 &>/dev/null
    cd radare2 || { echo -e "${RED}[!] Radare2 dizinine girilemedi. Çıkılıyor.......${RESET}"; exit 1; }
    ./sys/termux.sh &>/dev/null
    pkg install radare2 -y &>/dev/null
    echo -e "${GREEN}[✔] Radare2 başarıyla kuruldu! 🎉${RESET}"
else
    echo -e "${GREEN}[✔] Radare2 kuruldu.${RESET}"
fi

cd ~

TARGET_FOLDER="/storage/emulated/0"

if [ ! -d "$TARGET_FOLDER" ]; then
    echo -e "${RED}[!] hedef klasör bulunamadı: $TARGET_FOLDER${RESET}"
    exit 1
fi

LIBS=($(find "$TARGET_FOLDER" -type f -name "*.so" -print))

if [ ${#LIBS[@]} -eq 0 ]; then
    echo -e "${RED}[!] .so dosyası bulunamadı $TARGET_FOLDER.${RESET}"
    exit 1
fi

# Display lib list with two line breaks for clarity
echo -e "${CYAN}[*] Lib(s) found:${RESET}\n"
for ((i = 0; i < ${#LIBS[@]}; i++)); do
    lib_name=$(basename "${LIBS[i]}")
    echo -e "${BLUE}[$((i + 1))]${WHITE} $lib_name${RESET}"
done
echo ""

echo -en "${GREEN}[*]  lütfen dosyayı seçin:${RESET}"
read choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#LIBS[@]}" ]; then
    echo -e "${RED}[!] Geçersiz ${RESET}"
    exit 1
fi

LIB_NAME=$(basename "${LIBS[$((choice - 1))]}")
LIB_PATH="${LIBS[$((choice - 1))]}"

DUMP_FILE="$TARGET_FOLDER/${LIB_NAME}_dump.c"

echo -e "${YELLOW}[*] Devam ediyor${WHITE}$LIB_NAME${YELLOW}...${RESET}"

rabin2 -s "$LIB_PATH" >> "$DUMP_FILE" 2>/dev/null

# Check if dump is valid
if [ -s "$DUMP_FILE" ]; then
    echo -e "${GREEN}[✔] Lib başarıyla atıldı!${RESET}"
    echo -e "${YELLOW}[✔] Döküman  kaydedildi: ${GREEN}$DUMP_FILE${RESET}"
else
    echo -e "${RED}[!] Döküman başarısız oldu veya çıktı boş${RESET}"
fi