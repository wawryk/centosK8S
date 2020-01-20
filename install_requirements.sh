#!/usr/bin/env bash

function usage()
{
    echo ""
    echo "This script is intended to automate the installation"
    echo "Please run -i option as root user or with sudo -E."
    echo ""
    echo "$0"
    echo "  -h --help"
    echo "  -i --install       install requiremnts support Ubuntu18 OS"
    echo "  -d --deploy        deploy centosK8S"
    echo ""
    exit 0
}

function instalation()
{
    apt install vagrant
    apt install git
    apt install virtualbox
    snap install kubectl --classic
}

function deploy()
{
    git pull https://github.com/wawryk/centosK8S.git
    cd centosK8S/
    vagrant up
}

while getopts 'hid-:' optchar; do
    case "$optchar" in
        -)
        case "$OPTARG" in
            help) usage;;
            install) instalation;;
            deploy) deploy;;
            *) echo "Invalid argument '$OPTARG'"
            usage;;
        esac
        ;;
    h) usage;;
    i) instalation;;
    d) deploy;;
    *) echo "Invalid argument '$OPTARG'"
      usage;;
    esac
done

if [[ ! -z $optchar ]]; then
    usage
fi
