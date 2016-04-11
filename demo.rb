require_relative 'lib/sql_object'

DEMO_DB_FILE = 'dragons.db'
DEMO_SQL_FILE = 'dragons.sql'

# SCHEMA
# Dragon
# Columns: 'id', 'name', 'owner_id'
#
# Trainer
# Columns: 'id', 'fname', 'lname', 'hideout_id'
#
# Hideout
# Columns: 'id', 'address'

`rm '#{DEMO_DB_FILE}'`
`cat '#{DEMO_SQL_FILE}' | sqlite3 '#{DEMO_DB_FILE}'`

DBConnection.open(DEMO_DB_FILE)

class Dragon < SQLObject
  belongs_to :trainer, foreign_key: :owner_id
  has_one_through :hideout, :trainer, :hideout

  finalize!
end

class Trainer < SQLObject
  self.table_name = "trainers"
  has_many :dragons, foreign_key: :owner_id
  belongs_to :hideout

  finalize!
end

class Hideout < SQLObject
  has_many :trainers,
    class_name: "Trainer",
    foreign_key: :hideout_id,
    primary_key: :id

  finalize!
end
