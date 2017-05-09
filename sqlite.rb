require "active_record"

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3', # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
  host:     'localhost',
  database: 'example1.db'
)

# Define a minimal database schema
def init
  ActiveRecord::Schema.define do
    create_table :students, force: true do |t|
      t.string :name
      t.integer :gsoc_id
      t.belongs_to :organization
    end

    create_table :organizations, force: true do |t|
      t.string :name
      t.integer :gsoc_id
    end

    create_table :projects, force: true do |t|
      t.integer :gsoc_id
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

def create_student(student)
  name = student['display_name']
  gsoc_id = student['id']%100000
  s = Student.create(:name=>name, :gsoc_id=>gsoc_id)
  return s
end
def create_tags(tagname, tag_type)
  t = Tag.create(:name=>tagname, :tag_type=>tag_type)
  return t
end


def create_project(project)
  name = project['title']
  gsoc_id = project['id']%1000000
  p = Project.create(
    :title=>name,
    :gsoc_id=>gsoc_id
  )
  return p
end

def create_organization(organization)
  name = organization['name']
  gsoc_id = organization['id']%1000000
  p = Organization.create(
    :name=>name,
    :gsoc_id=>gsoc_id
  )
  return p
end


init
(1...15).each do |i|
  puts i
  f = File.read("#{i}.json")
  h = JSON.parse(f)
  Organization.transaction do
    h['results'].each do |result|

      #name = student['display_name']
      #gsoc_id = student['id']%10000
      #Student.create(:name=>name, :gsoc_id=>gsoc_id)
      #puts Student.count

      org = Organization.find_by_name(result['organization']['name'])
      if org.nil?
        org = create_organization(result['organization'])
      end
      student = create_student(result['student'])
      project = create_project(result)
      org.projects << project
      org.students << student
      student.project = project
    end
  end
end


Organization.all.each do |org|
  puts org.students.count
end
