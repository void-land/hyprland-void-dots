#!/bin/bash

# Make sure we don't inherit these from env.
SOURCE_DONE=
HOSTNAME_DONE=
KEYBOARD_DONE=
LOCALE_DONE=
TIMEZONE_DONE=
ROOTPASSWORD_DONE=
USERLOGIN_DONE=
USERPASSWORD_DONE=
USERNAME_DONE=
USERGROUPS_DONE=
USERACCOUNT_DONE=
PARTITIONS_DONE=
NETWORK_DONE=
FILESYSTEMS_DONE=
MIRROR_DONE=

TARGETDIR=
LOG=/dev/tty8
CONF_FILE=/tmp/.void-configs.conf
if [ ! -f $CONF_FILE ]; then
    touch -f $CONF_FILE
fi
ANSWER=$(mktemp -t vinstall-XXXXXXXX || exit 1)
TARGET_FSTAB=$(mktemp -t vinstall-fstab-XXXXXXXX || exit 1)

trap "DIE" INT TERM QUIT

# disable printk
if [ -w /proc/sys/kernel/printk ]; then
    echo 0 >/proc/sys/kernel/printk
fi

# dialog colors
BLACK="\Z0"
RED="\Z1"
GREEN="\Z2"
YELLOW="\Z3"
BLUE="\Z4"
MAGENTA="\Z5"
CYAN="\Z6"
WHITE="\Z7"
BOLD="\Zb"
REVERSE="\Zr"
UNDERLINE="\Zu"
RESET="\Zn"

# Properties shared per widget.
MENULABEL="${BOLD}Use UP and DOWN keys to navigate menus. Use TAB to switch between buttons and ENTER to select.${RESET}"
MENUSIZE="14 60 0"
INPUTSIZE="8 60"
MSGBOXSIZE="8 70"
YESNOSIZE="$INPUTSIZE"
WIDGET_SIZE="10 70"

DIALOG() {
    rm -f $ANSWER
    dialog --colors --keep-tite --no-shadow --no-mouse \
        --backtitle "${BOLD}${WHITE}Void Linux Config" \
        --cancel-label "Back" --aspect 20 "$@" 2>$ANSWER
    return $?
}

INFOBOX() {
    # Note: dialog --infobox and --keep-tite don't work together
    dialog --colors --no-shadow --no-mouse \
        --backtitle "${BOLD}${WHITE}Void Linux Config" \
        --title "${TITLE}" --aspect 20 --infobox "$@"
}

DIE() {
    rval=$1
    [ -z "$rval" ] && rval=0
    clear
    rm -f $ANSWER $TARGET_FSTAB
    # reenable printk
    if [ -w /proc/sys/kernel/printk ]; then
        echo 4 >/proc/sys/kernel/printk
    fi
    exit $rval
}

set_option() {
    if grep -Eq "^${1}.*" $CONF_FILE; then
        sed -i -e "/^${1}.*/d" $CONF_FILE
    fi
    echo "${1} ${2}" >>$CONF_FILE
}

get_option() {
    echo $(grep -E "^${1}.*" $CONF_FILE | sed -e "s|${1}||")
}

