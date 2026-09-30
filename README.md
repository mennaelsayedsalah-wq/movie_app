# CineNova - Movie Application

## Project Overview

CineNova is a Flutter movie application that allows users to discover movies, search for movies, view movie details, and manage their personal movie lists.

## Features

* User Registration and Login
* User Logout
* Browse Movies
* Search for Movies
* View Movie Details
* Favorites Movies
* Watched Movies
* Watching Movies
* Want to Watch Movies

## Technologies

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* TMDB API
* BLoC / Cubit
* REST API
* Git and GitHub

## Architecture

The application follows a structured architecture that separates the presentation layer from the application logic and data operations.

## State Management

The application uses BLoC / Cubit for state management.

## API

The application uses the TMDB API to retrieve movie information such as movie titles, posters, ratings, release dates, and other movie details.

## Authentication

Firebase Authentication is used to provide user registration, login, logout, authentication state handling, and authentication error handling.

## Database

Cloud Firestore is used to store the user's movie lists:

* Favorites
* Watched
* Watching
* Want to Watch

## Project Structure

The project is organized into separate folders for the application's presentation, business logic, data, models, services, and other reusable components.

## Setup Instructions

1. Clone the repository.
2. Open the project in Visual Studio Code.
3. Run:


flutter pub get


4. Configure Firebase for the project.
5. Configure the TMDB API.
6. Run the application using:


flutter run


## Screenshots

Screenshots of the final application will be added here.

## Known Limitations

Any known limitations or incomplete enhancements will be documented here.
