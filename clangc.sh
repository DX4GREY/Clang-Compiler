#!/bin/bash
#!/data/data/com.termux/files/usr/bin/bash

characters_numbers="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
shuffled=$(echo "$characters_numbers" | fold -w1 | shuf | tr -d '\n')
random_combination=$(echo "$shuffled" | head -c 8)
current=$(pwd)

reset_color="\033[0m"
red_color="\033[31m"
green_color="\033[32m"

checkPackage() {
    if [ ! -x "$(command -v $pkg)" ]; then
        echo -e "${red_color}[*]${reset_color} $pkg not installed. Please install.."
        if [ "$(uname -o)" == "Android" ]; then
            echo -e "   pkg install $pkg"
        else
            echo -e "   sudo apt-get install $pkg"
        fi
        exit 1
    else
        echo -e "${green_color}[*]${reset_color} $pkg installed, Continues..."
    fi
}

title() {
    echo -e "${red_color}  ___  _                       ___ "
    echo -e " / (_)| |                     / (_)"
    echo -e "|     | |  __,   _  _    __, |     "
    echo -e "|     |/  /  |  / |/ |  /  | |     "
    echo -e "${reset_color} \___/|__/\_/|_/  |  |_/\_/|/ \___/"
    echo -e "                          /|by ${green_color}Dx4 ${reset_color}"
    echo -e "                          \|WHITE  "
    echo
}

installScript(){
    pkg="clang"
    checkPackage
    
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
}
uninstallScript() {
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
}
helpRun() {
    echo "usage: clangc [file]"
    echo "   or: clangc -u [for uninstall]"
    echo ""
    echo "Options:"
    echo "  -h     For show help option"
    echo "  -u     Uninstall this project"
}


title
if [ "$#" == "0" ]; then
    helpRun
else
    case $1 in
        "-i")
            installScript
        ;;
        "-u")
            uninstallScript
        ;;
        "-h") 
            helpRun
        ;;
        *)  
            echo -e "${green_color}[*]${reset_color} Checking clang package..."
            pkg="clang" && checkPackage
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
                    rm -rf $HOME/.out
                    cd $current
                fi
            else
                echo -e "${red_color}[*]${reset_color} File does not exist.${reset_color}"
            fi
        ;;
    esac
fi