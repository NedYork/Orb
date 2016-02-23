require_relative 'lib/sql_object'

DEMO_DB_FILE = 'cats.db'
DEMO_SQL_FILE = 'cats.sql'

# SCHEMA
# Cat
# Columns: 'id', 'name', 'owner_id'
#
# Human
# Columns: 'id', 'fname', 'lname', 'house_id'
#
# House
# Columns: 'id', 'address'

`rm '#{DEMO_DB_FILE}'`
`cat '#{DEMO_SQL_FILE}' | sqlite3 '#{DEMO_DB_FILE}'`

DBConnection.open(DEMO_DB_FILE)

class Cat < SQLObject
  belongs_to :human, foreign_key: :owner_id
  has_one_through :house, :human, :house

  finalize!
end

class Human < SQLObject
  self.table_name = "humans"
  has_many :cats, foreign_key: :owner_id
  belongs_to :house

  finalize!
end

class House < SQLObject
  has_many :humans,
    class_name: "Humans",
    foreign_key: :house_id,
    primary_key: :id

  finalize!
end
