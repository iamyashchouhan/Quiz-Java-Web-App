package com.quiz.servlet;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class QuizServlet extends HttpServlet {
    private List<Question> questions;
    private final Gson gson = new Gson();
    private static final String CURRENT_QUIZ_QUESTIONS = "currentQuizQuestions";

    @Override
    public void init() throws ServletException {
        super.init();
        loadQuestions();
    }

    private void loadQuestions() {
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/classes/questions.json")) {
            Type listType = new TypeToken<ArrayList<Question>>(){}.getType();
            questions = gson.fromJson(new InputStreamReader(is), listType);
        } catch (IOException e) {
            e.printStackTrace();
            questions = new ArrayList<>();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Question> randomQuestions = getRandomQuestions(5);
        
        // Store the random questions in session
        HttpSession session = req.getSession(true);
        session.setAttribute(CURRENT_QUIZ_QUESTIONS, randomQuestions);
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(randomQuestions));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String[] answers = gson.fromJson(req.getReader(), String[].class);
        
        // Get the questions from session
        HttpSession session = req.getSession(false);
        List<Question> quizQuestions = session != null ? 
            (List<Question>) session.getAttribute(CURRENT_QUIZ_QUESTIONS) : 
            new ArrayList<>();
            
        int score = calculateScore(answers, quizQuestions);
        
        // Clear the session
        if (session != null) {
            session.removeAttribute(CURRENT_QUIZ_QUESTIONS);
        }
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(score));
    }

    private List<Question> getRandomQuestions(int count) {
        List<Question> shuffledQuestions = new ArrayList<>(questions);
        Collections.shuffle(shuffledQuestions);
        return shuffledQuestions.subList(0, Math.min(count, shuffledQuestions.size()));
    }

    private int calculateScore(String[] userAnswers, List<Question> quizQuestions) {
        int score = 0;
        if (quizQuestions == null || quizQuestions.isEmpty()) {
            return score;
        }
        
        for (int i = 0; i < Math.min(userAnswers.length, quizQuestions.size()); i++) {
            if (quizQuestions.get(i).getCorrectAnswer().equals(userAnswers[i])) {
                score++;
            }
        }
        return score;
    }
}

class Question {
    private String question;
    private String[] options;
    private String correctAnswer;

    public String getQuestion() {
        return question;
    }

    public String[] getOptions() {
        return options;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }
}