# ISO-639 language names for locales
iso639_language() {
    case "$1" in
    aa) echo "Afar" ;;
    af) echo "Afrikaans" ;;
    an) echo "Aragonese" ;;
    ar) echo "Arabic" ;;
    ast) echo "Asturian" ;;
    be) echo "Belgian" ;;
    bg) echo "Bulgarian" ;;
    bhb) echo "Bhili" ;;
    br) echo "Breton" ;;
    bs) echo "Bosnian" ;;
    ca) echo "Catalan" ;;
    cs) echo "Czech" ;;
    cy) echo "Welsh" ;;
    da) echo "Danish" ;;
    de) echo "German" ;;
    el) echo "Greek" ;;
    en) echo "English" ;;
    es) echo "Spanish" ;;
    et) echo "Estonian" ;;
    eu) echo "Basque" ;;
    fi) echo "Finnish" ;;
    fo) echo "Faroese" ;;
    fr) echo "French" ;;
    ga) echo "Irish" ;;
    gd) echo "Scottish Gaelic" ;;
    gl) echo "Galician" ;;
    gv) echo "Manx" ;;
    he) echo "Hebrew" ;;
    hr) echo "Croatian" ;;
    hsb) echo "Upper Sorbian" ;;
    hu) echo "Hungarian" ;;
    id) echo "Indonesian" ;;
    is) echo "Icelandic" ;;
    it) echo "Italian" ;;
    iw) echo "Hebrew" ;;
    ja) echo "Japanese" ;;
    ka) echo "Georgian" ;;
    kk) echo "Kazakh" ;;
    kl) echo "Kalaallisut" ;;
    ko) echo "Korean" ;;
    ku) echo "Kurdish" ;;
    kw) echo "Cornish" ;;
    lg) echo "Ganda" ;;
    lt) echo "Lithuanian" ;;
    lv) echo "Latvian" ;;
    mg) echo "Malagasy" ;;
    mi) echo "Maori" ;;
    mk) echo "Macedonian" ;;
    ms) echo "Malay" ;;
    mt) echo "Maltese" ;;
    nb) echo "Norwegian Bokmål" ;;
    nl) echo "Dutch" ;;
    nn) echo "Norwegian Nynorsk" ;;
    oc) echo "Occitan" ;;
    om) echo "Oromo" ;;
    pl) echo "Polish" ;;
    pt) echo "Portugese" ;;
    ro) echo "Romanian" ;;
    ru) echo "Russian" ;;
    sk) echo "Slovak" ;;
    sl) echo "Slovenian" ;;
    so) echo "Somali" ;;
    sq) echo "Albanian" ;;
    st) echo "Southern Sotho" ;;
    sv) echo "Swedish" ;;
    tcy) echo "Tulu" ;;
    tg) echo "Tajik" ;;
    th) echo "Thai" ;;
    tl) echo "Tagalog" ;;
    tr) echo "Turkish" ;;
    uk) echo "Ukrainian" ;;
    uz) echo "Uzbek" ;;
    wa) echo "Walloon" ;;
    xh) echo "Xhosa" ;;
    yi) echo "Yiddish" ;;
    zh) echo "Chinese" ;;
    zu) echo "Zulu" ;;
    *) echo "$1" ;;
    esac
}

