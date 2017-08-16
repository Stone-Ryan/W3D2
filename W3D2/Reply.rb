require_relative 'question.rb'
require_relative 'questionsdatabase.rb'
require_relative 'user.rb'

class Reply
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def self.find_by_subject_question_id(subject_question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, subject_question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        subject_question_id = ?
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def self.find_by_parent_id(top_level_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, top_level_id)
      SELECT
        *
      FROM
        replies
      WHERE
        top_level_id = ?
    SQL

    return nil if replies.length > 0
    Reply.new(replies.first)
  end

  attr_reader :id
  attr_accessor :subject_question_id, :user_id, :top_level_id, :body

  def initialize( options = {})
    @id, @subject_question_id, @user_id, @top_level_id, @body = options.values_at('id','subject_question_id', 'user_id', 'top_level_id', 'body')
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(subject_question_id)
  end

  def parent_reply
    Reply.find_by_id(top_level_id)
  end

  def child_reply
    # Reply.find_by_id(top_level_id + 1)
    Reply.find_by_parent_id(id)
  end

end
