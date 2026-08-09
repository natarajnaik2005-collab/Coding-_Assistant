package com.platform.dao;

import com.platform.model.Question;
import com.platform.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

	public boolean addQuestion(int testId, String questionText, String expectedOutput, int points,
			String testCase1Input, String testCase1Output, String testCase2Input, String testCase2Output,
			String testCase3Input, String testCase3Output) {

		String sql = "INSERT INTO questions (test_id, question_text, expected_output, points, "
				+ "test_case_1_input, test_case_1_output, " + "test_case_2_input, test_case_2_output, "
				+ "test_case_3_input, test_case_3_output) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, testId);
			ps.setString(2, questionText);
			ps.setString(3, expectedOutput);
			ps.setInt(4, points);
			ps.setString(5, testCase1Input);
			ps.setString(6, testCase1Output);
			ps.setString(7, testCase2Input);
			ps.setString(8, testCase2Output);
			ps.setString(9, testCase3Input);
			ps.setString(10, testCase3Output);

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

//Keep existing getQuestionsByTestId method
	public List<Question> getQuestionsByTestId(int testId) {
		List<Question> questions = new ArrayList<>();
		String sql = "SELECT * FROM questions WHERE test_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, testId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Question q = new Question();
				q.setQuestionId(rs.getInt("question_id"));
				q.setTestId(rs.getInt("test_id"));
				q.setQuestionText(rs.getString("question_text"));
				q.setExpectedOutput(rs.getString("expected_output"));
				q.setPoints(rs.getInt("points"));
// Test Cases
				q.setTestCase1Input(rs.getString("test_case_1_input"));
				q.setTestCase1Output(rs.getString("test_case_1_output"));
				q.setTestCase2Input(rs.getString("test_case_2_input"));
				q.setTestCase2Output(rs.getString("test_case_2_output"));
				q.setTestCase3Input(rs.getString("test_case_3_input"));
				q.setTestCase3Output(rs.getString("test_case_3_output"));
				questions.add(q);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return questions;
	}
}