# ISO-3166 country codes for locales
iso3166_country() {
    case "$1" in
    AD) echo "Andorra" ;;
    AE) echo "United Arab Emirates" ;;
    AL) echo "Albania" ;;
    AR) echo "Argentina" ;;
    AT) echo "Austria" ;;
    AU) echo "Australia" ;;
    BA) echo "Bonsia and Herzegovina" ;;
    BE) echo "Belgium" ;;
    BG) echo "Bulgaria" ;;
    BH) echo "Bahrain" ;;
    BO) echo "Bolivia" ;;
    BR) echo "Brazil" ;;
    BW) echo "Botswana" ;;
    BY) echo "Belarus" ;;
    CA) echo "Canada" ;;
    CH) echo "Switzerland" ;;
    CL) echo "Chile" ;;
    CN) echo "China" ;;
    CO) echo "Colombia" ;;
    CR) echo "Costa Rica" ;;
    CY) echo "Cyprus" ;;
    CZ) echo "Czech Republic" ;;
    DE) echo "Germany" ;;
    DJ) echo "Djibouti" ;;
    DK) echo "Denmark" ;;
    DO) echo "Dominican Republic" ;;
    DZ) echo "Algeria" ;;
    EC) echo "Ecuador" ;;
    EE) echo "Estonia" ;;
    EG) echo "Egypt" ;;
    ES) echo "Spain" ;;
    FI) echo "Finland" ;;
    FO) echo "Faroe Islands" ;;
    FR) echo "France" ;;
    GB) echo "Great Britain" ;;
    GE) echo "Georgia" ;;
    GL) echo "Greenland" ;;
    GR) echo "Greece" ;;
    GT) echo "Guatemala" ;;
    HK) echo "Hong Kong" ;;
    HN) echo "Honduras" ;;
    HR) echo "Croatia" ;;
    HU) echo "Hungary" ;;
    ID) echo "Indonesia" ;;
    IE) echo "Ireland" ;;
    IL) echo "Israel" ;;
    IN) echo "India" ;;
    IQ) echo "Iraq" ;;
    IS) echo "Iceland" ;;
    IT) echo "Italy" ;;
    JO) echo "Jordan" ;;
    JP) echo "Japan" ;;
    KE) echo "Kenya" ;;
    KR) echo "Korea, Republic of" ;;
    KW) echo "Kuwait" ;;
    KZ) echo "Kazakhstan" ;;
    LB) echo "Lebanon" ;;
    LT) echo "Lithuania" ;;
    LU) echo "Luxembourg" ;;
    LV) echo "Latvia" ;;
    LY) echo "Libya" ;;
    MA) echo "Morocco" ;;
    MG) echo "Madagascar" ;;
    MK) echo "Macedonia" ;;
    MT) echo "Malta" ;;
    MX) echo "Mexico" ;;
    MY) echo "Malaysia" ;;
    NI) echo "Nicaragua" ;;
    NL) echo "Netherlands" ;;
    NO) echo "Norway" ;;
    NZ) echo "New Zealand" ;;
    OM) echo "Oman" ;;
    PA) echo "Panama" ;;
    PE) echo "Peru" ;;
    PH) echo "Philippines" ;;
    PL) echo "Poland" ;;
    PR) echo "Puerto Rico" ;;
    PT) echo "Portugal" ;;
    PY) echo "Paraguay" ;;
    QA) echo "Qatar" ;;
    RO) echo "Romania" ;;
    RU) echo "Russian Federation" ;;
    SA) echo "Saudi Arabia" ;;
    SD) echo "Sudan" ;;
    SE) echo "Sweden" ;;
    SG) echo "Singapore" ;;
    SI) echo "Slovenia" ;;
    SK) echo "Slovakia" ;;
    SO) echo "Somalia" ;;
    SV) echo "El Salvador" ;;
    SY) echo "Syria" ;;
    TH) echo "Thailand" ;;
    TJ) echo "Tajikistan" ;;
    TN) echo "Tunisia" ;;
    TR) echo "Turkey" ;;
    TW) echo "Taiwan" ;;
    UA) echo "Ukraine" ;;
    UG) echo "Uganda" ;;
    US) echo "United States of America" ;;
    UY) echo "Uruguay" ;;
    UZ) echo "Uzbekistan" ;;
    VE) echo "Venezuela" ;;
    YE) echo "Yemen" ;;
    ZA) echo "South Africa" ;;
    ZW) echo "Zimbabwe" ;;
    *) echo "$1" ;;
    esac
}

menu_keymap() {
    local _keymaps="$(find /usr/share/kbd/keymaps/ -type f -iname "*.map.gz" -printf "%f\n" | sed 's|.map.gz||g' | sort)"
    local _KEYMAPS=

    for f in ${_keymaps}; do
        _KEYMAPS="${_KEYMAPS} ${f} -"
    done
    while true; do
        DIALOG --title " Select your keymap " --menu "$MENULABEL" 14 70 14 ${_KEYMAPS}
        if [ $? -eq 0 ]; then
            set_option KEYMAP "$(cat $ANSWER)"
            loadkeys "$(cat $ANSWER)"
            KEYBOARD_DONE=1
            break
        else
            return
        fi
    done
}

set_keymap() {
    local KEYMAP=$(get_option KEYMAP)

    if [ -f /etc/vconsole.conf ]; then
        sed -i -e "s|KEYMAP=.*|KEYMAP=$KEYMAP|g" $TARGETDIR/etc/vconsole.conf
    else
        sed -i -e "s|#\?KEYMAP=.*|KEYMAP=$KEYMAP|g" $TARGETDIR/etc/rc.conf
    fi
}

