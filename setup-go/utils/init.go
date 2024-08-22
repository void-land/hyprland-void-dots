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
	LogColoredMessage(fmt.Sprintf("Running command: %s %s", cmd, strings.Join(args, " ")), ColorPurple)

	out, err := exec.Command(cmd, args...).CombinedOutput()

	if err != nil {
		// LogMessage(fmt.Sprintf("Command failed: %s %s\nError: %v", cmd, strings.Join(args, " "), err))

		LogColoredMessage(fmt.Sprintf("Error Output: %s", string(out)), ColorRed)

		return
	}

	if len(out) > 0 {
		LogColoredMessage(string(out), ColorCyan)
	}
}

func WriteToFile(filePath, content string) error {
	file, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0644)

	if err != nil {
		return fmt.Errorf("failed to open file: %w", err)
	}

	defer file.Close()

	_, err = file.WriteString(content)

	if err != nil {
		return fmt.Errorf("failed to write to file: %w", err)
	}

	return nil
}

func AppendToFile(filename, text string) {
	f, err := os.OpenFile(filename, os.O_APPEND|os.O_WRONLY, 0644)

	Check(err, fmt.Sprintf("open file %s", filename))

	defer f.Close()

	_, err = f.WriteString(text + "\n")

	Check(err, fmt.Sprintf("write to file %s", filename))
}
