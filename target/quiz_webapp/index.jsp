<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Application</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #2196F3;
            --background-color: #f8f9fa;
            --text-color: #212529;
        }

        body {
            background-color: var(--background-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 70px;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
        }

        .navbar-brand {
            font-weight: 600;
            color: var(--primary-color) !important;
        }

        .navbar-brand i {
            margin-right: 8px;
        }
        
        .quiz-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            border-radius: 16px;
            position: relative;
        }

        .timer-container {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--background-color);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .timer-text {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .timer-label {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .option {
            margin: 10px 0;
            padding: 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            font-size: 1.1rem;
        }

        .option:before {
            content: attr(data-option);
            font-weight: bold;
            margin-right: 15px;
            color: #6c757d;
            min-width: 25px;
        }

        .option:hover {
            background-color: var(--background-color);
            border-color: #dee2e6;
            transform: translateY(-1px);
        }

        .option.selected {
            background-color: #e7f1ff;
            border-color: var(--secondary-color);
            color: var(--secondary-color);
        }

        .option.correct {
            background-color: #d4edda;
            border-color: var(--primary-color);
            color: #155724;
        }

        .option.incorrect {
            background-color: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }

        #question-text {
            font-size: 1.4rem;
            color: var(--text-color);
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary:hover {
            background-color: #3d8b40;
            border-color: #3d8b40;
            transform: translateY(-1px);
        }

        .feedback-message {
            margin-top: 15px;
            padding: 12px 20px;
            border-radius: 8px;
            font-weight: 500;
            display: none;
        }

        .feedback-correct {
            background-color: #d4edda;
            color: #155724;
            border: none;
        }

        .feedback-incorrect {
            background-color: #f8d7da;
            color: #721c24;
            border: none;
        }

        #result-container {
            text-align: center;
            padding: 2rem;
            display: none;
        }

        #result-container h2 {
            color: var(--text-color);
            margin-bottom: 1.5rem;
        }

        #score {
            font-size: 3rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .quiz-progress {
            position: fixed;
            top: 90px;
            right: 20px;
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            width: 250px;
        }

        @media (max-width: 992px) {
            .quiz-progress {
                position: static;
                width: 100%;
                margin-bottom: 1rem;
                order: -1;
            }

            .quiz-container {
                margin: 1rem;
            }

            .timer-container {
                position: static;
                margin: 0 auto 1rem auto;
            }

            #question-text {
                font-size: 1.2rem;
            }

            .option {
                font-size: 1rem;
                padding: 12px 15px;
            }
        }

        @media (max-width: 576px) {
            body {
                padding-top: 56px;
            }

            .quiz-container {
                padding: 1rem;
            }

            .option:before {
                min-width: 20px;
                margin-right: 10px;
            }

            .btn-primary {
                width: 100%;
                margin-top: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-brain"></i>
                Easy Quiz App
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#"><i class="fas fa-home"></i> Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-trophy"></i> Leaderboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-info-circle"></i> About</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="quiz-progress">
                    <h6 class="mb-3">Quiz Progress</h6>
                    <div id="progress-list">
                        <!-- Progress items will be added dynamically -->
                    </div>
                </div>

                <div class="quiz-container">
                    <div class="timer-container">
                        <div class="timer-text">0:20</div>
                        <div class="timer-label">Timer</div>
                    </div>

                    <div id="quiz-content">
                        <div id="question-container">
                            <h3 id="question-text"></h3>
                            <div id="options-container"></div>
                            <div id="feedback" class="feedback-message"></div>
                        </div>
                        
                        <div class="mt-4 text-end">
                            <button id="next-btn" class="btn btn-primary">Next Question</button>
                        </div>
                    </div>

                    <div id="result-container">
                        <h2>Quiz Complete!</h2>
                        <p>Your score: <span id="score"></span> out of 5</p>
                        <button id="play-again-btn" class="btn btn-success">Play Again</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/quiz.js"></script>
</body>
</html>
