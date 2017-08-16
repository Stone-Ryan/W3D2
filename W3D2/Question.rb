require_relative 'questionsdatabase.rb'
require_relative 'QuestionFollow.rb'
require_relative 'user.rb'

class Question

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum)}
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    return nil unless question.length > 0
    Question.new(question.first)
  end

  def self.find_by_title(title)
    question = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL

    return nil unless question.length > 0
    Question.new(question.first)
  end

  def self.find_by_author(author_id)
    question = QuestionsDatabase.instace.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    return nil unless question.length > 0
    Question.new(question.first)
  end

  attr_reader :id
  attr_accessor :title, :body, :user_id


  def initialize(options = {})
    @title, @body, @id, @user_id = options.values_at('title', 'body', 'id', 'user_id')
  end

  def author
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_subject_question_id(id)
  end
end
