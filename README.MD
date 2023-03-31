# ChatGPT SwiftUI iOS, macOS, watchOS, tvOS App

![Alt text](https://imagizer.imageshack.com/v2/640x480q90/922/hmlopw.png "image")

This is a native iOS, macOS, watchOS, tvOS App for interacting with ChatGPT built using SwiftUI and OpenAPI API. It's using Official ChatGPT endpoint with `gpt-3.5-turbo` model.


## Video tutorial
- [iOS YouTube](https://youtu.be/PLEgTCT20zU)
- [macOS YouTube](https://youtu.be/Wl1cDvwpJoE)
- [watchOS YouTube](https://youtu.be/DwXy0gKz1GY)
- [tvOS YouTube](https://youtu.be/7RQHG7GXJ_U)
- [Upgrade to Official API YouTube](https://youtu.be/9byLhs5hQjI)

## Requirements
- Xcode 14 
- Register at openai.com/api
- Create API Key
- Paste API key in ContentView where the ChatGPTAPI instance is declared

## ChatGPTSwift API Lib
You can use this standalone api client to access ChatGPT API, you can add dependency for [ChatGPTSwift](https://github.com/alfianlosari/ChatGPTSwift) to access the API only if you want to integrate into your own app.

## GPT Encoder Lib
I've also created [GPTEncoder](https://github.com/alfianlosari/GPTEncoder) Swift BPE Encoder/Decoder for OpenAI GPT Models. A programmatic interface for tokenizing text for OpenAI GPT API.

## GPT Tokenizer UI Lib
I've also created [GPTTokenizerUI](https://github.com/alfianlosari/GPTTokenizerUI), a SPM lib you can integrate in your app for providing GUI to input text and show the tokenization results used by GPT API.

![Alt text](https://imagizer.imageshack.com/v2/640x480q70/922/CEVvrE.png "image")
