#!/bin/bash

# Written By: iPmart Panel 
# Channel: @iPmartPanel
# Group: @iPmartNetwork_GP

if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[33mPlease run as root\033[0m"
    exit
fi

wait 

colorized_echo() {
    local color=$1
    local text=$2
    
    case $color in
        "red")
        printf "\e[91m${text}\e[0m\n";;
        "green")
        printf "\e[92m${text}\e[0m\n";;
        "yellow")
        printf "\e[93m${text}\e[0m\n";;
        "blue")
        printf "\e[94m${text}\e[0m\n";;
        "magenta")
        printf "\e[95m${text}\e[0m\n";;
        "cyan")
        printf "\e[96m${text}\e[0m\n";;
        *)
            echo "${text}"
        ;;
    esac
}

colorized_echo green "\n[+] - Please wait for a few seconde !"

echo " "

question="Please select your action?"
actions=("Update Bot" "Delete Bot" "Donate" "Exit")

select opt in "${actions[@]}"
do
    case $opt in 
        "Update Bot")
            echo -e "\n"
            read -p "Are you sure you want to update? [y/n] : " answer
            if [ "$answer" != "${answer#[Yy]}" ]; then
                if [ -d "/var/www/html/ZanborPanelBot" ]; then
                    if [ -f "/var/www/html/ZanborPanelBot/install/iPmart.install" ]; then
                        if [ -s "/var/www/html/iPmartPanelBot/install/iPmart.install" ]; then
                            colorized_echo green "Please wait, Updating . . ."
                            # update proccess !
                            sudo apt update && apt upgrade -y
                            colorized_echo green "The server was successfully updated . . .\n"
                            sudo apt install curl -y
                            sudo apt install jq -y
                            sleep 2
                            mv /var/www/html/iPmartBotPanel/install/iPmart.install /var/www/html/iPmart.install
                            sleep 1
                            rm -r /var/www/html/iPmartBotPanel/
                            colorized_echo green "\nAll file and folder deleted for update bot . . .\n"

                            git clone https://github.com/ipmartnetwork/ipmartbotpanel.git /var/www/html/iPmartBotPanel/
                            sudo chmod -R 777 /var/www/html/iPmartBotPanel/
                            mv /var/www/html/iPmart.install /var/www/html/iPmartBotPanel/install/iPmart.install
                            sleep 2
                            
                            content=$(cat /var/www/html/iPmartBotPanel/install/iPmart.install)
                            token=$(echo "$content" | jq -r '.token')
                            dev=$(echo "$content" | jq -r '.dev')
                            domain=$(echo "$content" | jq -r '.main_domin')
                            db_name=$(echo "$content" | jq -r '.db_name')
                            db_username=$(echo "$content" | jq -r '.db_username')
                            db_password=$(echo "$content" | jq -r '.db_password')

                            source_file="/var/www/html/iPmartBotPanel/config.php"
                            destination_file="/var/www/html/iPmartBotPanel/config.php.tmp"
                            replace=$(cat "$source_file" | sed -e "s/\[\*TOKEN\*\]/${token}/g" -e "s/\[\*DEV\*\]/${dev}/g" -e "s/\[\*DB-NAME\*\]/${db_name}/g" -e "s/\[\*DB-USER\*\]/${db_username}/g" -e "s/\[\*DB-PASS\*\]/${db_password}/g")
                            echo "$replace" > "$destination_file"
                            mv "$destination_file" "$source_file"

                            sleep 2
                            
                            curl --location "https://${domain}/iPmartBotPanel/sql/sql.php?db_password=${db_password}&db_name=${db_name}&db_username=${db_username}"
                            echo -e "\n"
                            TEXT_MESSAGE="✅ ربات شما با موفقیت به آخرین نسخه آپدیت شد."$'\n\n'"#️⃣ اطلاعات ربات :"$'\n\n'"▫️token: <code>${token}</code>"$'\n'"▫️admin: <code>${dev}</code> "$'\n'"▫️domain: <code>${domain}</code>"$'\n'"▫️db_name: <code>${db_name}</code>"$'\n'"▫️db_username: <code>${db_username}</code>"$'\n'"▫️db_password: <code>${db_password}</code>"$'\n\n'"🔎 - @iPmartPanel | @iPmartPanelGap"
                            curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" -d chat_id="${dev}" -d text="${TEXT_MESSAGE}" -d parse_mode="html"

                            sleep 2
                            clear
                            echo -e "\n\n"
                            colorized_echo green "[+] The iPmartPanel Bot Has Been Successfully Updated"
                            colorized_echo green "[+] Telegram channel: @iPmartPanel || Telegram group: @iPmartPanelGap\n\n"
                            colorized_echo green "Your Bot Information:\n"
                            colorized_echo blue "[+] token: ${token}"
                            colorized_echo blue "[+] admin: ${dev}"
                            colorized_echo blue "[+] domain: ${domain}"
                            colorized_echo blue "[+] db_name: ${db_name}"
                            colorized_echo blue "[+] db_username: ${db_username}"
                            colorized_echo blue "[+] db_password: ${db_password}"
                            echo -e "\n"
                        else
                            echo -e "\n"
                            colorized_echo red "The iPmart.install file is empty!"
                            echo -e "\n"
                            exit 1
                        fi
                    else
                        echo -e "\n"
                        colorized_echo red "The iPmart.install file was not found and the update process was canceled!"
                        echo -e "\n"
                        exit 1
                    fi
                else
                    echo -e "\n"
                    colorized_echo red "The iPmartBotPanel folder was not found for the update process, install the bot first!"
                    echo -e "\n"
                    exit 1
                fi
            else
                echo -e "\n"
                colorized_echo red "Update Canceled !"
                echo -e "\n"
                exit 1
            fi

            break;;
        "Delete Bot")
            echo -e "\n"
            read -p "Are you sure you want to update? [y/n] : " answer
            if [ "$answer" != "${answer#[Yy]}" ]; then
                if [ -d "/var/www/html/iPmartBotPanel" ]; then
                    colorized_echo green "\n[+] Please wait, Deleting . . .\n"
                    rm -r /var/www/html/iPmartBotPanel/

                    sleep 2

                    TEXT_MESSAGE="❌ The iPmartPanel Bot Has Been Successfully Deleted -> @iPmart_network | @iPmartPanel_Gp"
                    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" -d chat_id="${CHAT_ID}" -d text="${TEXT_MESSAGE}"

                    sleep 2
                    echo -e "\n"
                    colorized_echo green "[+] The iPmartPanel Bot Has Been Successfully Deleted"
                    colorized_echo green "[+] Telegram channel: @iPmart_network | @iPmartPanel_Gp"
                    echo -e "\n"
                else
                    echo -e "\n"
                    colorized_echo red "The iPmartBotPanel folder was not found for the update process, install the bot first!"
                    echo -e "\n"
                    exit 1
                fi
            else
                echo -e "\n"
                colorized_echo red "Delete Canceled !"
                echo -e "\n"
                exit 1
            fi

            break;;
        "Donate")
            echo -e "\n"
            colorized_echo green "[+] Bank Meli: 5022291506874237\n\n[+] Tron (TRX): TJbTYV1fFo2485sYMyajxGPLFzxmNmPrNA\n\n[+] , BNB (BEP20): 0x4af3de9b303a8d43105e284823d95b4c600961a3\n\n[+] Bitcoin network: bc1q0wc04pj7fn2r7dma2v7thzxetaquf7mdpqlg8t" 
            echo -e "\n"
            exit 0

            break;;
        "Exit")
            echo -e "\n"
            colorized_echo green "Exited !"
            echo -e "\n"

            break;;
            *) echo "Invalid option!"
    esac
done
