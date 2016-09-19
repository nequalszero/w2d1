class Employee
  attr_reader :salary

  def initialize(name, salary)
    @name = name
    @salary = salary
  end

  def bonus(multiplier)
    return @salary * multiplier
  end

end

class Manager < Employee

  attr_reader :employees

  def initialize(name, salary, employees)
    @employees = employees
    @employees = get_employees
    super(name, salary)
  end

  def bonus(multiplier)
    employee_sal = 0
    @employees.each { |employee| employee_sal += employee.salary }
    employee_sal * multiplier
  end

  def get_employees
    all_employees = []
    @employees.each do |employee|
      all_employees << employee
      all_employees += employee.get_employees if employee.is_a?(Manager)
    end
    all_employees
  end

end

david = Employee.new("David", 10000)
shawna = Employee.new("Shawna", 12000)
darren = Manager.new("Darren", 78000, [david, shawna])
ned = Manager.new("Ned", 1000000, [darren])

puts ned.bonus(5)
puts darren.bonus(4)
puts david.bonus(3)
