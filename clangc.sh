#!/bin/bash
#!/data/data/com.termux/files/usr/bin/bash

characters_numbers="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
shuffled=$(echo "$characters_numbers" | fold -w1 | shuf | tr -d '\n')
random_combination=$(echo "$shuffled" | head -c 8)
current=$(pwd)

reset_color="\033[0m"
red_color="\033[31m"
green_color="\033[32m"

if [ "$#" == "0" ]; then
    echo -e "${red_color}[*]${reset_color} No argument?${reset_color}"
else
    if [ "$1" != "-u" ]; then
        if [ "$1" != "-i" ]; then
            if test -e $1; then
                echo -e "${green_color}[*]${reset_color} Checking out exist...${reset_color}"
                mkdir -p $HOME/.out
                echo -e "${green_color}[*]${reset_color} Start compile clang...${reset_color}"
                response=$(clang -o "$HOME/.out/$random_combination" "$1" 2>&1)
                if [ -n "$response" ]; then 
                    echo -e "$response"
                fi
                if [[ $response == *"error"* ]]; then
                    rm -rf $HOME/.out
                    echo -e "${red_color}[*]${reset_color} Compilation failed with errors."
                    exit 1
                fi
                echo -e "${green_color}[*]${reset_color} Change root permission...${reset_color}"
                if [ "$(uname -o)" == "Android" ]; then
                    chmod 777 $HOME/.out/$random_combination
                else
                    chmod +x $HOME/.out/$random_combination
                fi
                cd $HOME/.out
                echo -e "${green_color}[*]${reset_color} Running...${reset_color}"
                sleep 1
                clear
                ./$random_combination $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15
                if [ $? -eq 0 ]; then
                    cd $current
                fi
            else
                echo -e "${red_color}[*]${reset_color} File does not exist.${reset_color}"
            fi
        else
            filename="$0"
            linux="0"
            case $(uname -o) in
                "Android")
                    cp -f $(pwd)/$filename $PREFIX/bin/clangc
                    chmod 777 $PREFIX/bin/clangc
                    linux="0"
                ;;
                "GNU/Linux")
                    sudo cp -f $(pwd)/$filename /usr/local/bin/clangc
                    sudo chmod +x /usr/local/bin/clangc
                    linux="1"
                ;;
                *)
                    echo "[*] Unsupported platform"
                    linux="0"
                ;;
            esac
            if [ "$linux" == "1" ]; then
                if [ "/usr/local/bin/clangc" != "-i" ]; then
                    echo -e "${green_color}[*]${reset_color} Install success"
                else
                    echo -e "${red_color}[*]${reset_color} Install failed"
                fi
            else
                if [ "$PREFIX/bin/clangc" != "-i" ]; then
                    echo -e "${green_color}[*]${reset_color} Install success"
                else
                    echo -e "${red_color}[*]${reset_color} Install failed"
                fi
            fi
        fi
    else
        case $(uname -o) in
            "Android")
                rm -rf $PREFIX/bin/clangc
            ;;
            "GNU/Linux")
                sudo rm -rf /usr/local/bin/clangc
            ;;
            *)
                echo "[*] Unsupported platform"
            ;;
        esac
        echo -e "${green_color}[*]${reset_color} Uninstall success" 
    fi
fi