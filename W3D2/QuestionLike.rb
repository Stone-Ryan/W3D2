require_relative 'question.rb'
require_relative 'questions_database.rb'
require_relative 'user.rb'

class QuestionLike
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end

  def find_by_id(id)
    questionlike = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    return nil unless questionlike.length > 0
    QuestionLike.new(questionlike.first)
  end

end
