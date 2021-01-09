require 'open-uri'
require 'pry'
# For future reference the siter is https://learn-co-curriculum.github.io/student-scraper-test-page/
class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile = "#{student.attr("href")}"
        student_location = student.css(".student-location").text
        student_name = student.css(".student-name").text 
        students << {name: student_name, location: student_location, profile_url: student_profile}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile = Nokogiri::HTML(open(profile_url))
    profile.css(".social-icon-container").children.css("a").collect{|element|element.attribute("href").value}.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link 
      elsif link.include?("twitter")
        student[:twitter] = link 
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile.css(".profile-quote").text if profile.css(".profile-quote")
    student[:bio] = profile.css("div.bio-content.content-holder div.description-holder p").text if profile.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end

