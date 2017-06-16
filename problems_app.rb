require 'rubygems'
require 'nokogiri'
require 'open-uri'

puts "Enter trainee username: "

trainee_username = gets.chomp

page_url = 'http://codeforces.com/submissions/'+trainee_username+'/page/'

puts "Enter number of pages to check: "

number_of_pages = gets.chomp.to_i

accepted_problems = Array.new

for page_number in (1..number_of_pages) do 
	page = Nokogiri::HTML(open(page_url+page_number.to_s))

	tmp = page.css('body #pageContent .datatable .status-frame-datatable tr .status-small a').text.split('  ')

	problem_names = Array.new

	tmp.each do |i|
		if(not i.strip.empty?) 
			problem_names << i.strip
		end
	end


	tmp = page.css('body #pageContent .datatable .status-frame-datatable tr .submissionVerdictWrapper')

	for i in (0..tmp.size-1) do
		if(tmp[i]['submissionverdict']=='OK')
			accepted_problems << problem_names[i].strip
		end
	end
end

accepted_problems = accepted_problems.uniq

puts "Enter the number of most solved pages to check: "

number_of_most_solved_pages = gets.chomp.to_i
total_problems = Array.new

for page_number in (1..number_of_most_solved_pages) do
	page = Nokogiri::HTML(open('http://codeforces.com/problemset/page/'+page_number.to_s+'?order=BY_SOLVED_DESC'))

	tmp = page.css('.problems tr')

	for i in (1..tmp.size-1) do
		id = tmp[i].css('td')[0].text.strip
		problem_name = tmp[i].css('td div')[0].text.strip
		total_problems <<  (id + ' - ' + problem_name)
	end

end
unsolved_problems = Array.new

total_problems.each do |i|
	if(!accepted_problems.include?(i.strip))
		unsolved_problems << i
	end
end

puts trainee_username +' solved ' + (total_problems.size - unsolved_problems.size).to_s + ' out of ' + total_problems.size.to_s
puts 'Unsolved problems: '
puts unsolved_problems