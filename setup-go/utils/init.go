package utils

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"time"
)

const (
	ColorReset  = "\033[0m"
	ColorGreen  = "\033[32m"
	ColorRed    = "\033[31m"
	ColorYellow = "\033[33m"
	ColorBlue   = "\033[34m"
	ColorPurple = "\033[35m"
	ColorCyan   = "\033[36m"
	ColorWhite  = "\033[37m"
)

func CheckSudo() {
	if os.Geteuid() != 0 {
		log.Fatalf("This script must be run as root")
	}
}

func LogMessage(message string) {
	fmt.Println(time.Now().Format(time.Kitchen), ":", message)
}

func LogColoredMessage(message string, colorCode ...string) {
	color := ColorYellow

	if len(colorCode) > 0 {
		color = colorCode[0]
	}

	coloredMessage := fmt.Sprintf("%s%s%s", color, message, ColorReset)

	LogMessage(coloredMessage)
}

func Check(err error, message string) {
	if err != nil {
		log.Fatalf("Error during %s: %v", message, err)
	}
}

func RunCommand(cmd string, args ...string) {
	LogMessage(fmt.Sprintf("Running command: %s %s", cmd, strings.Join(args, " ")))

	out, err := exec.Command(cmd, args...).CombinedOutput()

	Check(err, fmt.Sprintf("%s %s", cmd, strings.Join(args, " ")))

	LogMessage(string(out))
}
