package com.platform.model;


import java.sql.Timestamp;

public class Result {
    private int resultId;
    private int userId;
    private int testId;
    private int score;
    private Timestamp submissionTime;
    
    // Getters and Setters
    public int getResultId() { return resultId; }
    public void setResultId(int resultId) { this.resultId = resultId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getTestId() { return testId; }
    public void setTestId(int testId) { this.testId = testId; }
    
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    
    public Timestamp getSubmissionTime() { return submissionTime; }
    public void setSubmissionTime(Timestamp submissionTime) { this.submissionTime = submissionTime; }
}
