DateTime.class_eval do
  # Get long representation of date in specified lang format
  #
  # If _identifier_ is not available then default one is choosen.
  #
  # @param [Symbol] lang_code Optional locale identifier
  # @option lang_code :cs Czech date format (2.11.2014, 9:34)
  # @option lang_code :international (2/11/2014 9:34)
  #
  # @example my_date.full()
  # @example my_date.full(:cs)
  #
  # @return [String] Formated date
  def full(lang_code = :international)
    case lang_code
      when :cs
        self.strftime('%-d. %-m. %Y, %-H:%M')
      else
        self.strftime('%-d/%-m/%Y %-H:%M')
    end

  end

  # Get only date part representation of date in specified lang format
  #
  # If _identifier_ is not available then default one is choosen.
  #
  # @param [Symbol] lang_code Optional locale identifier
  # @option lang_code :cs Czech date format (2.11.2014)
  # @option lang_code :international (2/11/2014)
  #
  # @example my_date.short()
  # @example my_date.short(:cs)
  #
  # @return [String] Formated date
  def short(lang_code = :international)
    case lang_code
      when :cs
        self.strftime('%-d. %-m. %Y')
      else
        self.strftime('%-d/%-m/%Y')
    end
  end
end