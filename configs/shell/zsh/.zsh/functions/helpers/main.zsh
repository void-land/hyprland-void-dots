log() {
    local timestamp=$(date +"%T")
    local message="======> $1 : $timestamp"

    echo -e "$message\n"
}

params_required() {
    local param_name="$1"
    local error_message="$2"
    local param_value="$3"

    if [ -z "$error_message" ]; then
        error_message="Parameter '$param_name' is required but not provided."
    fi

    if [ -z "$param_value" ]; then
        echo "$error_message" >&2
        exit 1
    fi
}

validate_params() {
    local error_message="$1"
    shift
    local required_params=("$@")
    local missing_params=()

    for param in "${required_params[@]}"; do
        if [ -z "${!param}" ]; then
            missing_params+=("$param")
        fi
    done

    if [ ${#missing_params[@]} -gt 0 ]; then
        echo "$error_message Missing parameters: ${missing_params[*]}" >&2
        exit 1
    fi
}

check_command() {
    if ! command -v $1 &>/dev/null; then
        log "Command $1 is not installed. Please install $1 to continue."
        exit 1
    fi
}
