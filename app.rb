require_relative './person'
require_relative './book'
require_relative './rental'
require_relative './student'
require_relative './teacher'
require_relative './class_room'

class App
  def list_all_books(books)
    puts "Sorry there's no available books at the moment, kindly proceed to add book" if books.empty?

    books.each { |book| puts "Title: \"#{book.title}\", Title: #{book.author}" }
    puts
  end

  def list_all_people(people)
    puts "Sorry there's no people available at the moment, kindly proceed to add a person" if people.empty?

    people.each { |person| puts "[#{person.class}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}" }
    puts
  end

  def create_book(books)
    print 'Title: '
    book_title = gets.chomp
    print 'Author: '
    book_author = gets.chomp

    if book_title.strip != '' && book_author.strip != ''
      book = Book.new(book_title, book_author)
      books.push(book)
      puts 'Book created successfully'
    else
      puts 'Must enter title and author to create book'
    end
  end

  def create_student(person, name, age)
    print 'Has parent permission? [Y/N]: '
    permission = gets.chomp.downcase

    student = ''
    case permission
    when 'y'
      student = Student.new(age, name, parent_permission: true)
    when 'n'
      student = Student.new(age, name, parent_permission: false)

    else
      puts 'invalid selection for permission'
      return
    end
    person.push(student)
    puts 'Person created successfully'
    puts
  end

  def create_teacher(person, name, age)
    print 'Specialization: '
    specialization = gets.chomp
    teacher = Teacher.new(specialization, name, age)
    person.push(teacher)
    puts 'Person created successfully'
    puts
  end

  def create_person(person)
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    get_choice = gets.chomp.to_i

    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp

    case get_choice
    when 1
      create_student(person, name, age)

    when 2
      create_teacher(person, name, age)

    else
      puts 'invalid person type selection'
      nil
    end
  end

  def create_rental(data)
    if data[:books].empty? == true || data[:people].empty? == true
      puts 'Sorry there\'s no available books or people at the moment, kindly proceed to add book and person'
      return
    end

    puts 'Select a book from the following list by index'
    data[:books].each_with_index { |book, index| puts "#{index}) Title: \"#{book.title}\", Author: #{book.author}" }
    puts
    print 'Book index: '
    book_index = gets.chomp.to_i
    book_object = data[:books][book_index]

    puts 'Select a person from the following list by number (not id)'
    data[:people].each_with_index do |person, index|
      puts "#{index}) [#{person.class}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    end

    puts
    print 'Index of the person: '
    person_idx = gets.chomp.to_i
    person_object = data[:people][person_idx]

    puts
    print 'Date: '
    date = gets.chomp

    person_object.add_rental(book_object, date)
    puts 'Rental created sucessfully'
    puts
  end

  def list_rentals(people)
    puts 'Sorry no people available at the moment' if people.empty?

    puts
    print 'ID of the person: '

    id = gets.chomp.to_i
    get_person = people.select do |person|
      person.id == id || nil
    end

    puts

    return if [nil, []].include?(get_person)

    puts 'Rentals '

    get_person[0].rental.each do |rental|
      puts "Date: #{rental.date}, Book: \"#{rental.person.title}\" by #{rental.person.author}"
    end
  end
end
