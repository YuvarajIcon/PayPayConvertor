# PayPay Convertor App

## Overview

This project is a currency conversion app developed as part of an assignment for PayPay. The app allows users to convert currency and choose the base currency for conversion.

## Features

- **Currency Conversion:** Get real-time exchange rates for different currencies and perform currency conversion with ease.

- **Base Currency Selection:** Users can choose their preferred base currency for conversion, providing flexibility and convenience.

- **Search for Currencies:** Explore and search for currencies using a user-friendly interface to find the desired currency quickly.

- **Customization:** Users can customize their experience by adjusting settings such as the preferred currency and app appearance.

## Technologies Used

- **Swift:** The app is developed using the Swift programming language.

- **Alamofire:** Alamofire is used for network requests to fetch currency conversion data from a remote API.

- **UIKit:** UIKit is the primary framework for building the user interface.

- **SnapKit:** SnapKit is utilized for concise and expressive Auto Layout constraints.

## Architecture Used: VIPER

The PayPay Convertor App is built using the VIPER architecture pattern, which stands for View, Interactor, Presenter, Entity, and Router. VIPER is designed to enhance the separation of concerns in iOS applications, making them more modular and scalable.

### VIPER Components:

- **View:** Represents the user interface and displays the data to the user. It receives user inputs and passes them to the Presenter.

- **Interactor:** Contains the business logic and performs the data operations. It communicates with the Presenter to send the results.

- **Presenter:** Acts as the intermediary between the View and the Interactor. It receives input from the View, processes it, and updates the View with the results from the Interactor.

- **Entity:** Represents the data model or objects used by the application.

- **Router:** Handles the navigation and routing logic. It receives requests from the Presenter to navigate to a different module.

VIPER promotes a modular and testable codebase by separating concerns and ensuring that each component has a distinct role in the application.

## Getting Started

To run the project locally, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/YuvarajIcon/PayPayConvertor.git
   
2. **Open the Xcode project::**

   ```bash
   open PayPayConvertor.xcodeproj

## API Key Configuration

The PayPayConvertor App uses an API key from [OpenExchangeRates](https://openexchangerates.org/) to fetch weather information. To set up your own API key, follow these steps:

1. Sign up for a free account on [OpenExchangeRates](https://openexchangerates.org/) to obtain your API key.

2. Open the Xcode project:

    ```bash
    open PayPayConvertor.xcodeproj
    ```

3. In the Xcode project navigator, locate the `PayPayConvertor` folder and find the files named `debug.xcconfig` and `release.xcconfig` under the `Config` group.

4. Open both `debug.xcconfig` and `release.xcconfig` files in a text editor of your choice.

5. Locate the line containing `API_KEY = INSERT_YOUR_API_KEY` and replace `INSERT_YOUR_API_KEY` with your actual API key.

    ```plaintext
    API_KEY = YOUR_ACTUAL_API_KEY
    ```

6. Save the changes.

**Note:** Ensure that you replace the API key in both `debug.xcconfig` and `release.xcconfig` files if you plan to test the app in both debug and release modes.

By following these steps, you'll have configured your own API key for the PayPayConvertor App.

## Running XCTest:

To run unit tests and ensure the application's functionality, follow these steps:

1. Open the Xcode project:
    ```bash
    open PayPayConvertor.xcodeproj
    ```
2. Select the PayPayConvertorTests target.

3. Press **Command + U** or navigate to **Product > Test** in the Xcode menu to run the unit tests.

Build and run the app in the Xcode simulator or on a physical device.
Convert currencies, choose the base currency, and explore the convenience of PayPay Convertor!
