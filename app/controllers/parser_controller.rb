require 'open-uri'


class ParserController < ApplicationController
  def nokogiri
    #doc = Nokogiri::HTML(open("https://www.philosophie.ch/philosophie/highlights/politische-philosophie"))

    doc = Nokogiri::HTML('<ul>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/04/06/glueck/">Glück und gutes Leben</a>, Prof. Dagmar Fenner</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/04/17/wenn-sich-ein-philosoph-fragt-ob-er-ein-gutes-leben-hat/">Wenn sich ein Philosoph fragt, ob er ein gutes Leben hat.</a>, Franziska Wettstein</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/04/25/das-gute-leben-tout-court/">Das gute Leben tout court</a>, Adriano Mannino</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/04/30/lebenskunst/">Lebenskunst</a>, Prof. Dr. Andreas Brenner</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/05/15/leben-und-wurde/">Leben und Würde</a>, Franziska Wettstein</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/05/23/gluck-werte-sinn-buchvorstellung/">"Glück - Werte - Sinn"</a>, Buchvorstellung</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/06/23/philosophischetheorien/">Philosophische Theorien zum "Guten Leben"</a>, Anja Leser</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/08/26/glueck-und-psyche/">Glück</a>, Peter F. Wider</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/09/01/gutes-leben-selbstbestimmte-wahl-12/">Gutes Leben und selbstbestimmte Wahl (1/2)</a>, Sebastian Muders</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/09/02/gutes-leben-selbstbestimmte-wahl-22/">Gutes Leben und selbstbestimmte Wahl (2/2)</a>, Sebastian Muders</li>
<li><a href="http://blogs.philosophie.ch/gutesleben/2014/09/24/gutes-leben-fur-unternehmen/">Gibt es ein \'gutes Leben\' für Unternehmen?</a>, Dr. Mark Sommerhalder</li>
<li><a class="internal" href="/artikel/wider-die-gleichgueltigkeit">"Wider die Gleichgültigkeit"</a>, Buchvorstellung</li>
<li><a class="internal" href="/artikel/wider-die-gleichgueltigkeit">Prometheia - Voraussicht als politische Tugend</a>, Buchvorstellung</li>
</ul>
<p>  <strong>Andere Blogbeiträge</strong></p>
<ul>')

    outputstring = "<ul>"

    nodeset = doc.css('li')          # Get all anchors via css
    #puts nodeset.map {|element| element.text.strip}.compact
    i = 0
    nodeset.each do |element|
      i = i + 1
      puts i

      ahref = element.css('a')

      name = ahref.text.strip

      #suppl =  element.text.strip.gsub(name, '')
      suppl = element.xpath('./text()').to_s

      #name = name.to_s.gsub('\n','')
      chopped_name = name.to_s.chop

      puts chopped_name

     # page = AlchemyPage.where(page_layout: "article").where(language_code: "de").where('name ILIKE ?', "%#{chopped_name}%")

     # page = AlchemyPage.where(page_layout: "article").where(language_code: "de").where('name % ?', "%#{chopped_name}%")

      page = AlchemyPage.where(page_layout: "article").where(language_code: "de").where('name % ? AND similarity(name, ?) > 0.98', "%#{chopped_name}%", "%#{chopped_name}%")

      #WHERE loc_name % 'abeville' AND similarity(loc_name, 'abeville') > 0.35
      #page = AlchemyPage.find_by_name(name.to_s)


     if page.count == 1
       #page = page.last
       page = page.first
       outputstring = outputstring + " " + '<li> <a href="https://www.philosophie.ch/' + page.urlname.to_s + '">' + name + '</a>' + suppl + '</li>'
     elsif page.count > 1
     page = page.where.not(urlname: nil).last

     if !page.nil?
      outputstring = outputstring + " " + '<li> <a href="https://www.philosophie.ch/' + page.urlname.to_s + '">' + name + '</a>' + suppl + '</li>'
     else
       puts page.nil?
       outputstring = outputstring + " " + '<li> <a href="https://www.philosophie.ch/' + name + '">' + name + '</a>' + suppl + ' (Link funktioniert nicht)</li>'
     end

     else
       #outputstring = outputstring + " " + '<li> <a class="external" href="' + "https://www.philosophie.ch/" + '>Jesus</a></li>'
       #outputstring = outputstring + '<li> <a href="https://www.philosophie.ch/">Jesus</a></li>'

       while chopped_name.length > 1
         chopped_name.chop!

         pages = AlchemyPage.where(page_layout: "article").where(language_code: "de").where('name ILIKE ?', "%#{chopped_name}%")

         if pages.count > 0
           page = pages.last
           outputstring = outputstring + " " + '<li> <a href="https://www.philosophie.ch/' + page.urlname.to_s + '">' + name + '</a>' + suppl + '</li>'
         end
         break if pages.count > 0

       end

     end

    end

    @output = outputstring + " </ul>"
  end

end
