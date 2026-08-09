package com.platform.model;

public class Question {
    private int questionId;
    private int testId;
    private String questionText;
    private String expectedOutput;
    private int points;
    
    // ✅ Test Case Fields
    private String testCase1Input;
    private String testCase1Output;
    private String testCase2Input;
    private String testCase2Output;
    private String testCase3Input;
    private String testCase3Output;
    
    // Getters and Setters
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    
    public int getTestId() { return testId; }
    public void setTestId(int testId) { this.testId = testId; }
    
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    
    public String getExpectedOutput() { return expectedOutput; }
    public void setExpectedOutput(String expectedOutput) { this.expectedOutput = expectedOutput; }
    
    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }
    
    // ✅ Test Case Getters and Setters
    public String getTestCase1Input() { return testCase1Input; }
    public void setTestCase1Input(String testCase1Input) { this.testCase1Input = testCase1Input; }
    
    public String getTestCase1Output() { return testCase1Output; }
    public void setTestCase1Output(String testCase1Output) { this.testCase1Output = testCase1Output; }
    
    public String getTestCase2Input() { return testCase2Input; }
    public void setTestCase2Input(String testCase2Input) { this.testCase2Input = testCase2Input; }
    
    public String getTestCase2Output() { return testCase2Output; }
    public void setTestCase2Output(String testCase2Output) { this.testCase2Output = testCase2Output; }
    
    public String getTestCase3Input() { return testCase3Input; }
    public void setTestCase3Input(String testCase3Input) { this.testCase3Input = testCase3Input; }
    
    public String getTestCase3Output() { return testCase3Output; }
    public void setTestCase3Output(String testCase3Output) { this.testCase3Output = testCase3Output; }
}