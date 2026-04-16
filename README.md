# OnTracSports 🏆

A native iOS application that delivers real-time scores and stats for four major professional sports leagues — built with SwiftUI and the ESPN API.

## Features

- Live scores and game updates for NFL, NBA, MLB, and NHL
- Auto-refresh logic to keep data current without excessive API calls
- Local data persistence to maintain state across app lifecycles
- Clean, responsive UI

## Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Concurrency:** Swift Async/Await
- **Data:** ESPN API (REST)
- **Persistence:** Local data caching

## Architecture

This app follows the MVVM pattern to cleanly separate business logic from the UI layer. Swift Async/Await handles concurrent network requests, ensuring the interface stays responsive while fetching live data from multiple league endpoints simultaneously.

## Getting Started

### Prerequisites
- Xcode 15 or later
- iOS 16.0+ deployment target
- macOS Ventura or later

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/MrCarter22/OnTracSports.git
   ```
2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode
3. Build and run on a simulator or physical device

## Author

**Deric Carter**  
[LinkedIn](https://www.linkedin.com/in/deric-carter) | [GitHub](https://github.com/MrCarter22)
