# Telegram Bot (kbot)

A simple Telegram bot built with Golang, using [Cobra](https://github.com/spf13/cobra) for CLI and [Telebot](https://github.com/tucnak/telebot) for Telegram Bot API integration.

## Features

- Handle text messages from users
- Respond to commands: `/hello`, `/help`, `/start`
- Echo user messages with helpful responses

## Prerequisites

- Go 1.21 or higher
- Telegram Bot Token (obtained from [@BotFather](https://t.me/BotFather))

## Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/tg-bot.git
cd tg-bot
```

2. Install dependencies:
```bash
go mod download
```

3. Set up your Telegram Bot Token:
   - Create a bot using [@BotFather](https://t.me/BotFather) in Telegram
   - Get your bot token
   - Set it as an environment variable:
   
   **Windows (PowerShell):**
   ```powershell
   $env:TELE_TOKEN="your_bot_token_here"
   ```
   
   **Linux/Mac:**
   ```bash
   export TELE_TOKEN="your_bot_token_here"
   ```

## Usage

Run the bot:
```bash
go run main.go
```

Or build and run:
```bash
go build -o kbot
./kbot
```

## Bot Commands

Once the bot is running, you can interact with it in Telegram:

- `/start` - Start the bot and see welcome message
- `/hello` - Greet the bot
- `/help` - Show available commands
- Any other text - The bot will echo your message

## Bot Link

After creating your bot with BotFather, you can access it at:
```
t.me/your_bot_name_bot
```

Replace `your_bot_name` with the actual name you gave your bot.

## Project Structure

```
tg-bot/
├── cmd/
│   └── root.go      # Cobra root command and bot handlers
├── main.go          # Application entry point
├── go.mod           # Go module dependencies
├── .gitignore       # Git ignore rules
└── README.md        # This file
```

## Technologies Used

- [Golang](https://golang.org/) - Programming language
- [Cobra](https://github.com/spf13/cobra) - CLI framework
- [Telebot](https://github.com/tucnak/telebot) - Telegram Bot API wrapper

## Development

### Adding New Handlers

To add new message handlers, modify the `Handle` function in `cmd/root.go`:

```go
kbot.Handle(telebot.OnText, func(m telebot.Context) error {
    // Your handler logic here
    return m.Send("Response message")
})
```

### Building

Build the binary:
```bash
go build -o kbot
```

## Troubleshooting

- **"TELE_TOKEN is not set"**: Make sure you've set the `TELE_TOKEN` environment variable
- **Connection errors**: Check your internet connection and ensure the bot token is correct
- **Bot not responding**: Verify the bot is running and the token is valid

## License

This project is open source and available for educational purposes.

## Contributing

Feel free to submit issues and enhancement requests!

