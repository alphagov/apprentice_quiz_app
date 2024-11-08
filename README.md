# Quiz Application in Rails

This is a basic Rails-based quiz application that allows users to create quizzes and add questions to them. It provides a simple interface to manage quizzes and questions. I developed this as part of my journey of learning Rails as a student placement dev at the GDS.

## Features

- Create, edit, view, and delete quizzes.

- Add questions to a quiz.

- Display all quizzes and individual questions.

## Getting Started

### Prerequisites

Make sure you have the following installed on your system:

- Ruby: Version 2.7 or later.

- Rails: Version 6.0 or later.

- SQLite3: The default database used by Rails.

### Installation

Clone the repository:

```
 git clone https://github.com/Sunny-xyz/apprentice_quiz_app/
 cd quiz_app
```

Install the required gems:

```
bundle install
```

Set up the database:

```
rails db:create
rails db:migrate
```

## Running the Application

To start the server, run:
```
rails server
```
Visit http://localhost:3000 in your web browser to interact with the quiz application.

## Usage

- Create a Quiz: Navigate to the quizzes page and click "Create New Quiz" to add a new quiz.

- Add Questions: Open a quiz and click "Add Question" to create questions for that quiz.

- View and Manage: You can view, edit, and delete quizzes and questions.

## Application Structure

### Models

- Quiz: Represents a quiz, containing a title and description.

- Question: Represents a question associated with a quiz, containing content and a correct answer.

### Controllers

- QuizzesController: Manages CRUD actions for quizzes, such as listing, creating, editing, and deleting quizzes.

- QuestionsController: Manages adding questions to specific quizzes.

### Routes

The application uses nested routes for quizzes and questions to maintain a logical structure for managing questions under quizzes.
```
resources :quizzes do
  resources :questions
end
```
### Views

- Quizzes Index: Displays a list of all quizzes.

- Quiz Show: Displays quiz details along with associated questions.

## Future Improvements

- User Authentication: Integrate Devise to manage users and authentication.

- Quiz Timer: Add a timer feature for each quiz.

- Scoring System: Implement a scoring mechanism to calculate quiz results.

- Quiz Analytics: Provide feedback and statistics on quizzes.
