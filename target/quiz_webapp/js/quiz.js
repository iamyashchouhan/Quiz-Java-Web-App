let currentQuestions = [];
let currentQuestionIndex = 0;
let selectedAnswers = [];
let canSelectOption = true;
let timer = null;
let timeLeft = 20;

document.addEventListener('DOMContentLoaded', function() {
    startQuiz();
    
    document.getElementById('next-btn').addEventListener('click', handleNextQuestion);
    document.getElementById('play-again-btn').addEventListener('click', startQuiz);
});

function startQuiz() {
    currentQuestionIndex = 0;
    selectedAnswers = [];
    canSelectOption = true;
    timeLeft = 20;
    
    // Hide result container and show quiz content
    document.getElementById('result-container').style.display = 'none';
    document.getElementById('quiz-content').style.display = 'block';
    document.getElementById('feedback').style.display = 'none';
    
    // Reset timer
    if (timer) clearInterval(timer);
    startTimer();
    
    // Fetch questions from server
    fetch('quiz')
        .then(response => response.json())
        .then(questions => {
            currentQuestions = questions;
            displayQuestion();
            updateProgress();
        })
        .catch(error => console.error('Error fetching questions:', error));
}

function startTimer() {
    updateTimerDisplay();
    timer = setInterval(() => {
        timeLeft--;
        updateTimerDisplay();
        if (timeLeft <= 0) {
            clearInterval(timer);
            handleNextQuestion();
        }
    }, 1000);
}

function updateTimerDisplay() {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;
    document.querySelector('.timer-text').textContent = 
        `${minutes}:${seconds.toString().padStart(2, '0')}`;
}

function displayQuestion() {
    const question = currentQuestions[currentQuestionIndex];
    document.getElementById('question-text').textContent = `Question ${currentQuestionIndex + 1}: ${question.question}`;
    
    const optionsContainer = document.getElementById('options-container');
    optionsContainer.innerHTML = '';
    
    question.options.forEach((option, index) => {
        const optionDiv = document.createElement('div');
        optionDiv.className = 'option';
        optionDiv.textContent = option;
        optionDiv.setAttribute('data-option', String.fromCharCode(65 + index)); // Add A, B, C, D labels
        optionDiv.addEventListener('click', () => selectOption(index));
        optionsContainer.appendChild(optionDiv);
    });
    
    // Reset feedback
    const feedback = document.getElementById('feedback');
    feedback.style.display = 'none';
    feedback.className = 'feedback-message';
    
    // Update next button text for last question
    const nextBtn = document.getElementById('next-btn');
    nextBtn.textContent = currentQuestionIndex === 4 ? 'Finish Quiz' : 'Next Question';
    nextBtn.style.display = 'none';
    
    // Reset option selection state
    canSelectOption = true;
    
    // Reset timer
    timeLeft = 20;
    if (timer) clearInterval(timer);
    startTimer();
    
    // Update progress
    updateProgress();
}

function updateProgress() {
    const progressList = document.getElementById('progress-list');
    progressList.innerHTML = '';
    
    for (let i = 0; i < 5; i++) {
        const item = document.createElement('div');
        item.className = 'progress-item';
        if (i === currentQuestionIndex) {
            item.classList.add('active');
        } else if (i < currentQuestionIndex) {
            item.classList.add('completed');
        }
        item.textContent = `Question ${i + 1}`;
        progressList.appendChild(item);
    }
}

function selectOption(optionIndex) {
    if (!canSelectOption) return;
    
    // Stop timer
    if (timer) clearInterval(timer);
    
    // Remove selected class from all options
    document.querySelectorAll('.option').forEach(option => {
        option.classList.remove('selected', 'correct', 'incorrect');
    });
    
    const selectedOption = document.querySelectorAll('.option')[optionIndex];
    selectedOption.classList.add('selected');
    
    // Get the current question and check if the answer is correct
    const currentQuestion = currentQuestions[currentQuestionIndex];
    const selectedAnswer = currentQuestion.options[optionIndex].charAt(0);
    const isCorrect = currentQuestion.correctAnswer === selectedAnswer;
    
    // Store the answer
    selectedAnswers[currentQuestionIndex] = selectedAnswer;
    
    // Show feedback
    const feedback = document.getElementById('feedback');
    feedback.style.display = 'block';
    if (isCorrect) {
        selectedOption.classList.add('correct');
        feedback.textContent = 'Correct! Well done!';
        feedback.className = 'feedback-message feedback-correct';
    } else {
        selectedOption.classList.add('incorrect');
        // Find and highlight the correct answer
        document.querySelectorAll('.option').forEach((option, index) => {
            if (currentQuestion.options[index].charAt(0) === currentQuestion.correctAnswer) {
                option.classList.add('correct');
            }
        });
        feedback.textContent = 'Incorrect. Try again next time!';
        feedback.className = 'feedback-message feedback-incorrect';
    }
    
    // Show next button and disable further selection
    document.getElementById('next-btn').style.display = 'block';
    canSelectOption = false;
}

function handleNextQuestion() {
    if (currentQuestionIndex === 4) {
        submitQuiz();
    } else {
        currentQuestionIndex++;
        displayQuestion();
    }
}

function submitQuiz() {
    if (timer) clearInterval(timer);
    
    fetch('quiz', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(selectedAnswers)
    })
    .then(response => response.json())
    .then(score => {
        document.getElementById('quiz-content').style.display = 'none';
        document.getElementById('result-container').style.display = 'block';
        document.getElementById('score').textContent = score;
    })
    .catch(error => console.error('Error submitting quiz:', error));
}
