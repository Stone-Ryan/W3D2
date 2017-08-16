require 'sqlite3'
require_relative 'questionsdatabase'
require_relative 'QuestionFollow'

class User
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end


  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
        AND
        lname =?
    SQL

    return nil unless user.length > 0
    User.new(user.first)
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL


    return nil unless user.length > 0
    User.new(user.first)
  end

  def initialize( options = {} )
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def authored_questions
    Question.find_by_author(id)
  end

  def authored_replies
    Reply.find_by_user(user_id)
  end
end
