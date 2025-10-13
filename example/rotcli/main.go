package main

import (
	"log"
	"os"
	"strconv"

	"example.invalid/rotcli/cmd"
)

func main() {
	rot := 13
	if len(os.Args) > 1 {
		arg, err := strconv.Atoi(os.Args[1])
		if err != nil {
			log.Fatalf("invalid rotation argument: %v", err)
		}

		rot = arg
	}

	cmd.Run(os.Stdin, os.Stdout, rot)
}