menu_locale() {
    local _locales="$(grep -E '\.UTF-8' /etc/default/libc-locales | awk '{print $1}' | sed -e 's/^#//')"
    local LOCALES ISO639 ISO3166
    local TMPFILE=$(mktemp -t vinstall-XXXXXXXX || exit 1)
    INFOBOX "Scanning locales ..." 4 60
    for f in ${_locales}; do
        eval $(echo $f | awk 'BEGIN { FS="." } \
            { FS="_"; split($1, a); printf "ISO639=%s ISO3166=%s\n", a[1], a[2] }')
        echo "$f|$(iso639_language $ISO639) ($(iso3166_country $ISO3166))|" >>$TMPFILE
    done
    clear
    # Sort by ISO-639 language names
    LOCALES=$(sort -t '|' -k 2 <$TMPFILE | xargs | sed -e's/| /|/g')
    rm -f $TMPFILE
    while true; do
        (
            IFS="|"
            DIALOG --title " Select your locale " --menu "$MENULABEL" 18 70 18 ${LOCALES}
        )
        if [ $? -eq 0 ]; then
            set_option LOCALE "$(cat $ANSWER)"
            LOCALE_DONE=1
            break
        else
            return
        fi
    done
}

set_locale() {
    if [ -f $TARGETDIR/etc/default/libc-locales ]; then
        local LOCALE="$(get_option LOCALE)"
        : "${LOCALE:=C.UTF-8}"
        sed -i -e "s|LANG=.*|LANG=$LOCALE|g" $TARGETDIR/etc/locale.conf
        # Uncomment locale from /etc/default/libc-locales and regenerate it.
        sed -e "/${LOCALE}/s/^\#//" -i $TARGETDIR/etc/default/libc-locales
        echo "Running xbps-reconfigure -f glibc-locales ..." >$LOG
        chroot $TARGETDIR xbps-reconfigure -f glibc-locales >$LOG 2>&1
    fi
}

menu_timezone() {
    local areas=(Africa America Antarctica Arctic Asia Atlantic Australia Europe Indian Pacific)

    local area locations location
    while (
        IFS='|'
        DIALOG ${area:+--default-item|"$area"} --title " Select area " --menu "$MENULABEL" 19 51 19 $(printf '%s||' "${areas[@]}")
    ); do
        area=$(cat $ANSWER)
        read -a locations -d '\n' < <(find /usr/share/zoneinfo/$area -type f -printf '%P\n' | sort)
        if (
            IFS='|'
            DIALOG --title " Select location (${area}) " --menu "$MENULABEL" 19 51 19 $(printf '%s||' "${locations[@]//_/ }")
        ); then
            location=$(tr ' ' '_' <$ANSWER)
            set_option TIMEZONE "$area/$location"
            TIMEZONE_DONE=1
            return 0
        else
            continue
        fi
    done
    return 1
}

set_timezone() {
    local TIMEZONE="$(get_option TIMEZONE)"

    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" "${TARGETDIR}/etc/localtime"
}

menu_hostname() {
    while true; do
        DIALOG --inputbox "Set the machine hostname:" ${INPUTSIZE}
        if [ $? -eq 0 ]; then
            set_option HOSTNAME "$(cat $ANSWER)"
            HOSTNAME_DONE=1
            break
        else
            return
        fi
    done
}

set_hostname() {
    local hostname="$(get_option HOSTNAME)"
    echo "${hostname:-void}" >$TARGETDIR/etc/hostname
}

menu_rootpassword() {
    local _firstpass _secondpass _again _desc

    while true; do
        if [ -z "${_firstpass}" ]; then
            _desc="Enter the root password"
        else
            _again=" again"
        fi
        DIALOG --insecure --passwordbox "${_desc}${_again}" ${INPUTSIZE}
        if [ $? -eq 0 ]; then
            if [ -z "${_firstpass}" ]; then
                _firstpass="$(cat $ANSWER)"
            else
                _secondpass="$(cat $ANSWER)"
            fi
            if [ -n "${_firstpass}" -a -n "${_secondpass}" ]; then
                if [ "${_firstpass}" != "${_secondpass}" ]; then
                    INFOBOX "Passwords do not match! Please enter again." 6 60
                    unset _firstpass _secondpass _again
                    sleep 2 && clear && continue
                fi
                set_option ROOTPASSWORD "${_firstpass}"
                ROOTPASSWORD_DONE=1
                break
            fi
        else
            return
        fi
    done
}

