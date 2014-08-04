class AcceptLanguageExtractor

  def initialize(accept_header)
    @accept_header = accept_header
    @prioritized_languages = []
  end

  def parse_languages
    return [] if @accept_header.nil?
    extract_http_accept_languages
    priority_list_of_languages
  end

  private

  def priority_list_of_languages
    sorted_languages = @prioritized_languages.sort_by do |(_, priority_a), (_, priority_b)|
      priority_b <=> priority_a
    end
    sorted_languages.map(&:first)
  end

  def extract_http_accept_languages
    @accept_header.gsub(/\s+/, '').split(',').map do |lang|
      lang, priority = lang.split(";q=")
      lang = lang.downcase
      priority = priority ? priority.to_f : 1.0
      @prioritized_languages << [lang, priority]
    end
  end
end
