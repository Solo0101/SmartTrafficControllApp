# 🚦 Smart Traffic Control App

A Flutter mobile application designed to monitor and manage smart traffic light intersections. It provides real-time data, visualizations, and control over traffic flow by communicating with a dedicated Django backend API.

---

## ✨ Features

-   **🔐 User Authentication:** Secure login and registration system handled by the dedicated Django backend.
-   **📊 Real-time Dashboard:** View a list of all connected intersections and their current status.
-   **📈 Detailed Analytics:** Dive into specific intersections to view traffic volume charts and historical data.
-   **➕ Intersection Management:** Easily add and configure new intersections in the system.
-   **👤 User Profile:** View and manage your account details.
-   **🌐 Connectivity Checks:** Ensures the app has an active internet connection before performing network requests.
-   **📱 Responsive UI:** A clean and intuitive user interface built with Flutter.

---

## 🛠️ Tech Stack & Dependencies

### Frontend (This Application)
-   **Framework:** [Flutter](https://flutter.dev/)
-   **Language:** [Dart](https://dart.dev/)
-   **Backend Communication:** [HTTP](https://pub.dev/packages/http)
-   **Routing:** [go_router](https://pub.dev/packages/go_router)
-   **Local Caching:** [Hive](https://pub.dev/packages/hive)
-   **Data Visualization:** [fl_chart](https://pub.dev/packages/fl_chart)
-   **Connectivity:** [connectivity_plus](https://pub.dev/packages/connectivity_plus)

### Backend
-   This application requires the **[Backend - Smart Traffic Lights Controller](https://github.com/Solo0101/Backend-Smart_Traffic_Lights_Controller)** which is built with **Django** and **Django REST Framework**.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

1.  **Flutter SDK:** Make sure you have the Flutter SDK installed. For installation instructions, see the [official Flutter documentation](https://docs.flutter.dev/get-started/install).
2.  **IDE:** An IDE with Flutter support like [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/).
3.  **Android SDK:** Ensure you have the Android SDK installed (API level 34 or higher is recommended).

### ⚠️ Important: Backend Setup

This mobile application **will not function** without its backend. Please clone and follow the setup instructions in the **[Backend - Smart Traffic Lights Controller](https://github.com/Solo0101/Backend-Smart_Traffic_Lights_Controller)** repository **before** running this mobile app.

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/Solo0101/SmartTrafficControllApp.git](https://github.com/Solo0101/SmartTrafficControllApp.git)
    ```

2.  **Navigate to the project directory:**
    ```sh
    cd SmartTrafficControllApp/smart_traffic_control_app
    ```

3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Run the application:**
    Connect a physical device or start an Android emulator. Then, run the following command:
    ```sh
    flutter run
    ```

---
## 📂 Project Structure

The project is organized into the following main directories:

lib/├── components/     # Reusable UI widgets (buttons, text fields, charts)├── constants/      # App-wide constants (styles, routes, text)├── helpers/        # Helper classes (connectivity, time)├── models/         # Data models for User and Intersection├── pages/          # Main screens of the application├── services/       # Business logic (API, Auth, Database)└── shared/         # Shared configurations like routing
---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
