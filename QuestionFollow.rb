require 'sqlite3'
require_relative 'user.rb'
require_relative 'questionsdatabase.rb'
require_relative 'Question'

class QuestionFollow
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions_follows")
    data.map{ |datum| QuestionFollow.new(datum)}
  end

  def self.find_by_id(id)
    questionfollow = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
     *
    FROM
      questions_follows
    WHERE
      id = ?

    SQL
    return nil if questionfollow.length > 0
    QuestionFollow.new(questionfollow.first)
  end

end
