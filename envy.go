package main

import (
	"log"
	"os"

	envy "github.com/progrium/envy/cmd"
)

func main() {
	log.Println("[HACK] v0.3 starting ...")
	if envy.ClientMode() {
		envy.RunClient(os.Args[1:])
		return
	}

	envy.Envy.Setup()
	envy.SetupLogging()
	envy.CheckAdminCmd()
	envy.CheckSystemCmd()
	envy.Cmd.Execute()
}
