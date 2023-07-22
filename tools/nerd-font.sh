#!/bin/bash

# rewrite this some time...

declare -a fonts=(
    3270
    Agave
    AnonymousPro
    Arimo
    ArulentSansMono
    BigBlueTerminal
    BitstreamVeraSansMono
    CascadiaCode
    CodeNewRoman
    ComicShannsMono
    Cousine
    DaddyTimeMono
    DroidSansMono
    EnvyCodeR
    FantasqueSansMono
    FiraCode
    FiraMono
    Gohu
    Go-Mono
    Hack
    Hasklig
    Hermit
    IBMPlexMono
    iA-Writer
    Iosevka
    JetBrainsMono
    Lekton
    Lilex
    Meslo
    Mononoki
    MPlus
    Overpass
    ProggyClean
    ProFont
    RobotoMono
    SourceCodePro
    ShareTechMono
    SpaceMono
    Ubuntu
    UbuntuMono
    Terminus
    VictorMono
    NerdFontsSymbolsOnly
)

version='2.1.0'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip -fuo "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
