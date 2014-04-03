Date.class_eval do
  def short(lang_code = :international)
    case lang_code
      when :cs
        self.day.to_s + '. ' + self.month.to_s + '. ' + self.year.to_s
      else
        self.day.to_s + '/' + self.month.to_s + '/' + self.year.to_s
    end
  end
end