library(telegram)
## Create the bot object
bot <- TGBot$new(token = '183104961:AAFOVTLmfQ0MDHdt2ZnLgtUZYkM_gbDFkLs')
## Now check bot connection it should print some of your bot's data
bot$getMe()

## Now, on the phone, find and say something to your bot to start a chat
## (and obtain a chat id).
## ...

## Here, check what you have inserted
bot$getUpdates()

## You're interested in the message.chat.id variable: in order to set a
## default chat_id for the following commands (to ease typing)
bot$set_default_chat_id(181982455)
## Send some messages..
bot$sendMessage('This is text')
## Markdown support for messages
md1 <- "*bold* _italic_ [r-project](http://r-project.org) "
md2 <- " try `x <- rnorm(100)` at the console ..."
## below left spaces just for github displaying (not needed in the .R src)
md3 <- "
you can have
    ``` 
    x <- runif(100)
    mean(x)
    ```
too
" 
bot$sendMessage(md1, parse_mode = 'markdown')
bot$sendMessage(md2, parse_mode = 'markdown')
bot$sendMessage(md3, parse_mode = 'markdown')

## Send a image/photo
png('test.png')
plot(rnorm(100))
dev.off()
bot$sendPhoto('test.png', caption = 'This is my awesome graph')

## Send a document (can be any file)
help(TGBot, help_type = 'pdf')
bot$sendDocument('TGBot.pdf')

## Forward a message
bot$forwardMessage(from_chat_id = 123456,
                   chat_id = 123456,
                   message_id = 35)

## Send a location
bot$sendLocation(44.699, 10.6297)

## Send a sticker
bot$sendSticker(system.file('r_logo.webp', package = 'telegram'))

## Send a video
library(animation)
saveVideo({
    set.seed(1)
    nmax <- 10
    ani.options(interval = 0.4, nmax = nmax)
    x <- c()
    for (i in 1:nmax){
        x <- c(x, rnorm(1))
        plot(cumsum(x), lty = 2, xlim = c(1, nmax), ylim = c(-5, 5))
        abline(h = 0, col = 'red')
    }
}, video.name = 'animation.mp4')
bot$sendVideo('animation.mp4')

## Send mp3 audio files
bot$sendAudio(system.file('audio_test.mp3', package = 'telegram'),
              performer = 'espeak (http://espeak.sf.net)')

## Send voice (opus encoded .ogg files)
bot$sendVoice(system.file('voice_test.ogg', package = 'telegram'))

## getUserProfilePhotos
bot$getUserProfilePhotos(user_id('me')) # <- alternatively, message.from.id variable in getUpdates
bot$getUserProfilePhotos(user_id('me'), destfile = 'me.png')

# getFile
bot$getFile('asdasdasdqweqweqwe-UdYAAgI', # <- file_id from getUserProfilePhotos
            'me_small.png')