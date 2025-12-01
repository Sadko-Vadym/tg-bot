package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v4"
)

var (
	// TeleToken bot token
	TeleToken string
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "kbot",
	Short: "A simple Telegram bot",
	Long: `A simple Telegram bot built with Golang, Cobra and Telebot.
This bot can handle messages and respond to users in Telegram.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started\n", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		// Handle /start command
		kbot.Handle("/start", func(m telebot.Context) error {
			return m.Send(fmt.Sprintf("Welcome to %s bot! Type /help to see available commands.", kbot.Me.FirstName))
		})

		// Handle /hello command
		kbot.Handle("/hello", func(m telebot.Context) error {
			return m.Send(fmt.Sprintf("Hello! I'm %s bot. I'm here to help!", kbot.Me.FirstName))
		})

		// Handle /help command
		kbot.Handle("/help", func(m telebot.Context) error {
			return m.Send("Available commands:\n/hello - Greet the bot\n/help - Show this help message\n/start - Start the bot")
		})

		// Handle all text messages
		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Printf("%s wrote %s", m.Sender().Username, m.Text())
			payload := m.Text()

			// Ignore commands (they are handled separately)
			if len(payload) > 0 && payload[0] == '/' {
				return nil
			}

			return m.Send(fmt.Sprintf("You wrote: %s\nType /help for available commands.", payload))
		})

		kbot.Start()
	},
}

var appVersion = "1.0.0"

// Execute adds all child commands to the root command and sets flags appropriately.
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	rootCmd.PersistentFlags().StringVar(&TeleToken, "token", os.Getenv("TELE_TOKEN"), "Telegram Bot Token")
	if TeleToken == "" {
		log.Fatal("TELE_TOKEN is not set")
	}
}

