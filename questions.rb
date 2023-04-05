require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database 
    inlude Singletone
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Questions
    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Questions.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def create
        raise "#{self} already in database" if self.id 
        QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.user_id)
            INSERT INTO
                questions (title, body, user_if)
            VALUES
                (?, ?, ?)
        SQL
        self.id = QuestionsDatabase.instance.last_insert_row_id 
    end

    def update
        raise "#{self} not in database" if self.id 
        QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.user_id, self.id)
            UPDATE
                questions 
            SET
                title = ?, body = ?, user_id = ?
            WHERE
                id = ?
        SQL
    end

    def self.find_by_id
        
    end
end