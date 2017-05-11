# Its bad but it does what it was meant to do.

require "active_record"

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3', # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
  host:     'localhost',
  database: 'gsoc.db'
)

# Define a minimal database schema
def init
  ActiveRecord::Schema.define do
    create_table :students, force: true do |t|
      t.string :name
      t.belongs_to :organization
    end

    create_table :organizations, force: true do |t|
      t.string :name
    end

    create_table :projects, force: true do |t|
      t.string :title
      t.string :subcategory
      t.belongs_to :organization
      t.belongs_to :student
    end

    create_table :tags, force: true do |t|
      t.string :name
      t.string :tag_type
      t.belongs_to :project
    end
  end
end

class Student < ActiveRecord::Base
  has_one :project
  belongs_to :organization
end

class Organization < ActiveRecord::Base
  has_many :projects
  has_many :students
end

class Project < ActiveRecord::Base
  has_many :tags
  belongs_to :student
  belongs_to :organization
end

class Tag < ActiveRecord::Base
  belongs_to :project
end

# Helper function
def create_student(student)
  name = student['display_name']
  s = Student.create(:name=>name)
  return s
end

# Helper function
def create_project(project)
  name = project['title']
  p = Project.create(
    :title=>name
  )
  return p
end

# Helper function
def create_organization(organization)
  name = organization['name']
  p = Organization.create(
    :name=>name
  )
  return p
end


# Creates the schema
# Adds data to db
def initialize_db
  init
  (1...15).each do |i|
    puts i
    f = File.read("data/#{i}.json")
    h = JSON.parse(f)
    Organization.transaction do
      h['results'].each do |result|
        org = Organization.find_by_name(result['organization']['name'])
        if org.nil?
          org = create_organization(result['organization'])
        end
        student = create_student(result['student'])
        project = create_project(result)
        org.projects << project
        org.students << student
        student.project = project
        tags = result['organization']['proposal_tags']
        tags.each do |tag|
          t = Tag.create(:name=>tag, :tag_type=>'proposal')
          project.tags << t
        end
      end
    end
  end
end

# A helper function to merge all json files into one.
def combine_data
  results = []
  (1...15).each do |i|
    puts i
    f = File.read("data/#{i}.json") #read the file
    h = JSON.parse(f) # parse json
    h['results'].each do |result|
      results << result # append results to an array
    end
  end
  puts results.length
  File.write("combined.json", results)
end

initialize_db
#combine_data