set_rootpassword() {
    echo "root:$(get_option ROOTPASSWORD)" | chroot $TARGETDIR chpasswd -c SHA512
}

log_and_count() {
    local progress whole tenth
    while read line; do
        echo "$line" >$LOG
        copy_count=$((copy_count + 1))
        progress=$((1000 * copy_count / copy_total))
        if [ "$progress" != "$copy_progress" ]; then
            whole=$((progress / 10))
            tenth=$((progress % 10))
            printf "Progress: %d.%d%% (%d of %d files)\n" $whole $tenth $copy_count $copy_total
            copy_progress=$progress
        fi
    done
}

menu_config() {
    ROOTPASSWORD_DONE="$(get_option ROOTPASSWORD)"

    echo $ROOTPASSWORD_DONE

    if [ -z "$ROOTPASSWORD_DONE" ]; then
        set_rootpassword
    fi

    # set_keymap
    # set_locale
    set_timezone
    # set_hostname

    # installed successfully.
    DIALOG --yesno "${BOLD}Configs saved successfully!${RESET}\n
Do you want to exit?" ${YESNOSIZE}
    if [ $? -eq 0 ]; then
        DIE
    else
        return
    fi
}

menu_mirror() {
    xmirror 2>$LOG && MIRROR_DONE=1
}

menu() {
    local AFTER_HOSTNAME
    if [ -z "$DEFITEM" ]; then
        DEFITEM="Keyboard"
    fi

    DIALOG --default-item $DEFITEM \
        --extra-button --extra-label "Settings" \
        --title " Void Linux Configuration " \
        --menu "$MENULABEL" 10 65 0 \
        "Keyboard" "Set system keyboard" \
        "Mirror" "Select XBPS mirror" \
        "Hostname" "Set system hostname" \
        "Locale" "Set system locale" \
        "Timezone" "Set system time zone" \
        "RootPassword" "Set system root password" \
        "SaveSettings" "Submit your configs" \
        "Exit" "Exit installation"

    if [ $? -eq 3 ]; then
        # Show settings
        cp $CONF_FILE /tmp/conf_hidden.$$
        sed -i "s/^ROOTPASSWORD.*/ROOTPASSWORD <-hidden->/" /tmp/conf_hidden.$$
        sed -i "s/^USERPASSWORD.*/USERPASSWORD <-hidden->/" /tmp/conf_hidden.$$
        DIALOG --title "Saved settings for installation" --textbox /tmp/conf_hidden.$$ 14 60
        rm /tmp/conf_hidden.$$
        return
    fi

    case $(cat $ANSWER) in
    "Keyboard") menu_keymap && [ -n "$KEYBOARD_DONE" ] ;;
    "Mirror") menu_mirror && [ -n "$MIRROR_DONE" ] ;;
    "Hostname") menu_hostname && [ -n "$HOSTNAME_DONE" ] ;;
    "Locale") menu_locale && [ -n "$LOCALE_DONE" ] ;;
    "Timezone") menu_timezone && [ -n "$TIMEZONE_DONE" ] ;;
    "RootPassword") menu_rootpassword && [ -n "$ROOTPASSWORD_DONE" ] ;;
    "SaveSettings") menu_config ;;
    "Exit") DIE ;;
    *) DIALOG --yesno "Abort Configuration ?" ${YESNOSIZE} && DIE ;;
    esac
}

if ! command -v dialog >/dev/null; then
    echo "ERROR: missing dialog command, exiting..."
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "void-installer must run as root" 1>&2
    exit 1
fi

while true; do
    menu
done

exit 0
